echo "converting file: $1" 1>&2 && \

# use midicsv to merge tracks
midicsv "$1" "/tmp/midi_to_csv" && \

head -n1 "/tmp/midi_to_csv" | \
  awk '{ print "0, 0, Header, "$4" 1, "$6 }' > "/tmp/midi_to_csv2" && \
echo '1, 0, Start_track' >> "/tmp/midi_to_csv2" && \
cat "/tmp/midi_to_csv" | \
  grep -v -e "^0,.*" | \
  grep -v -e "^[0-9]\+, [0-9]\+, Start_track" | \
  grep -v -e "^[0-9]\+, [0-9]\+, End_track" | \
  sort -k 2 -n -t, | \
  sed -e 's/^[0-9]\+\,/1,/' >> "/tmp/midi_to_csv2" && \
cat "/tmp/midi_to_csv2" | \
  sort -k 2 -n -t, | \
  tail -1 | \
  awk '{ print "1, "$2" End_track" }' >> "/tmp/midi_to_csv2" && \
echo "0, 0, End_of_file" >> "/tmp/midi_to_csv2" && \

csvmidi "/tmp/midi_to_csv2" "/tmp/midi_to_midi" && \

midi2abc "/tmp/midi_to_midi" > "/tmp/midi_to_abc" && \
abc2abc "/tmp/midi_to_abc" -nokeys | \
  # remove comments
  sed 's/[[:blank:]]*\%.*//' | \
  # flatten voice
  grep -v -e "^V:.*$" | \
  # remove blank lines
  grep -v -e "^\s*$"
