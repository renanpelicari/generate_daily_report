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
use projectDefinitions qw(GENERATED_FILE_FOLDER GENERATED_FILE_EXTENSION);

require 'interfaceUtils.pm';

#############################################################################
# subroutine to show file results
#############################################################################
sub showFiles {
    my @resultFiles = @{$_[0]};

    interfaceUtils::header(DEFAULT_SEPARATOR);
    print BOLD, RED, "> Generated files:", RESET;
    foreach (@resultFiles) {
        print "\n\t".$_;
    }
    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "\n";
}

#############################################################################
# subroutine to create file
#############################################################################
sub createFile {
    my $content = $_[0];
    my $file = $_[1];
    my $filename = "";

    chomp $content;

    my $date = `date +%Y%m%d-%H%M%S`;
    chomp $date;

    if ($debug) {
        print "\nRESULT:";
        interfaceUtils::header(DEFAULT_SEPARATOR);
        print $content;
        interfaceUtils::header(DEFAULT_SEPARATOR);
    }

    $filename = $file."_".$date.GENERATED_FILE_EXTENSION;
    chomp $filename;

    system("touch $filename");

    open(my $fh, '>:encoding(UTF-8)', $filename)
        or die "Could not open file '$filename'";

    print $fh $content;
    close $fh;

    return $filename;
}

#############################################################################
# routine to move file to specific folder
#############################################################################
sub moveToGenerateFilesFolder {
    my @resultFiles = @{$_[0]};
    my $autoConfirm = $_[1];

    my $out = false;

    while ($out eq false) {

        my $input = '';

        if ($autoConfirm) {
            $input = 'Y';
        } else {
            print "\n\nDo you want to move generated files to ".GENERATED_FILE_FOLDER." folder (Y/N)?\n> ";
            $input = <STDIN>;
            chomp $input;
        }

        if ($input =~ m/^[Y]$/i) {
            #match Y or y
            foreach (@resultFiles) {
                system("mv $_ ".GENERATED_FILE_FOLDER);
            }
            $out = true;

        } elsif ($input =~ m/^[N]$/i) {
            #match N or n
            interfaceUtils::errorMessage("File was not moved!");
            $out = true;
        } else {
            interfaceUtils::errorMessage("Invalid Option!");
        }
    }

    interfaceUtils::header(DEFAULT_SEPARATOR);
    print "\nFile stored at target folder!";
    interfaceUtils::header(DEFAULT_SEPARATOR);
}

#############################################################################
return true;

