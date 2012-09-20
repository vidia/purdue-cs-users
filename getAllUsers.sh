#!/bin/bash

rm ~/users.txt

echo "Deploying command '$@'..."

for HOST in moore{00..24} sslab{00..24} borg{00..24} xinu{00..21} sac{01..13} pod{1..5}-{1..5} pod0-0 mc{01..18}; do
    echo $HOST
    ssh -o StrictHostKeyChecking=no `whoami`@${HOST}.cs.purdue.edu "hostname -s >> ~/users.txt && echo --begin users-- >> ~/users.txt && who >> ~/users.txt && echo --end host-- >> ~/users.txt"  >>/tmp/deploy_test 2>&1
done

echo "Done."
