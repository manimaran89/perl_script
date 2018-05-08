#my @dnsViews = ("default.ib1550agridmaster");

#foreach my $view (@dnsViews)
#{
$ar=1;

for ($z=1;$z<=1;$z++)
{
for(my $i=1;$i<=5;$i++)
  {
    for (my $j=0;$j<=4;$j++,$ar++)
      {


           print ("arecord,10.0.$j.$i,,arec$ar.zone$z.com,, this is a demo bind_a record ,FALSE,FALSE,,default.netview1,,,,,,,,,,,,,,,,,,,,,,\n");
        #   print ("aaaarecord,aaaa:1111:bbbb:2222:cccc:3333:dddd:$i,,aaaa$i.zone$z.com,,,FALSE,,default.netview1,,,,,,,,,,,,,,,,,,,,,,,\n");
        #   print ("cnamerecord,cname$i.zone$z.com,,cname$i.zone$z.com,,FALSE,33,default.netview1,,,,,,,,,,,,,,,,,,,,,,,,\n");
        #   print ("mxrecord,mx$i.zone$z.com,,exchanger1.rpz1_1.com,,1,,,FALSE,,default.netview1,,,,,,,,,,,,,,,,,,,,,\n");
        #   print ("txtrecord,txt$i.zone$z.com,,this is text string 1,,,FALSE,,default.netview1,,,,,,,,,,,,,,,,,,,,,,,\n");
      }
  }
}
