# Widget Server

## Author

   Fernando Romo (pop@cofradia.org)

## License
     
    GNU GENERAL PUBLIC LICENSE Version 3
    https://www.gnu.org/licenses/gpl-3.0.en.html
    See LICENSE.txt
    
## Abstract

   Apache-server to offer database based widgets to OBS, Ecamm Live or other video streaming tool
   
   Tested with OBS Studio 25.0.8 (Mac OS and Linux) and Ecamm Live 3.5.8 (Mac OS).

## Description

   This is a basic Web Serve to offer diferent types of Widgets using data store in a database.
   
   Is design to work with streaming programs like OBS (https://obsproject.com) and Ecamm Live (https://www.ecamm.com)
   
   The info to display is stored in a Postgresql Data base (https://www.postgresql.org), could be another
   database like MariaDB, but i prefer Postgresql.
   
## Install and configuration
   
### Mac OS
   
   1) You need the git program and another utilities, are available with the
      Xcode Command Line Tools, I sugests install Xcode from the Apple App Store,
      then check if you have the command line tools
         
      Open the Terminal application and put:
         
         xcode-select --install
            
      If are already instaled you see this message:
         
         xcode-select: error: command line tools are already installed, use __Software Update__ to install updates
            
      If are not previously installed, the process ask your admin passsword and proceed the installation.
   
   2) download the project repository to your disk in your prefered path
      
          git clone https://github.com/elpop/widget-server.git
         
      When the clone process end, you see a new directory called __widget-server__
         
   3) Enter in the directory and copy the configurations files and customize
      

         cd widget-server
         sudo cp etc/widget-server.conf /etc/.
         sudo cp etc/apache2/widget-server.conf /etc/apache2/extra/.
         
   4) Customize the configuration files
   
      a) for delivery your widget in your local machine (the same with your striming program),
         you need to add the name of the webserver in /etc/hosts
         
            sudo vim /etc/hosts
            
         You see something like this:
         

            ##
            # Host Database
            #
            # localhost is used to configure the loopback interface
            # when the system is booting.  Do not change this entry.
            ##
            127.0.0.1	localhost widget
            255.255.255.255	broadcasthost
            ::1             localhost
            
         you see the line with "__127.0.0.1 localhost__" you need to append the name of your apache virtual host name, in this case "__widget__"
      
      b) edit the widget-server config file
         
            sudo vim /etc/widget-server.conf
            
         The /etc/widget-server.conf  contains the parameters of the service:
   
            # Widget Server Configuration File
            [db_pg]
            name = "dbi:Pg:dbname=Widgets;host=127.0.0.1"
            user = "dba"
            pass = "cacahuamilpa"
     
            [timer]
            dbping    = 600

         The file is sefl explanatory. only put the name of the database replacing __Widgets__ for any name you want to use.
         
      c) edit the apache web server configuration file

         Here is where the things start to be more difficult, you need to know the exactly path where you clone directory are. is easy whit this command:
         
            pwd
            
         and you see somthing like
         
            /Volumes/Pop-Data/pop/Devel/widget-server
            
         or you path. Is important to copy this to procced the next step
            
         Edit the apache virtual host configuration file
      
           sudo /etc/apache2/extra/widget-server.conf
               
         You see the configuration almost duplicate, this is because we use port 80 for OBS (don't like ssl auto signed certs) and the port 443 for Ecamm (don't like plain http conections).

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

         You need to replace the path on the __DocumentRoot__, __ScriptAlias__, __ServerPath__ and __Directory__ arguments with the path saved.
         
         For example, if your path is __/Users/joe/widget-server__ you replace the arguments like this
         
            DocumentRoot "__/Users/joe/widget-server__/html"
            ScriptAlias __/bin/ /Users/joe/widget-server__/cgi-bin/
            ServerPath __/Users/joe/widget-server__/html
            <Directory __/Users/joe/widget-server__/ >
            
         Remeber to do it in both definitios of port 80 and 443.
         
         The arguments
         
            ServerName __widget__
            ServerAlias __widget__

         Can be the name you want, but need to match with your definition in /etc/hosts.
         
         Now, if you note, the definition of the port 443, we need to have a SSL certificate to work with Ecamm Live, OBS only accet valid SSL certificates emited by a CA, thas why use the port (80).
         
         To generate a self signed SSL certificate we need to create a directory and the certificates:
         
            sudo mkdir /etc/apache2/ssl
            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/widget.key -out /etc/apache2/ssl/widget.crt

         The name of certificates must match with the definitions on __SSLCertificateFile__ and __SSLCertificateKeyFile__ on the apache config file.
         
## To-do

   - Documentation

