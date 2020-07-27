Widget Server

Author

   Fernando Romo (pop@cofradia.org)

License
     
    GNU GENERAL PUBLIC LICENSE Version 3
    https://www.gnu.org/licenses/gpl-3.0.en.html
    See LICENSE.txt
    
Abstract

   Apache Server to offer widgets for Streaming programs like OBS or Ecamm on Mac OS and Linux
   
   Tested with OBS Studio 25.0.8 (Mac OS and Linux) and Ecamm Live 3.5.8 (Mac OS).

Description

   This are a basic Apache Web Serve to offer diferent types of Widgets to a different streaming programs.
   

   the /etc/widget-server.conf  contains the parameters of the service:
   
       # SipBan Configuration File
       [db_pg]
       name = "dbi:Pg:dbname=Widgets;host=127.0.0.1"
       user = "dba"
       pass = "cacahuamilpa"

       [timer]
       dbping    = 600

   The file is sefl explanatory. only put the name of the database replacing "Widgets" for any name you want to use.
    
Install
   
      1) download file
      
         git clone https://github.com/elpop/widget-server.git
      
      2) install perl dependecies:
         
         a) Ubuntu/Debian
         
            sudo apt-get install libproc-pid-file-perl libconfig-simple-perl libtime-hires-perl
         
         b) Redhat/CentOS/Fedora
         
            sudo dnf install perl-Proc-PID-File perl-Config-Simple perl-Time-HiRes
         
      3) Copy configuration files
      
         cd sipban
         cp sipban.pl /usr/local/bin/.
         cp etc/sipban.conf /etc/.
         cp etc/sipban.wl /etc/.
       
      4) Edit and add /etc/asterisk/manager.conf acording our sample on sipban/etc/asterisk/manager.conf
         
         use " asterisk -rx'manager reload' " after change the manager configuration file
         
      5) install the launch scripts
      
         a) for init.d 
         
            cp etc/init.d/sipban /etc/init.d/.
            chkconfig --level 345 sipban on
            /etc/init.d/sipban start
                    
         b) for systemd
         
            cp etc/systemd/system/sipban.service /etc/systemd/system/.
            systemctl enable sipban
            service sipban start
            
Operation

   The service are fully automatic, but you can control through the port 4451 (or another defined on /etc/sipban.conf), v.g.:
   
         [root@pbx ~]# telnet localhost 4451
         Trying ::1...
         telnet: connect to address ::1: Connection refused
         Trying 127.0.0.1...
         Connected to localhost.
         Escape character is '^]'.

         Sipban
         use 'help' for more commands
         sipban>
         
         
         sipban>help

         Commands:

         block                => List blocked ip address
         block {ip address}   => block ip address
         unblock [ip address] => unblock ip address
         flush                => Dump the blocked IP's and clear rules on chain sipban-udp
         restore              => If exists a dump file restore the rules from it
         ping                 => Send ping to Asterisk AMI
         uptime               => show the program uptime
         wl                   => show white list ip address
         exit/quit            => exit console session

         sipban>

   The log files reside on the file "/var/log/sipban.log"
   
         [root@pbx ~]# tail -f /var/log/sipban.log 
         [2019-06-12 12:01:50] SipBan Start
         [2019-06-12 12:01:50] WHITE LIST => 127.0.0.1
         [2019-06-12 12:01:55] BLOCK => 221.121.138.167
         [2019-06-12 12:01:59] BLOCK => 77.247.110.158
         [2019-06-12 12:02:01] BLOCK => 102.165.39.82
         [2019-06-12 12:02:06] BLOCK => 102.165.32.36
         [2019-06-12 12:02:07] BLOCK => 102.165.49.34
         [2019-06-12 12:02:08] BLOCK => 77.247.109.243
         ...   

   You can check the iptables rules with "iptables -S sipban-udp"
   
         [root@pbx ~]# iptables -S sipban-udp
         -N sipban-udp
         -A sipban-udp -s 221.121.138.167/32 -j DROP 
         -A sipban-udp -s 77.247.110.158/32 -j DROP 
         -A sipban-udp -s 102.165.39.82/32 -j DROP 
         -A sipban-udp -s 102.165.32.36/32 -j DROP 
         -A sipban-udp -s 102.165.49.34/32 -j DROP 
         -A sipban-udp -s 77.247.109.243/32 -j DROP 
         ...
         -A sipban-udp -j RETURN 

To-do

   - IPv6 support
   - IP Class blocking

