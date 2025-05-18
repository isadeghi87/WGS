#!/bin/bash

#PBS -N basejumper
#PBS -l mem=200g
#PBS -l nodes=1:ppn=25
#PBS -l walltime=200:00:00
#PBS -M iman.sadeghidehchesmeh@dkfz.de
#PBS -m e

# Load required modules
module load Nextflow/22.10.7

# Define variables
INST_DIR="/omics/odcf/analysis/OE0290_projects/heroes-aya/AG_Thongjuea/Sub_project1/Software/scWGS/Thongjuea/basejumper-wgs"
export NXF_SINGULARITY_CACHEDIR="${INST_DIR}/singularity_images"
export NXF_OFFLINE='TRUE'
export SENTIEON_LICENSE=b06x-pbs01.inet.dkfz-heidelberg.de:4000
export NXF_OPTS='-Xms4g -Xmx8g'
export NXF_VER=22.10.7

GENOME_BASE="${INST_DIR}/data"
INPUT="/omics/odcf/analysis/OE0290_projects_temp/heroes-aya/AG_Thongjuea/Sub_project1/Data/sample_sheets/basejumper_input.csv"
output_dir="/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Result/basejumper/"

cd  /b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Code/basejumper

    # Run Nextflow
    nextflow run "${INST_DIR}/bj-wgs/main.nf" -profile singularity \
    --input_csv $INPUT \
      --max_cpus 25 \
      --max_memory 200.GB \
      --genomes_base "$GENOME_BASE" \
      --mode wgs \
      --genome GRCh38 \
      --publish_dir "$output_dir" \
      --skip_fastq_merge false \
      -resume

   
