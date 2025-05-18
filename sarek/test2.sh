#!/bin/bash

#PBS -N sarek
#PBS -l mem=80g
#PBS -l nodes=1:ppn=24
#PBS -l walltime=30:00:00
#PBS -o sarek_test2_output.log
#PBS -e sarek_test2_error.log

module load  Nextflow/24.10.2

##Directories and files
## codes 
codes=/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Code/sarek
OUTDIR=/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Code/sarek/OE0290_HEROES-AYA_I005_014_metastasis001-01_test2
INPUT=/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Code/sarek/input.test.csv

cd $codes

nextflow run nf-core/sarek -profile singularity \
	--input $INPUT \
	--outdir $OUTDIR \
	--genome GATK.GRCh38 \
        --tools strelka,snpeff,haplotypecaller,manta \
	--step mapping \
	--wes true \
	--joint_germline true \
    	--save_mapped true 
