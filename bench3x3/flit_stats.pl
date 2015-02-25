# format assumed
#$display("##,tx,%d,%d",id,dest);
#$display("##,rx,%d,%d",src,id);

use Switch;
$n=9;
$ydim=3;

$file = $ARGV[0];
$totsent=0;
$totrec=0;
$rec[$n][$n]=0;
$sent[$n][$n]=0;
$dlost[$n][$n]=0;
open($fid, $file) or die("can not open file '$file'\n");

while (<$fid>)
{
	chomp; #remove the newline from the end of an input
	$line = $_; #default var
# 	print $_;
	
	#if (!($line =~ /^$/))
	{
		@arr = split(/,/, $line);
		
		$id = @arr[0];
		if ($id=="##")
		{

			switch (@arr[1])
			{
				case "rx"
				{
				  $totrec++;
				  $rec[@arr[2]][@arr[3]]++;
				}
				case "tx"
				{
				  $totsent++;
				  $sent[@arr[2]][@arr[3]]++;
				}
			}
		}
	}
			
}

$lost = $totsent-$totrec;

print "Traffic stats:\n";
# for ($j=0; $j < $n; $j++){
#   for ($i=0; $i < $n; $i++) {
#     if ($sent[$i][$j]!=0)
#     {
#       print "[$j]->[$i]=$sent[$i][$j]  \n";    
#     }
#   }
#  }
#       print " \n \n";
$k=0;
for ($j=0; $j < $n; $j++){
  for ($i=0; $i < $n; $i++) {
    if ($sent[$i][$j]!=0)
    {
    $k++;
      $dlost[$i][$j] = $sent[$i][$j] - $rec[$i][$j];
      print "$k - [$i]->[$j]=$sent[$i][$j], [$i]<-[$j]=$rec[$i][$j], $dlost[$i][$j]\n";
    }
  }
  print " \n";
}
      print " \n \n";

print "---------------------------\n";
print "total:\n";
print "sent: $totsent, received: $totrec, lost=$lost\n";

close($fid);

