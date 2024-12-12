#!/usr/bin/env bash

set -euo pipefail

zeros=()
ones=()
twos=()
threes=()
fours=()
fives=()
sixes=()
sevens=()
eights=()
nines=()

i=0
while IFS= read -r line; do
  for (( j=0; j<${#line}; j++ )); do
    if [ "${line:$j:1}" == "0" ]; then
      zeros+=("$i,$j")
    elif [ "${line:$j:1}" == "1" ]; then
      ones+=("$i,$j")
    elif [ "${line:$j:1}" == "2" ]; then
      twos+=("$i,$j")
    elif [ "${line:$j:1}" == "3" ]; then
      threes+=("$i,$j")
    elif [ "${line:$j:1}" == "4" ]; then
      fours+=("$i,$j")
    elif [ "${line:$j:1}" == "5" ]; then
      fives+=("$i,$j")
    elif [ "${line:$j:1}" == "6" ]; then
      sixes+=("$i,$j")
    elif [ "${line:$j:1}" == "7" ]; then
      sevens+=("$i,$j")
    elif [ "${line:$j:1}" == "8" ]; then
      eights+=("$i,$j")
    elif [ "${line:$j:1}" == "9" ]; then
      nines+=("$i,$j")
    fi
  done
  i=$((i+1))
done < "$1"


campers_1=()
i=0
echo "Taking first step (${#zeros[@]} campers)"
for trailhead in "${zeros[@]}"; do
  x=$(echo "$trailhead"| cut -f1 -d , )
  y=$(echo "$trailhead"| cut -f2 -d , )

  if [[ " ${ones[*]} " =~ " $x,$((y+1)) " ]]; then
    campers_1+=("$x,$((y+1)),$i")
  fi
  if [[ " ${ones[*]} " =~ " $x,$((y-1)) " ]]; then
    campers_1+=("$x,$((y-1)),$i")
  fi
  if [[ " ${ones[*]} " =~ " $((x+1)),$y " ]]; then
    campers_1+=("$((x+1)),$y,$i")
  fi
  if [[ " ${ones[*]} " =~ " $((x-1)),$y " ]]; then
    campers_1+=("$((x-1)),$y,$i")
  fi
  i=$((i+1))
done


echo "Taking 2nd step (${#campers_1[@]} campers)"
campers_2=()
for camper in "${campers_1[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${twos[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_2[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_2+=("$x,$((y+1)),$id")
  fi
  if [[ " ${twos[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_2[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_2+=("$x,$((y-1)),$id")
  fi
  if [[ " ${twos[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_2[*]} " =~ " $((x+1)),$y+1,$id " ]]; then
    campers_2+=("$((x+1)),$y,$id")
  fi
  if [[ " ${twos[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_2[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_2+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 3rd step (${#campers_2[@]} campers)"
campers_3=()
for camper in "${campers_2[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${threes[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_3[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_3+=("$x,$((y+1)),$id")
  fi
  if [[ " ${threes[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_3[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_3+=("$x,$((y-1)),$id")
  fi
  if [[ " ${threes[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_3[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_3+=("$((x+1)),$y,$id")
  fi
  if [[ " ${threes[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_3[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_3+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 4th step (${#campers_3[@]} campers)"
campers_4=()
for camper in "${campers_3[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${fours[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_4[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_4+=("$x,$((y+1)),$id")
  fi
  if [[ " ${fours[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_4[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_4+=("$x,$((y-1)),$id")
  fi
  if [[ " ${fours[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_4[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_4+=("$((x+1)),$y,$id")
  fi
  if [[ " ${fours[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_4[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_4+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 5th step (${#campers_4[@]} campers)"
campers_5=()
for camper in "${campers_4[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${fives[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_5[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_5+=("$x,$((y+1)),$id")
  fi
  if [[ " ${fives[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_5[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_5+=("$x,$((y-1)),$id")
  fi
  if [[ " ${fives[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_5[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_5+=("$((x+1)),$y,$id")
  fi
  if [[ " ${fives[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_5[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_5+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 6th step (${#campers_5[@]} campers)"
campers_6=()
for camper in "${campers_5[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${sixes[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_6[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_6+=("$x,$((y+1)),$id")
  fi
  if [[ " ${sixes[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_6[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_6+=("$x,$((y-1)),$id")
  fi
  if [[ " ${sixes[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_6[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_6+=("$((x+1)),$y,$id")
  fi
  if [[ " ${sixes[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_6[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_6+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 7th step (${#campers_6[@]} campers)"
campers_7=()
for camper in "${campers_6[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${sevens[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_7[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_7+=("$x,$((y+1)),$id")
  fi
  if [[ " ${sevens[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_7[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_7+=("$x,$((y-1)),$id")
  fi
  if [[ " ${sevens[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_7[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_7+=("$((x+1)),$y,$id")
  fi
  if [[ " ${sevens[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_7[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_7+=("$((x-1)),$y,$id")
  fi
done


echo "Taking 8th step (${#campers_7[@]} campers)"
campers_8=()
for camper in "${campers_7[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${eights[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_8[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_8+=("$x,$((y+1)),$id")
  fi
  if [[ " ${eights[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_8[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_8+=("$x,$((y-1)),$id")
  fi
  if [[ " ${eights[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_8[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_8+=("$((x+1)),$y,$id")
  fi
  if [[ " ${eights[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_8[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_8+=("$((x-1)),$y,$id")
  fi
done


echo "Taking last step (${#campers_8[@]} campers)"
campers_9=()
for camper in "${campers_8[@]}"; do
  x=$(echo "$camper"| cut -f1 -d , )
  y=$(echo "$camper"| cut -f2 -d , )
  id=$(echo "$camper"| cut -f3 -d , )

  if [[ " ${nines[*]} " =~ " $x,$((y+1)) " ]] && [[ ! " ${campers_9[*]} " =~ " $x,$((y+1)),$id " ]]; then
    campers_9+=("$x,$((y+1)),$id")
  fi
  if [[ " ${nines[*]} " =~ " $x,$((y-1)) " ]] && [[ ! " ${campers_9[*]} " =~ " $x,$((y-1)),$id " ]]; then
    campers_9+=("$x,$((y-1)),$id")
  fi
  if [[ " ${nines[*]} " =~ " $((x+1)),$y " ]] && [[ ! " ${campers_9[*]} " =~ " $((x+1)),$y,$id " ]]; then
    campers_9+=("$((x+1)),$y,$id")
  fi
  if [[ " ${nines[*]} " =~ " $((x-1)),$y " ]] && [[ ! " ${campers_9[*]} " =~ " $((x-1)),$y,$id " ]]; then
    campers_9+=("$((x-1)),$y,$id")
  fi
done

echo "Total score: ${#campers_9[@]}"
