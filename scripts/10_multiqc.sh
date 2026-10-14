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
SIF_PATH="/data/users/mkummer/Cancer_Genomics/containers/multiqc-1.32.sif"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR/normal" "$OUTPUT_DIR/tumor"

# Collect multiple metrics for the tumor sample.
for SAMPLE in normal tumor; do
  apptainer exec \
    --bind "$BASE_DIR":"$BASE_DIR" \
    "$SIF_PATH" \
    multiqc \
    "$BASE_DIR/output/fastqc/$SAMPLE" \
    "$BASE_DIR/output/fastp/$SAMPLE" \
    "$BASE_DIR/output/fastqc/trimmed/$SAMPLE" \
    "$BASE_DIR/output/GATK/$SAMPLE" \
    "$BASE_DIR/output/GATK/$SAMPLE/${SAMPLE}_metrics.txt" \
    --dirs \
    --fn_as_s_name \
    --outdir "$OUTPUT_DIR/$SAMPLE" \
    --filename "${SAMPLE}_multiqc.html" \
    --force
done