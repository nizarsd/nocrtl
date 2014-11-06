# the constants below must match those defined in constans.v

$NORTH	=	0;
$EAST	=	1;
$SOUTH	=	2;
$WEST	=	3;
$LOCAL	=	4;

$w	=	3;
$h	=	3;
$s	=	0;
open ($fid, ">rt.txt");

for ($j=0; $j<$h; $j++)
{
	for ($i=0; $i<$w; $i++)
	{
	
		$s 	= 	$j * $w + $i;
		
# 		print "$s\n";

	print $fid "if (NODE_ID == $s) begin \n";

		for ($y=0; $y<$h; $y++)
		{
			for ($x=0; $x<$w; $x++)
			{
				$d = $y * $w + $x;
				#print "$d = $x,$y ";
				if ($d == $s)
				{
					print $fid "	mem[$d] <= $LOCAL;\n";
				}
				elsif ($x == $i)
				{
					if ($y>$j)
					{
						print $fid "	mem[$d] <= $SOUTH;\n";
					}
					else
					{
						print $fid "	mem[$d] <= $NORTH;\n";
					}	
				}
				else
				{
					if ($x>$i)
					{
						print $fid "	mem[$d] <= $EAST;\n";
					}
					else
					{
						print $fid "	mem[$d] <= $WEST;\n";
					}
				}
			}
		}

# 		close ($fid);
	print $fid "end	 \nelse ";

	}
}
