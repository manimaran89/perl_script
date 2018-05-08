use strict;
use Infoblox;
use Data::Dumper;

my $host1_ip = $ARGV[0];
my $host1_fqdn = $ARGV[1]; 
my $session = Infoblox::Session->new(
     master   => $host1_ip,
     username => "admin",
     password => "infoblox"
     );
unless($session){
         die("Constructor for session failed: ",
                Infoblox::status_code(). ":" . Infoblox::status_detail());
}

print "Session created successfully.\n";

my @result_array = $session->get(
     object => "Infoblox::Grid::Member",
     name   => $host1_fqdn,
    );

my $for_obj = $result_array[0];

my @result_array1 = $session->get(
     object => "Infoblox::Grid::Member",
     name   => $host1_fqdn,
     );

my $for_obj1 = $result_array1[0];

my %data=(
'force_restart' => 'false',   
'services' => ['ALL']
);

$session->restart(%data);


print $session->status_code();
print $session->status_detail();


