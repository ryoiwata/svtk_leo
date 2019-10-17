Exercise 2

docker container: gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

#Exercise 2: Check the output of the previous run, you will notice that all variants whose 3rd column starts with "MantaBND" have dissappeared in the output file. This is a bug. Do you best to fix it.
#The relevant code are in /opt/svtk/. Once you found the issue simply edit the code as is. After you fixed the issue, run the following commands
svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.fixed.vcf.gz;
tabix -p vcf manta.SSC11438.fixed.vcf.gz