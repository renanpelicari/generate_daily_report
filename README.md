# Description:
	This project containing a lot of useful libs, like:
	    - File handlers;
	    - Queries and DB handlers;
	    - HTML, CSS and Graphs generator;
	    - Log handlers;
	    - Shell commands hendler;
	    - Generate nice views for shell;
	    - Message (log, error, info) handlers;
	Also containing usefull scripts, like:
	    - generateReport.pl     - generate html report containing table and graphs, based on queries
	    - generateFakeData.pl   - script to facilitate add or exlcude massive data (insert and delete)
    
# About project:
    With purpose to help and provide some routines that can be useful, it was made to share with community :)

# Pre requirements
    - Guarantee the LD_LIBRARY_HOME is properly defined
    - Install DBI (by CPAN)
    - Install DBD::Oracle (by CPAN)

# About graphs:
	To work the graphs in the HTML, you must use the Morris.js
	http://morrisjs.github.io/morris.js/
	
# How To Use:
    Environment that already pre configured Perl, also the pre requirements (section above).
    A execute permission should be configured (chmod +x ...)
    And to check how to use, you just need to view the help menu: ./generateReport.pl -h

# Author:
	Renan Peliçari - renanpelicari@gmail.com
	https://github.com/renanpelicari
	https://www.linkedin.com/in/renanpelicari/    
