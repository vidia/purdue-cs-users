for HOST in moore{00..24} sslab{00..24} borg{00..24} xinu{00..21} sac{01..13} pod{1..5}-{1..5} pod0-0 mc{01..18} data lore; do
#echo $HOST
# who > who.txt && sed -i 's/^/data /' who.txt && awk '{ print $1,$2,$3 }' who.txt >> users.log
		ssh -o StrictHostKeyChecking=no `whoami`@${HOST}.cs.purdue.edu "who > who.txt && sed -i 's/^/${HOST} /' who.txt && awk '{ print \$1,\$2,\$3 }' who.txt >> ~/users.log"  >>/tmp/deploy_test 2>&1
done
echo "Done."
