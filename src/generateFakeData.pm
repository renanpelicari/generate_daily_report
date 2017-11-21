#!/usr/bin/perl --
# #####################################################################################################
#    Script:
#   	generateFakeData.pl
#
#    Description:
#   	This script generate random fake data (with negative id) to insert at DB.
#       Also provide a rollback option (cleanup based a hash of negative ids).
#
#    Author:
#   	renanpelicari@gmail.com
#   	https://github.com/renanpelicari
#   	https://www.linkedin.com/in/renanpelicari/
#
#    Revision:
#       0.1b    - 2017-11-20    - First version

#    How TO Use:
#      You need to run in Linux or Unix like.
#      Also need to be prepared to run perl scripts.
#      A execute permission should be configured (chmod +x generateFakeData.pl)
#      And to check how to use, you just need to view the help menu: ./generateFakeData.pl -h
# #####################################################################################################

package generateFakeData;

#############################################################################
# import essentials
#############################################################################
use strict;
use warnings;

# lib to get parameter options
use Getopt::Std;

#############################################################################
# golbal variables
#############################################################################

# define the parameters that will be available
my %options = ();
getopts('hq:cd', \%options);

# include all folders inside lib (necessary for .pm libs)
use lib 'lib/dao/';
use lib 'lib/database/';
use lib 'lib/definitions/';
use lib 'lib/service/';
use lib 'lib/utils/';

# import only libs used in this script
require 'messageUtils.pm';
require 'interfaceUtils.pm';
require 'fooBarService.pm';

use globalDefinitions qw(true DEFAULT_SEPARATOR);

use constant FOOBAR_ID_START => -1001;
use constant FOOBAR_ID_FINISH => -2000;

#############################################################################
# missing doc
#############################################################################
sub cleanData {
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "Generate Fake Data: \t\t Cleanup Routine";

    # call cleanup service with hash of ids
    fooBarService::cleanupFooBar(FOOBAR_ID_START, FOOBAR_ID_FINISH);
}

#############################################################################
# missing doc
#############################################################################
sub insertData {
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "Generate Fake Data: \t\t Insert Routine";

    # call cleanup service with hash of ids
    fooBarService::insertFooBar(FOOBAR_ID_START, FOOBAR_ID_FINISH);
}

#############################################################################
# subroutine to show the help
#############################################################################
sub help {
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "SCRIPT:";
    print "\n\tgenerateFakeData.pl";
    print "\n\nDESCRIPTION:";
    print "\n\tScript generate random fake data (with negative id) to insert at DB";
    print "\n\tAlso provide a rollback option (cleanup based a hash of negative ids).";
    print "\n\nOPTIONS:";
    print "\n\t-h \t\t\t (help)";
    print "\n\t-c \t\t (clean option)";
    print "\n\t-q [integer] \t\t (quantity of data)";
    print "\n\t-d \t\t\t (Debug Mode)";
    print "\n\nUSAGE:";
    print "\n\t[-h][-s 1][-s 2]";
    print "\n\nEXAMPLES:";
    print "\n\t./generateFakeData.pm -h";
    print "\n\t./generateFakeData.pm -c";
    print "\n\t./generateFakeData.pm -q 2 -d";
    print "\n\nVERSION:";
    print "\n\t0.1b\t- 2017-11-20";
    print "\n\nAUTHOR:";
    print "\n\tRenan Peliçari (renanpelicari\@gmail.com)";
    print "\n\thttps://github.com/renanpelicari";
    print "\n\thttps://www.linkedin.com/in/renanpelicari/";
    interfaceUtils::header(DEFAULT_SEPARATOR);
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
        $globalDefinitions::_DEBUG_MODE = true;
    }

    # check the shift that were informed
    if (defined($options{c})) {
        cleanData();
    }

    if (defined($options{q})) {
        insertData();
    }

    messageUtils::wrongUsage("None or wrong parameter was informed!");
    help();
}

#############################################################################
main();         # start script
