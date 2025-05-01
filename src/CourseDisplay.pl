#!/bin/perl
#John Lee
#3168248

use strict; 
use warnings;

sub get_file_handler {
    my ($filename) = @_;
    open(my $fh, '<', $filename) or die "Can't access the specified file: No such file or directory $!\n ";
    return $fh;
}

sub check_in_associativearray {
    my ($str, $hash_ref) = @_;
    return exists $hash_ref->{$str} ? 1 : 0;
}

sub construct_associativearray {
    my ($fh) = @_;
    my %course_data;
    while (my $line = <$fh>) {
        chomp $line;
        my ($student, $course, $grade) = split /:/, $line;
        $course_data{$course}{$student} = $grade;
    }
    return \%course_data;
}

sub view_course_info {
    my ($course, $hash_ref) = @_;
    my %grades = %{ $hash_ref->{$course} };
    my $total = 0;
    my $count = 0;

    print "$course:\n";
    print "--------------------------------\n";
    print "Name\t\tGrade\n";
    print "----\t\t-----\n";

    for my $student (sort keys %grades) {
        my ($score, $max) = split '/', $grades{$student};
        $total += $score;
        $count++;
        print "$student\t$grades{$student}\n";
    }

    my $avg = $count > 0 ? sprintf("%.2f", $total / $count) : 0;
    my $max_grade = (split '/', $grades{(keys %grades)[0]})[1]; 
    print "------------------\n";
    print "AVG\t\t$avg/$max_grade\n";
}

print "Enter file name: ";
my $filename = <STDIN>;
chomp $filename;

my $fh = get_file_handler($filename);
my $course_data = construct_associativearray($fh);
close $fh;

my @courses = sort keys %$course_data;

while (1) {
    print "The file contains the following courses: @courses\n";
    print "Enter the course name (or quit to terminate): ";
    my $input = <STDIN>;
    chomp $input;

    if ($input eq 'quit') {
        print "Have a nice day\n";
        exit;
    }
    elsif (check_in_associativearray($input, $course_data)) {
        view_course_info($input, $course_data);
    }
    else {
        print "Invalid course name\n";
    }
}