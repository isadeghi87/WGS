setwd("/home/i439h/projects/kitz_heroes/bulkWGS/Result/basejumper/")

## get list of vcfs
dir = "/home/i439h/projects/kitz_heroes/bulkWGS/Result/basejumper"
files = list.files(path = dir,pattern = '_snpEff.ann.vcf',all.files = T,full.names = T,recursive = T)
files = files[grep('control',files,invert = T)]
files = files[grep('subset',files,invert = T)]
ids = basename(files)
ids[duplicated(ids)]

dest = '/home/i439h/projects/heroes_temp/Result/bulkWGS/all_vcfs/samples_vcf/'

# Copy the files to the target directory
# Setting overwrite = TRUE will overwrite existing files with the same name
success <- file.copy(from = files, to = dest, overwrite = TRUE)

# Check if all files were copied successfully
if (all(success)) {
  message("All files were copied successfully.")
} else {
  warning("Some files could not be copied:")
  print(source_files[!success])
}