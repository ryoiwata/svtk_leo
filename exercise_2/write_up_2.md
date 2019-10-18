Exercise 2

docker container: gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

# Exercise 2: Check the output of the previous run, you will notice that all variants whose 3rd column starts with "MantaBND" have dissappeared in the output file. This is a bug. Do you best to fix it.
#The relevant code are in /opt/svtk/. Once you found the issue simply edit the code as is. After you fixed the issue, run the following commands
svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.fixed.vcf.gz;
tabix -p vcf manta.SSC11438.fixed.vcf.gz

## Exploring the input file 
- Look up the file type of vcf (variant call files): 
    - https://samtools.github.io/hts-specs/VCFv4.2.pdf
- Look up what contigs are:
    - https://en.wikipedia.org/wiki/Contig 

## Exploring the Functions of SVTK/vcf-sort/tabix
Command Line
- svtk (to see doc string of entire file)
- svtk standardize -h (to see doc string of standarize function)
    - [ Preprocessing ] 
    - standardize    Convert SV calls to a standardized format.

- vcf-sort -h
- tabix -h 

## Source Algorithm (Manta)
 - https://github.com/Illumina/manta/blob/master/docs/userGuide/README.md

## Exploring what's unique about BND (searching for BND in files)
- https://github.com/hall-lab/svtools/issues/104 
- input file:
    - ##INFO=<ID=BND_DEPTH,Number=1,Type=Integer,Description="Read depth at local translocation breakend">
    - ##INFO=<ID=MATE_BND_DEPTH,Number=1,Type=Integer,Description="Read depth at remote translocation mate breakend">
    - ##ALT=<ID=BND,Description="Translocation Breakend">

- example of BND input
    - #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	SSC11438
    - chr1	806391	MantaBND:32:0:1:0:0:0:1	C	C]CHR2:242118516]	825	PASS	BND_DEPTH=212;CIPOS=0,12;HOMLEN=12;HOMSEQ=CATGCACTGCCC;MATEID=MantaBND:32:0:1:0:0:0:0;MATE_BND_DEPTH=189;SVTYPE=BND	GT:FT:GQ:PL:PR:SR	0/0:PASS:212:0,162,999:67,1:56,9

- example of non-BND input

    - chr1	933988	MantaDEL:0:57:57:0:0:0	CGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTCCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCG	CT	999	PASS	CIGAR=1M1I225D;END=934213;SVLEN=-225;SVTYPE=DEL	GT:FT:GQ:PL:PR:SR	1/1:PASS:103:999,106,0:0,3:0,37

    - chr1	998763	MantaINS:0:63:63:0:1:0	GC	GGGGAGGGCGCGGAGCGGAGGGGAGGGCGCGGAGCGGAGGGGAGGGCGCGGAGCGGAGG	999	PASS	CIGAR=1M58I1D;END=998764;SVLEN=58;SVTYPE=INS	GT:FT:GQ:PL:PR:SR	1/1:PASS:41:677,44,0:0,0:0,26

    - chr1	16545311	MantaINV:2435:0:1:0:0:0	C	<INV>	999	MaxDepth	END=16727936;INV3;SVINSLEN=3;SVINSSEQ=CCT;SVLEN=182625;SVTYPE=INV	GT:FT:GQ:PL:PR:SR	0/1:PASS:999:999,0,999:156,0:137,41

    - chr1	1068747	MantaDUP:TANDEM:0:75:75:2:0:0	C	<DUP:TANDEM>	999	PASS	CIEND=0,9;CIPOS=0,9;END=1068825;HOMLEN=9;HOMSEQ=CACGCGGGC;SVLEN=78;SVTYPE=DUP	GT:FT:GQ:PL:PR:SR	0/1:PASS:332:718,0,329:9,1:27,28

- out file:
    - ALT=<ID=BND,Description="Translocation">

    - Filter <BND> is missing 

## Looking through reference materials
- https://samtools.github.io/hts-specs/VCFv4.2.pdf
    - 5.4 Specifying complex rearrangements with breakends

## Seeing which files have svtk standardize in the text
Command Line
- grep -rnw . -e 'svtk standardize'

Files of interest
- ./svtk/cli/standardize_vcf.py

## Seeing which files have BND in the text
Command Line 
- grep -rnw . -e 'BND'

Files of interest
- /svtk/standardize/standardize.py
- /svtk/standardize/std_delly.py
- /svtk/standardize/std_manta.py
- /svtk/standardize/std_lumpy.py
- /svtk/standardize/std_smoove.py


## Seeing which files have VCFStandardizer in the text
- /svtk/cli/standardize_vcf.py >> File that's used when standaridzing 



## Try with a simple file
- with only one BND input
- svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 test.manta.vcf.gz test.SSC11438_unsorted.vcf manta
