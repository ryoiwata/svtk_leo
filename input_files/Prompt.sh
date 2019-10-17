#Start with the docker gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777, it will have all relevant codes

#In our lab we use the in-house tool svtk for many of our daily tasks, however in many occasions we run into issues that we must investigate and debug. This is one of those issues we encountered during our work.

#A VCF file is a variant call format, in which each line contains information about a interesting variant. Here we are trying to "standardize" a vcf file to input into our analysis pipeline. 

#You can safely ignore any line that starts with "#", they are not relevant to this exercise. 

#Exercise 1: Copy the input files into your docker instance. Run the following commands inside the docker image
svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.vcf.gz;
tabix -p vcf manta.SSC11438.vcf.gz

#Exercise 2: Check the output of the previous run, you will notice that all variants whose 3rd column starts with "MantaBND" have dissappeared in the output file. This is a bug. Do you best to fix it.
#The relevant code are in /opt/svtk/. Once you found the issue simply edit the code as is. After you fixed the issue, run the following commands
svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.fixed.vcf.gz;
tabix -p vcf manta.SSC11438.fixed.vcf.gz

#Attach a short write up of what you did with both exercises, alongside the output files of both exercises (manta.SSC11438.vcf.gz and manta.SSC11438.fixed.vcf.gz)in a zip file and send it back to us. 

#It is ok if you are unable to complete exercise 2, show us what steps you have taken to solve the problem. We're mainly interested in your ability to think on your feet.
#Obviously you should complete this on your own, but you're welcome to consult any online resources. 