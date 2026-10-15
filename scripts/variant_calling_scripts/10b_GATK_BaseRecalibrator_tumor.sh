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
INPUT_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/tumor"
INPUT_DIR_2="/data/courses/cancergenomics/VAR_CALLING"
RESULTS_DIR="/data/users/mkummer/Cancer_Genomics/output/GATK/BaseRecalibrator/tumor"
REF_DIR="/data/users/mkummer/Cancer_Genomics/input/bwa_idx"
REF="$REF_DIR/genome.fa"
IN_BAM="$INPUT_DIR/tumor_marked.bam"
OUT_TABLE="tumor_recal.table"
KNOWN_DBSNP="$INPUT_DIR_2/dbsnp/GCF_000001405.40_alias.vcf.gz"
KNOWN_INDELS="$INPUT_DIR_2/known_indels/resources_broad_hg38_v0_Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
SIF_PATH="/data/users/mkummer/Cancer_Genomics/containers/gatk_4.6.2.0.sif"


#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

# BaseRecalibrator for the normal sample.
apptainer exec \
  --bind "/data":"/data" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "$INPUT_DIR":"$INPUT_DIR" \
  --bind "$INPUT_DIR_2":"$INPUT_DIR_2" \
  "$SIF_PATH" \
  gatk BaseRecalibrator \
	-R "$REF" \
	-I "$IN_BAM" \
	--known-sites "$KNOWN_DBSNP" \
	--known-sites "$KNOWN_INDELS" \
  --output "$RESULTS_DIR/$OUT_TABLE"