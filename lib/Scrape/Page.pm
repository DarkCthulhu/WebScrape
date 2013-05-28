#!/usr/bin/perl
package Page;

use Moose;
use LWP::Simple;
use Scrape::Controller;
use Data::Dumper;
require LWP::UserAgent;


# Depth at which the page is, with respect to parent URL
has depth		=> (
	is      	=> 'ro',
	isa     	=> 'Int',
	reader		=> 'get_depth',
	required	=> 1,
);

# Url of the page
has url			=> (
	is	  		=> 'ro',
	isa    		=> 'Str',
	reader 		=> 'get_url',
	required	=> 1,
);

# User-agent
has ua	=> 	(is => 'rw');
has controller => (is => 'rw');

# Called right after construction
sub BUILD {
	# Try to look like a real browser!
	my $self = shift;
	$self->ua(LWP::UserAgent->new);
	$self->ua->timeout(10);
	$self->ua->env_proxy;
	$self->ua->agent('Mozilla/5.0');
	$self->controller(Controller->instance());
	$self->process_page();
}

sub process_page{
	my $self = shift;
	my $response = $self->_get_text($self->get_url);
	$self->_find_matches($response, $self->controller->get_regexes) if defined $response;
	
}

# Given a string and file extension to match, finds all instances of it
sub _find_matches{
	my ($self, $text, $regexes) = @_;
	my @matches;
	foreach my $regex(@$regexes){
		my @match = ($text =~ /$regex/g);
		@matches = (@matches, @match);
	}
	return @matches;
}

# Input: url
# Output: page contents as string
sub _get_text {
	my ($self, $url) = @_;
	my $response = $self->ua->get($url);
	if($response->is_success){
		return $response->decoded_content;
	}else{
		Debug::WARN("Page: Request to $url failed due to error: ", $response->status_line);
		return;
	}
}

# Input: url, directory, name
# Output: None
# Writes file from $url to supplied $dir with name $name. 
sub _download_file {
	my ($self, $url, $dir, $name) = @_;
	my $response = $self->ua->get($url);
	if($response->is_success){
		open(my $fh,'>:raw', File::Spec->catfile($dir, $name));
		print $fh $response->content;
		close($fh);
		return length($response->decoded_content);
	}else{
		warn $response->status_line;
		return -1;
	}
}
1;
