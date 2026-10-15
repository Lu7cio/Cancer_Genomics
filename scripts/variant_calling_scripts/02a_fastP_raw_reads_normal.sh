#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_fastqc
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/fastp/normal/fastp_analysis_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/fastp/normal/fastp_analysis_error_%j.

#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/Cancer_Genomics/input/raw_reads"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/fastp/normal"
R1="$READS_DIR/normal.R1.fq.gz"
R2="$READS_DIR/normal.R2.fq.gz"
SIF_PATH="/containers/apptainer/fastp_0.24.1.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Run FastP on the selected raw reads file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$SIF_PATH":"$SIF_PATH" \
  "$SIF_PATH" fastp -w 4 \
  -i "$R1" \
  -I "$R2" \
  --html "$RESULTS_DIR/normal.fastp.html" \
  --json "$RESULTS_DIR/normal.fastp.json" \
  -o "$RESULTS_DIR/normal.trimmed.R1.fq.gz" \
  -O "$RESULTS_DIR/normal.trimmed.R2.fq.gz" \
  --detect_adapter_for_pe


