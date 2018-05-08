use strict;
use warnings;
use Infoblox;

my $host_ip   = $ARGV[0] || die "Usage : $0 <Grid_VIP>\n";
my $flag = 0;

# Creates Session
my $session = Infoblox::Session->new(
    master   => $host_ip,
    username => "admin",
    password => "infoblox"
    );
unless ($session) {
    die(qq(constructor for session failed: ),
        join(":", Infoblox::status_code(), Infoblox::status_detail()));
}

# Gets all the IB_4030 Members
my @retrieved_objs = $session->get(
    object       => "Infoblox::Grid::Member::DNS",
    );
# Enable Lan Ipv6 Interface on DNS Member
foreach (@retrieved_objs) {
    if($_->use_lan_ipv6_port() eq "false") {
        $_->use_lan_ipv6_port("true");
        $flag = 1;
    }
    $session->modify($_) or die("Enable Lan Ipv6 Interface failed: ", $session->status_code() . ":" . $session->status_detail());
    print "Enable Lan Ipv6 Interface successfully done on dns member ". "\n";
}

$session->restart(force_restart => "true");
sleep 45 if ($flag == 1);

