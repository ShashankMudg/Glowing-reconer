#!/bin/bash

echo "
                     
        --||||||||          ------------     ||             ||      ||----------||-----------||           
        --                 |            |    ||             ||      ||          ||           ||
        --                 |            |    ||             ||      ||          ||           ||
        --                 |            |    ||             ||      ||          ||           ||
        --||||||||         |            |    ||             ||      ||          ||           ||
        --                 |            |    ||             ||      ||          ||           ||
        --                 |            |    ||             ||      ||          ||           ||
        --                 |            |    ||             ||      ||          ||           ||
        --||||||||         |            |    ||_____________||      ||          ||           ||


"
#Function to perform subdomain scaN
function assetf() {
echo "Performing Subdomain Scan"
assetfinder --subs-only $name > hostsim
assetfinder --subs-only $name | httprobe > hosts
wafin=$(wc -l hosts | awk -F " " '{print $name}')
echo "  "
echo "  "
}


#Function to perform port scan 
function ports() {
echo "Doing nmap scan"
naabu -port 20,21,22,23,25,42,53,68,69,80,123,110,135,137,138,139,143,161,162,389,636,873,993,995,443,1433,1434,3306,3389,5800,5900 -host $name -json ports
echo "  "
echo "  "
}

# functionn to performm directory bruteforcing
function direc() {
echo "Performing ffuf"
sudo ffuf -u https://$name/FUZZ/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt > directory
echo "  "
echo "  "
}

#function to perform wayback machine scan
function wayback() {
echo "Waybackurls Scan"
waybackurls $name > url\'s
echo "Waybackurls found"
wc url\'s -l 
echo "  "
echo "  "
}

#function to check for subdomain takeovers
function subt() {
echo "Checking for subdomain takeovers"
if [[ -f hosts ]]
then 
	subzy --targets hosts | tee takeover
else
	echo "Hosts file ddoesn't exists"
fi
}


#function to perform aquatone scan
function aqua() {
if [[ -f hosts ]]
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
	echo "  "
else
	echo "Hosts file not found"
fi
}

#function to perform arjun scan
function arju() {     
if [[ -f url\'s ]]
then
echo "Waybackurls found"
arjunurl=$(wc -l url\'s | awk -F " " '{print $1}')
echo $arjunurl
echo "Do you want to perform scan on all the url's...it yes enter yes otherwise enter the number of url's on which you want to perform arjun scan"
read scan1
	if [[ $scan1 == yes ]]
        then
                arjun -i url\'s -o arjunout 2>/dev/null 
        fi
        if [[ $scan -le $arjunurl ]]
        then
                head -n $scan1 url\'s > arjunfile
		cat arjunfile
                arjun -i arjunfile -o arjun  2> /dev/null
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
     
     else 
	     echo "Input waybakurl's file not found"
	
     fi
}

#function to perform gau scan
function gauep() {
if [[ -f hostsim ]]
then
mkdir gau
gauf=$( wc -l hostsim | awk -F " " '{print $1}' )
echo "There are $gauf  subdomains of the webste enter yes if you wantr to perform scan on all the domains , otherwise enter the number of doamins you want to perform scan on"
read gau_ou
		if [[ $gau_ou == yes ]] 
		then 
			while read hs ; do gau --o gau/$hs.txt $hs ; done < hostsim
		
		elif [[ $gau_ou -lt gauf ]]
		then
			head -n $gau_ou hostsim > gaulist
			cat gaulist
			while read hs ; do gau --o gau/$hs.txt $hs ; done < gaulist
		
		else 
			echo "Wrong Inout provided"
		fi
else
	echo "File to resolve host not found"
fi

}

#function to perform wafwoof scan
function wafwo() {
if [[ -f hosts ]]
then
#wafin=$(wc -l hosts | awk -F " " '{print $1}')
echo "The file of host input contain $wafin hosts enter yes if you want to perform scan on all the hosts , or enter the number of host you want to perform scan on"
read waf_ou
		if [[ $waf_ou == yes ]]
		then 
			wafw00f -i hosts -o wafwoof_out

		elif [[ $waf_ou -lt wafin ]]
		then
			head -n $waf_ou hosts > waffile
			wafw00f -i waffile -o wafwo_out

		else 
			echo "Wrong input provided"
		fi

else
echo "File to resolve host not found"
fi
}

#Function to perform favicon hash scan
function favhash() {
while read line ; do shodan search ssl.cert.issuer.cn:"$name" http.favicon.hash:$line --fields ip_str,port --separator " " | awk '{print $1":"$2}' ; echo "$line"  ; cat ~/Downloads/scrapts/shodan-favicon-hashes.csv | grep -e "$line"; done < ../favicon_hash.txt
}

#function to perform nuclei scan
function nucl() {
	if [[ -f hosts ]]
	then 
	nuclei -l hosts -t ~/nuclei-templates/exposed-panels/* | tee exposed_panels
	nuclei -l hosts -t ~/nuclei-templates/technologies/* | tee tech
	nuclei -l hosts -t ~/nuclei-templates/default-logins/* | tee logins1
	else
		echo "Hosts  file doesn't exists"
	fi
}

#Getting Options
while getopts ":d: :sd :c :s :w :f :p :h :i :t :a :g :q :u :j" opt; do
  case $opt in
    d)
      name=$OPTARG
      if [[ -d $name ]]
      then
	      cd $name
      else
	      mkdir $name && cd $name
      fi
      ;;
    s)
      assetf 
      ;;
    w)
      wayback
      ;;
    j)
      arju
      ;;
    f)
      direc
      ;;
    p)
      ports
      ;;
    a)
      aqua
      ;;
    i)
      favhash
      ;;
    t)
      subt
      ;;
    q)
      wafwo
      ;;
    g)
      gauep
      ;;
    u)
      nucl
      ;;
    h)
      echo "
      -d                           Domain name
      -s                           Subdomain Scan
      -w                           waybackurl scan
      -p                           Port Scan
      -f                           Directory Scan
      -l 		           Nuclei Test
      -s			   Shodan Scan
      -i                           Favico Ico Enumeration
      -t  			   Check For subdomain Takeovers
      -q                           Firewall Scans
      -g			   Gau Scans
      -u                           Nuclei Scan"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "
      -d                           Domain name
      -s			   Subdomain Scan
      -w                           waybackurl scan
      -p      			   Port Scan
      -f                           Directory Scan
      -n                           Nuceli Scan
      -s                           Shaodan Scan
      -i                           Favicon Ico Enumeration
      -t			   Check For Subdomain Takeovers
      -q                           Firewall Scans
      -g                           Gau Scans
      -u                           Nuclei Scan"
      exit
      ;;
  esac
done
