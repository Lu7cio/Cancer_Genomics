#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_GATK
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/inspection/quality_control_bam_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/inspection/quality_control_bam_%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/input/alignments"
normal_input_bam="$INPUT_DIR/normal.recal.bam"
tumor_input_bam="$INPUT_DIR/tumor.recal.bam"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/quality_control_bam/first_inspection"
SIF_PATH="/containers/apptainer/bwa_0.7.19_samtools_1.21.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Inspect the normal BAM file.
normal_output_file="$RESULTS_DIR/normal_recal_first_reads.txt"
: > "$normal_output_file"
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools view -H "$normal_input_bam" \
  >> "$normal_output_file"
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools view "$normal_input_bam" | head -3 \
  >> "$normal_output_file"

# Inspect the tumor BAM file.
tumor_output_file="$RESULTS_DIR/tumor_recal_first_reads.txt"
: > "$tumor_output_file"
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools view -H "$tumor_input_bam" \
  >> "$tumor_output_file"
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools view "$tumor_input_bam" | head -3 \
  >> "$tumor_output_file"