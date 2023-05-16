#!/usr/bin/env bash

RSTUDIO=/Applications/RStudio.app/Contents

# find Quarto and give instructions for putting it and pandoc on the path
QUARTO_PATH=$(find $RSTUDIO  -name "quarto" -type d | head -n 1)
echo 'Add the following to your $PATH:'
echo "PATH=\$PATH:$QUARTO_PATH/bin/"
echo "PATH=\$PATH:$QUARTO_PATH/bin/tools"

# remove x64 stuff
echo
echo -n "Removing non-ARM files..."
rm -f $(find $RSTUDIO -name "rsession" -type f | head -n 1)
rm -rf $(find $RSTUDIO -name "*x64*" -type d)
rm -rf $(find $RSTUDIO -name "*x86_64*" -type d)
echo done

# fixing icons
mkdir -p .rstudio-icons
pushd .rstudio-icons > /dev/null
echo -n "Downloading icons..."
ICNS_PATH=$(find $RSTUDIO  -name "RStudio.icns" -type f | head -n 1 | xargs dirname)
BASE_URL="https://raw.githubusercontent.com/rstudio/rstudio/main/src/node/desktop/resources/freedesktop/icons/512x512"

curl -S -s -O https://raw.githubusercontent.com/rstudio/rstudio/main/src/node/desktop/resources/icons/RProject.icns
mv RProject.icns $ICNS_PATH/

mk_iconset () {
    mkdir -p $1
    cd $1
    curl -S -s -O $2 
    PNG_NAME=$(basename $2)
    sips -z 16 16 $PNG_NAME --out icon_16x16.png > /dev/null
    sips -z 32 32 $PNG_NAME --out icon_32x32.png > /dev/null
    sips -z 128 128 $PNG_NAME --out icon_128x128.png > /dev/null
    sips -z 256 256 $PNG_NAME --out icon_256x256.png > /dev/null
    mv $PNG_NAME icon_512x512.png
    cd ..
    iconutil -c icns $1
    rm -r $1
    mv $(basename $1 .iconset).icns $ICNS_PATH/
}

mk_iconset RSource.iconset $BASE_URL/text-x-r-source.png
mk_iconset RMarkdown.iconset $BASE_URL/text-x-r-markdown.png
mk_iconset RDoc.iconset $BASE_URL/text-x-r-doc.png
mk_iconset QuartoMarkdown.iconset $BASE_URL/text-x-quarto-markdown.png

echo done
popd > /dev/null

echo
echo 'Run `killall Finder` to refresh the icons'
echo