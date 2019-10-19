# Exercise 2: Check the output of the previous run, you will notice that all variants whose 3rd column starts with "MantaBND" have dissappeared in the output file. This is a bug. Do you best to fix it.

## Set up
- operating system: Linux
- docker container: gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777
- relevant code is in /opt/svtk/ of docker image 

## Command to run afterwards
- svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
- vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.fixed.vcf.gz;
- tabix -p vcf manta.SSC11438.fixed.vcf.gz

## Mindset After Initial Input file/Output File Exploration
- Likely the problem is related to: 
    - how the input file formats datapoints with the "BND" SVTYPE
    - how datapoints with the "BND" SVTYPE are being processed
    - datapoints are being filtered out at somepoint
- Rationale:
    - No errors are raised when running the program
    - Datapoints that are not "BND" SVTYPE are being properly processed
- Focus:
    - code that involves processing of "BND" datapoints
        - Look for any code that has "BND"
    - code that involves filtering out certain datapoints
        - Look for conditionals, especially if there's a 'continue'

## Step 1: Background Knowledge
- Look up the file type of vcf (variant call files): 
    - https://samtools.github.io/hts-specs/VCFv4.2.pdf
- Look up what contigs are:
    - https://en.wikipedia.org/wiki/Contig 
- Look up the source algorithm(Manta)
    -  https://github.com/Illumina/manta/blob/master/docs/userGuide/README.md 

## Step 2: Exploring the relevant docstring to understand SVTK
In command line in the docker interactive
- svtk (to see doc string of entire file)
    - gained understanding of the standardize function
- svtk standardize -h (to see doc string of standarize function)
    - gained understanding of relevant arguments

## Step 3: Find relevant files 
### Find files that run when 'svtk standardize' is ran
In command line in the docker interactive
- grep -rnw . -e 'svtk standardize'
- Files of interest:
    - ./svtk/cli/standardize_vcf.py 
        - the file that is run when the command 'svtk standardize' is ran in command line
    - import of interest : "from svtk.standardize import VCFStandardizer"
        - standardizer = VCFStandardizer.create(
                args.source, vcf, fout, args.prefix, args.min_size,
                args.include_reference_sites, args.call_null_sites)

        - for record in standardizer.standardize_vcf():
            fout.write(record)

### Seeing which files have BND in the text
In command line in the docker interactive
- grep -rnw . -e 'BND'
- Files of interest: 
    - /svtk/standardize/standardize.py
    - /svtk/standardize/std_manta.py

### Assumed Simplified Pipeline Flow
- Command Line >> standardize_vcf.py >> standardize.py >> std_manta.py >> standardize_vcf.py >> Output file
    - Based off of class/function dependencies
    - Narrows focus down to these files and to look at relevant BND functions.  

## Step 4: Explore the input and output file
Exploring what's unique about BND 

- example of BND input:
    - #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	SSC11438

    - chr1	806391	MantaBND:32:0:1:0:0:0:1	C	C]CHR2:242118516]	825	PASS	BND_DEPTH=212;CIPOS=0,12;HOMLEN=12;HOMSEQ=CATGCACTGCCC;MATEID=MantaBND:32:0:1:0:0:0:0;MATE_BND_DEPTH=189;SVTYPE=BND	GT:FT:GQ:PL:PR:SR	0/0:PASS:212:0,162,999:67,1:56,9

- example of non-BND input: 
    - chr1	933988	MantaDEL:0:57:57:0:0:0	CGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTCCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCGGCTGCGTTACAGGTGGGCAGGGGAGGCG	CT	999	PASS	CIGAR=1M1I225D;END=934213;SVLEN=-225;SVTYPE=DEL	GT:FT:GQ:PL:PR:SR	1/1:PASS:103:999,106,0:0,3:0,37

    - chr1	998763	MantaINS:0:63:63:0:1:0	GC	GGGGAGGGCGCGGAGCGGAGGGGAGGGCGCGGAGCGGAGGGGAGGGCGCGGAGCGGAGG	999	PASS	CIGAR=1M58I1D;END=998764;SVLEN=58;SVTYPE=INS	GT:FT:GQ:PL:PR:SR	1/1:PASS:41:677,44,0:0,0:0,26

    - chr1	16545311	MantaINV:2435:0:1:0:0:0	C	<INV>	999	MaxDepth	END=16727936;INV3;SVINSLEN=3;SVINSSEQ=CCT;SVLEN=182625;SVTYPE=INV	GT:FT:GQ:PL:PR:SR	0/1:PASS:999:999,0,999:156,0:137,41

    - chr1	1068747	MantaDUP:TANDEM:0:75:75:2:0:0	C	<DUP:TANDEM>	999	PASS	CIEND=0,9;CIPOS=0,9;END=1068825;HOMLEN=9;HOMSEQ=CACGCGGGC;SVLEN=78;SVTYPE=DUP	GT:FT:GQ:PL:PR:SR	0/1:PASS:332:718,0,329:9,1:27,28

- example of non-BND output:
    - #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	SSC11438
    - chr1	820928	manta_SSC11438_1	N	<DEL>	.	PASS	END=820998;SVTYPE=DEL;CHR2=chr1;STRANDS=+-;SVLEN=70;ALGORITHMS=manta	GT:manta	0/1:1

### Analysis
- The ALT column for BND has a much different format than non-BND. 
- Read up on the general format of alternate bases
    - https://samtools.github.io/hts-specs/VCFv4.2.pdf 
- Continue exploring the different functions/classes that are related to BND
- Classes/functions of interest:
    - VCFStandardizer in standardize.py
        - filter_raw_vcf method
        - standardize_vcf method
        - standardize_alts method
    - parse_bnd_pos function in standardize.py
    - parse_bnd_strands function in standardize.py
    - MantaStandardizer in std_manta.py
        - standardize_info method
        - standardize_alts method

## Edit Files with nano/vim to edit code
In command line in the docker interactive
- apt update
- apt install nano
- apt install vim
- nano file_name

## Things to do if I had more time
- Experiment with a simple VCF file that has a few datapoints that are non-BND and BND
    - To get a better idea of how svtk standardize works
    - Use a file where you know the output beforehand 
- Put in print statements in classes/functions of interest or 
    - To see what functions are being run and the state of variables in each step
- Output traceback
    - To see all relevant files
- Find a way to use Python debugger or Visual Studio Code debugger locally
    - To see how the program runs and dependencies
- Use tools like SuperGlue
    - To track data lineages visually
- Refer back to a previous version of code that was working
    - To see relevant changes made