get_height()
{
  jpg="jpg"
  if [ "$2" = "$jpg" ]
  then
    file_info=$(file $1)
    IFS=' '
    read -ra ARR1 <<< "$file_info"
    IFS='x'
    read -ra ARR2 <<< "${ARR1[17]}"
    IFS=','
    read -ra ARR3 <<< "${ARR2[1]}"
    echo ${ARR3[0]}
  else
    file_info=$(file $1)
    IFS=','
    read -ra ARR1 <<< "$file_info"
    IFS=' '
    read -ra ARR2 <<< "${ARR1[1]}"
    echo ${ARR2[2]}
  fi
}

get_width()
{
  jpg="jpg"
  if [ "$2" = "$jpg" ]
  then
    file_info=$(file $1)
    IFS=' '
    read -ra ARR1 <<< "$file_info"
    IFS='x'
    read -ra ARR2 <<< "${ARR1[17]}"
    echo ${ARR2[0]}
  else
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

  epoch=$(date +%s)
  mkdir "printfiles~$epoch"
  
  for x in $(seq 0 $x_breaks)
  do 
    for y in $(seq 0 $y_breaks)
    do
      y_coord=$y*$height_inc
      x_coord=$x*$width_inc

      yes="yes"
      if [ "$5" = "$yes" ]
      then
        ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:$x_coord:$y_coord,hue=s=0,eq=gamma=0.5:saturation=2,curves=all='0/0 0.5/1 1/1'" "printfiles~$epoch/$y~$x~$1"
      else
        ffmpeg -i $1 -filter:v "crop=$width_inc:$height_inc:$x_coord:$y_coord" "printfiles~$epoch/$y~$x~$1"
      fi
    done
  done
}

print_gridX()
{
  count=`expr $1 / 8`
  if [ $count = 0 ]
  then
    count=1
  fi
  echo $count
}

print_gridY()
{
  count=`expr $1 / 11`
  if [ $count = 0 ]
  then
    count=1
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

printf "\n\nWould you like to make your image black and white? (yes / no)"
read black_white

grid_width=$(print_gridX $sign_width)
grid_height=$(print_gridY $sign_height)

split_image $file_name $grid_width $grid_height $file_type $black_white