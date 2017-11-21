# #####################################################################################################
# 	Script:
# 		html.pm
#
# 	Description:
#		This script contains subroutines to build with html content
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package html;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;

#############################################################################
# routine to start html file
# return:
#   string containing html declaration
#############################################################################
sub getHtmlStart() {
    return "<!doctype html>";
}

#############################################################################
# routine to close html file
#
# return:
#   string containing html close statement
#############################################################################
sub getHtmlClose() {
    return "</html>";
}

#############################################################################
# routine to start header statement
#
# return:
#   string containing start header statement
#############################################################################
sub getHeadStart() {
    return "<head>";
}

#############################################################################
# routine to close header statement
#
# return:
#   string containing header close statement
#############################################################################
sub getHeadClose() {
    return "</head>";
}

#############################################################################
# routine to start body statement
#
# return:
#   string containing start body statement
#############################################################################
sub getBodyStart() {
    return "<bod>";
}

#############################################################################
# routine to close body statement
#
# return:
#   string containing close body statement
#############################################################################
sub getBodyFinish() {
    return "</body>";
}

#############################################################################
# routine to apply header <h1> format to informed string
#
# params:
#   $_[0]   -> (string) header content
#
# return:
#   string containing close body statement
#############################################################################
sub getH1() {
    return "<h1>".$_[0]."</h1>";
}

#############################################################################
return 1;
