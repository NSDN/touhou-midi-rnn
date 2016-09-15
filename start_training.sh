INPUT_FILE="${1-data/inputs-alice}"
CHECKPOINT_NAME="$INPUT_FILE-check"

TOURCH_RNN=~/torch-rnn
RNN_SIZE=512

CHECKPOINT=$(ls -t $CHECKPOINT_NAME*.t7 | head -n1)
if [ $CHECKPOINT ]
then
  echo 'starting with '$CHECKPOINT

  LUA_PATH="$LUA_PATH;$TOURCH_RNN/?.lua" \
  th $TOURCH_RNN/train.lua -gpu -1 -checkpoint_name $CHECKPOINT_NAME \
    -input_h5 $INPUT_FILE.h5 -input_json $INPUT_FILE.json \
    -init_from $CHECKPOINT -reset_iterations 0
else
  source $TOURCH_RNN/.env/bin/activate && \
  python $TOURCH_RNN/scripts/preprocess.py \
    --input_txt $INPUT_FILE \
    --output_h5 $INPUT_FILE.h5 \
    --output_json $INPUT_FILE.json && \
  deactivate && \

  LUA_PATH="$LUA_PATH;$TOURCH_RNN/?.lua" \
  th $TOURCH_RNN/train.lua -gpu -1 -rnn_size $RNN_SIZE -checkpoint_name $CHECKPOINT_NAME \
    -input_h5 $INPUT_FILE.h5 -input_json $INPUT_FILE.json
fi
