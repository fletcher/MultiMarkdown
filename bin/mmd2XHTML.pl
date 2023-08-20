#!/usr/bin/env perl
#
# $Id: mmd2XHTML.pl 534 2009-06-19 20:52:55Z fletcher $
#
# Utility script to process MultiMarkdown files into XHTML
#
# Copyright (c) 2009 Fletcher T. Penney
#	<http://fletcherpenney.net/>
#
# MultiMarkdown Version 2.0.b6
#

# Combine all the steps necessary to process MultiMarkdown text into XHTML
# Not necessary, but easier than stringing the commands together manually.
#
# This script will process the text received via stdin, and output to stdout,
# OR
# will accept a list of files, and process each file individually.
#
# If a list of files is received, the input from "test.txt" will be output
# to "test.html", for example.

use strict;
use warnings;

use File::Basename;
use File::Spec;
use Cwd;
use Cwd 'abs_path';

# Determine where MMD is installed.  Use a "common installation" if available.

my $me = readlink(__FILE__) || __FILE__;		# Where is this script located?
my $MMDPath = LocateMMD($me);

# Determine whether we are in "file mode" or "stdin mode"

my $count = @ARGV;

if ($count == 0) {
	# We're in "stdin mode"

	# process stdin
	undef $/;
	my $data .= <>;

	MultiMarkdown::Support::ProcessMMD2XHTML($MMDPath, "", $data);

} else {
	# We're in "file mode"

	foreach(@ARGV) {
		# process each file individually

		# warn if directory
		if ( -d $_ ) {
			warn "This utility will not process directories.  Please specify the files to process.\n";
		} elsif ( -f $_ ) {
			# Determine filenames
			my $filename = $_;

			# Read input and process
			open(INPUT, "<$filename");
			local $/;
			my $data = <INPUT>;
			close(INPUT);

			MultiMarkdown::Support::ProcessMMD2XHTML($MMDPath, $filename, $data);
		} else {
			system("perldoc $0");
		}
	}
}

sub LocateMMD {
	my $me = shift;		# Where am I running from?

	my $os = $^O;	# Mac = darwin; Linux = linux; Windows contains MSWin
	my $MMDPath = "";

	# Determine where MMD is installed.  Use a "common installation"
	# if available.

	$me = dirname($me);

	my @candidates = ();

	if ( -f File::Spec->join($me, 'MultiMarkdown.pl') ) {
		$MMDPath = dirname($me);
	} else {
		# Next, look in user's home directory, then in common directories
		if ($os =~ /MSWin/) {
			# We're running Windows
			push @candidates, "$ENV{HOMEDRIVE}$ENV{HOMEPATH}\\MultiMarkdown";
			push @candidates, "$ENV{HOMEDRIVE}\\Documents and Settings\\All Users\\MultiMarkdown";

		} else {
			# We're running Mac OS X or some *nix
			if (defined($ENV{HOME})) {
				push @candidates, "$ENV{HOME}/Library/Application Support/MultiMarkdown";
				push @candidates, "$ENV{HOME}/.multimarkdown";
				push @candidates, "/Library/Application Support/MultiMarkdown";
				push @candidates, "/usr/share/multimarkdown";
			}
		}
	}

	foreach (@candidates) {
		if (-d $_) {
			$MMDPath = $_;
			last;
		}
	}

	if ($MMDPath eq "") {
		die "You do not appear to have MultiMarkdown installed.\n";
	} else {
		# Load the MultiMarkdown::Support.pm module
		$MMDPath = abs_path($MMDPath);
		unshift (@INC, File::Spec->join($MMDPath, 'lib'));
		require MultiMarkdown::Support;
	}

	return $MMDPath;
}

=head1 NAME

mmd2XHTML - utility script for MultiMarkdown to convert MultiMarkdown text
into XHTML.

=head1 SYNOPSIS

mmd2XHTML.pl [file ...]


=head1 DESCRIPTION

This script is designed as a "front-end" for MultiMarkdown. It can convert a
series of text files into XHTML.


=head1 SEE ALSO

Designed for use with MultiMarkdown.

<http://fletcherpenney.net/multimarkdown/>

Mailing list support for MultiMarkdown:

<http://groups.google.com/group/multimarkdown/>

	OR

<mailto:multimarkdown@googlegroups.com>

=head1 AUTHOR

Fletcher T. Penney, E<lt>owner@fletcherpenney.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Fletcher T. Penney

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the
   Free Software Foundation, Inc.
   59 Temple Place, Suite 330
   Boston, MA 02111-1307 USA

=cut
