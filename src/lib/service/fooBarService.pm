# #####################################################################################################
#   Script:
#       fooBarService.pl
#
#   Description:
#   	This script handle with delete/create fooBar data
#
#   Author:
#     	renanpelicari@gmail.com
#
#   Revision:
#       1.0b	- 2017-11-20    - First version
#
# #####################################################################################################

package fooBarService;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;

require 'fooBarDao.pm';
require 'randomUtils.pm';

#############################################################################
# (void) call routine to delete foobar based on range of ids
# params:
#   $startId    -> int - first id of range
#   $lastId     -> int - last id of range
#############################################################################
sub cleanupFooBar {
    fooBarDao::deleteByIdBetween($_[0], $_[1]);
}

#############################################################################
# (void) call routine to insert new foobar based on range of ids
# params:
#   $startId    -> int - first id of range
#   $lastId     -> int - last id of range
#############################################################################
sub insertFooBar {
    for (my $i=0; $_[0] < $_[1]; $i++) {
        fooBarDao::insertFooBar($i, randomUtils::getRandomString(7), "NEW");
    }
}

1;
