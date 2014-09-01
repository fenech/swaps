#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Std;
our($opt_a, $opt_r);

getopts('ar');
die "can only add or remove" if ($opt_a && $opt_r);

my $file = shift;

sub readlist;
my %stickers;
map { ++$stickers{$_} } readlist $file;

my ($added, $removed, $failed) = (0, 0, 0);

while (my $s = shift) {
    if ($opt_a) {
	++$stickers{$s};
	++$added;
    }
    elsif ($opt_r) {
	if (exists $stickers{$s} && $stickers{$s} > 0) {
	    delete $stickers{$s} if --$stickers{$s} == 0;	    
	    ++$removed;
	} else {
	    print "sticker $s not found\n";
	    ++$failed;
	}
    }
}

print "$added stickers added, $removed stickers removed, $failed failed\n";
print scalar keys %stickers, " stickers in $file\n";

open my $out, '>', $file;
print $out "$_\n" for join("\n", map { ("$_") x $stickers{$_} } sort {$a <=> $b} keys %stickers);

sub readlist {
    local $/;
    open my $fh, "<", shift;
    my $file = <$fh>;
    return split /[\s,.]+/, $file;
}
