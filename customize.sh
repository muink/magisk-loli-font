#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "       Magisk Loli Font        "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
# --------------------------------------------
ui_print "- Searching in fonts.xml"
#[[ -d /debug_ramdisk/.magisk/mirror ]] && MIRRORPATH=/debug_ramdisk/.magisk/mirror || unset MIRRORPATH
FILEPATH=/system/etc/fonts.xml
mkdir -p $MODPATH/$(dirname $FILEPATH) 2>/dev/null

ui_print "- Unzipping font files..."
FONTSPATH=/system/fonts
unzip -oj "$ZIPFILE" fonts.tar.xz -d $TMPDIR >&2
mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
tar -xf $TMPDIR/fonts.tar.xz -C $MODPATH/$FONTSPATH 2>/dev/null


ui_print "- Installing fonts..."
TARGET=$(sed -En '/<family name="sans-serif(-condensed)?">/,/<\/family>/ {s|.*<font [^\>]*>(.*).ttf.*|\1|p}' $FILEPATH | sort -u)
SOURCE='Loli'
# Just replace
for _t in $TARGET; do
  if [ -f "$MODPATH/$FONTSPATH/${SOURCE}-${_t#*-}.ttf" ]; then
    ln -s ${SOURCE}-${_t#*-}.ttf $MODPATH/system/fonts/${_t}.ttf.placeholder
  fi
done


ui_print "- Installing CJK fonts..."
# With fonts.xml
# CJK=(zh-Hans zh-Hant,zh-Bopo ja ko)
SANS_CJK='LoliCJK-Regular.ttf'
#SANS_CJK='DFFangYuan-Std-W7.ttf'

for _xml in $MIRRORPATH/$FILEPATH; do
if [ -f "$_xml" ]; then
  cp -af $_xml $MODPATH/${_xml/$MIRRORPATH/} 2>/dev/null

  for _lang in zh-Hans zh-Hant,zh-Bopo ja ko; do
    sed -Ei "/^[ \t]*<family lang=\"$_lang\">/,/^[ \t]*<\/family>/{ \
      /fallback/b; \
      s|^([ \t]*<font .* style=\"normal\")|\1>$SANS_CJK</font>\n\1|; \
    }" $MODPATH/${_xml/$MIRRORPATH/}
  done
fi
done


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
