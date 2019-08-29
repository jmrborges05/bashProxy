#!/bin/bas -ih
shopt -s expand_aliases

function stopProxy() {
    #kill all instances of proxies mitmweb listening and stop mac listening http proxy
    ps -ef | grep mitmweb | grep -v grep | awk '{print $2}' | xargs kill -9
    networksetup -setwebproxystate Wi-Fi off
}

function enableProxy() {
    #get ip address of the machine
    ip=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    echo "SET HTTP PROXY"
    echo "SET PROXY FOR LOCAL IP :::: ${ip}"
    #setup http proxy with the machine ip
    networksetup -setwebproxy Wi-Fi $ip 8080
    networksetup -setwebproxystate Wi-Fi on
    #open mitmweb proxy portal without any output on bash
    nohup mitmweb &>/dev/null &
	echo "PROXY SETUP AND ENABLE"
}



PS3='Please enter your choice: '
options=("Enable proxy" "Disable proxy" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Enable proxy")
            stopProxy
            enableProxy
            break
        ;;
        "Disable proxy")
            stopProxy
            echo "HTTP PROXY DISABLED"
            break
        ;;
        "Quit")
            break
        ;;
        *) echo "invalid option $REPLY";;
    esac
done



