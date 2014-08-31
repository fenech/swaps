#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use List::Compare;

sub readlist {
    local $/;
    open my $fh, "<", shift;
    my $file = <$fh>;
    return split /[\s,.\*]+/, $file;
}

my @my_need = readlist 'my_need';
my @my_got = readlist 'my_got';

my @p1_need = readlist shift;
my @p1_got = readlist shift;

my @give_to_p1 = List::Compare->new(\@my_got, \@p1_need)->get_intersection;
my @get_from_p1 = List::Compare->new(\@my_need, \@p1_got)->get_intersection;

print("give(", scalar @give_to_p1, "):\n", 
      join(",", sort{$a <=> $b} @give_to_p1), "\n");

print("receive(", scalar @get_from_p1, "):\n", 
      join (",", sort{$a <=> $b}@get_from_p1), "\n");
