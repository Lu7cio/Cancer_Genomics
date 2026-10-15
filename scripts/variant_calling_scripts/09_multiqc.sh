#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_multiqc
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/multiqc/multiqc_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/multiqc/multiqc_%j.e

#Define data path, container path and output directory
BASE_DIR="/data/users/mkummer/Cancer_Genomics"
OUTPUT_DIR="$BASE_DIR/output/multiqc"
SIF_PATH="/containers/apptainer/multiqc-1.33.sif"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR/normal" "$OUTPUT_DIR/tumor"

# Collect multiple metrics for the tumor sample.
for SAMPLE in normal tumor; do
  apptainer exec \
    --bind "$BASE_DIR":"$BASE_DIR" \
    "$SIF_PATH" \
    GATK BaseRecalibrator \
  gatk BaseRecalibrator \
	-R $REF \
	-I $IN_BAM \
	--known-sites $KNOWN_DBSNP \
	--known-sites $KNOWN_INDELS \