#!/usr/bin/perl
 my $server = shift;
 my $result = system("expect resetlicense.exp $server > resetdb.out");
 my $result1 = `grep "RESETTING THE SYSTEM" < resetdb.out`;
 system ("cat resetdb.out");
 if ($result1 eq "")
 {
    print  "\nreset license operation is not completed successfully!!!";
 }
 else

 {
  print  "\nreset license operation is completed successfully!!!";
 }

