#!/bin/bash
#SBATCH --job-name=17_FilterMutectCalls
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/mkummer/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.o
#SBATCH --error=/data/users/mkummer/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.e

# Define directories and input files
BASE_DIR="/data/users/mkummer/Cancer_Genomics"

REF_FA="$BASE_DIR/input/reference/ref_genome.fa"
RAW_VCF="$BASE_DIR/output/GATK/Mutect2/somatic_raw.vcf.gz"

# Containers
GATK_SIF="$BASE_DIR/containers/gatk_4.6.2.0.sif"
BCFTOOLS_SIF="/data/users/gmaringarcia/Cancer_Genomics/containers/bcftools.img"

# Output definitions
OUT_DIR="$BASE_DIR/output/GATK/Mutect2"
FILTERED_VCF="$OUT_DIR/somatic_filtered.vcf.gz"
PASS_VCF="$OUT_DIR/somatic_filtered_PASS.vcf.gz"

# Ensure output directory exists
mkdir -p "$OUT_DIR"

# Step 1: Filter Mutect2 Calls
apptainer exec \
  --bind /data \
  "$GATK_SIF" \
  gatk FilterMutectCalls \
  -R "$REF_FA" \
  -V "$RAW_VCF" \
  -O "$FILTERED_VCF"

# Step 2: Extract only PASS variants using bcftools
apptainer exec \
  --bind /data \
  "$BCFTOOLS_SIF" \
  bcftools view \
  -f PASS "$FILTERED_VCF" \
  -Oz > "$PASS_VCF"

# Step 3: Index the final PASS VCF using bcftools
apptainer exec \
  --bind /data \
  "$BCFTOOLS_SIF" \
  bcftools index \
  --tbi "$PASS_VCF"