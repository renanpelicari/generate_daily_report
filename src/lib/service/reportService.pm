# #####################################################################################################
#    Script:
#   	reportService.pl
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

package reportService;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;

# include definitions
use globalDefinitions qw(true false DEFAULT_SEPARATOR);
use projectDefinitions qw(SET_GRAPHS);

require 'interfaceUtils.pm';
require 'messageUtils.pm';
require 'fileHandler.pm';
require 'graphHandler.pm';
require 'fooBarDao.pm';

#############################################################################
# routine to handle with reports
# like call routines to execute queries, generate html, graphs, logs
#############################################################################
sub handleReport {
    my $graphType = $_[0];
    my @columns = @{$_[1]};
    my @values = @{$_[2]};
    my $goal = $_[3];

    my $fileContent = "";

    # check if the constant to set graphs is true
    if (SET_GRAPHS) {
        $fileContent .= graphHandler::getGraphContent($graphType, \@values, $goal);
    }

    $fileContent .= commons::getTableHeaderReportFormat(\@columns);
    $fileContent .= commons::getTableElementReportFormat(\@columns, \@values);

    $fileContent .= htmlTable::getTableClose();

    return $fileContent;
}

#############################################################################
# get file content containing overview by status
#############################################################################
sub getOverviewByStatus {
    my $goal = false;
    my $title = "Overview tasks by status";
    my @columns = ("Status", "Quantity");
    my $graphType = "Bar";
    my @values = fooBarDao::getOverviewByStatus();

    my $fileContent = handleReport($graphType, \@columns, \@values, $goal);
    $fileContent .= commons::getReportHeaderFormat($title);
    return $fileContent;
}

#############################################################################
# get file content containing overview worked tasks
#############################################################################
sub getOverviewWorkedTasks {
    my $date_a = $_[0];
    my $date_b = $_[1];

    my $goal = false;
    my $title = "Tasks that were worked during the shift";
    my @columns = ("Status", "Quantity");
    my $graphType = "Bar";
    my @values = fooBarDao::getTasksWorkedOverview($date_a, $date_b);

    my $fileContent = handleReport($graphType, \@columns, \@values, $goal);
    $fileContent .= commons::getReportHeaderFormat($title);
    return $fileContent;
}

#############################################################################
return true;
