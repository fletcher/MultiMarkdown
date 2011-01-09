#!/usr/bin/env perl

require 5.006_000;
use strict;
use warnings;

use File::Basename;
use File::Spec;

eval {require MultiMarkdown};
if ($@) {
	my $me = readlink(__FILE__);

	my $path = dirname(dirname($me));

	$path = File::Spec->join($path, 'lib');

	unshift (@INC, $path);

	require MultiMarkdown;
}

import MultiMarkdown qw{markdown};

#### Blosxom plug-in interface ##########################################

# Set $g_blosxom_use_meta to 1 to use Blosxom's meta plug-in to determine
# which posts Markdown should process, using a "meta-markup: markdown"
# header. If it's set to 0 (the default), Markdown will process all
# entries.
our $g_blosxom_use_meta = 0;

sub start { 1; }
sub story {
	my($pkg, $path, $filename, $story_ref, $title_ref, $body_ref) = @_;

	if ( (! $g_blosxom_use_meta) or
	     (defined($meta::markup) and ($meta::markup =~ /^\s*markdown\s*$/i))
	     ){
			$$body_ref  = markdown($$body_ref);
     }
     1;
}


#### Movable Type plug-in interface #####################################
eval {require MT};  # Test to see if we're running in MT.
unless ($@) {
    require MT;
    import  MT;
    require MT::Template::Context;
    import  MT::Template::Context;

	eval {require MT::Plugin};  # Test to see if we're running >= MT 3.0.
	unless ($@) {
		require MT::Plugin;
		import  MT::Plugin;
		my $plugin = new MT::Plugin({
			name => "MultiMarkdown",
			description => "Based on the original Markdown",
			doc_link => 'http://fletcherpenney.net/multimarkdown/'
		});
		MT->add_plugin( $plugin );
	}

	MT::Template::Context->add_container_tag(MultiMarkdownOptions => sub {
		my $ctx	 = shift;
		my $args = shift;
		my $builder = $ctx->stash('builder');
		my $tokens = $ctx->stash('tokens');

		if (defined ($args->{'output'}) ) {
			$ctx->stash('multimarkdown_output', lc $args->{'output'});
		}

		defined (my $str = $builder->build($ctx, $tokens) )
			or return $ctx->error($builder->errstr);
		$str;		# return value
	});

	MT->add_text_filter('multimarkdown' => {
		label     => 'MultiMarkdown',
		docs      => 'http://fletcherpenney.net/MultiMarkdown/',
		on_format => sub {
			my $text = shift;
			my $ctx  = shift;
			my $raw  = 0;
			my %opts = ();
		    if (defined $ctx) {
		    	my $output = $ctx->stash('multimarkdown_output'); 
				if (defined $output  &&  $output =~ m/^html/i) {
					$opts{empty_element_suffix} = ">";
					$ctx->stash('multimarkdown_output', '');
				}
				elsif (defined $output  &&  $output eq 'raw') {
					$raw = 1;
					$ctx->stash('multimarkdown_output', '');
				}
				else {
					$raw = 0;
					$opts{empty_element_suffix} = " />";
				}
			}
			$text = $raw ? $text : markdown($text, %opts);
			$text;
		},
	});

	# If SmartyPants is loaded, add a combo Markdown/SmartyPants text filter:
	my $smartypants;

	{
		no warnings "once";
		$smartypants = $MT::Template::Context::Global_filters{'smarty_pants'};
	}

	if ($smartypants) {
		MT->add_text_filter('multimarkdown_with_smartypants' => {
			label     => 'MultiMarkdown With SmartyPants',
			docs      => 'http://fletcherpenney.net/MultiMarkdown/',
			on_format => sub {
				my $text = shift;
				my $ctx  = shift;
				my %opts = ();
				if (defined $ctx) {
					my $output = $ctx->stash('multimarkdown_output'); 
					if (defined $output  &&  $output eq 'html') {
						$opts{empty_element_suffix} = ">";
					}
					else {
						$opts{empty_element_suffix} = " />";
					}
				}
				$text = markdown($text, %opts);
				$text = $smartypants->($text, '1');
			},
		});
	}
}
else {
#### BBEdit/command-line text filter interface ##########################
# Needs to be hidden from MT (and Blosxom when running in static mode).

    # We're only using $blosxom::version once; tell Perl not to warn us:
	no warnings 'once';
    unless ( defined($blosxom::version) ) {
		use warnings;

		my %opts = ();

		#### Check for command-line switches: #################
		my %cli_opts;
		use Getopt::Long;
		Getopt::Long::Configure('pass_through');
		GetOptions(\%cli_opts,
			'version',
			'shortversion',
			'html4tags',
			'markdownonly',
		);

		if ($cli_opts{'markdownonly'} || basename($0) eq 'Markdown.pl') {
			%opts = (
				allow_mathml => 0,
				use_metadata => 0,
				heading_ids => 0,
				img_ids => 0,
				codeblocks_newline => "\n",
				disable_tables => 1,
				disable_footnotes =>1,
				disable_bibliography =>1,
			);
		}

		if ($cli_opts{'version'}) {		# Version info
			print "\nThis is MultiMarkdown, version $MultiMarkdown::VERSION.\n";
			print "Original code Copyright 2004 John Gruber\n";
			print "MultiMarkdown changes Copyright 2005-2009 Fletcher Penney\n";
			print "http://fletcherpenney.net/multimarkdown/\n";
			print "http://daringfireball.net/projects/markdown/\n\n";
			exit 0;
		}
		if ($cli_opts{'shortversion'}) {		# Just the version number string.
			print $MultiMarkdown::VERSION;
			exit 0;
		}
		if ($cli_opts{'html4tags'}) {			# Use HTML tag style instead of XHTML
			$opts{empty_element_suffix} = ">";
		}

		#### Process incoming text: ###########################
		my $text;
		{
			local $/;               # Slurp the whole file
			$text = <>;
		}
        print markdown($text, \%opts);
    }
}

