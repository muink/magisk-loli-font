#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "       Magisk Loli Font        "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
# --------------------------------------------
ui_print "- Searching in fonts.xml"
[[ -d /sbin/.magisk/mirror ]] && MIRRORPATH=/sbin/.magisk/mirror || unset MIRRORPATH
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
  if [ -f "$MODPATH/$FONTSPATH/${SOURCE}-${_t##*-}.ttf" ]; then
    ln -s ${SOURCE}-${_t##*-}.ttf $MODPATH/system/fonts/${_t}.ttf
  fi
done


ui_print "- Installing CJK fonts..."
# With fonts.xml
# CJK=(zh-Hans zh-Hant,zh-Bopo ja ko)
SANS_CJK=LoliCJK-Regular.ttf
cp -af $MIRRORPATH/$FILEPATH $MODPATH/$FILEPATH 2>/dev/null

if [ -f "$MODPATH/$FILEPATH" ]; then
  # SansAll    sed -n "/^    <family name=\"sans-serif\">/,/<\/family>/p" fonts.xml
  # sed -i "/^    <family name=\"sans-serif\">/,/<\/family>/ {\
  #   s|${TARGET}-|${SOURCE}-|}" \
  # $MODPATH/$FILEPATH

  # SansRegular
  # sed -i "/^    <family name=\"sans-serif\">/,/<\/family>/ {/weight=\"400\"/ {\
  #   s|style=\"normal\".*</font>$|style=\"normal\">$SANS</font>|; \
  #   s|style=\"italic\".*</font>$|style=\"italic\">${SANS-ITALIC}</font>|}}" \
  # $MODPATH/$FILEPATH

  # sed -n "/^    <family lang=\"ko\">$/,+1p" fonts.xml
  # CJK Sans    sed -n "/^    <family lang=\"ko\">/{n; p;}" fonts.xml
  # CJK Sans&Serif    sed -n "/^    <family lang=\"ko\">/,/<\/family>/p" fonts.xml
  # for _lang in "${CJK[@]}"; do
  for _lang in zh-Hans zh-Hant,zh-Bopo ja ko; do
    sed -i "/^    <family lang=\"$_lang\">/{n; \
      s|weight=\"400\" style=\"normal\".*</font>$|weight=\"400\" style=\"normal\">$SANS_CJK</font>|}" \
    $MODPATH/$FILEPATH
    # sed "/^    <family lang=\"$_lang\">/,/<\/family>/ c\    <family lang=\"$_lang\">\n        <font weight=\"400\" style=\"normal\">$SANS_CJK<\/font>\n        <font weight=\"400\" style=\"normal\" fallbackFor=\"serif\">$SANS_CJK<\/font>\n    <\/family>" $MODPATH/$FILEPATH
  done
fi


# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
