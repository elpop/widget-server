Widget Server

Author

   Fernando Romo (pop@cofradia.org)

License
     
    GNU GENERAL PUBLIC LICENSE Version 3
    https://www.gnu.org/licenses/gpl-3.0.en.html
    See LICENSE.txt
    
Abstract

   Apache-server to offer database based widgets to OBS, Ecamm Live or other video streaming tool
   
   Tested with OBS Studio 25.0.8 (Mac OS and Linux) and Ecamm Live 3.5.8 (Mac OS).

Description

   This is a basic Web Serve to offer diferent types of Widgets using data store in a database.
   
   Is design to work with streaming programs like OBS (https://obsproject.com) and Ecamm Live (https://www.ecamm.com)
   
   The info to display is stored in a Postgresql Data base (https://www.postgresql.org), could be another
   database like MariaDB, but i prefer Postgresql.
   
Install and configuration
   
    Mac OS 
   
      1) You need the git program and another utilities, are available with the Xcode Command Line Tools, I sugests install Xcode
         from the Apple App Store, then check if you have the command line tools
         
         Open the Terminal application and put:
         
            xcode-select --install
            
         If are already instaled you see this message:
         
            xcode-select: error: command line tools are already installed, use "Software Update" to install updates
            
         If are not previously installed, the process ask your admin passsword and proceed the installation.
   
      2) download the project repository to your disk in your prefered path
      
         git clone https://github.com/elpop/widget-server.git
         
         When the clone process end, you see a new directory called "widget-server"
         
      3) Enter in the directory and copy the configurations files and customize
      
         cd widget-server
         sudo cp etc/widget-server.conf /etc/.
         sudo cp etc/apache2/widget-server.conf /etc/apache2/extra/.
         
      4) Customize the configuration files
      
         a) edit the widget-server config file
         
                sudo vim /etc/widget-server.conf
            
            The /etc/widget-server.conf  contains the parameters of the service:
   
               # Widget Server Configuration File
               [db_pg]
               name = "dbi:Pg:dbname=Widgets;host=127.0.0.1"
               user = "dba"
               pass = "cacahuamilpa"
        
               [timer]
               dbping    = 600

            The file is sefl explanatory. only put the name of the database replacing "Widgets" for any name you want to use.
    
To-do

   - Documentation

