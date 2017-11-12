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

require '../database/queryHandler.pm';

use globalDefinitions qw(true);

# define internal constants
use constant TABLE_NAME => "T_FOO_BAR";
use constant PK_ID => "ID";
use constant CODE_ATTR => "CODE";


#############################################################################
# example: get new foo bar code for test purpose
#############################################################################
sub getNewCode {
    my $query = queryHandler::selectAny(TABLE_NAME, CODE_ATTR, PK_ID);

    return queryHandler::getNextElement($query);
}

#############################################################################
# example: get random foo bar code
#############################################################################
sub getRandomCode {
    my $query = queryHandler::selectAny(TABLE_NAME, CODE_ATTR, undef);

    return queryHandler::getElement($query);
}

#############################################################################
# get query to select one element
# params:
#   value -> value of column code
# return:
#   string with query
#############################################################################
sub getQuerySelectOne {
    return queryHandler::selectOne(TABLE_NAME, PK_ID, CODE_ATTR, "'".$_[0]."'");
}

#############################################################################
# subroutine to get geocode based on sku_code
#############################################################################
sub getIdByCode {
    return queryHandler::getElement(getQuerySelectOne($_[0]));
}

#############################################################################
# check if code exists
#############################################################################
sub existsByCode {
    return queryHandler::exists(getQuerySelectOne($_[0]));
}

#############################################################################
return true;
