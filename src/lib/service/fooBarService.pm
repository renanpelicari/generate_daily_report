package fooBarService;
use strict;
use warnings;

require 'fooBarDao.pm';
require 'randomUtils.pm';

sub cleanupFooBar {
    fooBarDao::deleteByIdBetween($_[0], $_[1]);
}

sub insertFooBar {
    for (my $i=0; $_[0] < $_[1]; $i++) {
        fooBarDao::insertFooBar($i, randomUtils::getRandomString(7), "NEW");
    }
}

1;
