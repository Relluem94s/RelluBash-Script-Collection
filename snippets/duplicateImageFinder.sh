#!/bin/bash
# Duplikate über AE-Pixelvergleich erkennen

if ! command -v magick >/dev/null 2>&1 || ! command -v compare >/dev/null 2>&1; then
    echo "ImageMagick (magick) ist nicht installiert! Bitte installiere es."
    exit 1
fi

if ! command -v parallel >/dev/null 2>&1; then
    echo "GNU parallel ist nicht installiert! Bitte installiere es."
    exit 1
fi

temp_dir=$(mktemp -d)
threshold_value=1
export threshold_value

mapfile -t -d '' images < <(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -print0)
total_images=${#images[@]}
echo "Vergleiche $total_images Bilder:"


compare_images() {
    local img1="$1"
    local img2="$2"
    local output_file="$3"

    if [ ! -f "$img1" ] || [ ! -f "$img2" ]; then
        return
    fi

    size1=$(magick identify -format "%w x %h" "$img1" 2>>"$temp_dir/identify_errors.log")
    size2=$(magick identify -format "%w x %h" "$img2" 2>>"$temp_dir/identify_errors.log")
    if [ -z "$size1" ] || [ -z "$size2" ]; then
        return
    fi
    if [ "$size1" != "$size2" ]; then
        return
    fi

    local temp_img1="$temp_dir/temp1_$(echo "$img1" | tr -dc 'a-zA-Z0-9').png"
    local temp_img2="$temp_dir/temp2_$(echo "$img2" | tr -dc 'a-zA-Z0-9').png"
    if ! magick "$img1" -strip "$temp_img1" 2>>"$temp_dir/magick_errors.log"; then
        return
    fi
    if ! magick "$img2" -strip "$temp_img2" 2>>"$temp_dir/magick_errors.log"; then
        return
    fi


    if [ ! -f "$temp_img1" ] || [ ! -f "$temp_img2" ]; then
        return
    fi


    ae_diff=$(compare -metric AE "$temp_img1" "$temp_img2" null: 2>>"$temp_dir/compare_errors.log")
    exit_code=$?



    if [ $exit_code -eq 0 ] && { [ -z "$ae_diff" ] || [ "$ae_diff" -eq 0 ]; }; then
        echo "$img1|$img2" >> "$output_file"
    fi

    rm -f "$temp_img1" "$temp_img2"
}


export -f compare_images

temp_result="$temp_dir/results.txt"
touch "$temp_result"

for ((i = 0; i < total_images; i++)); do
    for ((j = i + 1; j < total_images; j++)); do
        compare_images "${images[i]}" "${images[j]}" "$temp_result"
    done
done
echo "Debug: Insgesamt $(( (total_images * (total_images - 1)) / 2 )) Vergleiche durchgeführt" >&2

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
