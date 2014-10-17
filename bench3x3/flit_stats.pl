
use Switch;
$n=16;
$ydim=4;

$file = $ARGV[0];
$totsent=0;
$totrec=0;
$rec[$n][$n]=0;
$sent[$n][$n]=0;

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
#       print "[$i]->[$j]=$sent[$i][$j]  \n";    
#     }
#   }
#  }
#       print " \n \n";
# 
# for ($j=0; $j < $n; $j++){
#   for ($i=0; $i < $n; $i++) {
#     if ($rec[$i][$j]!=0)
#     {
#       print "[$i]<-[$j]=$rec[$i][$j]  \n";
#     }
#   }
# }
#       print " \n \n";

print "---------------------------\n";
print "total:\n";
print "sent: $totsent, received: $totrec, lost=$lost\n";

close($fid);

