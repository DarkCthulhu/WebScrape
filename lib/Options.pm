#!/usr/bin/perl
package Options;
use Moose;
with 'MooseX::Getopt::Usage';

has 'url'       => (
    is              => 'rw', 
    isa             => 'Str', 
    required        => 1, 
    documentation   => qq{Which URL to start from},
);

has 'depth'     => (
    is              => 'rw', 
    isa             => 'Int', 
    required        => 0, 
    default         => 1, 
    documentation   => qq{Number of levels to traverse},
);

has 'filetype'  => (
    is              => 'rw', 
    isa             => 'ArrayRef', 
    required        => 1, 
    default         => sub { [''] },
    documentation   => qq{Files to download (This option can occur multiple times)},
);

has 'outdir'    => (
    is              => 'rw', 
    isa             => 'Str', 
    required        => 0,
    default         => '.', 
    documentation   => qq{Output Directory},
);
1;
