#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw{$Bin};

system qq[zcat $Bin/../logs/*.gz | docker run --rm -i allinurl/goaccess -a --ignore-crawlers -o html --log-format CLOUDFRONT - > report.html];
