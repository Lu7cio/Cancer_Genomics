#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_fastqc
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/fastqc/trimmed/tumor/fastqc_analysis_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/fastqc/trimmed/tumor/fastqc_analysis_error_%j.

#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/Cancer_Genomics/output/fastp/tumor"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/fastqc/trimmed/tumor"
R1="$READS_DIR/tumor.trimmed.R1.fq.gz"
R2="$READS_DIR/tumor.trimmed.R2.fq.gz"
SIF_PATH="/containers/apptainer/fastqc-0.12.1.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Run FastQC on the selected raw reads file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  "$SIF_PATH" fastqc -t 4 -o "$RESULTS_DIR" -R "$R1" "$R2"


