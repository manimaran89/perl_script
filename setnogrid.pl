#!/usr/bin/perl
 my $server = shift;
 my $result = system("expect setnogrid.exp $server > setnogrid.out");
 my $result1 = `grep "Disconnect NOW if you have not been expressly authorized to use this system." < resetdb.out`;
 system ("cat setnogrid.out");
 if ($result1 eq "")
 {
    print  "\nreset grid operation is not completed successfully!!!";
 }
 else

 {
  print  "\nreset grid operation is completed successfully!!!";
 }
