# #####################################################################################################
# 	Script:
# 		projectDefinitions.pm
#
# 	Description:
#		This script just define the specific project constants
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-09	- First version
#
# #####################################################################################################

package projectDefinitions;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# import global definitions
use globalDefinitions qw(false true);

#############################################################################
# constants
#############################################################################

# define database
use constant DEFINED_DATABASE => "ORACLE";

# define db connection strings
use constant DB_HOST => "127.0.0.1";
use constant DB_PORT => "1521";
use constant DB_SID => "SID";
use constant DB_USER => "userdb";
use constant DB_PASS => "passdb";

# define date formats
use constant DB_TIMESTAMP_FORMAT => "YYYY-MM-DD HH24:MI:SS";
use constant DB_DATE_FORMAT => "YYYY-MM-DD";
use constant DB_COMPLETEHOUR_FORMAT => "HH24";
use constant TIME_SHIFT_01_START => "07:00:00";
use constant TIME_SHIFT_01_FINISH => "18:59:59";
use constant TIME_SHIFT_02_START => "19:00:00";
use constant TIME_SHIFT_02_FINISH => "06:59:59";

# define logs and files
use constant DAILY_REPORT_NAME => "daily_report";
use constant SET_GRAPHS => true;
use constant LOG_FILE_APPLICATION => "/usr/log/application/";
use constant LOG_FILENAME => "app_test.log";

# folder to store generated files
use constant GENERATED_FILE_FOLDER => "/tmp/";
use constant GENERATED_FILE_EXTENSION => ".dat";


#############################################################################
# export constants/variables
#############################################################################
our @EXPORT = qw();
our @EXPORT_OK = qw(DEFINED_DATABASE DB_HOST DB_PORT DB_SID DB_USER
DB_PASS DB_TIMESTAMP_FORMAT DB_DATE_FORMAT DB_COMPLETEHOUR_FORMAT
TIME_SHIFT_01_START TIME_SHIFT_01_FINISH TIME_SHIFT_02_START
TIME_SHIFT_02_FINISH DAILY_REPORT_NAME SET_GRAPHS LOG_FILE_APPLICATION
LOG_FILENAME GENERATED_FILE_FOLDER GENERATED_FILE_EXTENSION);

#############################################################################
return true;
