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
   
       # Widget Server Configuration File
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

To-do

   - Documentation

