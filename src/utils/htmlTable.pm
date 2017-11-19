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
sub startTable() {
    return "<table cellpadding='4px' cellspacing='0px'>";
}

sub closeTable() {
    return "</table>";
}

#############################################################################
# Routine to get start tr of header statement
#
# return:
#   string containing start tr of header statement
#############################################################################
sub startHeaderLine() {
    return "<tr class='head'>";
}

#############################################################################
# Routine to get close tr of header statement
#
# return:
#   string containing close tr of header statement
#############################################################################
sub closeHeaderLine() {
    return "</tr>";
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
sub startLine() {
    if ($_[0]) {
        return "<tr class='diff'>";
    }
    return "<tr>";
}

#############################################################################
# Routine to get close line in table statement
#
# return:
#   string containing close line in table statement
#############################################################################
sub closeLine() {
    return "</tr>";
}

sub applyColumn() {
    return "<td>".$_[0]."</td>";
}

#############################################################################
return 1;
