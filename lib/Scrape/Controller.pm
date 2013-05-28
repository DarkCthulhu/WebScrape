#!/usr/bin/perl
package Controller;

use MooseX::Singleton; #singleton class
use Scrape::Page;
use Debug;

has url	=> (
	is       	=> 'ro',
	isa      	=> 'Str',
	reader	 	=> 'get_url',
    required   	=>  1,
);

has max_depth	=> (
	is       	=> 'ro',
	isa      	=> 'Int',
	reader	 	=> 'get_max_depth',
    default   	=> 0,
);

has out_dir	=> (
	is       	=> 'ro',
	isa      	=> 'Str',
	reader	 	=> 'get_out_dir',
    default   	=> '.',
);

has file_types => (
    is          => 'ro',
    isa         => 'ArrayRef[Str]',
    reader      => 'get_regexes',
    required    => 1,
);

sub BUILD{
    my $self = shift;
    # kick-off the process of processing pages
    $self->add_page($self->get_url, 1); # depth is currently 1
}

sub add_page{
	my ($self, $url, $depth) = @_;
    if($depth <= $self->get_max_depth()){
        Debug::TRACE("Controller: Fetching $url");     
        my $page = new Page(url => $url, depth => $depth);   
    }
}
1;
