#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_GATK
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/collect_hs_metrics/collect_hs_metrics_normal_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/collect_hs_metrics/collect_hs_metrics_normal_%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/input/alignments"
normal_input_bam="$INPUT_DIR/normal.recal.bam"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/quality_control_bam/collect_hs_metrics"
SIF_PATH="/data/users/mkummer/Cancer_Genomics/containers/gatk_4.6.2.0.sif"
REF_DIR="/data/users/mkummer/Cancer_Genomics/input"
REF="$REF_DIR/reference/ref_genome.fa"
OUTPUT_FILE="$RESULTS_DIR/normal_recal_hs_metrics.txt"
BAIT_INTERVALS_LIST="$REF_DIR/reference/exome_regions.bed.interval_list"
TARGET_INTERVALS_LIST="$REF_DIR/reference/exome_regions.bed.interval_list"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Collect hybrid-selection metrics for the normal BAM.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  gatk CollectHsMetrics \
    -I "$normal_input_bam" \
    -O "$OUTPUT_FILE" \
    -R "$REF" \
    --BAIT_INTERVALS "$BAIT_INTERVALS_LIST" \
    --TARGET_INTERVALS "$TARGET_INTERVALS_LIST"
