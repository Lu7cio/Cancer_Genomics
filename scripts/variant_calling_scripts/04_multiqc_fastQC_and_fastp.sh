#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_fastqc
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/multiqc/multiqc_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/multiqc/multiqc_%j.e

# Define base directory and output directory for MultiQC results
BASE_DIR="/data/users/mkummer/Cancer_Genomics"
OUTPUT_DIR="$BASE_DIR/output/multiqc"
SIF_PATH="/containers/apptainer/multiqc-1.33.sif"

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR/normal" "$OUTPUT_DIR/tumor"

# Run MultiQC for normal samples
apptainer exec \
  --bind "$BASE_DIR":"$BASE_DIR" \
  "$SIF_PATH" \
  multiqc \
  "$BASE_DIR/output/fastqc/normal" \
  "$BASE_DIR/output/fastp/normal" \
  "$BASE_DIR/output/fastqc/trimmed/normal" \
  --dirs \
  --fn_as_s_name \
  --outdir "$OUTPUT_DIR/normal" \
  --filename normal_multiqc.html \
  --force

# Run MultiQC for tumor samples
apptainer exec \
  --bind "$BASE_DIR":"$BASE_DIR" \
  "$SIF_PATH" \
  multiqc \
  "$BASE_DIR/output/fastqc/tumor" \
  "$BASE_DIR/output/fastp/tumor" \
  "$BASE_DIR/output/fastqc/trimmed/tumor" \
  --dirs \
  --fn_as_s_name \
  --outdir "$OUTPUT_DIR/tumor" \
  --filename tumor_multiqc.html \
  --force

