#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw{$Bin};

setup_environment();

if (get_stack_status() =~ /does not exist/) {
  deploy_stack('create');
}
else {
  deploy_stack('update');
}

sub get_stack_status {
  my $status;

  while (1) {
    $status = `aws cloudformation describe-stacks --stack-name rustjobs 2>&1`;

    last if $status =~ /_COMPLETE/;
    last if $status =~ /does not exist/;

    if ($status =~ /(?:CREATE|UPDATE)_IN_PROGRESS/) {
      print ".";
      sleep 1;
      next;
    }

    die "Error: $status";
  }

  return $status;
}

sub deploy_stack {
  my ($action) = @_;

  my $modify_stack = join(" ",
    "aws cloudformation $action-stack",
    '--stack-name rustjobs',
    "--parameters ParameterKey=ProxySecret,ParameterValue=$ENV{ProxySecret}",
    "--template-body file://$Bin/../templates/cloudformation.yml",
  );

  system $modify_stack;
}

sub setup_environment {
  foreach my $name (qw{AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY ProxySecret}) {
    unless ($ENV{$name}) {
      die "The '$name' environment variable is not set\n";
    }
  }

  unless (($ENV{AWS_DEFAULT_REGION} || '') eq 'us-east-1') {
    die "CloudFront only supports ACM certificates in AWS_DEFAULT_REGION=us-east1\n";
  }
}
