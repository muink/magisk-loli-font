#!/sbin/sh

BIN_FILE=./META-INF/com/google/android/update-binary

sed -n '/http[s]*/ s/\/blob\//\/raw\//p' $BIN_FILE | cut -f2 -d' ' | xargs wget -O $BIN_FILE 
