#!/usr/bin/perl

use strict;
use warnings;
use autodie;

my $dirpath = "hymns";
my $newname = "Insights from A Prophets Life";

my @nonuppers = ("the", "of", "a", "in", "for", "with", "on", "from", "and", "to");


# 2001-01-0010-the-morning-breaks-eng.pdf -> 001 - The Morning Breaks.pdf
# 2001-01-0020-the-spirit-of-god-eng.pdf  -> 002 - The Spirit of God.pdf

opendir my $dh, $dirpath or die "Can't open $dirpath: $!";

my $number = 0;

print "Begin renaming...\n\n";
while ( my $file = readdir($dh) ) {
    next if $file =~ /^\.+$/;
	my $num = substr($file, 8, 3);
	my $name = substr($file, 13, length($file) - 13 - 8);
	my @words = split(/-/, $name);

	my @title = ();
	my $numwords = scalar(@words);
	my @indices = (0..scalar(@words) - 1);
	for (@indices) {
		my $word = $words[$_];
		my $newword = uc(substr($word, 0, 1)) . substr($word, 1, length($word) - 1);
		if ($_ != 0 && $_ != scalar(@words) - 1 && $word ~~ @nonuppers) {
			#print "$word\n";
			push(@title, $word);
		} else {
			#print "$newword\n";
			push(@title, $newword);
		}
	}
	
	my $final = "$num - @title.pdf";
	#print "Final title is: $final\n";

	my $newfile = "$dirpath/$final";
    print "Converting file $file to $newfile\n";
	rename "$dirpath/$file", $newfile or die "Cant rename file $file -> $newfile: $!";
}
print "\nRenaming complete.\n";

closedir $dh;
