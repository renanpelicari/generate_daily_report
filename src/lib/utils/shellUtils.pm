# #####################################################################################################
# 	Script:
# 		shellUtils.pm
#
# 	Description:
#		This script contains subroutines to handle with shell commands
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package shellUtils;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;

#############################################################################
# execute shell command
#############################################################################
sub executeCommand {
    my $result = `$_[0]`;

    # remove the blank space
    chomp $result;
    $result =~ s/\t//g;;

    return $result;
}

#############################################################################
return 1;
