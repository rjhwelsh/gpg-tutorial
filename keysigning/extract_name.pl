#!/usr/bin/perl
# from https://linuxconfig.org/extract-email-address-from-a-text-file

use strict;

my $name_count;
$name_count = 0;

while (my $line = <>) { #read from file or STDIN
		foreach my $name (split /[\]<]/, $line) {
     if ( $name =~ /^ ([a-z0-9][a-z-0-9]+ )+$/i ) {
 		print $name . "\n";
		$name_count++;
  }
}
}

if ($name_count == 0) {
		print STDERR "No names found!\n";
		exit 1;
}
else {
		print STDERR "Names Extracted: $name_count\n";
		exit 0;
}