__END__

=pod

=head1 NAME

B<MultiMarkdown>


=head1 SYNOPSIS

B<MultiMarkdown.pl> [ B<--html4tags> ] [ B<--version> ] [ B<-shortversion> ]
    [ I<file> ... ]


=head1 DESCRIPTION

MultiMarkdown is an extended version of Markdown. See the website for more
information.

	http://fletcherpenney.net/multimarkdown/

Markdown is a text-to-HTML filter; it translates an easy-to-read /
easy-to-write structured text format into HTML. Markdown's text format
is most similar to that of plain text email, and supports features such
as headers, *emphasis*, code blocks, blockquotes, and links.

Markdown's syntax is designed not as a generic markup language, but
specifically to serve as a front-end to (X)HTML. You can  use span-level
HTML tags anywhere in a Markdown document, and you can use block level
HTML tags (like <div> and <table> as well).

For more information about Markdown's syntax, see:

    http://daringfireball.net/projects/markdown/


=head1 OPTIONS

Use "--" to end switch parsing. For example, to open a file named "-z", use:

	Markdown.pl -- -z

=over 4


=item B<--html4tags>

Use HTML 4 style for empty element tags, e.g.:

    <br>

instead of Markdown's default XHTML style tags, e.g.:

    <br />


=item B<-v>, B<--version>

Display Markdown's version number and copyright information.


=item B<-s>, B<--shortversion>

Display the short-form version number.


=back



=head1 BUGS

To file bug reports or feature requests (other than topics listed in the
Caveats section above) please send email to:

    support@daringfireball.net (for Markdown issues)
    
    owner@fletcherpenney.net (for MultiMarkdown issues)

Please include with your report: (1) the example input; (2) the output
you expected; (3) the output (Multi)Markdown actually produced.


=head1 AUTHOR

    John Gruber
    http://daringfireball.net/

    PHP port and other contributions by Michel Fortin
    http://michelf.com/

    MultiMarkdown changes by Fletcher Penney
    http://fletcherpenney.net/

=head1 COPYRIGHT AND LICENSE

Original Markdown Code Copyright (c) 2003-2007 John Gruber   
<http://daringfireball.net/>   
All rights reserved.

MultiMarkdown changes Copyright (c) 2005-2009 Fletcher T. Penney   
<http://fletcherpenney.net/>   
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

* Neither the name "Markdown" nor the names of its contributors may
  be used to endorse or promote products derived from this software
  without specific prior written permission.

This software is provided by the copyright holders and contributors "as
is" and any express or implied warranties, including, but not limited
to, the implied warranties of merchantability and fitness for a
particular purpose are disclaimed. In no event shall the copyright owner
or contributors be liable for any direct, indirect, incidental, special,
exemplary, or consequential damages (including, but not limited to,
procurement of substitute goods or services; loss of use, data, or
profits; or business interruption) however caused and on any theory of
liability, whether in contract, strict liability, or tort (including
negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.

=cut
