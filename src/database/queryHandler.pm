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
use definitions::globalDefinitions qw(false true DEBUG_MODE);

# import connection handler
require 'connectionHandler.pm';
require '../utils/interfaceUtils.pm';

#############################################################################
# subroutine to get element
#############################################################################
sub getElement {
    my $query = $_[0];

    if (DEBUG_MODE) {interfaceUshowDebug("Sub - getElement", $query);}

    my $db = dbConnect();

    my $sth = $db->prepare($query);
    $sth->execute();

    my @data = $sth->fetchrow_array();

    my $elem = $data[0];

    dbFinishStatement($sth);
    dbDisconnect($db);

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
    my $query = $_[0];

    return getElement($query) ne 0;
}

#############################################################################

return true;

