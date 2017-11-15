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
use globalDefinitions qw(true false DEBUG_MODE DEFAULT_SEPARATOR);
use projectDefinitions qw(SET_GRAPHS);

require 'interfaceUtils.pm';
require 'messageUtils.pm';
require 'commons.pm';
require 'fileHandler.pm';
require 'fooBarDao.pm';
require 'graphHandler.pm';

#############################################################################
# sub to execute the queries
#############################################################################
sub handleReport {
    my $graphType = $_[0];
    my @columns = @{$_[1]};
    my @values = @{$_[2]};
    my $goal = $_[3];
    my @graphColumns = @{$_[4]};

    my $fileContent = "";

    # check if the constant to set graphs is true
    if (SET_GRAPHS) {
        $fileContent .= graphHandler::populateGraph($graphType, \@columns, \@values, $goal, $graphType);
    }

    $fileContent .= commons::formatTableHeaderReport(\@columns);
    $fileContent .= commons::formatTableElementReport(\@columns, \@values);

    $fileContent .= htmlTable::closeTable();

    return $fileContent;
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub getOverviewByStatus {
    my $graphCtrl = $_[0];

    my $goal = false;
    my $title = "Overview tasks by status";
    my @columns = ("Status", "Quantity");
    my $graphType = "Bar";
    my @values = fooBarDao::getOverviewByStatus();

    my $fileContent = handleReport($graphType, \@columns, \@values, $goal, $graphCtrl);
    $fileContent .= commons::formatReport($title);
    return $fileContent;
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub getTasksWorkedOverview {
    my $graphCtrl = $_[0];
    my $date_a = $_[1];
    my $date_b = $_[2];

    my $goal = false;
    my $title = "Tasks that were worked during the shift";
    my @columns = ("Status", "Quantity");
    my $graphType = "Bar";
    my @values = fooBarDao::getTasksWorkedOverview($date_a, $date_b);

    my $fileContent = handleReport($graphType, \@columns, \@values, $goal, $graphCtrl);
    $fileContent .= commons::formatReport($title);
    return $fileContent;
}

#############################################################################
return true;
