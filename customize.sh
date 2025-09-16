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
mkdir -p $TMPDIR/$FONTSPATH 2>/dev/null
mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
tar -xf $TMPDIR/fonts.tar.xz -C $TMPDIR/$FONTSPATH 2>/dev/null


ui_print "- Installing fonts..."
FILEPATH=/system/etc/fonts.xml
SOURCE='Loli'
STATIC='LoliStatic'
SANS_CJK='LoliCJK-Regular.ttf'
#SANS_CJK='DFFangYuan-Std-W7.ttf'

# sans-serif(-condensed)?
TARGET=$(sed -En '/<family name="sans-serif(-condensed)?">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}' $FILEPATH | sort -u)
# Just replace
for _t in $TARGET; do
  cp -f $TMPDIR/$FONTSPATH/${SOURCE}-${_t##*-}.ttf $MODPATH/$FONTSPATH/
  if [ -f "$MODPATH/$FONTSPATH/${SOURCE}-${_t##*-}.ttf" ]; then
    if [ -L "/$FONTSPATH/${_t}.ttf" ]; then
      ln -s ${SOURCE}-${_t##*-}.ttf $MODPATH/$FONTSPATH/${_t}.ttf.placeholder
    else
      mv -f $MODPATH/$FONTSPATH/${SOURCE}-${_t##*-}.ttf $MODPATH/$FONTSPATH/${_t}.ttf
    fi
  fi
done

if [ $API -gt 30 ]; then # Android 12+
  # sans-serif(-condensed)? (Static)
  TARGET=$(sed -En '/<family name="sans-serif(-condensed)?">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}'   $FILEPATH | sort -u | grep Static)
  # Just replace
  for _t in $TARGET; do
    rm -f $MODPATH/$FONTSPATH/${_t}.ttf.placeholder 2>/dev/null
    rm -f $MODPATH/$FONTSPATH/${_t}.ttf 2>/dev/null
    cp -f $TMPDIR/$FONTSPATH/${STATIC}-${_t##*-}.ttf $MODPATH/$FONTSPATH/
    if [ -f "$MODPATH/$FONTSPATH/${STATIC}-${_t##*-}.ttf" ]; then
      if [ -L "/$FONTSPATH/${_t}.ttf" ]; then
        ln -s ${STATIC}-${_t##*-}.ttf $MODPATH/$FONTSPATH/${_t}.ttf.placeholder
      else
        mv -f $MODPATH/$FONTSPATH/${STATIC}-${_t##*-}.ttf $MODPATH/$FONTSPATH/${_t}.ttf
      fi
    fi
  done
fi

# CJK
TARGET=$(sed -En "/<family lang=\"(zh-Hans|zh-Hant,zh-Bopo|ja|ko)\">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}" $FILEPATH | sort -u)
# Just replace
cp -f $TMPDIR/$FONTSPATH/$SANS_CJK $MODPATH/$FONTSPATH/
for _t in $TARGET; do
  ln -s $SANS_CJK $MODPATH/$FONTSPATH/${_t}.ttf.placeholder
done


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
