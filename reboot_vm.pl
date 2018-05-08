#!/usr/bin/perl
 my $server = shift;
 my $result = system("expect set_reboot.exp $server > setreboot.out");
 my $result1 = `grep "SYSTEM REBOOTING!" < resetdb.out`;
 system ("cat setnogrid.out");
 if ($result1 eq "")
 {
    print  "\nreset grid operation is not completed successfully!!!";
 }
 else

 {
  print  "\nreset grid operation is completed successfully!!!";
 }
