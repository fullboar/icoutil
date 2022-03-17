#!/bin/bash


set -e

SRC_FILE="$1"
DST_PATH="$2"

VERSION=1.0.0

info() {
     local green="\033[1;32m"
     local normal="\033[0m"
     echo -e "[${green}INFO${normal}] $1"
}

error() {
     local red="\033[1;31m"
     local normal="\033[0m"
     echo -e "[${red}ERROR${normal}] $1"
}

usage() {
cat << EOF
VERSION: $VERSION
USAGE:
    $0 file destination

DESCRIPTION:
    Generate a complete set of iOS application icons.

    file - The source png image. Preferably above 1024x1024
    destination - The destination path where the icons are output to.

    This script is depend on sips, a small command line utility available on
    macOS.
AUTHOR:
    Jason <jason.leach@fullboar.ca>

LICENSE:
    Apache 2.0 

EXAMPLE:
    $0 1024.png ~/out
EOF
}

# Check ImageMagick
command -v sips >/dev/null 2>&1 || { error >&2 "The sips tool is not installed."; exit -1; }

# Check param
if [ $# != 2 ];then
    usage
    exit -1
fi

# Check dst path whether exist.
if [ ! -d "$DST_PATH" ];then
    mkdir -p "$DST_PATH"
fi

# Generate, refer to:https://developer.apple.com/library/ios/qa/qa1686/_index.html

#FILE_NAME,SIZE
ARRAY=(
iTunesArtwork,1024
Icon-20,20
Icon-20@2x,40
Icon-20@3x,60
Icon-29,29
Icon-29@2x,58
Icon-29@3x,87
Icon-40,40
Icon-40@2x,80
Icon-40@3x,120
Icon-48,48
Icon-48@2x,96
Icon-60,60
Icon-60@2x,120
Icon-60@3x,180
Icon-76,76
Icon-76@2x,152
Icon-57,57
Icon-57@2x,114
Icon-83.5@2x,167
Icon-72,72
Icon-72@2x,144
Icon-50,50
Icon-50@2x,100
Icon-64@3x,192
)

for i in ${ARRAY[*]}; do
    IFS=",";
    set -- $i;
    cp "$SRC_FILE" "$DST_PATH/$1.png" && sips -Z $2 "$DST_PATH/$1.png"
done

info 'Generate Done.'
