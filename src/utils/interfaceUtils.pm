# #####################################################################################################
# 	Script:
# 		interfaceUtils.pm
#
# 	Description:
#		This script contains subroutines to treat and create good look view,
#       and show messages at shell script.
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-12	- First version
#
# #####################################################################################################

package interfaceUtils;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);
use Term::ANSIColor qw(:constants); # text format (color/bold)

# include definitions
use globalDefinitions qw(true HEADER_SEPARATOR_SIZE DEFAULT_SEPARATOR);

#############################################################################
# subroutine to exit the script
#############################################################################
sub quit {
    header(DEFAULT_SEPARATOR);
    print "\nBye...\n\n";
    exit();
}

#############################################################################
# iterator to generate separator to be a good look (more less) at shell :)
# params:
#   $_[0]   -> string with separator definition
# return:
#   string with separator to show
#############################################################################
sub header {
    my $separator = $_[rand ($_[0])] for 1 .. HEADER_SEPARATOR_SIZE;

    print "\n".$separator."\n";
}

#############################################################################
# show debug message
# params:
#   message     -> String with debug message
#   query       -> Query to log at debug message
# return:
#   string with debug message formatted
#############################################################################
sub showDebug {
    my $message = $_[0];
    my $query = $_[1];

    header(DEFAULT_SEPARATOR);
    print "DEBUG MODE";
    print "\nINFO: \t".$message;
    if ($query) {
        $query =~ s/\t//g;
        print "\nQUERY: \n".$query.";"."\n";
    }
    header(DEFAULT_SEPARATOR);
    print "\n";
}

#############################################################################
# show the wrong messages
# params:
#   errorMsg    -> String with error message
# return:
#   string formatted with wrong message
#############################################################################
sub wrongUsage {
    my $errorMsg = $_[0];

    header(DEFAULT_SEPARATOR);
    print BOLD, RED;
    print "ERROR: \t\tWrong option or value.";
    print "\nMESSAGE: \t".$errorMsg;
    print "\nTODO: \t\tPlease check the options and examples at the menu!";
    print RESET;
    header(DEFAULT_SEPARATOR);
    print "\n";
    help();
}

#############################################################################
# show the messages
# params:
#   $type     -> type of message
#   $message  -> String with message
#   @lines    -> array containing info to show one by line
# return:
#   string formatted with message
#############################################################################
sub message {
    my $type = $_[0];
    my $message = $_[1];
    my @lines = @{$_[2]};

    header(DEFAULT_SEPARATOR);

    if ($type eq 'ERROR') {
        print BOLD, RED;
    } else {
        print BOLD, YELLOW;
    }

    print $type.": \t\t".$message;
    print RESET;

    foreach (@lines) {
        print "\n\t".$_;
    }
    header(DEFAULT_SEPARATOR);
    print "\n";
}

#############################################################################
# show the error messages
# params:
#   $_[0]    -> String with error message
# return:
#   string formatted with wrong message
#############################################################################
sub errorMessage {
    message("ERROR", $_[0], undef);
}

#############################################################################
# show the info messages
# params:
#   $_[0]    -> String with info message
# return:
#   string formatted with info message
#############################################################################
sub infoMessage {
    message("INFO", $_[0], undef);
}

#############################################################################
# show the error messages
# params:
#   $_[0]    -> String with error message
#   @{$_[1]} -> list of lines to show
# return:
#   string formatted with wrong message
#############################################################################
sub errorListMessage {
    message("ERROR", $_[0], @{$_[1]});
}

#############################################################################
# show the info messages
# params:
#   $_[0]    -> String with info message
#   @{$_[1]} -> list of lines to show
# return:
#   string formatted with info message
#############################################################################
sub infoListMessage {
    message("INFO", $_[0], @{$_[1]});
}

#############################################################################
return true;
