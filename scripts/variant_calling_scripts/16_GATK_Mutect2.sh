#!/bin/bash
#SBATCH --job-name=16_Mutect2
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/Mutect2_%j.o
#SBATCH --error=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/Mutect2_%j.e

# Define directories
# Mario's directory for Inputs
MARIO_DIR="/data/users/mkummer/Cancer_Genomics"
# Your directory for Outputs
MY_DIR="/data/users/gmaringarcia/Cancer_Genomics"
# Shared course resources (for gnomAD and Panel of Normals)
COURSE_RES_DIR="/data/courses/cancergenomics/VAR_CALLING/resources"

# Input files
REF_FA="${MARIO_DIR}/input/reference/ref_genome.fa"
INTERVALS="${MARIO_DIR}/input/reference/exome_regions.bed.interval_list"
TUMOR_BAM="${MARIO_DIR}/input/alignments/tumor.recal.bam"
NORMAL_BAM="${MARIO_DIR}/input/alignments/normal.recal.bam"
GNOMAD_VCF="${COURSE_RES_DIR}/af-only-gnomad.hg38.subset.vcf.gz"
PON_VCF="${COURSE_RES_DIR}/1000g_pon.hg38.subset.vcf.gz"

# Container
GATK_SIF="${MARIO_DIR}/containers/gatk_4.6.2.0.sif"

# Output definitions
OUT_DIR="${MY_DIR}/output/GATK/Mutect2"
OUT_VCF="${OUT_DIR}/somatic_raw.vcf.gz"

# Ensure output and log directories exist
mkdir -p "$OUT_DIR"
mkdir -p "${MY_DIR}/logs/GATK"

# Run GATK Mutect2
apptainer exec \
  --bind /data \
  "$GATK_SIF" \
  gatk Mutect2 \
  -R "$REF_FA" \
  -I "$TUMOR_BAM" \
  -I "$NORMAL_BAM" \
  -normal normal \
  --intervals "$INTERVALS" \
  --germline-resource "$GNOMAD_VCF" \
  --panel-of-normals "$PON_VCF" \
  -O "$OUT_VCF"