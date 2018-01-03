#! /usr/bin/perl -w
use strict;
use autodie;
#use warnings;
no warnings 'uninitialized';	
use LWP::Simple qw( $ua );
use XML::LibXML;

our $mol_url = "https://www.rcsb.org/pdb/rest/describeMol?structureId=";
our $pdb_url = "https://www.rcsb.org/pdb/rest/describePDB?structureId=";
our $chem_url = "https://www.rcsb.org/pdb/rest/describeHet?chemicalID=";
our $smiles_url = "https://www.rcsb.org/pdb/rest/smilesQuery?smiles=";
our $ligand_url = "https://www.rcsb.org/pdb/rest/ligandInfo?structureId=";
our $grab_url = "ftp://ftp.wwpdb.org/pub/pdb/data/structures/all/pdb/pdb"; 
our $rest_search ='http://www.rcsb.org/pdb/rest/search/';

sub query_gen {
	my($keyword,$type) = @_;
	my $query = qq(
<?xml version="1.0" encoding="UTF-8"?>
<orgPdbQuery>
	<version>B0905</version>
	<queryType>org.pdb.query.simple.${type}</queryType>
	<description>StructTitleQuery: struct.title.comparator=contains struct.title.value=${keyword}</description>
	<struct.title.comparator>contains</struct.title.comparator>
	<struct.title.value>${keyword}</struct.title.value>
</orgPdbQuery>
);
	return $query;
}

sub id_to_name {
	my($IDs) = @_;
	my @IDlist = split("\n",$IDs);
	foreach my $ID (@IDlist)
	 {
		print "$ID\t";
		my $url = join("","$pdb_url","$ID");
		my $get = `wget -q -O - \"$url\"`; 
		my $xml = XML::LibXML->load_xml(string => $get);
		foreach my $PDB ($xml->findnodes('//PDB'))
		{
			print $PDB->getAttribute('title');
		}
		print "\n";
	}	
}

sub disp_xml {
	my($xml) = @_;
	foreach my $polymer ($xml->findnodes('//polymer'))
	{
		foreach my $synonym ($polymer->findnodes('synonym'))
		{
			print "\nNAME:      ";
			print $synonym->getAttribute('name');
		}
		foreach my $polymerDes ($polymer->findnodes('polymerDescription'))
		{
			print "\nALT NAME:  ";
			print $polymerDes->getAttribute('description');
		}
		foreach my $taxonomy ($polymer->findnodes('Taxonomy'))
		{
			print "\nTAXONOMY:  "; 
			print $taxonomy->getAttribute('name');
		}
		foreach my $chain ($polymer->findnodes('chain'))
		{
			print "\nCHAIN:     ";
			print $chain->getAttribute('id');
		}
		print "\nLENGTH:    ";
		print $polymer->getAttribute('length');
		print "\nTYPE:      ";
		print $polymer->getAttribute('type');
		print "\nWEIGHT:    ";
		print $polymer->getAttribute('weight');
		foreach my $fragment ($polymer->findnodes('fragment'))
		{
			print "\nFRAGMENT:  ";
			print $fragment->getAttribute('desc');	
		}
	}
	
	foreach my $PDB ($xml->findnodes('//PDB'))
	{
		print "\nTITLE:      ";
		print $PDB->getAttribute('title');
		print "\nMETHOD:     ";
		print $PDB->getAttribute('expMethod');
		print "\nRESOLUTION: ";
		print $PDB->getAttribute('resolution');
		print "\nKEYWORDS:   ";
		print $PDB->getAttribute('keywords');
		print "\nENTITIES:   ";
		print $PDB->getAttribute('nr_entities');
		print "\nRESIDUES:   ";
		print $PDB->getAttribute('nr_residues');
		print "\nATOMS:      ";	
		print $PDB->getAttribute('nr_atoms');
		print "\nAUTHORS:    ";
		print $PDB->getAttribute('citation_authors');
		print "\nDEP DATE:   ";
		print $PDB->getAttribute('deposition_date');
	}	
}

if (not @ARGV  or grep(/--help/,@ARGV))
{
    print "\n => YYPDB \n";
    print "\n usage: yypdb [opts] [str]\n";
    print "\n\t--molid [PDBID]       get molecule info";
	print "\n\t--header [PDBID]      get header info";
	print "\n\t--grab [PDBID]        save pbd file to local directory";
    print "\n\t--idsearch [keyword]  search PDBIDs using keyword";
	print "\n";
    exit;
}

my $keyword = "$ARGV[$#ARGV]";

if (grep(/\-\-molid/, @ARGV))
{
	print "\n>>> Fetching Molecule Info for ID $keyword...\n";
	my $url = join("","$mol_url","$keyword");
	my $get = `wget -q -O - \"$url\"`; 
	#print $get;
	my $xmlget = XML::LibXML->load_xml(string => $get);
	disp_xml($xmlget);
	print "\n";
}
if (grep(/\-\-header/, @ARGV))
{
	print "\n>>> Fetching PDB Info for ID $keyword...\n";
	my $url = join("","$pdb_url","$keyword");
	my $get = `wget -q -O - \"$url\"`;
#	print $get;
	my $xmlget = XML::LibXML->load_xml(string => $get);
	disp_xml($xmlget);
	print "\n";
}
if (grep(/\-\-grab/, @ARGV))
{
	print "\n>>> Saving PDB $keyword to local directory...\n";
	my $url = join("","$grab_url","$keyword",".ent.gz");
	my $get = `wget -q \"$url\"`;
}
if (grep(/\-\-idsearch/, @ARGV)) 
{
	print "\nSearching PDBIDs for $keyword...";
	print "\nThis may take a few seconds...\n\n";
	my $query = query_gen(${keyword},"StructTitleQuery"); 
	my $request = HTTP::Request->new( POST => ${rest_search});
	$request->content_type( 'application/x-www-form-urlencoded' );
	$request->content( $query );
	my $response = $ua->request($request);
	#print $response->content;
	id_to_name($response->content);
	print "\n";
}

