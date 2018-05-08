#!/usr/bin/perl
 my $server = shift;
 my $license_name =shift;
 my $result = system("expect setlicense.exp $server > setlicense.out");
 my $result1 = `grep "Disconnect NOW if you have not been expressly authorized to use this system." < resetdb.out`;
 system ("cat setlicense.out");
 if ($result1 eq "")
 {
    print  "\nLicense Installed Successfully";
 }
 else

 {
  print  "\nLicense Not Installed successfully!!!";
 }
