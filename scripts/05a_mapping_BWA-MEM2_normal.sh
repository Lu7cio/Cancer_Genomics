#!/bin/bash

#SBATCH --job-name=BWA-MEM2_mapping_normal
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=32G
#SBATCH --time=06:00:00

#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/bwa-mem2/normal/mapping%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/bwa-mem2/normal/mapping%j.e


# Define base directory and output directory for MultiQC results
READS_DIR="/data/users/mkummer/Cancer_Genomics/output/fastp/normal"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/bwa-mem2/normal"
REF_DIR="/data/users/mkummer/Cancer_Genomics/input/bwa_idx"
R1="$READS_DIR/normal.trimmed.R1.fq.gz"
R2="$READS_DIR/normal.trimmed.R2.fq.gz"
REF="$REF_DIR/genome.fa"
OUT_BAM="$RESULTS_DIR/normal_aligned.bam"
SIF_PATH_1="/data/users/mkummer/Cancer_Genomics/containers/bwa-mem2.sif"
SIF_PATH_2="/containers/apptainer/bwa_0.7.19_samtools_1.21.sif"

ID=normal
PLATFORM=ILLUMINA


# Ensure output directory exists
mkdir -p "$RESULTS_DIR"

apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$REF_DIR":"$REF_DIR" \
  "$SIF_PATH_1" \
  bwa-mem2 mem \
    -t 16 \
    -R "@RG\tID:$ID\tSM:$ID\tPL:$PLATFORM" \
    "$REF" \
    "$R1" "$R2" |
    
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  "$SIF_PATH_2" \
  samtools view \
    -@ 4 \
    -b \
    -o "$OUT_BAM" \
    -



  