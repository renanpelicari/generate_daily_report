# #####################################################################################################
# 	Script:
# 		interfaceUtils.pm
#
# 	Description:
#		This script contains subroutines to treat and create good look view for shell script.
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-13	- First version
#
# #####################################################################################################

package interfaceUtils;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

require 'htmlTable.pm';

# include definitions
use globalDefinitions qw(true HEADER_SEPARATOR_SIZE DEFAULT_SEPARATOR);

#############################################################################
# iterator to generate separator to be a good look (more less) at shell :)
# params:
#   $_[0]   -> string with separator definition
# return:
#   string with separator to show
#############################################################################
sub header {
    my $separator = "";

    for (my $i=0; $i < HEADER_SEPARATOR_SIZE; $i++) {
        $separator .= $_[0];
    }

    print "\n".$separator."\n";
}

#############################################################################
# add line in the "table" to output on the server
#############################################################################
sub addTableLine {
    my @columns = @{$_[0]};

    foreach (@columns) {
        if (defined($_)) {
            printf "+---------------------";
        }
    }
    print "+\n";
}

#############################################################################
# add info in the html tables, also show in the server
#############################################################################
sub addTableElement {
    my @data = @{$_[0]};
    my $elementType = $_[1];
    my $lineStyle = $_[2];

    my $fileContent = "";

    # check if the header will be for a header, otherwise a simple tr will be used
    $fileContent .= ($elementType eq "header")
        ? htmlTable::startHeaderLine()
        : htmlTable::startLine($lineStyle);

    foreach (@data) {
        if (defined($_)) {
            printf "| %-20s", $_;
            $fileContent .= htmlTable::applyColumn($_);
        }
    }

    # close the tr
    $fileContent .= htmlTable::closeLine();
    print "|\n";

    # add more lines with dash ---
    addTableLine(\@data);

    return $fileContent;
}

#############################################################################
return true;
