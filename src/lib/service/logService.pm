# #####################################################################################################
#   Script:
#       logService.pl
#
#   Description:
#   	This script handle with logs for generate table and graph
#
#   Author:
#     	renanpelicari@gmail.com
#
#   Revision:
#       1.0b	- 2017-11-13    - First version
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
# this routine call routines to generate table and graph based on log info
# params:
#   @values  -> array containing two parameters
#               first - string - description of log
#               second - int - amount of occurrences for that log
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
# execute command to get info for dmesg
# return:
#   array containing log info and quantity of occurrences
#############################################################################
sub getDmesgError() {
    return ("Dmesg Errors",
        shellUtils::executeCommand("dmesg  | grep -i error | wc -l"));
}

#############################################################################
# execute command to get quantity of root auth
# return:
#   array containing log info and quantity of occurrences
#############################################################################
sub getRootAccess() {
    return ("Root Access",
        shellUtils::executeCommand("grep 'session opened for user root /var/log/auth.log' | wc -l"));
}

#############################################################################
# orchestrate get execution of command, transform result in array and call
# routine to handle with logs
# return:
#   array of array, containing result for getDmesgError and getRootAccess routines
#############################################################################
sub getLogs() {
    return handleLogs(getDmesgError(), getRootAccess());
}

#############################################################################
return 1;
