#!/bin/bash

#ARCH
arch=$(uname -a)

#CPU
CPUS=$(lscpu | grep "CPU(s):" | grep -v NUMA | awk '{print $2}')

#vCPUS=$(nproc --all)
mCPUS=$(lscpu | grep "(s) per" | awk '{total=$4; getline; total*=$4; print total}')
vCPUS=$((CPUS * mCPUS))

#Memory Usage
uMEM=$(free -tm | grep T | awk '{print $3}')
tMEM=$(free -tm | grep T | awk '{print $2}')
pMEM=$(awk -v used="$uMEM" -v total="$tMEM" 'BEGIN { printf "%.2f\n", (used/total)*100 }')
#pMEM=$(echo "scale=2; $uMEM/$tMEM" | bc)

#Disk Usage
uDISK=$(df --output=used -BG | awk 'NR>1 {sum+=$1} END {print sum}')
tDISK=$(df --output=size -BG | awk 'NR>1 {sum+=$1} END {print sum}')
#pDISK=$(df --output=ipcent | awk 'NR>1 {sum+=$1} END {print sum}')
pDISK=$((uDISK * 100 / tDISK))


	wall "	#Architeture: $arch
	#CPU physical: $CPUS
	#vCPU: $vCPUS
	#Memory Usage: $uMEM/${tMEM}MB ($pMEM%)
	#Disk Usage: $uDISK/${tDISK}GB ($pDISK%)"

