#!/bin/bash

#SBATCH --job-name=quality_control_multiqc
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/multiqc_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/quality_control_bam/multiqc_%j.e

# Define input, output, and container paths.
BASE_DIR="/data/users/mkummer/Cancer_Genomics/output/quality_control_bam"
FLAGSTAT_DIR="$BASE_DIR/samtools_flagstat"
HSMETRICS_DIR="$BASE_DIR/collect_hs_metrics"
RESULTS_DIR="$BASE_DIR/multiqc"
SIF_PATH="/containers/apptainer/multiqc-1.33.sif"

# Ensure output directory exists.
mkdir -p "$RESULTS_DIR"

# Aggregate HsMetrics and other quality-control reports for normal and tumor.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$BASE_DIR":"$BASE_DIR" \
  "$SIF_PATH" \
  multiqc "$FLAGSTAT_DIR" "$HSMETRICS_DIR" \
    --outdir "$RESULTS_DIR" \
    --filename multiqc_report.html \
    --force
