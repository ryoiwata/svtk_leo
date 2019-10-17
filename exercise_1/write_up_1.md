Exercise 1

docker container: gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

#Exercise 1: Copy the input files into your docker instance. Run the following commands inside the docker image
svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.vcf.gz;
tabix -p vcf manta.SSC11438.vcf.gz

##Step 1: Get the docker image
- docker pull gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

##Step 2: Copy files into your docker image 
- docker container ls
- docker cp file_name container_id:/file_name

##Step 3: Run the docker image
- docker run -it gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777 sh

##Step 4: Run commands within the image
-svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.vcf.gz;
tabix -p vcf manta.SSC11438.vcf.gz

