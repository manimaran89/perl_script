 use strict;
 use warnings;
 use Infoblox;

 if(@ARGV < 2) {
   print "Usage : $0 Master-VIP Member-Hostname\n";
   exit 1; 
 }

 my $host_ip   = $ARGV[0];
 my $host_name = $ARGV[1];
 
 my $session = Infoblox::Session->new(
     master   => $host_ip,
     username => "admin",
     password => "infoblox"
 );

 unless ($session) {
     die(qq(constructor for session failed: ),
         join(":", Infoblox::status_code(), Infoblox::status_detail()));
 }
 print "Session created successfully \n";

 my $object = $session->get(
     object => "Infoblox::Grid::Member::DHCP",
     name   => $host_name
 );

  unless ($object) {
       die("get member DHCP failed: ",
       $session->status_code() . ":" . $session->status_detail());
   }
  print "member DHCP get successfull\n";

 if($object->enable_dhcp() eq "false") {
        $object->enable_dhcp("true");
 }
 
 $session->modify($object)
   or die("modify member DHCP failed: ",
       $session->status_code() . ":" . $session->status_detail());
 print "DHCP member object modified successfully \n";

 $session->restart(force_restart => "true");
 sleep 45;
