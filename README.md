# Script:
	generateDailyReport.pl

# Description:
	This script collect the data from DB and Logfile, based at shft.
	The idea is not split the routines in different files/scripts, 
		because should be simple to adapt and use in another projects and situations.

# Author:
	renanpelicari@gmail.com

# Revision:
	1.1b	- 2016-08-12	- First stable version
	1.2b	- 2016-08-15	- Fixed some queries
	1.3b	- 2016-08-16	- Added function to generate html file with table
	1.4b	- 2016-08-17	- Added function to generate graphs (this one has a pre requirement: morris js)
	1.5b	- 2016-08-18	- Function to collect informations from log file were added (not working yet)
	2.0b	- 2016-08-19	- Added comments and fixed the function to collect from logfile
	2.1b	- 2016-08-19	- Added queries and changed the css to be more clear the labels for graphs
	2.2b	- 2016-08-24	- Improvement in the way that graphs are being shown / Added some queries
	2.3b	- 2016-08-28	- Public and shared script

# Pre requirements
    - Install DBI (by CPAN)

# About graphs:
	To work the graphs in the HTML, you must use the Morris.js
	http://morrisjs.github.io/morris.js/
	
# How TO Use:
    You need to run in Linux or Unix like.
    Also need to be prepared to run perl scripts.
    A execute permission should be configured (chmod +x generateDailyReport.pl)
    And to check how to use, you just need to view the help menu: ./generateDailyReport.pl -h
