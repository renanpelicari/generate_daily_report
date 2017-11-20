# #####################################################################################################
# 	Script:
# 		messageUtils.pm
#
# 	Description:
#		This script contains subroutines to handle with messages
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package messageUtils;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);
use Term::ANSIColor qw(:constants); # text format (color/bold)

require 'interfaceUtils.pm';

use globalDefinitions qw(true DEFAULT_SEPARATOR);

#############################################################################
# subroutine to exit the script
#############################################################################
sub quit {
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "\nBye...\n\n";
    exit();
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

    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "DEBUG MODE";
    print "\nINFO: \t".$message;
    if ($query) {
        $query =~ s/\t//g;
        print "\nQUERY: \n".$query.";"."\n";
    }
    interfaceUtils::header(DEFAULT_SEPARATOR);
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

    interfaceUtils::header(DEFAULT_SEPARATOR);
    print BOLD, RED;
    print "ERROR: \t\tWrong option or value.";
    print "\nMESSAGE: \t".$errorMsg;
    print "\nTODO: \t\tPlease check the options and examples at the menu!";
    print RESET;
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "\n";
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

    interfaceUtils::header(DEFAULT_SEPARATOR);

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
    interfaceUtils::header(DEFAULT_SEPARATOR);
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
