use warnings;
use strict;
use Exporter qw(import);

#############################################################################
# subroutine to get random string
#############################################################################
sub getRandomString {
    my $quantity = $_[0];

    my @chars = ("A" .. "Z", "a" .. "z");

    my $string;
    $string .= $chars[rand @chars] for 1 .. $quantity;

    return $string;

}

#############################################################################
# subroutine to get random date
#############################################################################
sub getRandomDate {
    my $date = `date +%Y%m%d`;
    chomp $date;

    return $date;
}

#############################################################################
return true;
