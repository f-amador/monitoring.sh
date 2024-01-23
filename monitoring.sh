#!/bin/bash

# Get system architecture information
arch=$(uname -a)

# Get the number of physical CPUs
TCPUS=$(lscpu | grep "CPU(s):" | grep -v NUMA | awk '{print $2}')
CPUS=$(lscpu | awk '/^CPU\(s\):/ {print $2}')

# Get the number of cores per CPU
mCPUS=$(lscpu | grep "(s) per" | awk '{total=$4; getline; total*=$4; print total}')

# Calculate the total number of virtual CPUs (vCPUs)
vCPUS=$((CPUS * mCPUS))

# Get the total and used memory in MB
uMEM=$(free -tm | grep T | awk '{print $3}')
tMEM=$(free -tm | grep T | awk '{print $2}')

# Calculate the percentage of used memory
pMEM=$(awk -v used="$uMEM" -v total="$tMEM" 'BEGIN { printf "%.2f\n", (used/total)*100 }')

# Get the total and used disk space in GB
uDISK=$(df --output=used -BG | awk 'NR>1 {sum+=$1} END {print sum}')
tDISK=$(df --output=size -BG | awk 'NR>1 {sum+=$1} END {print sum}')

# Calculate the percentage of used disk space
pDISK=$((uDISK * 100 / tDISK))

# Get the CPU load percentage
#uCPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | tail -n1)
uCPU=$(uptime | awk '{print ($9 + $10 + $11)/3}')
# Get the last boot time
lastBoot=$(who -b | awk '{print $3, $4}')

# Check if LVM is used
uLVM=$(if lsblk | grep -q 'lvm'; then echo 'yes'; else echo 'no'; fi)

# Count the number of active TCP connections
cTCP=$(ss -tH | wc -l)

# Check if there are any established TCP connections
eTCP=$(ss -tH | grep -q 'ESTAB' && echo 'ESTABLISHED' || echo 'NOT ESTABLISHED')

# Count the number of logged in users
uLOG=$(who | awk '{print $1}' | uniq | wc -l)

# Print the IP address
sIP=$(hostname -I)

# Print the MAC address
sMAC=$(ip link | awk '/ether/ {print $2}')

# Print the number of sudo cmds used
uSUDO=$(sudo journalctl _COMM=sudo | wc -l)

# Print all the collected information
wall "	#Architeture: $arch
    #CPU physical: $CPUS
    #vCPU: $vCPUS
    #Memory Usage: $uMEM/${tMEM}MB ($pMEM%)
    #Disk Usage: $uDISK/${tDISK}GB ($pDISK%)
    #CPU load: $uCPU%
    #Last boot: $lastBoot
    #LVM use: $uLVM
    #Connections TCP: $cTCP $eTCP
    #User log: $uLOG
    #Network: IP $sIP ($sMAC)
    #Sudo: $uSUDO cmd"
