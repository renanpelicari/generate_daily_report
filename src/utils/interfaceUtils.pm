use warnings;
use strict;
use Exporter qw(import);

#############################################################################
# subroutine to exit the script
#############################################################################
sub quit {
    header("=");
    print "\nBye...\n\n";
    exit();
}

#############################################################################
# sub with a simple for to generate the same size for headers
#############################################################################
sub header {
    my $strSeparator = $_[0];
    my $separator = "";

    for (my $i = 0; $i < 67; $i++) {
        $separator .= $strSeparator;
    }

    print "\n" . $separator . "\n";
}

#############################################################################
# subroutine to show debug message
#############################################################################
sub showDebug {
    my $message = $_[0];
    my $query = $_[1];

    if ($query) {$query =~ s/\t//g;}

    header("=");
    print "DEBUG MODE";
    print "\nINFO: \t" . $message;
    if ($query) {print "\nQUERY: \n" . $query . ";" . "\n";}
    header("=");
    print "\n";
}

#############################################################################
# subroutine to show the wrong messages
#############################################################################
sub wrongUsage {
    my $errorMsg = $_[0];

    header("=");
    print BOLD, RED;
    print "ERROR: \t\tWrong option or value.";
    print "\nMESSAGE: \t" . $errorMsg;
    print "\nTODO: \t\tPlease check the options and examples at the menu!";
    print RESET;
    header("=");
    print "\n";
    help();
}

#############################################################################
return true;
