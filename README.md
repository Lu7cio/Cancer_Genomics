# Course

## Cancer Genomics, Autumn Semester 2026

## University

University of Bern

## Authors

Marin Garcia Guillermo, Endrinë Krasniqi, Mario Lucio Kummer

## Description

The goal of this course project was to analyze cancer genomic data.

## Software and Tool Versions

All analyses were performed using fixed software versions.

| Tool / Software | Version |
|---|---:|
| FastQC | 0.12.1 |
| fastp | 24.1 |
| Jellyfish | 2.2.6 |
| Flye | 2.9.5 |
| hifiasm | 0.25.0 |
| LJA | 0.2 |
| Trinity | 2.15.2 |
| BUSCO | 5.7.1 |
| Merqury | 1.3 |
| QUAST | 5.2.0 |
| nucmer/mummer | 4.0.0rc1 |

## Workflow of Analysis

### Frist Part: Variant Calling

All the scripts for this part of the are located in
[`scripts/variant_calling_scripts/`](scripts/variant_calling_scripts/). Run the SLURM scripts in the following order for both the normal and tumor samples (Scripts with `normal` and `a` in the name are for the normal sample, and scripts with `tumor` and `b` in the name are for the tumor sample). Submit each  scriptwith `sbatch myscript.sh`:

1. **Raw-read quality control** \
   Run [`01a_fastQC_raw_reads_normal.sh`](scripts/variant_calling_scripts/01a_fastQC_raw_reads_normal.sh)
   and [`01b_fastQC_raw_reads_tumor.sh`](scripts/variant_calling_scripts/01b_fastQC_raw_reads_tumor.sh)
   with FastQC to assess the raw paired-end reads.

   - **Findings**\
   Test

2. **Read trimming and filtering**
   Run [`02a_fastP_raw_reads_normal.sh`](scripts/variant_calling_scripts/02a_fastP_raw_reads_normal.sh)
   and [`02b_fastP_raw_reads_tumor.sh`](scripts/variant_calling_scripts/02b_fastP_raw_reads_tumor.sh)
   with fastp to remove adapters and low-quality bases.

3. **Quality control of trimmed reads**
   Run [`03a_fastQC_trimmed_reads_normal.sh`](scripts/variant_calling_scripts/03a_fastQC_trimmed_reads_normal.sh)
   and [`03b_fastQC_trimmed_reads_tumor.sh`](scripts/variant_calling_scripts/03b_fastQC_trimmed_reads_tumor.sh)
   to verify the quality of the filtered reads.

4. **Initial quality-control report**
   Run [`04_multiqc_fastQC_and_fastp.sh`](scripts/variant_calling_scripts/04_multiqc_fastQC_and_fastp.sh)
   to combine FastQC and fastp results into MultiQC reports.

5. **Read alignment**
   Run [`05a_mapping_BWA-MEM2_normal.sh`](scripts/variant_calling_scripts/05a_mapping_BWA-MEM2_normal.sh)
   and [`05b_mapping_BWA-MEM2_tumor.sh`](scripts/variant_calling_scripts/05b_mapping_BWA-MEM2_tumor.sh)
   to align reads to the reference genome with BWA-MEM2.

6. **Sorting and indexing**
   Run [`06a_sort_index_samtools_normal.sh`](scripts/variant_calling_scripts/06a_sort_index_samtools_normal.sh)
   and [`06b_sort_index_samtools_tumor.sh`](scripts/variant_calling_scripts/06b_sort_index_samtools_tumor.sh)
   to sort and index the aligned BAM files.

7. **Duplicate marking**
   Run [`07a_GATK_MarkDuplicates_normal.sh`](scripts/variant_calling_scripts/07a_GATK_MarkDuplicates_normal.sh)
   and [`07b_GATK_MarkDupilcates_tumor.sh`](scripts/variant_calling_scripts/07b_GATK_MarkDupilcates_tumor.sh)
   with GATK MarkDuplicates, then index the resulting BAM files.

8. **Alignment metrics**
   Run [`08a_GATK_CollectMultipleMetrics_normal.sh`](scripts/variant_calling_scripts/08a_GATK_CollectMultipleMetrics_normal.sh)
   and [`08b_GATK_CollectMultipleMetrics_tumor.sh`](scripts/variant_calling_scripts/08b_GATK_CollectMultipleMetrics_tumor.sh)
   to collect alignment and insert-size metrics.

9. **Post-alignment quality-control report**
   Run [`09_multiqc.sh`](scripts/variant_calling_scripts/09_multiqc.sh)
   to summarize the available quality-control and GATK metrics.

10. **Base quality score recalibration table**
    Run [`10a_GATK_BaseRecalibrator_normal.sh`](scripts/variant_calling_scripts/10a_GATK_BaseRecalibrator_normal.sh)
    and [`10b_GATK_BaseRecalibrator_tumor.sh`](scripts/variant_calling_scripts/10b_GATK_BaseRecalibrator_tumor.sh)
    with GATK BaseRecalibrator to generate recalibration tables using dbSNP
    and known indel sites.

11. **Apply base quality score recalibration**
    Run [`11a_GATK_ApplyBQSR_normal.sh`](scripts/variant_calling_scripts/11a_GATK_ApplyBQSR_normal.sh)
    and [`11b_GATK_ApplyBQSR _tumor.sh`](scripts/variant_calling_scripts/11b_GATK_ApplyBQSR%20_tumor.sh)
    with GATK ApplyBQSR to produce recalibrated BAM files for downstream variant
    calling.


