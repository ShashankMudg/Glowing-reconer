#!/bin/bash
 
#This is a simple script consisting various functions in a jibberish way
#These will be simplified later on

echo "                      ____________                             ____________ ___________
        --||||||||         |            |    ||    	    ||	    ||		||	     ||	
	--		   |		|    ||		    ||	    ||		||   	     ||
	--		   |		|    ||		    ||	    ||		||           ||
	--		   |		|    ||		    ||	    ||		||           ||
	--||||||||	   |		|    ||		    ||	    || 		||           ||
	--		   |		|    ||		    ||	    ||		||           ||
	--		   |		|    ||		    ||	    ||		||           ||
	--		   |		|    ||             ||      ||		||           ||
	--||||||||	   |		|    ||_____________||      ||		||           ||

                       
"

# This script is for recon purposes 

mkdir $1 && cd $1 


if [ $2 == yes ]
then	
echo "Performing Subdomain Scan"
assetfinder --subs-only $1 > hostsim
assetfinder --subs-only $1 | httprobe > hosts
echo "  "
echo "  "
fi

# This will perform a nmap scan for default ports many more ports to add 
if [[ $3 == yes ]]
then
echo "Doing nmap scan"
nmap -p 20,21,22,23,25,42,53,68,69,80,123,110,135,137,138,139,143,161,162,389,636,873,993,995,443,1433,1434,3306,3389,5800,5900  $1 -oN nmap.txt
echo "  "
echo "  "
else
	echo " "
	echo "  "
fi

#Directory Scan

if [[ $4 == yes ]]
then
	echo "Performing ffuf"
	ffuf -u https://$1/FUZZ/ -w /root/Downloads/DirBuster-0.12/directory-list-2.3-medium.txt > directory
	echo "  "
	echo "  "
fi

# Waybackurls scan

if [[ $5 == yes ]]
then
	echo "Waybackurls Scan"
	waybackurls $1 > url\'s
	echo "Waybackurls found"
	wc url\'s -l 
	echo "  "
	echo "  "
fi

# aquatone scan

if [[ $6 == yes ]]
then
	echo "Performing aquatone scan"
        cat hosts | aquatone -chrome-path /usr/bin/chromium -out aquatone_res 2> /dev/null
	if [[ $? -eq 0 ]]
	then
		echo "Aquatone processed successfully"
	else 
		echo "Chromium path or host file not found"
	fi
	echo "  " 
	echo "  ":
	
fi

#arjun scan

echo "Now is the time to perform arjun scan which takes some time...enter yes if you want to perform the scan and in many hosts it takes a lot of time"

read scan 

if [[ $scan == yes ]]
then 
	echo "Waybackurls found"
	arjunurl=$(wc -l url\'s | awk -F " " '{print $1}') 
	echo $arjunurl
	echo "Do you want to perform scan on all the url's...it yes enter yes otherwise enter the number of url's on which you want to perform arjun scan"
	read scan1 
	if [[ $scan1 == yes ]]
	then
	arjun.py -i url\'s -o arjun 2 > /dev/null 
	fi
	if [[ $scan -le $arjunurl ]]
	then 
		head -n $scan1 url\'s > arjunfile
		arjun.py -i arjunfile -o arjun  2> /dev/null
	fi
	if [[ $? -eq 0 ]]
	then 
		echo "  "
		echo "Arjun Processed SUccessfully"
	else 
		echo "  "
		echo "Arjun encountered an error "
	fi
	echo "  "
	echo "  "
fi

#gau_scan

echo "There are many subdomins of $1 enter yes if you want to perform the scan , enter no if you don't want to perform the scan"

read gau_res

if [[ $gau_res == yes ]]
then 
	mkdir gau
	echo "  "
	echo "  "
	gauurl=$(wc hostsim -l | awk -F " " '{print $1}')
	echo "wc is "
	echo $gauurl
	echo "Printed"
	echo "Enter yes if you want to perform scan on all" echo "$gauurl" echo "subdomains , enter number if you want to perform the scans of particular number of subdomians"
	read gauans
	if [[ $gauans -le $gauurl ]]
	then 
		echo $gauans
		head -n $gauans hostsim > gaulist
		echo "Printing gaulist"
		cat gaulist
		echo "billi"
	        while read hs ; do gau -o gau/$hs.txt $hs ; done < gaulist 
	fi

fi


# echo "Now is the time to perform nuclei scan for low hanging bugs , input yes if you want to scan and input no ig you don't"

#nuclei scan

#read nuc_sc

#if [[ $nuc_sc == yes ]]
#then
#	echo "Enter the tempate path you want to scan"
#	read tpath
#	nuclei -l 



