# #####################################################################################################
# 	Script:
# 		connectionHandler.pm
#
# 	Description:
#		This script handle database connection
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-09	- First version
#
# #####################################################################################################

package connectionHandler;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# lib to handle with database
use DBI;

use lib '../utils';
require 'messageUtils.pm';

# include project definitions
use globalDefinitions qw (true);
use projectDefinitions qw(DB_HOST DB_SID DB_PORT DB_USER DB_PASS DEFINED_DATABASE DB_TIMESTAMP_FORMAT);

#require 'messageUtils.pm';

#############################################################################
# routine to connect to oracle database
# return:
#   db connection
#############################################################################
sub dbConnectOracle {
    my $db = DBI->connect("dbi:Oracle:host=".DB_HOST.";sid=".DB_SID.";port=".DB_PORT."", "".DB_USER."/".DB_PASS."")
        or die(messageUtils::errorMessage($DBI::errstr));
    $db->{AutoCommit} = 0;
    $db->{RaiseError} = 1;
    $db->{ora_check_sql} = 0;
    $db->{RowCacheSize} = 16;

    return $db;
}

#############################################################################
# routine to connect to database
# return:
#   db connection
# #############################################################################
sub dbConnect {
    if (DEFINED_DATABASE eq 'ORACLE') {
        my $db = dbConnectOracle();
        dbAlterSession($db);
        return $db;
    }

    die "FATAL ERROR: Database connection is not defined!"
}

#############################################################################
# (void) routine to finish statement
#       ps: you just need to use when the fetchrow will be finish prematurely
# params:
#   $db -> db connection
#############################################################################
sub dbFinishStatement {
    my $sth = $_[0];

    $sth->finish if defined($sth); # close statement
}

#############################################################################
# (void) routine to close the database connection
# params:
#   $db -> db connection
#############################################################################
sub dbDisconnect {
    my $db = $_[0];

    $db->disconnect if defined($db); # close connection
}

#############################################################################
# subroutine to set the session to handling with date easily
#############################################################################
sub dbAlterSession {
    my $db = $_[0];

    my $query = "ALTER SESSION SET NLS_TIMESTAMP_FORMAT = '".DB_TIMESTAMP_FORMAT."'";
    if ($globalDefinitions::_DEBUG_MODE) {messageUtils::showDebug("Alter Session to set the timestamp properly to handle", $query);}
    my $def = $db->prepare($query);
    $def->execute();
}

#############################################################################
return true;
