# yypdb
## Command line PDB query and access

---

<p align="center">
<img src='logo.png' width=300px>
</p>

### Features

Search the PDB for molecular, methodological, genomic, chemical,
strucutral, ontological, and taxonomical information using site-side REST search
services and XML query. See usage for instructions (--help).  

### Usage
```
YYPDB

FETCH SERVICES:
usage: yypdb [flags] [str]

  --vb                         verbose mode
  --molid [PDBID]              get molecule info
  --header [PDBID]             get header info
  --seq [PDBID.A.B.C ...]      get amino acid sequence for each chain
  --lig [PDBID]                get ligand info
  --go [PDBID]                 get gene associated ontology info
  --grab [PDBID]               save pbd file to local directory

SEARCH SERVICES:
usage: yypdb [optional verbose] --search [search type] [params]

  --vb                         verbose mode
  title [str]		       search PDBIDs by title
  author [str]		       search PDBIDs by citation author
  organism [str]               search PDBIDs by associated organism
  seqMotif --motif [str]       search PDBIDs by sequence filter
  revisionDate --min [y-m-d] --max [y-m-d]
			       search PDBIDs by revision dates
  releaseDate --min [y-m-d] --max [y-m-d]
			       search PDBIDs by release dates

  macromolecu:wle --protein [y/n] --DNA [y/n] --RNA [y/n]
    --hybrid [y/n]             serach PDBIDs by macromolecule type

  chainNum --assembly [asymmetric/biological]
    --min [min] --max [max]    search PDBIDs by number of chains

  entNum --min [min] --max [max]    search PDBIDs by entity number
  binding --min [min] --max[max]    search PDBIDS by ki binding affinity
  chemName --name [str] --target [str] --polymerType [str]
		                    search PDBIDs by chemical subcomponent
```
### Aside (Please Read)

Why Perl? I like Perl. And first/foremost this is meant to a commandline tool. Whether it is used
to simply retrieve information from the PDB without leaving the terminal,
log information to file, or it plays a role in a chain of UNIX tools or
scripts, I hope that it finds some use.

The PDB and and some of the third party resources it may use are for public
use. Please avoid spamming XML requests or making unduly large requests.
Continued behaviors such as this will prompt your requests to moved to a
slower access lane or outright blocked for a temporary time. Please respect the
use of these generous libraries. Enjoy! 

### Dependencies

* Perl 5
* wget
* LibXML


