#!/bin/bash
IF=$1
if [ -z "$IF" ]; then
        IF=`ls -1 /sys/class/net/ | head -1`
fi

RXPREV=-1
TXPREV=-1
MAXRXTX=1250

echo "Listening $IF..."
while [ 1 == 1 ] ; do
  RX=`cat /sys/class/net/${IF}/statistics/rx_bytes`
  TX=`cat /sys/class/net/${IF}/statistics/tx_bytes`
  if [ $RXPREV -ne -1 ] ; then
    let BWRX=$RX-$RXPREV
    let BWTX=$TX-$TXPREV 
		let KWRX=($BWRX/1000000)
		let KWTX=($BWTX/1000000)
	 	let SRXTX=$KWRX+$KWTX 
		let PRX=($KWRX*100/$MAXRXTX)
		let PTX=($KWTX*100/$MAXRXTX)
		let SPRXTX=$PRX+$PTX
    echo "Received: $KWRX Mb/s     |Sent: $KWTX Mb/s	    |TX/RX Max: $MAXRXTX Mb/s 	|(%)RX:$PRX      |(%)TX: $PTX     |%(RX+TX): $SPRXTX "
  fi
  RXPREV=$RX
  TXPREV=$TX
  sleep 1 
done
