#!/bin/bash

set -e

command -v tv_merge >/dev/null 2>&1 || { echo >&2 "I require tv_merge but it's not installed. Please install xmltv-util package. Aborting."; exit 1; }
command -v tar >/dev/null 2>&1 || { echo >&2 "I require tar but it's not installed.  Aborting."; exit 1; }
command -v zip >/dev/null 2>&1 || { echo >&2 "I require zip but it's not installed.  Aborting."; exit 1; }

output="merge.xmltv"
i=0

for filename in $1
do
  if [[ "$filename" = "merge.xmltv" ]]; then
    continue
  fi

  if [[ $i -eq 0 ]]; then
    second=$filename
    i=$((i+1))
    continue
  fi

  if [[ $i -gt 1 ]]; then
    second=$output
  fi

  [[ $(grep -c "<programme" $second) -eq 0 ]] && continue

  echo -e "merge ${filename} $second"
  /usr/bin/tv_merge -i $filename -m $second -o $output
  i=$((i+1))

done;

[[ ! -f ./merge.xmltv ]] && echo "merge.xmltv file not generated!" && exit 0

mv ./merge.xmltv ./merge.xml && tar zcvf merge.tar.gz merge.xml && zip -r merge.zip merge.xml && rm merge.xml

exit 0