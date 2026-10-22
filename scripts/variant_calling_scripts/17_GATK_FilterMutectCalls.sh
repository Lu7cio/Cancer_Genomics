#!/bin/bash
#SBATCH --job-name=17_FilterMutectCalls
#SBATCH --partition=pibu_el8 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --account=class-407009-ws-2026
#SBATCH --output=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.o
#SBATCH --error=/data/users/gmaringarcia/Cancer_Genomics/logs/GATK/FilterMutectCalls_%j.e

# 1. Define paths and directories
MARIO_DIR="/data/users/mkummer/Cancer_Genomics"
MY_DIR="/data/users/gmaringarcia/Cancer_Genomics"

# Inputs
REF_FA="${MARIO_DIR}/input/reference/ref_genome.fa"
RAW_VCF="${MY_DIR}/output/GATK/Mutect2/somatic_raw.vcf.gz"

# Containers (using Mario's GATK and your newly downloaded bcftools)
GATK_SIF="${MARIO_DIR}/containers/gatk_4.6.2.0.sif"
BCFTOOLS_SIF="${MY_DIR}/containers/bcftools.img"

# Outputs
OUT_DIR="${MY_DIR}/output/GATK/Mutect2"
FILTERED_VCF="${OUT_DIR}/somatic_filtered.vcf.gz"
PASS_VCF="${OUT_DIR}/somatic_filtered_PASS.vcf.gz"

# 2. Step 1: Filter Mutect2 Calls
apptainer exec \
  --bind /data \
  "$GATK_SIF" \
  gatk FilterMutectCalls \
  -R "$REF_FA" \
  -V "$RAW_VCF" \
  -O "$FILTERED_VCF"

# 3. Step 2: Extract only PASS variants using bcftools
apptainer exec \
  --bind /data \
  "$BCFTOOLS_SIF" \
  bcftools view \
  -f PASS "$FILTERED_VCF" \
  -Oz > "$PASS_VCF"

# 4. Step 3: Index the final PASS VCF using bcftools
apptainer exec \
  --bind /data \
  "$BCFTOOLS_SIF" \
  bcftools index \
  --tbi "$PASS_VCF"