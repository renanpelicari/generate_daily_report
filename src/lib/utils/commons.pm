# #####################################################################################################
#    Script:
#   	commons.pl
#
#    Description:
#   	This script common handlers for project
#
#    Author:
#   	renanpelicari@gmail.com
#
#    Revision:
#   	1.1b	- 2017-11-13    - First version
#
# #####################################################################################################

package commons;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;
use Data::Dumper qw(Dumper);

require 'html.pm';
require 'htmlStyleSheet.pm';
require 'htmlGraphDefine.pm';
require 'htmlTable.pm';
require 'interfaceUtils.pm';

# lib to handle date/time
use POSIX qw(strftime);

use Term::ANSIColor qw(:constants); # text format (color/bold)

# include definitions
use globalDefinitions qw(true false DEFAULT_SEPARATOR);
use projectDefinitions qw(TIME_SHIFT_01_START TIME_SHIFT_01_FINISH TIME_SHIFT_02_START TIME_SHIFT_02_FINISH SET_GRAPHS);

#############################################################################
# sub to handle with days are less than 10, in order to guarantee 2 digits
#
# params:
#   $_[0]    -> int containing just the day
#
# return:
#   day with 2 digits
#############################################################################
sub getFormattedDay {
    return ("%02d", $_[0]);
}

#############################################################################
# routine to get opposite value of boolean
#
# params:
#   $_[0]   -> current value for boolean
#
# return:
#   the opposite value for boolean
#############################################################################
sub getInverseBool {
    return (!$_[0] eq true);
}

#############################################################################
# routine to generate start and finish time for shifts
# based on the constants and alter session

# params:
#   $shift        -> the shift name
#   $daysBefore   -> quantity of days before current (or 0 for today),
#                    to know range of datetime
#
# return:
#   the opposite value for boolean
#############################################################################
sub getBetweenShiftTime {
    my $shift = $_[0];
    my $daysBefore = $_[1];

    my $startDateTime = "";
    my $finishDateTime = "";

    my $year = strftime "%Y", localtime;
    my $mon = strftime "%m", localtime;
    my $day = strftime "%d", localtime;
    my $hour = strftime "%H", localtime;

    $day = ($daysBefore ne 0) ? $day - $daysBefore : $day;

    $day = getFormattedDay($day);

    my $today = $year."-".$mon."-".$day;

    if ($shift eq 1) {
        $startDateTime = $today." ".TIME_SHIFT_01_START;
        $finishDateTime = $today." ".TIME_SHIFT_01_FINISH;
    } else {
        if (($daysBefore ne 0) || (($hour >= 0) && ($hour <= 7))) {

            ($day eq 1) ? $mon-- : $day--;

            $day = getFormattedDay($day);
            my $yesterday = $year."-".$mon."-".$day;

            $startDateTime = $yesterday." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
            $finishDateTime = $today." ".TIME_SHIFT_02_FINISH;

        } else {

            $day++;
            $day = getFormattedDay($day);
            my $tomorrow = $year."-".$mon."-".$day;

            $startDateTime = $today." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
            $finishDateTime = $tomorrow." ".TIME_SHIFT_02_FINISH;
        }
    }

    print "\nStart at: \t".$startDateTime;
    print "\nFinish at: \t".$finishDateTime."\n";

    return ($startDateTime, $finishDateTime);
}

#############################################################################
# routine to build start part of html
#
# return:
#   string containing html, body, header, css, js definitions
#############################################################################
sub getHtmlInitialStructure {
    my $fileContent = html::getHtmlStart();
    $fileContent .= html::getHeadStart();
    $fileContent .= (SET_GRAPHS) ? htmlGraphDefine::getGraphImport() : "";
    $fileContent .= htmlStyleSheet::getCss();
    $fileContent .= html::getHeadClose();
    $fileContent .= html::getBodyStart();

    return $fileContent;
}

#############################################################################
# routine to get report header format
#
# params:
#   $title  -> title to show in H1 html tag
#
# return:
#   content of H1
#############################################################################
sub getReportHeaderFormat {
    my $title = $_[0];

    interfaceUtils::header(DEFAULT_SEPARATOR);

    print BOLD, YELLOW, "> ".$title, RESET;

    return html::getH1($title);
}

#############################################################################
# routine to get table header report format
#
# params:
#   @columns  -> array containing columns to show in table
#
# return:
#   html content with table header
#############################################################################
sub getTableHeaderReportFormat {
    my @columns = @{$_[0]};

    # show at shell
    print "\n\n";
    interfaceUtils::showTableLine(\@columns);

    # store into file to build html
    my $fileContent = htmlTable::getTableStart();
    $fileContent .= interfaceUtils::showTableElement(\@columns, "header");

    return $fileContent;
}

#############################################################################
# routine to get table element report format
#
# params:
#   @values  -> array containing values for each column to show in table
#
# return:
#   html content with table elements
#############################################################################
sub getTableElementReportFormat {
    my @values = @{$_[0]};

    my $lineDiff = true;    # var to control the colored tr in table
    print "\n\n";

    interfaceUtils::showTableLine(\@{$values[0]});

    my $fileContent = "";
    foreach my $data (@values) {
        $lineDiff = getInverseBool($lineDiff);
        $fileContent .= interfaceUtils::showTableElement(\@{$data}, "element", $lineDiff);
    }

    return $fileContent;
}

#############################################################################
return true;
