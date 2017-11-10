# #####################################################################################################
# 	Script:
# 		queries.pm
#
# 	Description:
#		This script contains queries examples
#       It's necessary to change and create new ones according the project
#       For test purposes, we will show connection to fake table
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-09	- First version
#
# #####################################################################################################

package fooBarDao;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# include project definitions
use definitions::globalDefinitions qw(false true);
use definitions::projectDefinitions qw(DEBUG_MODE DB_HOST DB_SID DB_PORT DB_USER DB_PASS);

require '../database/queryHandler.pm';

#############################################################################
# example: get new foo bar code for test purpose
#############################################################################
sub getNewCode {
    my $query = "SELECT CODE
	             FROM (SELECT CODE FROM T_FOO_BAR ORDER BY ID DESC)
	             WHERE ROWNUM = 1";

    return queryHandler::getNextElement($query);
}

#############################################################################
# example: get random foo bar code
#############################################################################
sub getRandomCode {
    my $query = "SELECT CODE
					FROM (SELECT CODE FROM T_FOO_BAR ORDER BY DBMS_RANDOM.VALUE)
					WHERE ROWNUM = 1";

    return queryHandler::getElement($query);
}

#############################################################################
# subroutine to get geocode based on sku_code
#############################################################################
sub getIdByCode {
    my $query = "SELECT ID FROM T_FOO_BAR WHERE CODE = '" . $_[0] . "'";

    return queryHandler::getElement($query);
}

#############################################################################
# subroutine to get exists lg code
#############################################################################
sub existsByCode {
    my $query = "SELECT ID FROM T_FOO_BAR WHERE CODE = '" . $_[0] . "'";

    return queryHandler::exists($query);
}

return true;
