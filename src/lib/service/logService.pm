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
use projectDefinitions qw(SET_GRAPHS);

#############################################################################
# sub to receive array of log summary and generate donut graphs
#############################################################################
sub handleLogs {
    my @values = @{$_[0]};

    my @columns = ("Info", "Quantity");
    my $graphType = 'Donut';
    my $fileContent = "";

    # check if the constant to set graphs is true
    if (SET_GRAPHS) {
        $fileContent .= graphHandler::getGraphContent($graphType, \@values, false);
    }

    $fileContent .= commons::getTableHeaderReportFormat(\@columns);
    $fileContent .= commons::getTableElementReportFormat(\@columns, \@values);

    $fileContent .= htmlTable::getTableClose();

    return $fileContent;
}

#############################################################################
# get quantity dmesg errors
#############################################################################
sub getDmesgError() {
    return ("Dmesg Errors",
        shellUtils::executeCommand("dmesg  | grep -i error | wc -l"));
}

#############################################################################
# get quantity of root access
#############################################################################
sub getRootAccess() {
    return ("Root Access",
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
