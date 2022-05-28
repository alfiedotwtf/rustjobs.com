#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw{$Bin};

setup_environment();
fetch_logs();

sub fetch_logs {
  system qq{aws s3 sync s3://logs.rustjobs.com $Bin/../logs};
}

sub setup_environment {
  foreach my $name (qw{AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY}) {
    unless ($ENV{$name}) {
      die "The '$name' environment variable is not set\n";
    }
  }

  system qq{mkdir -p $Bin/../logs};
}
