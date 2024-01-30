# bash-20231216
Bash script show state (up/dn) 3 services on linux cluster in one row (keepalive, haproxy, nginx, vip)
Look's like this with color hightlight Up & Dn:

<h2>Keepalived_Up,  Haproxy_Dn,  Nginx_Up,  (vip)</h2>

Script have some parameters:
   <p>-a [--all]       show all indormation</p>
   <p>-d [--docker]    show output of command: docker ps</p>
   <p>-p [--patroni]   show output of command: sudo patronictl -c /etc/patroni/postgres.yml list</p>

![img](https://github.com/IgorConst/bash-20231216/assets/15715197/d30916f4-1d8a-4234-b8fc-eafb2b0e884f)
