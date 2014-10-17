# the constants below must match those defined in constans.v

$NORTH	=	0;
$EAST	=	1;
$SOUTH	=	2;
$WEST	=	3;
$LOCAL	=	4;

$w	=	4;
$h	=	4;


for ($j=0; $j<$h; $j++)
{
	for ($i=0; $i<$w; $i++)
	{
	
		$s 	= 	$j * $w + $i;
		
		print "$s\n";

		open ($fid, ">$s.txt");

		for ($y=0; $y<$h; $y++)
		{
			for ($x=0; $x<$w; $x++)
			{
				$d = $y * $w + $x;
				#print "$d = $x,$y ";
				if ($d == $s)
				{
					print $fid "$LOCAL\n";
				}
				elsif ($x == $i)
				{
					if ($y>$j)
					{
						print $fid "$SOUTH\n";
					}
					else
					{
						print $fid "$NORTH\n";
					}	
				}
				else
				{
					if ($x>$i)
					{
						print $fid "$EAST\n";
					}
					else
					{
						print $fid "$WEST\n";
					}
				}
			}
		}

		close ($fid);

	}
}
