#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw{$Bin};

setup_environment();
check_stack_exists();
deploy_htdocs();

sub check_stack_exists {
  my $status = `aws cloudformation describe-stacks --stack-name rustjobs 2>&1`;
  return if $status =~ /(?:CREATE|UPDATE)_COMPLETE/;

  die "Error: $status";
}

sub deploy_htdocs {
  my @files = (
    "404.html",
    "favicon.ico",
    "index.html",
    "robots.txt",

    "css/desktop.css",
    "css/fonts/inter-300.ttf",
    "css/fonts/inter-600.ttf",
    "css/fonts/inter-700.ttf",
    "css/fonts/inter-800.ttf",
    "css/fonts/inter-900.ttf",

    "advertise.html",

    "blog.html",
    "blog/the-rust-jobs-market.html",

    "contact.html",

    "images/rust-jobs-logo.png",
    "images/menu.png",

    "js/global.js",

    "legal.html",
  );

  for my $file (@files) {
    system qq{aws s3 cp $Bin/../htdocs/$file s3://www.rustjobs.com/$file};
    print "\n";
  }
}

sub setup_environment {
  foreach my $name (qw{AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY}) {
    unless ($ENV{$name}) {
      die "The '$name' environment variable is not set\n";
    }
  }

  unless (($ENV{AWS_DEFAULT_REGION} || '') eq 'us-east-1') {
    die "CloudFront only supports ACM certificates in AWS_DEFAULT_REGION=us-east-1\n";
  }
}
