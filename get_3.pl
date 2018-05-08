 use strict;
 use Infoblox;
 use Data::Dumper;
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => shift,
     username => "admin",
     password => "infoblox"
 );
 unless ($session) {
    die("Construct session failed: ",
        Infoblox::status_code() . ":" . Infoblox::status_detail());
 }
# print "Session created successfully\n";
my $audit1 = Infoblox::DNS::Member::SoaMname->new(
      'ms_server' => '10.102.30.200',
      #'dns_mname' => 'SERE',
      'mname' => 'SERE',
);
my @result_array = $session->get(
     object => "Infoblox::DNS::Zone",
     name   => "10.in-addr.arpa"
 );

my $for_obj = $result_array[0];


$for_obj->member_soa_mnames([$audit1]);
$session->modify($result_array[0])
         or die("Update DNS Properties has failed: ",
                $session->status_code(). ":" .$session->status_detail());
print "DNS Properties updated successfully.\n";

 # print Dumper $object;
 # =cut
