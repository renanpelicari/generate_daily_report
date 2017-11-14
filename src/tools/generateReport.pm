# #####################################################################################################
#    Script:
#   	generateReport.pl
#
#    Description:
#   	This script collect the data from DB and Logfile, based at shft.
#   	The idea is not split the routines in different files/scripts,
#   		because should be simple to adapt and use in another projects and situations.
#
#    Author:
#   	renanpelicari@gmail.com
#
#    Revision:
#   	1.1b	- 2016-08-12	- First stable version
#   	1.2b	- 2016-08-15	- Fixed some queries
#   	1.3b	- 2016-08-16	- Added function to generate html file with table
#   	1.4b	- 2016-08-17	- Added function to generate graphs (this one has a pre requirement: morris js)
#   	1.5b	- 2016-08-18	- Function to collect information from log file were added (not working yet)
#   	2.0b	- 2016-08-19	- Added comments and fixed the function to collect from logfile
#   	2.1b	- 2016-08-19	- Added queries and changed the css to be more clear the labels for graphs
#   	2.2b	- 2016-08-24	- Improvement in the way that graphs are being shown / Added some queries
#   	2.3b	- 2016-08-28	- Public and shared script
#       2.5b    - 2017-11-13    - Refactor script (split functions in files, generify the execution of scripts)
#
#    About graphs:
#   	To work the graphs in the HTML, you must use the Morris.js
#   	http://morrisjs.github.io/morris.js/
#
#    How TO Use:
#      You need to run in Linux or Unix like.
#      Also need to be prepared to run perl scripts.
#      A execute permission should be configured (chmod +x generateDailyReport.pl)
#      And to check how to use, you just need to view the help menu: ./generateDailyReport.pl -h
# #####################################################################################################

package generateReport;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use Switch;

# lib to handle date/time
use POSIX qw(strftime);

# lib to get parameter options
use Getopt::Std;

#############################################################################
# golbal variables 
#############################################################################

# define the parameters that will be available
my %options = ();
getopts('hs:b:d', \%options);

# include definitions
use globalDefinitions qw(false true DEBUG_MODE DEFAULT_SEPARATOR);
use projectDefinitions qw(DAILY_REPORT_NAME SET_GRAPHS);

require 'interfaceUtils.pm';
require 'messageUtils.pm';
require 'commons.pm';
require 'fileHandler.pm';

# define local var to debug mode
my $lineDiff = false;    # var to control the colored tr in table

# handle log files
sub handleLogs {
    my $logname = "";
    my $fileContent = "";
    my $title = "Logs from server";
    my @columns = ("Info", "Quantity");
    my $graphType = "bar";
    my $goal;
    my $arraySize = 2;

    # loop to collect all the lognames that need to be executed
    $logname = LOG_FILE_APPLICATION.LOG_FILENAME;

    # array with commands to get logs from server
    # this array is composed with 2 columns
    # first one: The name that will be shown in the result / Kind of alias
    # second one: the command
    # if you need add more elements here, you need to guarantee the last element will not have a comma
    #
    # example with less info, to be more clear:
    # my @info = (
    # 	["title",
    #		"command"],
    # 	["title",
    #		"command"],
    # 	["title",
    #		"command"],
    # 	["title",
    #		"command"]
    # );
    my @info = (
        [ "Server Down",
            "grep \"Connection refused\" ".$logname." | cut -d: -f1 | wc -l;" ],
        [ "Conn. Failed",
            "grep -e \"Trying to reestablish connection\" ".$logname." | wc -l" ]
    );

    my @result;
    my $i = 0;
    my $j = 0;

    # for each element in the array, do:
    for my $row (@info) {
        # for each element in a row of array, do:
        for my $element (@$row) {
            if ($i eq 1) {
                # if is the second element, call the sub to execute the command on the server
                # save the result in another array, that will be used to output results
                $result[$j][$i] = executeCommand($element);
            } else {
                # else, save the title another array, that will be used to output results
                $result[$j][$i] = $element;
            }

            $i++;
        }
        $i = 0;
        $j++;
    }

    # starting to create html content
    $fileContent .= handleHTML("div_page_ini");
    $fileContent .= handleHTML("header_01", $title);

    # check if the constant to set graphs is true
    if (SET_GRAPHS) {
        # call the sub to set the graphs
        #$fileContent .= setGraphs(\@result, $graphType, $goal, $arraySize, \@columns);
    }

    header(DEFAULT_SEPARATOR);
    print BOLD, YELLOW, "> ".$title, RESET;

    # call the table definitions
    $fileContent .= handleHTML("table_ini");

    print "\n\n";
    # add the first lines according with the quantity of array / lines with dashes ---
    addTableLine(\@columns);

    # fill with the header content
    $fileContent .= addTableElement(\@columns, "header");
    # add more lines with dash ---
    addTableLine(\@columns);

    # foreach element in the result array, do:
    foreach my $array (@result) {
        # fill with the content
        $fileContent .= addTableElement($array, "element");
    }

    # add more lines with dash ---
    addTableLine(\@columns);

    $fileContent .= handleHTML("table_end");
    $fileContent .= handleHTML("div_page_end");

    return $fileContent;
}


