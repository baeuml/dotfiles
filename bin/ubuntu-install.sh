#!/bin/bash

enable_repos()
{
    if `grep -q 12.04 /etc/issue.net` ; then
        echo deb http://cvhci.anthropomatik.kit.edu/linux-install/ubuntu/apt/precise ./ > /etc/apt/sources.list.d/cvhci.list
        echo deb http://cvhci.anthropomatik.kit.edu/linux-install/ubuntu/mirror precise main restricted universe multiverse > /etc/apt/sources.list.d/cvhci-mirror.list
        echo deb http://cvhci.anthropomatik.kit.edu/linux-install/ubuntu/mirror precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/cvhci-mirror.list
        echo deb http://cvhci.anthropomatik.kit.edu/linux-install/ubuntu/mirror precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/cvhci-mirror.list
    else
        echo deb http://cvhci.anthropomatik.kit.edu/linux-install/ubuntu/apt/oneiric ./ > /etc/apt/sources.list.d/cvhci.list
    fi

    echo deb http://www.mendeley.com/repositories/ubuntu/stable / > /etc/apt/sources.list.d/mendeleydesktop.list
}

check_network()
{
    echo -ne "Checking if network is up..."
    i=0
    while ! ping -q -c 1 141.3.14.1 >/dev/null; do
        i=$(( i+1 ))
        sleep 1
        echo -ne "."
        if [[ $i -gt 30 ]]; then
            echo
            echo "Network is not up. Please fix and restart..."
            exit 1
        fi
    done
    echo
}

refresh_packages()
{
    echo "Refreshing packages..."
    apt-get -y update
    apt-get upgrade
}


install_common()
{
    apt-get -y --allow-unauthenticated install cvhci-common
}


if [[ $(id -u) != 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

echo "Welcome to installer..."
echo "======================="

enable_repos
check_network
refresh_packages
install_common
