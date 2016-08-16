#!/usr/bin/perl -w
# EGQuery  takes a user input as a query and then displays the number of hits to that query  
# in each of the NCBI Entrez databases.
# Note on eutil install from cpan:
# gave error on inc::TestHelper not available
# cpan module in root/.cpan/build/  (Bio-EUtilities-1.73-0)
# edited Makefile.PL to remove reference to require TestHelper
# ran         
#        perl Makefile.PL
#        make
#        make test
#        make install 
# installed fine
#EGquery code modified from http://bioperl.org/howtos/EUtilities_Cookbook_HOWTO.html#item13

use warnings;
use strict;
use CGI ( ':standard' );
use Bio::DB::EUtilities;

#from CGI form user input
#my $term = param( 'term' );
#my $email = param( 'email' );

#for testing
my $term = 'werner';
my $email = 'phillipwoolwine@gmail.com';


my $factory = Bio::DB::EUtilities->new(-eutil => 'egquery',
                                       -email => $email,
                                       -term  => $term );

my $title = 'EGQuery';
  
  print header,
    start_html( $title ),
    h1( $title );
    
while (my $gq = $factory->next_GlobalQuery) {
	print p("Database: ",$gq->get_database),
       	 p("   Count: ",$gq->get_count),
	 p("  Status: ",$gq->get_status),
}

end_html;

