#!/usr/bin/perl
# from https://linuxconfig.org/extract-email-address-from-a-text-file

use strict;

my $email_count;
$email_count = 0;

while (my $line = <>) { #read from file or STDIN
  foreach my $email (split /[:<>]/, $line) {
     if ( $email =~ /^[-\w.]+@([a-z0-9][a-z-0-9]+\.)+[a-z]{2,4}$/i ) {
 		print $email . "\n";
		$email_count++;
  }
}
}

if ($email_count == 0) {
		print STDERR "No emails found!\n";
		exit 1;
}
else {
		print STDERR "Emails Extracted: $email_count\n";
		exit 0;
}
