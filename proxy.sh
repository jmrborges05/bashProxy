#!/bin/bas -ih
shopt -s expand_aliases
PS3='Please enter your choice: '
options=("Enable proxy" "Disable proxy" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Enable proxy")
			#kill all instances of proxies listening on port 8080 and stop mac listening http proxy 
			lsof -ti tcp:8080 | xargs kill
			networksetup -setwebproxystate Wi-Fi off
			#get ip address of the machine 
			ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
			echo "SET HTTP PROXY"
			echo "SET PROXY FOR LOCAL IP :::: ${ip}"
			#setup http proxy with the machine ip 
			networksetup -setwebproxy Wi-Fi $ip 8080
			networksetup -setwebproxystate Wi-Fi on
			#open mitmweb proxy portal without any output on bash
			nohup mitmweb &>/dev/null &
			break
            ;;
        "Disable proxy")
			#kill all instances of proxies listening on port 8080 and stop mac listening http proxy 
			lsof -ti tcp:8080 | xargs kill
			networksetup -setwebproxystate Wi-Fi off
			echo "HTTP PROXY DISABLED"
			break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



