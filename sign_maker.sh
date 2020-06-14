#!/bin/bash
set -euo pipefail

# paper dimensions
SHEET_WIDTH=8.5
SHEET_HEIGHT=11

usage()
{
  echo "Usage: sign_maker.sh [-c|--color] filename width height"
  exit 2
}

split_image()
{
  local metadata
  metadata=$(ffprobe -v quiet -show_streams "$1")
  local grid_width="$2"
  local grid_height="$3"
  local color="$4"

  local width
  width=$(echo "$metadata" | awk -F "=" '/width/ {print $2;exit;}')
  local height
  height=$(echo "$metadata" | awk -F "=" '/height/ {print $2;exit;}')

  local outdir="${1%%.*}_printfiles"
  rm -rf "$outdir" && mkdir -p "$outdir"

  local width_inc=$((width / grid_width))
  local height_inc=$((height / grid_height))

  for x in $(seq 0 $((grid_width - 1))); do 
    for y in $(seq 0 $((grid_height - 1))); do
      local y_coord=$((y * height_inc))
      local x_coord=$((x * width_inc))
      local filter_args="crop=$width_inc:$height_inc:$x_coord:$y_coord"
      if [[ "$color" != "true" ]]; then
        filter_args+=",hue=s=0,eq=gamma=0.5:saturation=2,curves=all='0/0 0.5/1 1/1'"
      fi
        ffmpeg -loglevel error -i "$1" -filter:v "$filter_args" "${outdir}/$y~$x~$1" &
    done
  done

  wait
}

max()
{
  echo $(($1 > $2 ? $1 : $2))
}

quotient()
{
  bc -l <<< "scale=0; $1 / $2"
}

if [[ $# -ne 3 ]] && [[ $# -ne 4 ]]; then
  usage
fi

color="false"
if [[ $# -eq 4 ]]; then
  if [[ "$1" == "-c" ]] || [[ "$1" == "--color" ]]; then
    color="true"
    shift
  else
    usage
  fi
fi

filename="$1"
grid_w=$(max "$(quotient "$2" "$SHEET_WIDTH")" 1)
grid_h=$(max "$(quotient "$3" "$SHEET_HEIGHT")" 1)

split_image "$filename" "$grid_w" "$grid_h" "$color"
