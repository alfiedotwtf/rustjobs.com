#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw{$Bin};

setup_environment();
rm_logs();

sub rm_logs {
  system qq{aws s3 rm s3://logs.rustjobs.com --recursive --exclude "*" --include "*$ARGV[0]*"};
}

sub setup_environment {
  foreach my $name (qw{AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY}) {
    unless ($ENV{$name}) {
      die "The '$name' environment variable is not set\n";
    }
  }

  unless (($ARGV[0] || '') && length($ARGV[0] || 0) >= 7) {
    die "usage: $0 <YYYY-MM-DD>\n";
  }
}