#############################################################################
# run the script
# call the subs to define and execute queries and get logs from server
#############################################################################
sub run {
    my $shift = $_[0];
    my $daysBefore = $_[1];

    my $resultFile = "";

    my $fileContent = commons::buildHtmlStart();

    header(DEFAULT_SEPARATOR);
    print "Shift: \t\t".$shift;

    # generate between date
    my ($between_date_a, $between_date_b) = commons::generateBetweenDate($shift, $daysBefore);

    # call the sub to handle with queries
    $fileContent .= handleReport("tasks_worked", $between_date_a, $between_date_b);
    $fileContent .= handleReport("overview_by_status");

    # call the sub to handle with logs
    $fileContent .= handleLogs();

    # end the html
    $fileContent .= html::finishBody();

    #return generated html file
    return fileHandler::createFile($fileContent, DAILY_REPORT_NAME);
}

#############################################################################
# subroutine to show the help
#############################################################################
sub help {
    header(DEFAULT_SEPARATOR);
    print "SCRIPT:";
    print "\n\tgenerateReport.pl";
    print "\n\nDESCRIPTION:";
    print "\n\tScript to generate report (print at terminal and html with graphs) based on queries";
    print "\n\tBy default script use the current date to generate reports...";
    print "\n\nOPTIONS:";
    print "\n\t-h \t\t\t (help)";
    print "\n\t-s [integer] \t\t (Shift: 1 or 2 / 0 for all shifts)";
    print "\n\t-b [integer] \t\t (Days before)";
    print "\n\t-d \t\t\t (Debug Mode)";
    print "\n\nUSAGE:";
    print "\n\t[-h][-s 1][-s 2]";
    print "\n\nEXAMPLES:";
    print "\n\t./generateReport.pl -h";
    print "\n\t./generateReport.pl -s 1";
    print "\n\t./generateReport.pl -s 2";
    print "\n\t./generateReport.pl -s 1 -d";
    print "\n\t./generateReport.pl -s 2 -b 2";
    print "\n\nVERSION:";
    print "\n\t2.5b\t- 2017-11-13";
    header(DEFAULT_SEPARATOR);
}

#############################################################################
# main function
# this one checks the parameters that was informed for script
#############################################################################
sub main {
    # check if the parameter to show menu was used
    if (defined($options{h})) {
        help();
        messageUtils::quit();
    }

    # check if the parameter debug was informed
    if (defined($options{d})) {
        DEBUG_MODE = true;
    }

    my $daysBefore = 0;
    # check if the report should be for some days before
    if (defined($options{b})) {
        $daysBefore = $options{b};
        chomp $daysBefore;
    }

    # check the shift that were informed
    if (defined($options{s})) {
        my $shift = $options{s};
        chomp $shift;

        if (($shift eq 0 || $shift eq 1 || $shift eq 2)) {
            my $resultFile = run($shift, $daysBefore);
            FileHandle::showFiles($resultFile);
            messageUtils::quit();
        }

        messageUtils::wrongUsage("Wrong shift was informed. Only 1 and 2 are available!");
    }

    messageUtils::wrongUsage("None or wrong parameter was informed!");
}

#############################################################################
main();         # start script
