# Course

**Cancer Genomics, Autumn Semester 2026, University of Bern**

## Authors

Marin Garcia Guillermo, Endrinë Krasniqi, Mario Lucio Kummer

## Description

The goal of this course project was to analyze cancer genomic data.

## Software and Tool Versions

All analyses were performed using fixed software versions.

| Tool / Software | Version |
|---|---:|
| FastQC | 0.12.1 |
| fastp | 0.24.1 |
| multiqc | 1.33 |
| BWA-MEM2 | 0.7.19 |
| samtools | 1.21 |
| GATK | 4.6.2.0 |


## Workflow of Analysis

### First Part: Variant Calling

All the scripts for this part of the are located in
[`scripts/variant_calling_scripts/`](scripts/variant_calling_scripts/). Run the SLURM scripts in the following order for both the normal and tumor samples (Scripts with `normal` and `a` in the name are for the normal sample, and scripts with `tumor` and `b` in the name are for the tumor sample). Submit each  script with `sbatch myscript.sh`:

1. **Raw-read quality control with FastQC** \
   Run [`01a_fastQC_raw_reads_normal.sh`](scripts/variant_calling_scripts/01a_fastQC_raw_reads_normal.sh)
   and [`01b_fastQC_raw_reads_tumor.sh`](scripts/variant_calling_scripts/01b_fastQC_raw_reads_tumor.sh)
   with FastQC.

   - **Description**\
   Test

   - **Main findings**\
   Test

2. **Read trimming and filtering with fastp** \
   Run [`02a_fastP_raw_reads_normal.sh`](scripts/variant_calling_scripts/02a_fastP_raw_reads_normal.sh)
   and [`02b_fastP_raw_reads_tumor.sh`](scripts/variant_calling_scripts/02b_fastP_raw_reads_tumor.sh)
   with fastp.

   - **Description**\
   Test

   - **Main findings**\
   Test



3. **Quality control of trimmed reads with FastQC** \
   Run [`03a_fastQC_trimmed_reads_normal.sh`](scripts/variant_calling_scripts/03a_fastQC_trimmed_reads_normal.sh)
   and [`03b_fastQC_trimmed_reads_tumor.sh`](scripts/variant_calling_scripts/03b_fastQC_trimmed_reads_tumor.sh)
   with FastQC.

   - **Description**\
   Test

   - **Main findings**\
   Test

4. **Initial quality-control report with MultiQC** \
   Run [`04_multiqc_fastQC_and_fastp.sh`](scripts/variant_calling_scripts/04_multiqc_fastQC_and_fastp.sh)
   with MultiQC.

   - **Description**\
   Test

   - **Main findings**\
   Test

5. **Read alignment with BWA-MEM2** \
   Run [`05a_mapping_BWA-MEM2_normal.sh`](scripts/variant_calling_scripts/05a_mapping_BWA-MEM2_normal.sh)
   and [`05b_mapping_BWA-MEM2_tumor.sh`](scripts/variant_calling_scripts/05b_mapping_BWA-MEM2_tumor.sh)
   with BWA-MEM2.

   - **Description**\
   Test

   - **Main findings**\
   Test


6. **Sorting and indexing with samtools** \
   Run [`06a_sort_index_samtools_normal.sh`](scripts/variant_calling_scripts/06a_sort_index_samtools_normal.sh)
   and [`06b_sort_index_samtools_tumor.sh`](scripts/variant_calling_scripts/06b_sort_index_samtools_tumor.sh)
   with samtools sort and index.

   - **Description**\
   Test

   - **Main findings**\
   Test


7. **Duplicate marking with GATK** \
   Run [`07a_GATK_MarkDuplicates_normal.sh`](scripts/variant_calling_scripts/07a_GATK_MarkDuplicates_normal.sh)
   and [`07b_GATK_MarkDupilcates_tumor.sh`](scripts/variant_calling_scripts/07b_GATK_MarkDupilcates_tumor.sh)
   with GATK MarkDuplicates.

   - **Description**\
   Test

   - **Main findings**\
   Test


8. **Alignment metrics with GATK** \
   Run [`08a_GATK_CollectMultipleMetrics_normal.sh`](scripts/variant_calling_scripts/08a_GATK_CollectMultipleMetrics_normal.sh)
   and [`08b_GATK_CollectMultipleMetrics_tumor.sh`](scripts/variant_calling_scripts/08b_GATK_CollectMultipleMetrics_tumor.sh)
   with GATK CollectMultipleMetrics.

   - **Description**\
   Test

   - **Main findings**\
   Test



9. **Post-alignment quality-control report with MultiQC** \
   Run [`09_multiqc.sh`](scripts/variant_calling_scripts/09_multiqc.sh)
   with multiqc.

   - **Description**\
   Test

   - **Main findings**\
   Test

10. **Base quality score recalibration table** \
    Run [`10a_GATK_BaseRecalibrator_normal.sh`](scripts/variant_calling_scripts/10a_GATK_BaseRecalibrator_normal.sh)
    and [`10b_GATK_BaseRecalibrator_tumor.sh`](scripts/variant_calling_scripts/10b_GATK_BaseRecalibrator_tumor.sh)
    with GATK BaseRecalibrator.

    - **Description**\
    Test

    - **Main findings**\
    Test


