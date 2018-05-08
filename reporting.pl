#Create an Infoblox::Session object

 #PROGRAM STARTS: Include all the modules that will be used
 use strict;
 use Infoblox;
 use Data::Dumper;
 my $boolean="true"; 
 #Create a session to the Infoblox appliance
 my $session = Infoblox::Session->new(
     master   => shift,
     username => "admin",
     password => "infoblox"
 );
 if ($session->status_code()) {
    die("Construct session failed: ",
        $session->status_code() . ":" . $session->status_detail());
 }
 print "Session created successfully\n";

print $session->status_detail();
my $audit1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'AUDIT',

);

my $capture1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'DNS_CAPTURE',
);
my $discovery1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'DISCOVERY',
);
my $eco1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'ECOSYSTEM_SUBSCRIPTION',
);
my $security1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'SECURITY',
);
my $dns1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '15',
      'name' => 'DNS',
);
my $dhcp1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '14',
      'name' => 'DHCP',
);
my $ipam1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'IPAM',
);
my $publish1 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'ECOSYSTEM_SUBSCRIPTION',
);

my $sysutil2 = Infoblox::Grid::Reporting::Index->new(
      'max_pct' => '1',
      'name' => 'SYSTEM',
);


print Infoblox->status_detail();
my @result_array = $session->get(
     object => "Infoblox::Grid::Reporting",
 );

my $for_obj = $result_array[0];
$for_obj->cat_audit("true");
$for_obj->cat_dns_scavenging("true");
$for_obj->cat_discovery("true");
$for_obj->cat_dns_query_capture("true");
$for_obj->cat_dhcp_lease("true");
$for_obj->cat_dns_perf("true");
$for_obj->cat_ecosystem_subscription("true");
$for_obj->cat_dhcp_fingerprint("true");
$for_obj->cat_security("true");
$for_obj->cat_dhcp_perf("true");
$for_obj->cat_ddns("true");
$for_obj->cat_ecosystem_publish("true");
$for_obj->cat_ipam("true");
$for_obj->cat_system("true");
$for_obj->cat_dns_query("true");
$for_obj->enabled("true");
$for_obj->indices([$audit1,$capture1,$discovery1,$eco1,$security1,$dns1,$dhcp1,$ipam1,$publish1,$sysutil2]);


 $session->modify($result_array[0])
         or die("Update Grid/Member Reporting Properties has failed: ",
                $session->status_code(). ":" .$session->status_detail());
  print "Grid/Member Reporting Properties updated successfully.\n";

