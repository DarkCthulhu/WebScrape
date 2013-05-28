#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use Scrape::Controller;
use Debug;
use Options;

sub main{
	my $options = Options->new_with_options(); #contains all options in hash-ref
	my $pc = Controller->initialize(
					url			=> $options->{'url'},
					file_types 	=> $options->{'filetype'}, 
					out_dir		=> $options->{'outdir'},
					max_depth	=> $options->{'depth'},
				);
}
main();


