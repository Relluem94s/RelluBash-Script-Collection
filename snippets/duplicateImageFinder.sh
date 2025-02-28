#!/bin/bash
# Beschreibung: Findet visuell ähnliche Bilder mit ImageMagick v7, gruppiert Duplikate und gibt Statistiken aus (optimiert mit Hashing)

# Prüfen, ob ImageMagick installiert ist
if ! command -v magick >/dev/null 2>&1 || ! command -v compare >/dev/null 2>&1; then
    echo "ImageMagick (magick) ist nicht installiert! Bitte installiere es (z. B. 'sudo apt install imagemagick')."
    exit 1
fi

# Prüfen, ob parallel verfügbar ist
if ! command -v parallel >/dev/null 2>&1; then
    echo "GNU parallel ist nicht installiert! Bitte installiere es (z. B. 'sudo apt install parallel')."
    exit 1
fi

# Temporäres Verzeichnis
temp_dir=$(mktemp -d)
threshold_value=5000  # Schwellwert für compare
hash_threshold=5      # Hamming-Distanz für Hash-Vergleich
export threshold_value hash_threshold

# Bilder finden, Videos ausschließen
mapfile -t -d '' images < <(find . -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print0)

total_images=${#images[@]}
echo "Vergleiche $total_images Bilder (Videos ausgeschlossen)..."

# Funktion zum Berechnen eines Perceptual Hash
compute_hash() {
    local img="$1"
    local output_file="$2"
    # Hash mit ImageMagick v7 (magick statt convert)
    hash=$(magick "$img" -resize 8x8! -colorspace Gray -format "%[fx:mean]" info: | md5sum | awk '{print $1}')
    echo "$img|$hash" >> "$output_file"
}
export -f compute_hash

# Hashes berechnen
echo "Berechne Hashes für alle Bilder..."
temp_hashes="$temp_dir/hashes.txt"
touch "$temp_hashes"
printf '%s\n' "${images[@]}" | parallel -N1 compute_hash {} "$temp_hashes"

# Funktion zum Vergleichen von Hashes und selektivem compare
compare_with_hash() {
    local img1="$1"
    local hash1="$2"
    local img2="$3"
    local hash2="$4"
    local output_file="$5"
    
    # Hamming-Distanz zwischen Hashes (vereinfacht als String-Vergleich)
    diff=$(echo "$hash1 $hash2" | awk '{print ($1 == $2) ? 0 : 10}')
    
    if [ "$diff" -le "$hash_threshold" ]; then
        diff_output=$(compare -metric MAE "$img1" "$img2" null: 2>&1)
        diff_int=$(echo "$diff_output" | awk '{if ($1+0==$1) print int($1); else print "NaN"}')
        
        if [ -n "$diff_int" ] && (( diff_int < threshold_value )); then
            echo "$img1|$img2" >> "$output_file"
            echo "Debug: Bilder als ähnlich erkannt: '$img1' und '$img2' (diff_int=$diff_int)" >&2
        fi
    fi
}
export -f compare_with_hash

# Bildpaare mit Hashes vergleichen
echo "Starte Hash-basierte Vergleiche..."
temp_result="$temp_dir/results.txt"
touch "$temp_result"

# Erstelle Paare mit Hashes
while IFS='|' read -r img1 hash1; do
    while IFS='|' read -r img2 hash2; do
        if [[ "$img1" < "$img2" ]]; then  # Vermeide doppelte Vergleiche
            echo "$img1|$hash1|$img2|$hash2|$temp_result"
        fi
    done < "$temp_hashes"
done < "$temp_hashes" | parallel --colsep '|' compare_with_hash {1} {2} {3} {4} {5}

# Gruppen bilden
declare -A groups
group_num=0
declare -A seen

while IFS='|' read -r img1 img2; do
    if [ -z "${seen[$img1]}" ] && [ -z "${seen[$img2]}" ]; then
        groups["$img1"]=$group_num
        groups["$img2"]=$group_num
        seen["$img1"]=1
        seen["$img2"]=1
        ((group_num++))
    elif [ -n "${seen[$img1]}" ] && [ -z "${seen[$img2]}" ]; then
        groups["$img2"]=${groups["$img1"]}
        seen["$img2"]=1
    elif [ -z "${seen[$img1]}" ] && [ -n "${seen[$img2]}" ]; then
        groups["$img1"]=${groups["$img2"]}
        seen["$img1"]=1
    fi
done < "$temp_result"

# Statistik
duplicate_count=0
for img in "${!groups[@]}"; do
    ((duplicate_count++))
done
unique_duplicates=$((duplicate_count - group_num))
echo "Statistik: $unique_duplicates von $total_images Bildern sind doppelt."

# Nur Duplikate ausgeben
echo "Gruppiere Duplikate:"
for g in $(seq 0 $((group_num - 1))); do
    group_size=0
    for img in "${!groups[@]}"; do
        if [ "${groups["$img"]}" -eq "$g" ]; then
            ((group_size++))
        fi
    done
    if [ "$group_size" -gt 1 ]; then
        echo "Gruppe $g:"
        for img in "${!groups[@]}"; do
            if [ "${groups["$img"]}" -eq "$g" ]; then
                echo "$img"
            fi
        done
        echo ""
    fi
done

# Aufräumen
rm -rf "$temp_dir"
echo "Fertig!"
