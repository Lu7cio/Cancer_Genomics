#!/bin/bash
#SBATCH --job-name=17_FilterMutectCalls
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --reservation=class-407009-2026-10-08
#SBATCH --output=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.o
#SBATCH --error=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.e

# Define directories
MARIO_DIR="/data/users/mkummer/Cancer_Genomics"
MY_DIR="/data/users/gmaringarcia/Cancer_Genomics"
COURSE_CONT_DIR="/data/courses/cancergenomics/2026/VAR_CALLING/containers"

# Input files
REF_FA="${MARIO_DIR}/input/reference/ref_genome.fa"
RAW_VCF="${MY_DIR}/output/GATK/Mutect2/somatic_raw.vcf.gz"

# Containers
GATK_SIF="${MARIO_DIR}/containers/gatk_4.6.2.0.sif"
# Update this path if you have bcftools.sif in your containers folder
BCFTOOLS_SIF="${COURSE_CONT_DIR}/bcftools.img"

# Output files
OUT_DIR="${MY_DIR}/output/GATK/Mutect2"
FILTERED_VCF="${OUT_DIR}/somatic_filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/somatic_filtered_PASS.vcf.gz"

# Step 1: Filter Mutect2 Calls
apptainer exec \
  --bind /data \
  --bind /storage \
  "$GATK_SIF" \
  gatk FilterMutectCalls \
  -R "$REF_FA" \
  -V "$RAW_VCF" \
  -O "$FILTERED_VCF"

# Step 2: Extract only PASS variants using bcftools
apptainer exec \
  --bind /data \
  --bind /storage \
  "$BCFTOOLS_SIF" \
  bcftools view \
  -f PASS "$FILTERED_VCF" \
  -Oz > "$PASS_VCF"

# Step 3: Index the final PASS VCF
apptainer exec \
  --bind /data \
  --bind /storage \
  "$BCFTOOLS_SIF" \
  bcftools index \
  --tbi "$PASS_VCF"