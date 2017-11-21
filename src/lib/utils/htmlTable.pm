# #####################################################################################################
# 	Script:
# 		htmlTable.pm
#
# 	Description:
#		This script contains subroutines to build html table
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package htmlTable;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;

#############################################################################
# Routine to get start table statement
#
# return:
#   string containing start table statement
#############################################################################
sub getTableStart {
    return "<table cellpadding='4px' cellspacing='0px'>";
}

sub getTableClose {
    return "</table>";
}

#############################################################################
# Routine to get start tr of header statement
#
# return:
#   string containing start tr of header statement
#############################################################################
sub getTrHeaderStart {
    return "<tr class='head'>";
}

#############################################################################
# Routine to get start line.
# The color of line can be switched between two, according the parameter.
#
# params:
#   $_[0]   -> boolean to say if will use class or not,
#               in order to switch colors in the lines.
#
# return:
#   string containing line start statement
#############################################################################
sub getTrLineStart() {
    if ($_[0]) {
        return "<tr class='diff'>";
    }
    return "<tr>";
}

#############################################################################
# Routine to get close tr of header statement
#
# return:
#   string containing close tr of header statement
#############################################################################
sub getTrClose {
    return "</tr>";
}

sub getTd() {
    return "<td>".$_[0]."</td>";
}

#############################################################################
return 1;
