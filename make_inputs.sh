INPUT_FILE="${1-data/inputs-alice}"

DOWNLOAD_URL="http://www.touhoumidi.altervista.org"
TEMP_DIR="tmp"

mkdir -p "$TEMP_DIR" && \

curl -ss $DOWNLOAD_URL | \
  grep 'a href="' | \
  sed 's#^.*href="\(.*\)".*#'$DOWNLOAD_URL'\1#' | \
  uniq | \
  xargs -n 1 curl -ss >> $TEMP_DIR/html && \

cat $TEMP_DIR/html | \
  grep 'a href="[^"]*\.mid"' | \
  sed 's#^.*href="\(.*\)/\(.*\)".*#'$DOWNLOAD_URL'\1/\2 -o '$TEMP_DIR'/\2#' | \
  uniq | \
  xargs -n 3 -P 5 curl -ss && \

# these tracks make abc2abc crazy
rm -f "$TEMP_DIR/12PoisonBodyForsakenDollaoba-ss.mid" && \
rm -f "$TEMP_DIR/th08_01.mid" && \
rm -f "$TEMP_DIR/th08_08.mid" && \
rm -f "$TEMP_DIR/th09_00.mid" && \
rm -f "$TEMP_DIR/bambooforest.mid" && \
rm -f "$TEMP_DIR/kappawayassaid.mid" && \
rm -f "$TEMP_DIR/OurHisouTensoku.mid" && \
rm -f "$TEMP_DIR/thebridgepeoplenolongercross.mid" && \
rm -f "$TEMP_DIR/werewolf.mid" && \

echo -n "" > $INPUT_FILE && \
find $TEMP_DIR/ -maxdepth 1 -name "*.mid" -type f -print0 | \
  xargs -0 -n 1 bash -c './midi_to_abc.sh $1 >> "'$INPUT_FILE'" || echo' - && \

rm -rf $TEMP_DIR && \

exit

