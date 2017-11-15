# #####################################################################################################
#    Script:
#   	logService.pl
#
#    Description:
#   	This to handler with reports#
#
#    Author:
#   	renanpelicari@gmail.com
#
#    Revision:
#   	1.1b	- 2017-11-13    - First version
#
# #####################################################################################################

package logService;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;

require 'shellUtils.pm';

# include definitions
use globalDefinitions qw(false);

#############################################################################
# sub to receive array of log summary and generate donut graphs
#############################################################################
sub handleLogs {
    my $graphCtrl = $_[0];
    my @content = @{$_[1]};

    my @columns = ("Info", "Quantity");
    my $graphType = 'Donut';
    my $fileContent = "";

    # check if the constant to set graphs is true
    if (SET_GRAPHS) {
        $fileContent .= graphHandler::populateGraph($graphType, \@columns, \@content, false, $graphCtrl);
    }

    $fileContent .= commons::formatTableHeaderReport(\@columns);
    $fileContent .= commons::formatTableElementReport(\@columns, \@values); #FIXME - pass array of array...@content

    $fileContent .= htmlTable::closeTable();

    return $fileContent;
}

#############################################################################
# get quantity dmesg errors
#############################################################################
sub getDmesgError() {
    my $graphCtrl = $_[0];
    return ($graphCtrl, "Dmesg Errors",
        shellUtils::executeCommand("dmesg  | grep -i error | wc -l"));
}

#############################################################################
# get quantity of root access
#############################################################################
sub getRootAccess() {
    my $graphCtrl = $_[0];
    return ($graphCtrl, "Root Access",
        shellUtils::executeCommand("grep 'session opened for user root /var/log/auth.log' | wc -l"));
}

#############################################################################
# get all logs
#############################################################################
sub getLogs() {
    return handleLogs(getDmesgError(), getRootAccess());
}

#############################################################################
return 1;
