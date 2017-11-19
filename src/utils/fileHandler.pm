# #####################################################################################################
# 	Script:
# 		fileHandler.pm
#
# 	Description:
#		This script contains subroutines to handle with files
#
# 	Author:
#		renanpelicari@gmail.com
#
#	Revision:
#		1.0b	- 2017-11-12	- First version
#
# #####################################################################################################

package fileHandler;

#############################################################################
# imports essentials
#############################################################################
use strict;
use warnings;
use Exporter qw(import);

# include definitions
use globalDefinitions qw(false true DEFAULT_SEPARATOR);
use projectDefinitions qw(GENERATED_FILE_FOLDER GENERATED_FILE_EXTENSION FILE_ENCODING);

#require 'messageUtils.pm';

#############################################################################
# routine to show result files
# params:
#   $content    -> content of file
#   $prefix     -> prefix of filename
# return:
#   the name of file generated
#############################################################################
sub showFiles {
    my @resultFiles = @{$_[0]};

    messageUtils::infoListMessage("Generated files:", @resultFiles);
}

#############################################################################
# routine to create file
# params:
#   $content    -> content of file
#   $prefix     -> prefix of filename
# return:
#   the name of file generated
#############################################################################
sub createFile {
    my $content = $_[0];
    my $prefix = $_[1];

    chomp $content;

    my $date = `date +%Y%m%d-%H%M%S`;
    chomp $date;

    if ($globalDefinitions::_DEBUG_MODE) {
        messageUtils::infoMessage("Creating file with content ...\n".$content);
    }

    my $filename = $prefix."_".$date.GENERATED_FILE_EXTENSION;
    chomp $filename;

    system("touch $filename")
        or die messageUtils::errorMessage("Could not create file '$filename'");

    open(my $fh, '>:encoding('.FILE_ENCODING.')', $filename)
        or die messageUtils::errorMessage("Could not open file '$filename'");

    print $fh $content;
    close $fh;

    return $filename;
}

#############################################################################
# (void) routine to move file to specific folder
# params:
#   @resultFiles    -> array containing filenames that will move
#   $autoConfirm    -> flag to inform if file will be move
#############################################################################
sub moveToGenerateFilesFolder {
    my @resultFiles = @{$_[0]};
    my $autoConfirm = $_[1];

    my $out = false;

    while ($out eq false) {

        my $input = '';

        if (!$autoConfirm) {
            print "\n\nDo you want to move generated files to ".GENERATED_FILE_FOLDER." folder (Y/N)?\n> ";
            $input = <STDIN>;
            chomp $input;
        }

        if (($autoConfirm) || ($input =~ m/^[Y]$/i)) {
            #match Y or y
            foreach (@resultFiles) {
                system("mv $_ ".GENERATED_FILE_FOLDER);
            }
            $out = true;

        } elsif ($input =~ m/^[N]$/i) {
            #match N or n
            messageUtils::errorMessage("File was not moved!");
            $out = true;

        } else {
            messageUtils::errorMessage("Invalid Option!");
        }
    }

    messageUtils::infoMessage("File stored at target folder!");
}

#############################################################################
return true;
