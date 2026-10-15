#!/bin/bash

#SBATCH --job-name=sort_index_samtools_tumor
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/sort_samtools/tumor/sort_index%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/sort_samtools/tumor/sort_index%j.e

#Define data path, container path and output directory
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/output/bwa-mem2/tumor"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/samtools_sorted/tumor"
IN_BAM="$INPUT_DIR/tumor_aligned.bam"
OUT_BAM="$RESULTS_DIR/tumor_aligned.sorted.bam"
SIF_PATH="/containers/apptainer/bwa_0.7.19_samtools_1.21.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# Run sammtools sort  on the selected aligned files
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools sort \
    -@ 4 \
    -o "$OUT_BAM" \
    "$IN_BAM"

# Run sammtools index on the selected aligned files
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  "$SIF_PATH" \
  samtools index "$OUT_BAM"
