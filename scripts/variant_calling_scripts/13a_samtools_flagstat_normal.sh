#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_GATK
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/samtools_flagstat/samtools_flagstat_normal_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/samtools_flagstat/samtools_flagstat_normal_%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/input/alignments"
normal_input_bam="$INPUT_DIR/normal.recal.bam"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/quality_control_bam/samtools_flagstat"
SIF_PATH="/containers/apptainer/bwa_0.7.19_samtools_1.21.sif"
OUTPUT_FILE="$RESULTS_DIR/normal_recal_flagstat.txt"


#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Write flagstat statistics for the normal BAM.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools flagstat -@ 4 "$normal_input_bam" \
  > "$OUTPUT_FILE"

