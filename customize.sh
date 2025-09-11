#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "       Magisk Loli Font        "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
# --------------------------------------------
ui_print "- Unzipping font files..."
FONTSPATH=/system/fonts
unzip -oj "$ZIPFILE" fonts.tar.xz -d $TMPDIR >&2
mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
tar -xf $TMPDIR/fonts.tar.xz -C $MODPATH/$FONTSPATH 2>/dev/null


ui_print "- Installing fonts..."
FILEPATH=/system/etc/fonts.xml
SOURCE='Loli'
SANS_CJK='LoliCJK-Regular.ttf'
#SANS_CJK='DFFangYuan-Std-W7.ttf'

# sans-serif(-condensed)?
TARGET=$(sed -En '/<family name="sans-serif(-condensed)?">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}' $FILEPATH | sort -u)
# Just replace
for _t in $TARGET; do
  if [ -f "$MODPATH/$FONTSPATH/${SOURCE}-${_t#*-}.ttf" ]; then
    ln -s ${SOURCE}-${_t#*-}.ttf $MODPATH/system/fonts/${_t}.ttf.placeholder
  fi
done

# CJK
TARGET=$(sed -En "/<family lang=\"(zh-Hans|zh-Hant,zh-Bopo|ja|ko)\">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}" $FILEPATH | sort -u)
# Just replace
for _t in $TARGET; do
  ln -s $SANS_CJK $MODPATH/system/fonts/${_t}.ttf.placeholder
done


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
