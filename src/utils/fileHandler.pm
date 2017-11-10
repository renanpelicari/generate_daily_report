use warnings;
use strict;
use Exporter qw(import);

#############################################################################
# subroutine to show file results
#############################################################################
sub showFiles {
    my @resultFiles = @{$_[0]};

    header("=");
    print BOLD, RED, "> Generated files:", RESET;
    foreach (@resultFiles) {
        print "\n\t" . $_;
    }
    header("=");
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
        header("=");
        print $content;
        header("=");
    }

    $filename = $file . "_" . $date . ".dat";
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
sub moveToHComFolder {
    my @resultFiles = @{$_[0]};
    my $autoConfirm = $_[1];

    my $out = false;

    while ($out eq false) {

        my $input = '';

        if ($autoConfirm) {
            $input = 'Y';
        } else {
            print "\n\nDo you want to move generated files to GENERATED_FILES_FOLDER folder (Y/N)?\n> ";
            $input = <STDIN>;
            chomp $input;
        }

        if ($input =~ m/^[Y]$/i) {
            #match Y or y

            foreach (@resultFiles) {
                system("mv $_ GENERATED_FILES_FOLDER");
            }

            $out = true;

        } elsif ($input =~ m/^[N]$/i) {
            #match N or n
            header("=");
            print "\nFile was not moved!";
            header("=");
            $out = true;
        } else {
            print "Invalid Option!";
        }
    }

    header("=");
    print "\nFile moved (or keep) to the properly folder!";
    header("=");
}

#############################################################################
return true;
