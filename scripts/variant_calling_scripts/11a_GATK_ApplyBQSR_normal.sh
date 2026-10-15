#!/bin/bash

#SBATCH --job-name=assignment_cancer_genomics_GATK
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-15
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/GATK/tumor/BaseRecalibrator_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/GATK/tumor/BaseRecalibrator_%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/normal"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/ApplyBQSR/normal"
REF_DIR="/data/users/mkummer/Cancer_Genomics/input/bwa_idx"
REF="$REF_DIR/genome.fa"
IN_BAM="$INPUT_DIR/normal_marked.bam"
IN_TABLE="$INPUT_DIR/normal_recal.table"
OUT_BAM="$RESULTS_DIR/normal_bqsr.bam"
SIF_PATH="/data/users/mkummer/Cancer_Genomics/containers/gatk_4.6.2.0.sif"
 
#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Apply BQSR for the normal sample.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  gatk ApplyBQSR \
	-R $REF \
	-I $IN_BAM \
	--bqsr-recal-file $IN_TABLE \
	-O $OUT_BAM