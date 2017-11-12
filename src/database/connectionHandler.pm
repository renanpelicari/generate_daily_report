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

# include project definitions
use globalDefinitions qw (true);
use projectDefinitions qw(DB_HOST DB_SID DB_PORT DB_USER DB_PASS DEFINED_DATABASE);

#############################################################################
# subroutine to connect to oracle database
#############################################################################
sub dbConnectionOracle {
    # execute connection
    my $db = DBI->connect("dbi:Oracle:host=".DB_HOST.";sid=".DB_SID.";port=".DB_PORT."",
        "".DB_USER."/".DB_PASS."")
        || die($DBI::errstr."\n");
    $db->{AutoCommit} = 0;
    $db->{RaiseError} = 1;
    $db->{ora_check_sql} = 0;
    $db->{RowCacheSize} = 16;

    # return connection var
    return $db;
}

#############################################################################
# subroutine to connect to default database
#############################################################################
sub dbConnection {
    # check database definition
    if (DEFINED_DATABASE eq 'ORACLE') {
        return dbConnectionOracle();
    }

    die "FATAL ERROR: Database connection is not defined!"
}

#############################################################################
# subroutine to finish statement
# you just need to use when the fetchrow will be finish prematurely
#############################################################################
sub dbFinishStatement {
    # received the db var
    my $sth = $_[0];

    # execute the command to disconnect
    $sth->finish if defined($sth);
}

#############################################################################
# subroutine to close the database connection
#############################################################################
sub dbDisconnect {
    # received the db var
    my $db = $_[0];

    # execute the command to disconnect
    $db->disconnect if defined($db);
}

#############################################################################
return true;
