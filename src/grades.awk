#!/bin/awk -f 


function grades(grade)
{
    if (grade >= 98) return "A+";
    else if (grade >= 90) return "A";
    else if (grade >= 85) return "A-";
    else if (grade >= 80) return "B+";
    else if (grade >= 75) return "B";
    else if (grade >= 70) return "B-";
    else if (grade >= 65) return "C+";
    else if (grade >= 60) return "C";
    else if (grade >= 55) return "C-";
    else if (grade >= 50) return "D+";
    else if (grade >= 45) return "D";
    else return "F";

}



BEGIN{
    print "NAME \t \t GRADE \t \t Letter" 
    print "=========================================" 
}

{

    print $1 "\t" "\t" $2 "\t" "\t" grades($2)
    sum=sum+$2
    counter++ 

}


END {
    average=sum/counter
    print "Average \t" average "\t" "\t" grades(average)

}