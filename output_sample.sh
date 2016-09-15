INPUT_FILE="${1-data/inputs-alice}"
CHECKPOINT_NAME="$INPUT_FILE-check"

TOURCH_RNN=~/torch-rnn

OUTPUT_FILE="$INPUT_FILE-output"
OUTPUT_SPLIT="$OUTPUT_FILE-p"

OUTPUT_LENGTH=512000
START_TEXT=$'X: 1\nT:'

CHECKPOINT=$(ls -t $CHECKPOINT_NAME*.t7 | head -n1)
echo 'sampling with '$CHECKPOINT

LUA_PATH="$LUA_PATH;$TOURCH_RNN/?.lua" \
th $TOURCH_RNN/sample.lua -gpu -1 \
  -start_text "$START_TEXT" \
  -checkpoint $CHECKPOINT \
  -length $OUTPUT_LENGTH | \
#  grep -v -e "^V:.*$" | \
  grep -v -e "^$" > "$OUTPUT_FILE" && \

rm -f "$OUTPUT_SPLIT*" && \
awk '/^X:.*/{i ++}{print $0 > "'$OUTPUT_SPLIT'"i".abc"}' "$OUTPUT_FILE" && \

find . -wholename "*$OUTPUT_SPLIT*.abc" -type f -print0 | \
  sed -z 's/\.abc$//' | \
  xargs -0 -n 1 bash -c 'abc2midi $1.abc -o $1.mid' - && \
exit
