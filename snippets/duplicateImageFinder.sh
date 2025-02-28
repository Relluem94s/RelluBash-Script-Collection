#!/bin/bash
# Beschreibung: Findet visuell ähnliche Bilder mit ImageMagick v7, gruppiert Duplikate und gibt Statistiken aus (optimiert mit Hashing)

if ! command -v magick >/dev/null 2>&1 || ! command -v compare >/dev/null 2>&1; then
    echo "ImageMagick (magick) ist nicht installiert! Bitte installiere es (z. B. 'sudo apt install imagemagick')."
    exit 1
fi

if ! command -v parallel >/dev/null 2>&1; then
    echo "GNU parallel ist nicht installiert! Bitte installiere es (z. B. 'sudo apt install parallel')."
    exit 1
fi

temp_dir=$(mktemp -d)
threshold_value=5000
hash_threshold=5
export threshold_value hash_threshold

# Bilder finden (mit Leerzeichen-Unterstützung)
mapfile -t -d '' images < <(find . -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print0)

# DEBUG: Ausgabe der gefundenen Dateien
# printf 'Gefunden:\n'
# printf '%s\n' "${images[@]}"

total_images=${#images[@]}
echo "Vergleiche $total_images Bilder..."

compute_hash() {
    local img="$1"
    local output_file="$2"

    if [ ! -f "$img" ]; then
        echo "Fehler: '$img' ist keine gültige Datei!" >&2
        return
    fi

    hash=$(magick "$img" -resize 8x8! -colorspace Gray -format "%[fx:mean]" info: 2>/dev/null | md5sum | awk '{print $1}')
    if [ -z "$hash" ]; then
        echo "Fehler: Konnte Hash nicht berechnen für '$img'" >&2
        return
    fi

    echo "$img|$hash" >> "$output_file"
}
export -f compute_hash

temp_hashes="$temp_dir/hashes.txt"
touch "$temp_hashes"

printf '%s\0' "${images[@]}" | parallel --null compute_hash {} "$temp_hashes"

compare_with_hash() {
    local img1="$1"
    local hash1="$2"
    local img2="$3"
    local hash2="$4"
    local output_file="$5"

    if [ ! -f "$img1" ] || [ ! -f "$img2" ]; then
        return
    fi

    diff=$(echo "$hash1 $hash2" | awk '{print ($1 == $2) ? 0 : 10}')

    if [ "$diff" -le "$hash_threshold" ]; then
        diff_output=$(compare -metric MAE "$img1" "$img2" null: 2>&1)
        diff_int=$(echo "$diff_output" | awk '{print $1}' | xargs printf "%.0f" 2>/dev/null)

        if [[ "$diff_int" =~ ^[0-9]+$ ]] && (( diff_int < threshold_value )); then
            echo "$img1|$img2" >> "$output_file"
            echo "Debug: Bilder als ähnlich erkannt: '$img1' und '$img2' (diff_int=$diff_int)" >&2
        fi
    fi
}
export -f compare_with_hash

echo "Starte Hash-basierte Vergleiche..."
temp_result="$temp_dir/results.txt"
touch "$temp_result"

while IFS='|' read -r img1 hash1; do
    while IFS='|' read -r img2 hash2; do
        if [[ "$img1" < "$img2" ]]; then
            printf '%s\0%s\0%s\0%s\0%s\0' "$img1" "$hash1" "$img2" "$hash2" "$temp_result"
        fi
    done < "$temp_hashes"
done < "$temp_hashes" | parallel --null -0 compare_with_hash {1} {2} {3} {4} {5}

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

duplicate_count=0
for img in "${!groups[@]}"; do
    ((duplicate_count++))
done
unique_duplicates=$((duplicate_count - group_num))
echo "Statistik: $unique_duplicates von $total_images Bildern sind doppelt."

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

rm -rf "$temp_dir"
echo "Fertig!"

