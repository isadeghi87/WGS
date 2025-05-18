# Define the list of sample paths
setwd("/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Code/basejumper/samples_bash/")
sample_paths <- list.files(path = "/omics/odcf/analysis/OE0290_projects_temp/heroes-aya/AG_Thongjuea/Sub_project1/Data/sample_sheets/sample_csvs",
                           pattern = "csv",full.names = T,recursive = T)

# Template for the bash script
script_template <- "#!/bin/bash

#PBS -N basejumper_{sample_name}
#PBS -l mem=200g
#PBS -l walltime=200:00:00
#PBS -M iman.sadeghidehchesmeh@dkfz.de
#PBS -m e

# Load required modules
module load Nextflow/22.10.7

# Define variables
INST_DIR=\"/omics/odcf/analysis/OE0290_projects/heroes-aya/AG_Thongjuea/Sub_project1/Software/scWGS/Thongjuea/basejumper-wgs\"
export NXF_VER=22.10.7
export NXF_SINGULARITY_CACHEDIR=\"${INST_DIR}/singularity_images\"
export NXF_OFFLINE='TRUE'
export SENTIEON_LICENSE=b06x-pbs01.inet.dkfz-heidelberg.de:4000

GENOME_BASE=\"${INST_DIR}/data\"
INPUT=\"{input_path}\"
output_dir=\"/b06x-isi/b062/g-i/HEROES-AYA/bulkWGS/Result/basejumper/{sample_name}\"

WORK=`mktemp -d`

cd $WORK

# Run Nextflow
nextflow run \"${INST_DIR}/bj-wgs/main.nf\" -profile singularity \\
    --input_csv $INPUT \\
    --max_cpus 20 \\
    --max_memory 150.GB \\
    --genomes_base \"$GENOME_BASE\" \\
    --mode wgs \\
    --genome GRCh38 \\
    --publish_dir \"$output_dir\" \\
    --skip_fastq_merge false \\
    -resume
"

# Generate bash scripts for each sample
jobs = c()
for (path in sample_paths) {
  # Extract the sample name
  sample_name <- gsub("_input.csv$", "", basename(path))
  
  # Replace placeholders in the template with sample-specific values
  script_content <- gsub("\\{sample_name\\}", sample_name, script_template)
  script_content <- gsub("\\{input_path\\}", path, script_content)
  
  # Define the script filename
  script_filename <- paste0("basejumper_", sample_name, ".sh")
  jobs=c(jobs,paste('qsub',script_filename))
  # Write the script to a file
  writeLines(script_content, script_filename)
}

write.table(jobs,"./jobs.sh",quote = F,row.names = F,col.names = F)

