# #####################################################################################################
# 	Script:
# 		randomUtils.pm
#
# 	Description:
#		This script contains subroutines to create random value
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-12	- First version
#
# #####################################################################################################

package randomUtils;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

#############################################################################
# get random string
# params:
#   quantity    -> delimit maximum length
# return:
#   a random string
#############################################################################
sub getRandomString {
    my $quantity = $_[0];

    my @chars = ("A" .. "Z", "a" .. "z");

    my $string;
    $string .= $chars[rand @chars] for 1 .. $quantity;

    return $string;
}

#############################################################################
# get a random date
# return:
#   random date
#############################################################################
sub getRandomDate {
    return chomp `date +%Y%m%d`;
}

#############################################################################
return 1;
