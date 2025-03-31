#!/usr/bin/perl
#Script to complete input file for OOFEM

my $scale = 1;

my $nNodes;

my $nodeNumber = 0;
my @x, @y, @z;

my $R = 2.54;

my @xNew, @yNew, @zNew;

my $inputFile = $ARGV[0];
open(FILEIN, "<$inputFile") || die "Could not open file $inputFile. Should be the oofem input file.\n";

my $nNodes = 0;

while($line = <FILEIN>) { 

    if ($line =~ /ndofman\s+(\d+)/) {
     	$nNodes = $1;
     }

    if ($line =~ /coords\s+\d+\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)/) {
	($x[$nodeNumber], $y[$nodeNumber], $z[$nodeNumber]) = ($1, $2, $3);
	$nodeNumber++;
    }
}

print "$nodeNumber\n";

close(FILEIN);

my $dataFile = $ARGV[1];
open(FILEDAT, "<$dataFile") || die "Could not open file $dataFile. Should be the data file.\n";

my $nLines = 0;
my $i,$k;
my @allDisp;
my @xDisp;
my @yDisp;
my @zDisp;


while($line = <FILEDAT>) {
    @allDisp = split(/\s+/, $line);


    if (scalar(@allDisp) <= 3 * $nNodes) {
	die "Error: Data file does not have expected columns. Expected at least " . (3 * $nNodes) . " values, got " . scalar(@allDisp) . " on line $nLines.\n";
    }


    for ($i=0; $i<$nNodes;$i++){
	$xDisp[$nLines][$i] = $allDisp[1+$i];
	$yDisp[$nLines][$i] = $allDisp[1+$i+$nNodes];
	$zDisp[$nLines][$i] = $allDisp[1+$i+2*$nNodes];	
    }
    $nLines++;
}

print "$nLines";

close(FILEDAT);

#PrintOutput
#First the undeformed mesh
open(FILEOUT, ">outputStep0.dat") || die "Could not open file outputStep0.dat\n";
for($i=0;$i<$nNodes;$i++){
     printf FILEOUT "%.5f %.5f %.5f\n", $x[$i]-$R, $y[$i], $z[$i];    
}
close(FILEOUT);

#Now for the deformations
for($k=0;$k<$nLines;$k++){
    $help = $k+1;
    open(FILEOUT, ">outputStep$help.dat") || die "Could not open file outputStep$help.dat\n";
    for($i=0;$i<$nNodes;$i++){
	$xNew[$i] = $x[$i] + $scale*$xDisp[$k][$i];
	$yNew[$i] = $y[$i] + $scale*$yDisp[$k][$i];
	$zNew[$i] = $z[$i] + $scale*$zDisp[$k][$i];
    printf FILEOUT "%.5f %.5f  %.5f\n", $xNew[$i]-$R, $yNew[$i], $zNew[$i];    
    }
    close(FILEOUT);
}
