#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Std;
our($opt_a, $opt_r);

getopts('ar');
die "can only add or remove" if ($opt_a && $opt_r);

my $file = shift;

sub readlist;
my %got;
map { ++$got{$_} } readlist $file;

my ($added, $removed, $failed) = (0, 0, 0);

while (my $s = shift) {
    if ($opt_a) {
	unless (exists $got{$s}) {
	    $got{$s} = 1;
	    ++$added;
	} else {
	    print "already got sticker $s\n";
	    ++$failed;
	}
    }
    elsif ($opt_r) {
	if (exists $got{$s}) {
	    delete $got{$s};
	    ++$removed;
	} else {
	    print "sticker $s not found\n";
	    ++$failed;
	}
    }
}

print "$added stickers added, $removed stickers removed, $failed failed\n";
print scalar keys %got, " stickers in $file\n";

open my $out, '>', $file;
print $out join(",", join(",", map { ("$_") x $got{$_} } sort {$a <=> $b} keys %got)), "\n";

sub readlist {
    local $/;
    open my $fh, "<", shift;
    my $file = <$fh>;
    return split /[\s,.]+/, $file;
}
