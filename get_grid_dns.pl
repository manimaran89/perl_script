 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => "10.35.133.4",
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "Session created successfully\n";
 my $object = $session->get(
     object => "Infoblox::Grid::DNS",
     name   => "ib-10-34-98-22.infoblox.com"
 );

  unless ($object) {
       die("get Grid DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());
   }
  print "Grid DNS get  successfull\n";
  #print Dumper $object;
   my $sort1 = Infoblox::DNS::Sortlist->new(
     match_list      => ["10.20.1.0/24", "10.20.2.0/24"],
     source_ipv4addr => "1.2.3.4"
 );

 unless($sort1) {
      die("Construct sort list failed: ",
            Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
 print "First sort list object (IPv4) created successfully\n";

  		
=cc
  $object->use_lan_ipv6_port("false");
  #Apply the changes
  $session->modify($object)
   or die("modify member DNS failed: ",
       $session->status_code() . ":" . $session->status_detail());

   print "DNS member object modified successfully \n";
  print Dumper $object;
  =cut
