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

# lib to handle date/time
use POSIX qw(strftime);

use Term::ANSIColor qw(:constants); # text format (color/bold)

# include definitions
use globalDefinitions qw(true false DEFAULT_SEPARATOR);
use projectDefinitions qw(TIME_SHIFT_01_START TIME_SHIFT_01_FINISH TIME_SHIFT_02_START TIME_SHIFT_02_FINISH SET_GRAPHS);

require 'html.pm';
require 'htmlGraphDefine.pm';
require 'htmlStyleSheet.pm';
require 'htmlTable.pm';

#############################################################################
# sub to handle with days are less than 10
# to guarantee 2 digits
#############################################################################
sub handleDay {
    my $day = $_[0];

    return ($day < 10) ? "0".$day : $day;
}

#############################################################################
# return different inverse line
#############################################################################
sub getInverseBool {
    return (!$_[0] eq true);
}

#############################################################################
# generate between date to use in the queries
# based on the constants and alter session
#############################################################################
sub generateBetweenDate {
    my $shift = $_[0];
    my $daysBefore = $_[1];

    my $between_date_a = "";
    my $between_date_b = "";

    my $year = strftime "%Y", localtime;
    my $mon = strftime "%m", localtime;
    my $day = strftime "%d", localtime;
    my $hour = strftime "%H", localtime;

    $day = ($daysBefore ne 0) ? $day - $daysBefore : $day;

    $day = handleDay($day);

    my $today = $year."-".$mon."-".$day;

    if ($shift eq 1) {
        $between_date_a = $today." ".TIME_SHIFT_01_START;
        $between_date_b = $today." ".TIME_SHIFT_01_FINISH;
    } else {
        if (($daysBefore ne 0) || (($hour >= 0) && ($hour <= 7))) {

            ($day eq 1) ? $mon-- : $day--;

            $day = handleDay($day);
            my $yesterday = $year."-".$mon."-".$day;

            $between_date_a = $yesterday." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
            $between_date_b = $today." ".TIME_SHIFT_02_FINISH;

        } else {

            $day++;
            $day = handleDay($day);
            my $tomorrow = $year."-".$mon."-".$day;

            $between_date_a = $today." ".(($shift eq 2) ? TIME_SHIFT_02_START : TIME_SHIFT_01_START);
            $between_date_b = $tomorrow." ".TIME_SHIFT_02_FINISH;
        }
    }

    print "\nStart at: \t".$between_date_a;
    print "\nFinish at: \t".$between_date_b."\n";

    return ($between_date_a, $between_date_b);
}

#############################################################################
# routine to build start part of html
#
# return:
#   string containing html, body, header, css, js definitions
#############################################################################
sub buildHtmlStart() {
    my $fileContent = html::startHtml();
    $fileContent .= html::startHeader();
    $fileContent .= (SET_GRAPHS) ? htmlGraphDefine::getGraphImport() : "";
    $fileContent .= htmlStyleSheet::getCss();
    $fileContent .= html::finishHeader();
    $fileContent .= html::startBody();

    return $fileContent;
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub formatReport {
    my $title = $_[0];

    interfaceUtils::header(DEFAULT_SEPARATOR);

    print BOLD, YELLOW, "> ".$title, RESET;

    return html::applyHeader($title);
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub formatTableHeaderReport {
    my @columns = @{$_[0]};

    # show at shell
    print "\n\n";
    interfaceUtils::addTableLine(\@columns);

    # store into file to build html
    my $fileContent = htmlTable::startTable();
    $fileContent .= interfaceUtils::addTableElement(\@columns, "header");

    return $fileContent;
}

#############################################################################
# handle with queries
# each query are in the case
#############################################################################
sub formatTableElementReport {
    my @values = @{$_[0]};
    my $lineDiff = true;    # var to control the colored tr in table

    # show at shell
    print "\n\n";

    interfaceUtils::addTableLine(\@{$values[0]});

    my $fileContent = "";
    foreach my $data (@values) {
        $lineDiff = getInverseBool($lineDiff);
        $fileContent .= interfaceUtils::addTableElement(\@{$data}, "element", $lineDiff);
    }

    return $fileContent;
}

#############################################################################
return true;
