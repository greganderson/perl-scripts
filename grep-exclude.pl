#!/usr/bin/perl

# A perl recreation of `grep --exclude` or `grep --exclude-dir`.  Find the
# target string, skipping over lines that contain the excluded string.

use Term::ANSIColor;

my $target = shift or &usage;
my $exclude = shift or &usage;
my $len = length($target);

while (<>) {
	if (/$exclude/) {
		next;
	}
	
	if (/$target/) {
		my $offset = 0;
		my $index = index $_, $target, $offset;

		while ($index != -1) {
			print (substr($_, $offset, $index - $offset));

			print color('bold red');
			print (substr($_, $index, $len));

			print color('bold white');
			$offset = $index + $len;
			$index = index $_, $target, $offset;
		}

		print (substr($_, $offset, length($_) - $offset));
	}
}

sub usage {
	print "Usage: $0 <SEARCH_TERM> <EXCLUDE_TERM>\n";
	exit(1);
}
