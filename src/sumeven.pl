#!/bin/perl

use strict; 
use warnings;



my $input=0;

print "Input a number above 1 ? \n";
while ($input<2) 
{
$input=<STDIN>;
if ($input<2){
    print "Invalid number please enter greater than 1? \n";

}


} 
my $sum=0;
for (my $num=0; $num<=$input; $num+=2)
{
    $sum+=$num; 
}
print "The sum is $sum \n"