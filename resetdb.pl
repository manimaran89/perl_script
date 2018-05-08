#!/usr/bin/perl
 my $server = shift;
 my $result = system("expect resetdatabase.exp $server > resetdb.out");
 my $result1 = `grep "RESETTING THE DATABASE" < resetdb.out`;
 system ("cat resetdb.out");
 if ($result1 eq "")
 {
    print  "\nreset database operation is not completed successfully!!!";
 }
 else

 {
  print  "\nreset database operation is completed successfully!!!";
 }
