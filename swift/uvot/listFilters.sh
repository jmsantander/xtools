obs=`ls -1 data/`

for o in $obs; do
  echo "Obs: $o"
  files=`ls -1 data/$o/uvot/image/sw*sk*img*`
  for f in $files; do
    filter=`basename $f | cut -d_ -f1 | colrm 1 13`
    echo "Filter: $filter"
  done
  echo
done
