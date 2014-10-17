
use Switch;

$file = $ARGV[0];

open($fid, $file) or die("can not open file '$file'\n");

while (<$fid>)
{
	chomp;
	$line = $_;
	
	if (!($line =~ /^#/))
	{
		if (!($line =~ /^$/))
		{
			@arr = split(/,/, $line);
			
			$id = @arr[0];
			
			switch ($id)
			{
				case "rr"
				{
					$r1 = $arr[1];
					$r2 = $arr[2];
					$p1 = $arr[3];
					$p2 = $arr[4];
					
					print "assign rx_data[$r2][$p2] = tx_data[$r1][$p1];\n";
					print "assign tx_busy[$r1][$p1] = rx_busy[$r2][$p2];\n";
					print "\n";
				}
				case "sr"
				{
					$s = @arr[1];
					$r = @arr[2];
					$p = @arr[3];
					print "assign rx_data[$r][$p] = source_data[$s];\n";
					print "assign source_busy[$s] = rx_busy[$r][$p];\n";
					print "\n";
				}
				case "rs"
				{
					$r = @arr[1];
					$p = @arr[2];
					$s = @arr[3];
					print "assign sink_data[$s] = tx_data[$r][$p];\n";
					print "assign tx_busy[$r][$p] = sink_busy[$s];\n";
					print "\n";
				}
				case "tx"
				{
					$r = @arr[1];
					$p = @arr[2];
					print "assign tx_busy[$r][$p] = 0;\n";				
				}
				case "rx"
				{
					$r = @arr[1];
					$p = @arr[2];
					print "assign rx_data[$r][$p] = 0;\n";
				}
				else
				{
					die("** syntax error in file '$file' **\n");
				}
			}
				
			
			
		}
	}
}

close($fid);

