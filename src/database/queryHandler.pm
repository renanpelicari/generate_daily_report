# #####################################################################################################
# 	Script:
# 		queryHandler.pm
#
# 	Description:
#		This script common query statements
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-09	- First version
#
# #####################################################################################################

package queryHandler;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# lib to handle with database
use DBI;

# include project definitions
use globalDefinitions qw(true DEBUG_MODE);
use projectDefinitions qw(DEFINED_DATABASE);

# import connection handler
require 'connectionHandler.pm';
require '../utils/interfaceUtils.pm';

#############################################################################
# subroutine to get element
#############################################################################
sub getElement {
    my $query = $_[0];

    if (DEBUG_MODE) {interfaceUtils::showDebug("Sub - getElement", $query);}

    my $db = connectionHandler::dbConnect();

    my $sth = $db->prepare($query);
    $sth->execute();

    my @data = $sth->fetchrow_array();

    my $elem = $data[0];

    connectionHandler::dbFinishStatement($sth);
    connectionHandler::dbDisconnect($db);

    return $elem;
}

#############################################################################
# subroutine to get next element
#############################################################################
sub getNextElement {
    my $query = $_[0];

    my $element = getElement($query);

    return ++$element;
}

#############################################################################
# subroutine to check if exists
#############################################################################
sub exists {
    return getElement($_[0]) ne 0;
}

#############################################################################
# select any element (exclusive for Oracle)
# params:
#   table   -> table name
#   column  -> the selected column
#   orderBy -> column used by criteria to order (null in case of random)
# return:
#   string with query
#############################################################################
sub selectAnyOracle {
    my $table = $_[0];
    my $column = $_[1];
    my $orderBy = defined($_[2]) ? $_[2] : "DBMS_RANDOM.VALUE";

    my $query = join(" ", "SELECT", $column,
        "FROM (SELECT", $column, "FROM", $table, "ORDER BY", $orderBy, "DESC) WHERE ROWNUM = 1");

    return $query;
}

#############################################################################
# select one element
# params:
#   table           -> table name
#   response        -> the value of column that will return as response
#   criteria        -> the criteria column to compare
#   value           -> criteria value
# return:
#   string with query
#############################################################################
sub selectOne {
    return join(" ", "SELECT", $_[0], "FROM", $_[1], "WHERE", $_[2], "=", $_[3]);
}

#############################################################################
# check the with database is used and call the right implementation
# params:
#   table   -> table name
#   column  -> the selected column
#   orderBy -> column used by criteria to order (null in case of random)
# return:
#   string with query
#############################################################################
sub selectAny {
    # check database definition
    if (DEFINED_DATABASE eq 'ORACLE') {
        return selectAnyOracle($_[0], $_[1], $_[2]);
    }

    die "FATAL ERROR: Database connection is not defined!"
}

#############################################################################
return true;
