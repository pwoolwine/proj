#!/usr/bin/perl -w
#prompts the user for an accession number, does a BLAST search of the corresponding sequence, 
#retrieves the top non-self hit, does a BLAST search with that, and prints out information 
#(accession, GI, name, species, etc.) from the top non-self hit of the second BLAST search.
#Indicates if the top non-self hit from the second search is the same as the original sequence.
#needs bio root exception handling
#needs result object parsing (versus old style perl data parsing)

use warnings;
use strict;
use Bio::Perl;
use Bio::Seq;
use Bio::DB::GenBank;

#my $accession_num = 'NM_201559.2';
my $accession_num;
my $gene_acc;
my $seq;

my $header;
my @header_split;
my $i = 0;
my $j = 0;

print "\nPlease enter an accession number: ";
$accession_num = <STDIN>;
chomp($accession_num);

print "\nOriginal acc to BLAST: ",$accession_num,"\n";

my $gb_dbh = Bio::DB::GenBank->new( -format => 'fasta' );

my $seq_obj = $gb_dbh->get_Seq_by_acc( $accession_num );
#need to add bio root exception handling here

my $report_obj = blast_sequence( $seq_obj->seq() );
my $file = './blast_output';
write_blast( ">$file" , $report_obj );


open(my $ifh, $file) || die "ERROR: can't read input FASTA file: $!";

OUTER:
while ( my $line = <$ifh> ) {
	if($line =~ /^\#/ || $line =~ /^\>/) {
		
	$header = $line;
		
	#parses each section of header
	@header_split = split /\|/,$header;

	$gene_acc = $header_split[1];
					
	if ( $gene_acc eq $accession_num ) {
		#print $gene_acc, $accession_num;
		next;
	} else { 
		
		print "\nTop non-self hit is: ", $gene_acc, "\n";
		$seq = $gb_dbh->get_Seq_by_acc( $gene_acc );
		$report_obj = blast_sequence( $seq->seq() );
		my $file = './blast_output2';
		write_blast( ">$file" , $report_obj );

		open(my $ifh, $file) || die "ERROR: can't read input FASTA file: $!";


		while ( my $line = <$ifh> ) {
			
			if($line =~ /^\#/ || $line =~ /^\>/) {
			
			$header = $line;
			print "\n", $header,"\n";
			#parses each section of header
			@header_split = split /\|/,$header;

			$gene_acc = $header_split[1];
					
			if ( $gene_acc eq $accession_num ) {
				print "The blasted sequence matches the original acc ", $accession_num, "\n";
			}	
			
			last OUTER;
			
			}
			}
	}

	next;
	}

}



