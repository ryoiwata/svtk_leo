# Exercise 1: Copy the input files into your docker instance. Run the following commands inside the docker image

## Set Up
- operating system: Linux
- docker container: gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

## Step 1: Get the docker image(command line)
- docker pull gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777

## Step 2: Run the docker image(command line)
- docker run -it gatksv/sv-pipeline-base:3a9da85b1d9c785b9866db5407115a6c0f30f777 sh
    - this opens up an interactive image

## Step 3: Copy the input files into your docker image(command line, new terminal)
- docker container ls
    - to get the container id
- docker cp file_name container_id:/file_name
    - this will copy files into the home directory of the docker image

## Step 4: Run command(within the docker interactive image)
- svtk standardize --prefix manta_SSC11438 --contigs contig.fai --min-size 50 SSC11438.manta.vcf.gz manta.SSC11438_unsorted.vcf manta
- vcf-sort -c manta.SSC11438_unsorted.vcf | bgzip -c > manta.SSC11438.vcf.gz;
- tabix -p vcf manta.SSC11438.vcf.gz

## Step 5: Copy files from your docker image to your local(command line, different terminal)
- docker cp container_id:/file_name ./file_name