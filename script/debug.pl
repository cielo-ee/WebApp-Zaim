#!/usr/bin/perl

use strict;
use warnings;


use FindBin qw($Bin);
use lib "$Bin/../lib/";

use WebApp::Zaim;
use Data::Dumper;

my $zaim = WebApp::Zaim->new(filename => '../lib/WebApp/config.json');

my $res = $zaim->call_api(
    method => 'GET',
    url    => q{/home/user/verify},
);

print Dumper $res;
