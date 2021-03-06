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
#   	1.0b	- 2017-11-13    - First version
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
#
# params:
#   $graphType     -> type of graph, the available ones: Line, Bar, Donut
#   @columns       -> array containing columns to show at table
#   @values        -> array containing values for each column
#   $goal          -> boolean flag to inform if will show or not goal at graphs
#
# return:
#   string containing part of generated html (graph and table)
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
# routine to get file content containing overview by status
#
# return:
#   string containing part of generated html
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
# routine to get file content containing overview worked tasks
#
# params:
#   $dateStart     -> the start date of range
#   $dateFinish    -> the finish date of range
#
# return:
#   string containing part of generated html
#############################################################################
sub getOverviewWorkedTasks {
    my $dateStart = $_[0];
    my $dateFinish = $_[1];

    my $goal = false;
    my $title = "Tasks that were worked during the shift";
    my @columns = ("Status", "Quantity");
    my $graphType = "Bar";
    my @values = fooBarDao::getTasksWorkedOverview($dateStart, $dateFinish);

    my $fileContent = handleReport($graphType, \@columns, \@values, $goal);
    $fileContent .= commons::getReportHeaderFormat($title);
    return $fileContent;
}

#############################################################################
return true;