11. **Apply base quality score recalibration** \
    Run [`11a_GATK_ApplyBQSR_normal.sh`](scripts/variant_calling_scripts/11a_GATK_ApplyBQSR_normal.sh)
    and [`11b_GATK_ApplyBQSR_tumor.sh`](scripts/variant_calling_scripts/11b_GATK_ApplyBQSR_tumor.sh)
    with GATK ApplyBQSR.

    - **Description**\
    Test

    - **Main findings**\
    Test

**From this point onward, the provided BAM files from the course are used instead
of the BAM files generated in the preceding steps.**

12. **Inspect the provided BAM files** \

    Run [`12_inspect_quality_control_bam_files.sh`](scripts/variant_calling_scripts/12_inspect_quality_control_bam_files.sh)
    with samtools view.

    - **Description**\
    Test

    - **Main findings**\
    Test

13. **Calculate alignment statistics with samtools flagstat** \

    Run [`13a_samtools_flagstat_normal.sh`](scripts/variant_calling_scripts/13a_samtools_flagstat_normal.sh)
    and [`13b_samtools_flagstat_tumor.sh`](scripts/variant_calling_scripts/13b_samtools_flagstat_tumor.sh) with samtools flagstat.

    - **Description**\
    Test

    - **Main findings**\
    Test

14. **Calculate hybrid-selection metrics with GATK CollectHsMetrics** \

    Run [`14a_GATK_CollectHsMetrics_normal.sh`](scripts/variant_calling_scripts/14a_GATK_CollectHsMetrics_normal.sh)
    and [`14b_GATK_CollectHsMetrics_tumor.sh`](scripts/variant_calling_scripts/14b_GATK_CollectHsMetrics_tumor.sh)
    with GATK CollectHsMetrics. 

    - **Description**\
    Test

    - **Main findings**\
    Test

15. **Aggregate quality-control metrics with MultiQC** \

    Run [`15_multiqc_quality_bam_files.sh`](scripts/variant_calling_scripts/15_multiqc_quality_bam_files.sh) with multiqc.

    - **Description**\
    Test

    - **Main findings**\
    Test


### Second Part: Mutational signatures


## Folder Structure

```text
Cancer_Genomics/
├── README.md
├── containers/
│   ├── bwa-mem2.sif
│   ├── gatk_4.6.2.0.sif
│   └── multiqc_1.32.sif
├── input/
│   ├── alignments/
│   ├── bwa_idx/
│   ├── reference/
│   └── raw_reads/
├── output/
│   ├── bwa-mem2/
│   ├── fastp/
│   ├── fastqc/
│   ├── GATK/
│   │   └── ApplyBQSR/
│   ├── multiqc/
│   ├── quality_control_bam/
│   │   ├── collect_hs_metrics/
│   │   ├── first_inspection/
│   │   ├── multiqc/
│   │   └── samtools_flagstat/
│   └── samtools_sorted/
├── logs/
│   ├── bwa-mem2/
│   ├── fastp/
│   ├── fastqc/
│   ├── GATK/
│   ├── multiqc/
│   ├── quality_control_bam/
│   │   ├── collect_hs_metrics/
│   │   ├── inspection/
│   │   └── samtools_flagstat/
│   └── sort_samtools/
└── scripts/
    ├── mutational_signatures_scripts/
    │   └── test.sh
    └── variant_calling_scripts/
        ├── 01a_fastQC_raw_reads_normal.sh
        ├── 01b_fastQC_raw_reads_tumor.sh
        ├── 02a_fastP_raw_reads_normal.sh
        ├── 02b_fastP_raw_reads_tumor.sh
        ├── 03a_fastQC_trimmed_reads_normal.sh
        ├── 03b_fastQC_trimmed_reads_tumor.sh
        ├── 04_multiqc_fastQC_and_fastp.sh
        ├── 05a_mapping_BWA-MEM2_normal.sh
        ├── 05b_mapping_BWA-MEM2_tumor.sh
        ├── 06a_sort_index_samtools_normal.sh
        ├── 06b_sort_index_samtools_tumor.sh
        ├── 07a_GATK_MarkDuplicates_normal.sh
        ├── 07b_GATK_MarkDupilcates_tumor.sh
        ├── 08a_GATK_CollectMultipleMetrics_normal.sh
        ├── 08b_GATK_CollectMultipleMetrics_tumor.sh
        ├── 09_multiqc.sh
        ├── 10a_GATK_BaseRecalibrator_normal.sh
        ├── 10b_GATK_BaseRecalibrator_tumor.sh
        ├── 11a_GATK_ApplyBQSR_normal.sh
        ├── 11b_GATK_ApplyBQSR_tumor.sh
        ├── 12_inspect_quality_control_bam_files.sh
        ├── 13a_samtools_flagstat_normal.sh
        ├── 13b_samtools_flagstat_tumor.sh
        ├── 14a_GATK_CollectHsMetrics_normal.sh
        ├── 14b_GATK_CollectHsMetrics_tumor.sh
        └── 15_multiqc_quality_bam_files.sh
```

- `input/` contains the raw sequencing reads, reference-genome indexes and the provided bam files (Data provided by the Course).
- `output/` contains results generated by the analysis workflow.
- `logs/` contains SLURM standard-output and error logs.
- `containers/` contains some extra containers used by the scripts.
- `scripts/variant_calling_scripts/` contains the normal and tumor variant-calling workflow.
- `scripts/mutational_signatures_scripts/` contains scripts for the second project part.
