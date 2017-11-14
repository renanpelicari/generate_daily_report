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
# execute commands in server
#############################################################################
sub executeCommand {
    my $command = $_[0];
    my $result = "";

    $result = `$command`;

    # remove the blank space
    chomp $result;
    $result =~ s/\t//g;;

    return $result;
}

#############################################################################
return 1;
