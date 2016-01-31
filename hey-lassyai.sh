#!/usr/bin/env sh

KEY="$HOME/.ssh/id_rsa"

ADDRESS=`grep OFFER /var/log/system.log | tail -n1 | cut -d' ' -f9`
KNOWNHOST=`grep $ADDRESS ~/.ssh/known_hosts | awk '{print $1}'`

if [ "$KNOWNHOST" = $ADDRESS ] ; then
  ssh-keygen -R $ADDRESS
fi

ssh-copy-id -i $KEY pi@$ADDRESS 
itamae ssh -u pi --host $ADDRESS ./recipes/sushi.rb -i $KEY
