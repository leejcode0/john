#!/usr/bin/perl


use strict;
use warnings;
use Getopt::Std;

# Handle command line arguments
my %opts;
getopts('t', \%opts) or usage();
usage() if @ARGV != 1;

my $filename = $ARGV[0];
my $use_12hr = $opts{t};

# Read and parse the data file
my ($stops, $times) = parse_bus_file($filename);

# Generate and print the timetable
print_timetable($stops, $times, $use_12hr);

# Subroutines
sub parse_bus_file {
    my $filename = shift;
    
    open(my $fh, '<', $filename) or die "Cannot open file: $!\n";
    
    # Read stops (first line)
    my $first_line = <$fh>;
    chomp($first_line);
    my @stops = split /:/, $first_line;
    @stops = map { s/^\s+|\s+$//gr } @stops; # Trim whitespace
    
    # Read times (remaining lines)
    my @times;
    while (<$fh>) {
        chomp;
        push @times, [split /:/];
    }
    close $fh;
    
    return (\@stops, \@times);
}

sub print_timetable {
    my ($stops, $times, $use_12hr) = @_;
    
    # Calculate maximum stop name length for alignment
    my $max_stop_len = 0;
    foreach my $stop (@$stops) {
        $max_stop_len = length($stop) if length($stop) > $max_stop_len;
    }
    $max_stop_len += 2; # Add some padding
    
    # Print each stop's times
    foreach my $stop_idx (0..$#$stops) {
        my $stop = $stops->[$stop_idx];
        printf "%-*s", $max_stop_len, $stop;
        
        foreach my $time_row (@$times) {
            my $time = $time_row->[$stop_idx] // '';
            print format_time($time, $use_12hr, 7), " ";
        }
        print "\n";
    }
}

sub format_time {
    my ($time, $convert, $width) = @_;
    
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
        
        return sprintf("%2d:%02d%s", $hour, $min, $ampm);
    } else {
        $time =~ s/(\d{2})(\d{2})/$1:$2/;
        return sprintf("%5s", $time);
    }
}

sub usage {
    print <<"USAGE";
Usage:
perl bus_timetable.pl file
perl bus_timetable.pl -t file

where:
-t: displays times in 12-hour format with AM/PM

File format: First line contains stop names separated by colons.
Subsequent lines contain arrival times in HHMM format, colon-separated.
USAGE
    exit;
}