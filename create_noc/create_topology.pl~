

$w=3;
$h=3;

$north = 0;
$east  = 1;
$south = 2;
$west  = 3;
$local = 4;



for ($y=0; $y<$h; $y++)
{
	for ($x=0; $x<$w-1; $x++)
	{
		$r1 = getrouterid($x,$y);
		$r2 = getrouterid($x+1,$y);
		#print "router $r1 east -> router $r2 west\n";
		print "# horizontal channels between routers $r1 and $r2\n";
		print "rr,$r1,$r2,$east,$west\n";
		print "rr,$r2,$r1,$west,$east\n";
		#print "router $r1 east <- router $r2 west\n";
	}
}

for ($y=0; $y<$h-1; $y++)
{
	for ($x=0; $x<$w; $x++)
	{
		$r1 = getrouterid($x,$y);
		$r2 = getrouterid($x,$y+1);
		print "# vertical channels between routers $r1 and $r2\n";
		print "rr,$r1,$r2,$south,$north\n";
		print "rr,$r2,$r1,$north,$south\n";
		#print "router $r1 south -> router $r2 north\n";
		#print "router $r1 south <- router $r2 north\n";
	}
}

for ($x=0; $x<$w; $x++)
{
	$r1 = getrouterid($x,0);
	#print "router $r1 north -> terminator\n";
	print "# north terminator\n";
	print "tx,$r1,$north\n";
	print "rx,$r1,$north\n";
	$r1 = getrouterid($x,$h-1);
	#print "router $r1 south -> terminator\n";
	print "# south terminator\n";
	print "tx,$r1,$south\n";
	print "rx,$r1,$south\n";
}

for ($y=0; $y<$h; $y++)
{
	$r1 = getrouterid(0,$y);
	#print "router $r1 west -> terminator\n";
	print "# west terminator\n";
	print "tx,$r1,$west\n";
	print "rx,$r1,$west\n";
	$r1 = getrouterid($w-1,$y);
	#print "router $r1 east -> terminator\n";
	print "# east terminator\n";
	print "tx,$r1,$east\n";
	print "rx,$r1,$east\n";	
}

for ($i=0; $i<$h * $w; $i++)
{
	#print "router $i local -> sink\n";
	#print "router $i local <- source\n";

	print "#source\n";
	print "sr,$i,$i,$local\n";
	
	print "#sink\n";
	print "rs,$i,$local,$i\n";

}

sub getrouterid
{
	$w * $_[1] + $_[0];
}
