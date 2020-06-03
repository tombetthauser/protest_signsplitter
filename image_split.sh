get_height()
{
  jpg="jpg"
  if [ "$2" = "$jpg" ]
  then
    # for jpgs
    file_info=$(file $1)
    IFS=' '
    read -ra ARR1 <<< "$file_info"
    IFS='x'
    read -ra ARR2 <<< "${ARR1[17]}"
    IFS=','
    read -ra ARR3 <<< "${ARR2[1]}"
    echo ${ARR3[0]}
  else
    # for png
    file_info=$(file $1)
    IFS=','
    read -ra ARR1 <<< "$file_info"
    IFS=' '
    read -ra ARR2 <<< "${ARR1[1]}"
    echo ${ARR2[2]}
  fi

  # file_info=$(file "statue.jpg")
  # IFS=' '
  # read -ra ARR1 <<< "$file_info"
  # IFS='x'
  # read -ra ARR2 <<< "${ARR1[17]}"
  # IFS=','
  # read -ra ARR3 <<< "${ARR2[1]}"
  # echo ${ARR3[0]}
  
  # for png
  # file_info=$(file $1)
  # IFS=','
  # read -ra ARR1 <<< "$file_info"
  # IFS=' '
  # read -ra ARR2 <<< "${ARR1[1]}"
  # echo ${ARR2[2]}

  # let a=$width-50
  # echo $a

  # for i in "${ARR2[@]}"; do # access each element of array
  #   echo "$i"
  # done
}

get_width()
{
  jpg="jpg"
  if [ "$2" = "$jpg" ]
  then
    # for jpgs
    file_info=$(file $1)
    IFS=' '
    read -ra ARR1 <<< "$file_info"
    IFS='x'
    read -ra ARR2 <<< "${ARR1[17]}"
    echo ${ARR2[0]}
  else
  # # for pngs
    file_info=$(file $1)
    IFS=','
    read -ra ARR1 <<< "$file_info"
    IFS=' '
    read -ra ARR2 <<< "${ARR1[1]}"
    echo ${ARR2[0]}
  fi
}

split_image()
{
  width=$(get_width $1 $4)
  height=$(get_height $1 $4)

  grid_width=$2
  grid_height=$3

  x_breaks=`expr $2 - 1`
  y_breaks=`expr $3 - 1`
  
  printf "\ngrid width: $grid_width\n"
  printf "grid height: $grid_height\n"

  width_inc=$width/$grid_width
  height_inc=$height/$grid_height

  # ffmpeg -i $1 -filter:v "crop=out_w:out_h:x:y" "copy_$1"

  # print_files="print_files"

  # if [ -f "$print_files" ]
  # then
  #   rm -rf print_files/
  # fi
  
  # rm -rf print_files

  epoch=$(date +%s)
  mkdir "printfiles~$epoch"
  
  #iterate through grid_height
  for x in $(seq 0 $x_breaks)
  do 
    for y in $(seq 0 $y_breaks)
    do
      y_coord=$y*$height_inc
      x_coord=$x*$width_inc
      ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:$x_coord:$y_coord" "printfiles~$epoch/$y~$x~$1"
    done
  done

    #iterate through grid_width

  # ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:0:0" "print_files/topleft_$1"
  # ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:$width_inc:0" "print_files/topright_$1"

  # ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:0:$height_inc" "print_files/bottomleft_$1"
  # ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:$width_inc:$height_inc" "print_files/bottomright_$1"
}

print_gridX()
{
  # paper_width=$(echo "scale = 2; 17 / 2" | bc)

  count=`expr $1 / 8`
  if [ `expr $1 % 8` -eq 0 ]
  then
    count=$count
  else
    count=`expr $count + 1`
  fi
  echo $count
}

# printf %.10f\\n "$((10**9 * 20/7))e-9"

# var=$(printf %.10f\\n "$((10**9 / 10))e-9")
# var2=$(`expr $var / 10`)
# echo $var2

#  var5=$(echo "scale = 2; 17 / 2" | bc)

print_gridY()
{
  count=`expr $1 / 11`
  if [ `expr $1 % 11` -eq 0 ]
  then
    count=$count
  else
    count=`expr $count + 1`
  fi
  echo $count
}

clear

printf "\n\nIs your image a png or jpg file? (enter 'jpg' or 'png'): "
read file_type

printf "\n\nEnter image file in current folder to process (with file extension): "
read file_name

printf "\n\nEnter height of sign surface in inches rounding down to the nearest inch: "
read sign_height

printf "\n\nEnter width of sign surface in inches rounding down to the nearest inch: "
read sign_width

grid_height=$(print_gridX $sign_width)
grid_width=$(print_gridY $sign_width)

split_image $file_name $grid_width $grid_height $file_type