#!/bin/bash
#--ip in 4_row must be changed! "8.8.8.141" to your VIP-ip address
{
 sudo systemctl status keepalived | grep Active | grep running && isKeep='Up' || isKeep='Dn' 
 sudo systemctl status haproxy | grep Active | grep running && isHpxy='Up' || isHpxy='Dn' 
 sudo systemctl status nginx | grep Active | grep running && isNgnx='Up' || isNgnx='Dn' 
 ip a | grep eth0 | grep inet | grep "8.8.8.141" && isVip='(vip)' || isVip='(no_vip)'
} &> /dev/null

showhelp=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -a|--all) out_all=1; shift ;;
        -d|--docker) docker_chk=2; shift ;;
        -p|--patroni) patroni_chk=3 ; shift ;;
        -h|--help) showhelp=4 ;;
	*) echo "  Unknown parameter passed: $1 (use -h for help)"; exit 1 ;;
    esac
    shift
done

if [ $isKeep == "Up" ];
 then kCLR='[31;42m'
 else kCLR='[1;41m'
fi

if [ $isHpxy == "Up" ];
 then hCLR='[31;42m'
 else hCLR='[1;41m'
fi

if [ $isNgnx == "Up" ];
then nCLR='[31;42m'
else nCLR='[1;41m'
fi

if [ $isVip == "(vip)" ];
then vCLR='[1;36;44m'
else vCLR='[1;36m'
fi

if [[ $showhelp -eq 0 ]]; then
  echo -e "  Keepalived_\e${kCLR}${isKeep}\e[0m,  Haproxy_\e${hCLR}${isHpxy}\e[0m,  Nginx_\e${nCLR}${isNgnx}\e[0m,  \e${vCLR}${isVip}\e[0m"
fi

#echo "5. Docker's"
if [[ $out_all -gt 0 ]]; then
  docker ps -a --format="table | {{.Names}}\t{{.Image}} dockers\t{{.Status}}"
fi

if [[ $out_all -gt 0 ]]; then
  echo "-  Patroni"
  sudo patronictl -c /etc/patroni/postgres.yml list | grep cluster_p
fi

if [[ $docker_chk -gt 0 ]]; then
  docker ps -a --format="table | {{.Names}}\t{{.Image}} dockers\t{{.Status}}"
fi

if [[ $patroni_chk -gt 0 ]]; then
  echo "-  Patroni"
  sudo patronictl -c /etc/patroni/postgres.yml list | grep cluster_p
fi

if [[ $showhelp -gt 0 ]]; then
  echo "  By default script show only status (Up|Down) of services: Keepalived, Haproxy, Nginx & VIP."
  echo "     -a [--all]     show all information."
  echo "     -d [--docker]  show output of cmd: docker ps"
  echo "     -p [--patroni] show output of cmd: sudo patronictl -c /etc/patroni/postgres.yml list"
fi
