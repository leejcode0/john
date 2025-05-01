#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use List::Util qw(first);

# Handle command line arguments
my %opts;
getopts('t', \%opts) or usage();
usage() if @ARGV != 1;

my $filename = $ARGV[0];
my $use_12hr = $opts{t};

# Read the data file
open(my $fh, '<', $filename) or die "Cannot open file: $!\n";

# Read and clean stop names
my $first_line = <$fh>;
$first_line =~ s/\r?\n//;  # Handle both Unix and Windows line endings
my @stops = map { s/^\s+|\s+$//gr } split /:/, $first_line;

# Read and clean time data
my @times;
while (<$fh>) {
    s/\r?\n//;  # Clean line endings
    next if /^\s*$/;  # Skip empty lines
    push @times, [split /:/];
}
close $fh;

# Get user input for stops
my ($stop1, $stop2);
my @invalid;

do {
    @invalid = ();
    
    print "What is your first stop?\n";
    $stop1 = <STDIN>;
    chomp($stop1);
    $stop1 =~ s/^\s+|\s+$//g;  # Trim whitespace
    
    print "What is your destination?\n";
    $stop2 = <STDIN>;
    chomp($stop2);
    $stop2 =~ s/^\s+|\s+$//g;
    
    # Check if stops exist (case-insensitive)
    push @invalid, $stop1 unless first { lc($_) eq lc($stop1) } @stops;
    push @invalid, $stop2 unless first { lc($_) eq lc($stop2) } @stops;
    
    if (@invalid) {
        print "Invalid stop: $_\n" for @invalid;
    }
} while (@invalid);

# Find indices of the stops
my $index1 = first { lc($stops[$_]) eq lc($stop1) } 0..$#stops;
my $index2 = first { lc($stops[$_]) eq lc($stop2) } 0..$#stops;

die "Error: Stop indices not found" unless defined $index1 && defined $index2;

# Display the schedule
print "\nThe travel times between $stop1 and $stop2 are:\n";
printf "%-15s %-15s\n", $stop1, $stop2;

foreach my $time_row (@times) {
    my $time1 = $time_row->[$index1] // '';
    my $time2 = $time_row->[$index2] // '';
    
    printf "%-15s %-15s\n",
        format_time($time1, $use_12hr),
        format_time($time2, $use_12hr);
}

sub format_time {
    my ($time, $convert) = @_;
    
    return '----' unless $time && $time =~ /\S/;
    
    if ($convert) {
        my ($hour, $min) = $time =~ /(\d{2})(\d{2})/;
        return '----' unless defined $hour && defined $min;
        
        my $ampm = 'AM';
        if ($hour >= 12) {
            $ampm = 'PM';
            $hour -= 12 if $hour > 12;
        }
        $hour = 12 if $hour == 0;
        
        return "$hour:$min $ampm";
    } else {
        $time =~ s/(\d{2})(\d{2})/$1:$2/;
        return $time;
    }
}

sub usage {
    print <<"USAGE";
Usage:
perl bus_schedule.pl file
perl bus_schedule.pl -t file

where:
-t: for displaying times in 12 hours format

File format: the first line contains the names of each stop on the route, separated by colons; subsequent lines contain the times, using a 24 hour clock.
USAGE
    exit;
}




