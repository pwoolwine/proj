#!/usr/bin/perl -w
#reads the header and sequence of a multi fasta file. Blasts both nt and aa sequence with ncbi.

use warnings;
use strict;
use Bio::Perl;

my $fasta_file = shift || die "USAGE: pass me a FASTA file on the command line";

open(my $ifh, $fasta_file) || die "ERROR: can't read input FASTA file: $!";

#arrays for custom header info
my $seq = "";
my @seq_array;
my @header;
my $i = 0;
my $prot;
my $strSeq;


while ( my $line = <$ifh> ) {
	if($line =~ /^\#/ || $line =~ /^\>/) {
		
		$header[$i] = $line;
		$seq = ""; 
		$i++;
		next; }
	
## take all whitespace out of the line
$line =~ s/\s//g;
## add the line to the sequence
$seq .= $line;
##	
$seq_array[$i-1] = $seq;
	
}



my $select = 0;
while ($select != -1) {

my $j = 1;
print "\nThese are the sequences in the fasta: \n";
foreach my $item (@header) {print $j,": ", $item, "\n"; $j++ ;}

print "\nEnter the number of the desired Fasta Sequence to Blast (Press 0 to quit): ";
$select = <STDIN>;
chomp $select;

   if ($select == 0) { last;}
$select = $select-1;
#print $seq_array[$select], "\n";


$prot = translate( $seq_array[$select] );
#print $prot->seq();

my $blastp = blast_sequence( $prot );
my $blastn = blast_sequence( $seq_array[$select] );

my $filep = './blast_outputp';
write_blast( ">$filep" , $blastp );

my $filen = './blast_outputn';
write_blast( ">$filen" , $blastn );

print "\nBLAST results written to files blast_outputp and blast_outputn\n";

}



