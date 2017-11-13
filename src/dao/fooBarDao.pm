# #####################################################################################################
# 	Script:
# 		queries.pm
#
# 	Description:
#		This script contains queries examples
#       It's necessary to change and create new ones according the project
#       As example, the subroutines show how to handle with fake (foo bar) table
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
# get new code base on the last one
# return:
#   string containing new code
#############################################################################
sub getNewCode {
    my $query = queryHandler::selectAny(TABLE_NAME, CODE_ATTR, PK_ID);

    return queryHandler::getNextElement($query);
}

#############################################################################
# get random foo bar code
# return:
#   string random foo bar code
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
# get foo bar id based on code
# params:
#   $_[0]   -> foo bar code
# return:
#   foo bar id
#############################################################################
sub getIdByCode {
    return queryHandler::getElement(getQuerySelectOne($_[0]));
}

#############################################################################
# check if exists any foo bar with code informed
# params:
#   $_[0]   -> foo bar code
# return:
#   result of compare
##############################################################################
sub existsByCode {
    return queryHandler::exists(getQuerySelectOne($_[0]));
}

#############################################################################
return true;
