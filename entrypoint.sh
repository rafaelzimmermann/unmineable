#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'

print_help () {
	echo "CPU crypto miner."
	echo
	echo "Usage: "
	echo "docker run rafaelzimmermann/unminable --coin=ETH --wallet=YOUR_WALLET_ADDRESS "
	echo "options:"
	echo "-c/--coin            The coin to be mined."
	echo "                     Check available coins here: https://unmineable.com/coins"
	echo "-w/--wallet          Your ETH wallet address."
	echo "-n/--worker-name     Worker name."
	echo 

}

for i in "$@"
do
case $i in
    -c=*|--coin=*)
    COIN="${i#*=}"
    ;;
    -w=*|--wallet=*)
    WALLET="${i#*=}"
    ;;
    -d=*|--difficulty=*)
    DIFFICULTY="${i#*=}"
    ;;
    -n=*|--worker-name=*)
    WORKER="${i#*=}"
    ;;
esac
done

if [ -z "$COIN" ] || [ -z "$WALLET" ]
then
	printf "${RED}Error: ${NC}Missing mandatory parameters.\n"
	print_help
	exit -1
fi

if [ -z "$DIFFICULTY" ]
then    
    DIFFICULTY="50000"
fi

if [ -z "$REFERAL" ]
then
	REFERAL="jnad-vt8z"
fi

if [ -z "$WORKER" ]
then    
    WORKER="worker-1"
fi



echo COIN = ${COIN}
echo WALLET = ${WALLET}
echo DIFFICULTY = ${DIFFICULTY}
echo WORKER = ${WORKER}
echo DEFAULT = ${DEFAULT}

sed -i "s/COIN/$COIN/g" /app/config.json
sed -i "s/WALLET/$WALLET/g" /app/config.json
sed -i "s/WORKER/$WORKER/g" /app/config.json
sed -i "s/DIFFICULTY/$DIFFICULTY/g" /app/config.json

echo exec /usr/sbin/xmrig --rig-id="${WORKER}" -p x -u "${COIN}:${WALLET}.${WORKER}#${REFERAL}" -c /app/config.json

exec /usr/sbin/xmrig --rig-id="${WORKER}" -p x -u "${COIN}:${WALLET}.${WORKER}#${REFERAL}" -c /app/config.json
