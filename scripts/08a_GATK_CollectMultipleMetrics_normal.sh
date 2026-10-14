#!/bin/bash

#SBATCH --job-name=GATK_normal
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/GATK/normal/GATK_normal/%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/GATK/normal/GATK_normal/%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/normal"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/normal"
REF_DIR="/data/users/mkummer/Cancer_Genomics/input/bwa_idx"
IN_BAM="$INPUT_DIR/normal_marked.bam"
OUT_PREFIX="$RESULTS_DIR/normal"
REF="$REF_DIR/genome.fa"
SIF_PATH="/data/users/mkummer/Cancer_Genomics/containers/gatk_4.6.2.0.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Collect multiple metrics for the normal sample.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  gatk CollectMultipleMetrics \
	-I "$IN_BAM" \
  -O "$OUT_PREFIX" \
  -R "$REF"




 
