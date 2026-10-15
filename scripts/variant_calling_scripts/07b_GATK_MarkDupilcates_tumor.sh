#!/bin/bash

#SBATCH --job-name=GATK_tumor
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/GATK/tumor/GATK_tumor/%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/GATK/tumor/GATK_tumor/%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/output/samtools_sorted/tumor"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/tumor"
IN_BAM="$INPUT_DIR/tumor_aligned.sorted.bam"
OUT_BAM="$RESULTS_DIR/tumor_marked.bam"
OUT_METRICS="$RESULTS_DIR/tumor_metrics.txt"
SIF_PATH="/containers/apptainer/gatk4_4.6.2.0_samtools_1.21.sif"

# Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Mark duplicate reads with GATK.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  gatk MarkDuplicates \
	-I $IN_BAM \
	-O $OUT_BAM \
	-M $OUT_METRICS

apptainer exec \
  --bind /data:/data \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  "$SIF_PATH" \
  samtools index "$OUT_BAM"


	

 