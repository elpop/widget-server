# Widget Server

## Author

   Fernando Romo (pop@cofradia.org)

## License
```
GNU GENERAL PUBLIC LICENSE Version 3
https://www.gnu.org/licenses/gpl-3.0.en.html
See LICENSE.txt
``` 
## Abstract

   Apache-server to offer database based widgets to OBS, Ecamm Live or other video streaming tool
   
   Tested with OBS Studio 25.0.8 (Mac OS and Linux) and Ecamm Live 3.5.8 (Mac OS).
   
***Voting poll sample***
![polls_demo.png](https://raw.githubusercontent.com/elpop/widget-server/master/html/images/Demo/polls_demo.png)  
***Scoreboard sample***
![Scoreboard_demo.png](https://raw.githubusercontent.com/elpop/widget-server/master/html/images/Demo/scoreboard_demo.png)
## Description

This is a basic Web Server to offer diferent types of Widgets using data store in a database.
   
Is design to work with streaming programs like OBS ([https://obsproject.com]()) and Ecamm Live ([https://www.ecamm.com]()).
   
The info to display is stored in a Postgresql Data base ([https://www.postgresql.org]()), could be another database like MariaDB, but i prefer Postgresql.
   
## Install and configuration
   
### Mac OS
   
You need the git program and another utilities, are available with the Xcode Command Line Tools, I sugests install Xcode from the Apple App Store, then check if you have the command line tools.  

1. Open the Terminal application and put:  
      
    ```
    xcode-select --install
    ```     

    If are already instaled you see this message:  
  
    ```
    xcode-select: error: command line tools are already installed, use Software Update to install updates        
    ```  

    if are not previously installed, the process ask your admin passsword and proceed the installation.

2. Download the project repository to your disk in your prefered path.
  
    ```
    git clone https://github.com/elpop/widget-server.git
    ```
  
    When the clone process end, you see a new directory called widget-server.
    
    Enter in the directory and copy the configurations files and customize:
    
    ```
    cd widget-server  
    sudo cp etc/widget-server.conf /etc/.  
    sudo cp etc/apache2/widget-server.conf /etc/apache2/extra/.
    ```
    
3. Customize the configuration files

    I use the **vim text editor**, is available on Mac OS and any Linux flavor. If you don't have any experience with, please read this guide: 
    [vim for beginners](https://computers.tutsplus.com/tutorials/vim-for-beginners--cms-21118)
       
    * for delivery your widget in your local machine (the same with your striming program), you need to add the name of the webserver in /etc/hosts

        ```
        sudo vim /etc/hosts
        ```  
    
        You see something like this:  
    
        ```
        ##
        # Host Database
        #
        # localhost is used to configure the loopback interface
        # when the system is booting.  Do not change this entry.
        ##
        127.0.0.1	localhost widget
        255.255.255.255	broadcasthost
        ::1             localhost
        ```
    
        You see the line with "**127.0.0.1 localhost**" you need to append the name of your apache virtual host name, in this case "**widget**".
    
    * Edit the widget-server config file

        ```
        sudo vim /etc/widget-server.conf
        ```
    
        The /etc/widget-server.conf contains the parameters of the service:  
        
        ```
        # Widget Server Configuration File
        [db_pg]
        name = "dbi:Pg:dbname=Widgets;host=127.0.0.1"
        user = "dba"
        pass = "cacahuamilpa"
        
        [timer]
        dbping    = 600
        ```

        The file is sefl explanatory. only put the name of the database replacing Widgets for any name you want to use.

    * Edit the apache web server configuration file

        ***Here is where the things start to be more difficult***, you need to know the exactly path where you clone directory are. is easy whit this command:
        
        ```
        pwd
        ```
        
        and you see somthing like

        ```
        /Volumes/Pop-Data/pop/Devel/widget-server
        ```
        
        or you path. Is important to copy this to procced the next step

    * Edit the apache virtual host configuration file
    
        ```
        sudo vim /etc/apache2/extra/widget-server.conf
        ```
    
        You see the configuration almost duplicate, this is because we use port 80 for OBS (don't like ssl auto signed certs) and the port 443 for Ecamm (don't like plain http conections).

        ```
        #<VirtualHost *:80>
        #        ServerName widget
        #        ServerAlias widget
        #        Redirect permanent / https://widget/
        #</VirtualHost>
          
        <VirtualHost *:80>
            ServerName widget
            ServerAlias widget
            DocumentRoot "/Volumes/Pop-Data/pop/Devel/widget-server/html"
            ErrorLog "/private/var/log/apache2/widget-server-error_log"
            CustomLog "/private/var/log/apache2/widget-server-access_log" common
            ServerAdmin pop@cofradia.org
            ScriptAlias /bin/ /Volumes/Pop-Data/pop/Devel/widget-server/cgi-bin/
            ServerPath /Volumes/Pop-Data/pop/Devel/widget-server/html
            SetEnv CONF_FILE /etc/widget-server.conf
            # AddDefaultCharset UTF-8
            AddDefaultCharset on
            <Directory /Volumes/Pop-Data/pop/Devel/widget-server/ >
                AddHandler cgi-script .cgi .pl
                Options Indexes FollowSymLinks
                Require all granted
            </Directory>
        </VirtualHost>
          
        <VirtualHost *:443>
            ServerName widget
            ServerAlias widget
            DocumentRoot "/Volumes/Pop-Data/pop/Devel/widget-server/html"
            ErrorLog "/private/var/log/apache2/widget-server-error_log"
            CustomLog "/private/var/log/apache2/widget-server-access_log" common
          
            SSLEngine on
            SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
            SSLCertificateFile /etc/apache2/ssl/widget.crt
            SSLCertificateKeyFile /etc/apache2/ssl/widget.key
          
            ServerAdmin pop@cofradia.org
            ScriptAlias /bin/ /Volumes/Pop-Data/pop/Devel/widget-server/cgi-bin/
            ServerPath /Volumes/Pop-Data/pop/Devel/widget-server/html
            SetEnv CONF_FILE /etc/widget-server.conf
            # AddDefaultCharset UTF-8
            AddDefaultCharset on
            <Directory /Volumes/Pop-Data/pop/Devel/widget-server/ >
                AddHandler cgi-script .cgi .pl
                Options Indexes FollowSymLinks
                Require all granted
            </Directory>
        </VirtualHost>
        ```
            
        You need to replace the path on the **DocumentRoot**, **ScriptAlias**, **ServerPath** and **Directory** arguments with the path saved.

        For example, if your path is ***/Users/joe/widget-server*** you replace the arguments like this

        ```
        DocumentRoot "/Users/joe/widget-server/html"
        ScriptAlias /bin/ /Users/joe/widget-server/cgi-bin/
        ServerPath /Users/joe/widget-server/html
        <Directory /Users/joe/widget-server/ >
        ```
        
        Remeber to do it in both definitios of port 80 and 443.

        The arguments

        ```
        ServerName widget
        ServerAlias widget
        ```
        
        Can be the name you want, but need to match with your definition in /etc/hosts.

        Now, if you note, the definition of the port 443, we need to have a SSL certificate to work with Ecamm Live, OBS only accet valid SSL certificates emited by a CA, thas why use the port (80).

        To generate a self signed SSL certificate we need to create a directory and the certificates:
    
        ```
        sudo mkdir /etc/apache2/ssl
        sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/widget.key -out /etc/apache2/ssl/widget.crt
        ```
    
        The name of certificates must match with the definitions on **SSLCertificateFile** and **SSLCertificateKeyFile** on the apache config file.
        
    * Edit the apache web server configuration files
        
        We need to change the Apache Web server configurations and use the admin user to do it.
        
        **important**: ***make a backup of the apache configuration file in case of something go wrong*** 
        
        ```
        sudo cp /etc/apache2/httpd.conf /etc/apache2/httpd.conf_back
        ```
        
        Then we start to edit the apache configuration file with:
        
        ```
        sudo vim /etc/apache2/httpd.conf
        ```
        
        You need to uncomment the lines (deleting the # chararcter) and leave the rest with this text:
        
        ```
        #LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so
        
        to 
        
        LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so
        ```
        
        ```
        #LoadModule rewrite_module libexec/apache2/mod_rewrite.so
        
        to
        
        LoadModule rewrite_module libexec/apache2/mod_rewrite.so
        ```
        
        ```
        #LoadModule mpm_prefork_module libexec/apache2/mod_mpm_prefork.so
        
        to
        
        LoadModule mpm_prefork_module libexec/apache2/mod_mpm_prefork.so
        ```
        
        ```
        <IfModule !mpm_prefork_module>
            #LoadModule cgid_module libexec/apache2/mod_cgid.so
        </IfModule>
        <IfModule mpm_prefork_module>
            #LoadModule cgi_module libexec/apache2/mod_cgi.so
        </IfModule>

        to

        <IfModule !mpm_prefork_module>
            LoadModule cgid_module libexec/apache2/mod_cgid.so
        </IfModule>
        <IfModule mpm_prefork_module>
            LoadModule cgi_module libexec/apache2/mod_cgi.so
        </IfModule>
        ```
        
        To activate the HTTPS protocol, you need to load de **ssl_module**:
        
        ```
        #LoadModule ssl_module libexec/apache2/mod_ssl.so
        
        to
        
        LoadModule ssl_module libexec/apache2/mod_ssl.so
        ```
        
        Locate "**# Virtual hosts**" and append like the sample:
        
        ```
        # Virtual hosts
        #Include /private/etc/apache2/extra/httpd-vhosts.conf
        
        to
        
        # Virtual hosts
        #Include /private/etc/apache2/extra/httpd-vhosts.conf
        Include /private/etc/apache2/extra/widget-server.conf
        ```
        
        The last line is the definition of our widget-server vitual host.
        
        save the file and check if exists errors previously with the apache control utility:
        
        ```
        sudo apachectl configtest
        ```
        
        and you see something like this:
        
        ```
        AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using HT-Pop.local. Set the 'ServerName' directive globally to suppress this message
        Syntax OK
        ```
        
        The first is a warning, but you need to see the leyend "**Syntax OK**".
        
        Then use apache control to restart the service:
        
        ```
        sudo apachectl restart
        ```
        
        and now, go to your browser in your local machine and test with http and https puting "**http://widget/**" and "**https://widget/**"
        
        You must see the next screen:
        
        ![web widget test](https://raw.githubusercontent.com/elpop/widget-server/master/html/images/Demo/web_widget.png)
        
        And the page dispaly the widgets available and how to invoke on OBS Ecamm Live, remeber to use **https** in place of **http** when use Ecamm Live.


##To-Do

 * Documentation in progress    
    

