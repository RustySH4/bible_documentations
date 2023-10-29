#!/bin/bash

bin='Graph90+E_03.50.2202.fls'
rm -f $bin
for file in ./*.bin ; do
  echo "add $file"
  cat "$file" >> $bin
done
