#!/usr/bin/env perl

require 5.006_000;
use strict;
use warnings;

use File::Basename;
use File::Spec;

eval {require MultiMarkdown};
if ($@) {
	my $me = __FILE__;

	my $path = dirname(dirname($me));

	$path = File::Spec->join($path, 'lib');

	unshift (@INC, $path);

	require MultiMarkdown;
}
