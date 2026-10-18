# To do:
Multiqc report adjustments and and workflow proof read.

# Course

**Cancer Genomics, Autumn Semester 2026, University of Bern**

## Authors

Marin Garcia Guillermo, Endrinë Krasniqi, Mario Lucio Kummer

## Description

The goal of this course project was to analyze cancer genomic data.Biological Samples: Whole-exome sequencing (WES) data from paired cell lines:
Tumor: Triple-negative breast cancer HCC1395
Normal: Matched normal tissue HCC1395 BL


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
   Run [`01a_fastQC_raw_reads_normal.sh`](scripts/variant_calling_scripts/01a_fastQC_raw_reads_normal.sh) and [`01b_fastQC_raw_reads_tumor.sh`](scripts/variant_calling_scripts/01b_fastQC_raw_reads_tumor.sh).

   - **Description**\
   Asses quality of the raw reads, in terms of potential artifacts, low-quality bases, or adapter contamination etc. This was done for both reverse and forwards reads for the normal and tumor samples.

   - **Main findings**\
   For both Reads R1 and R2 for both the tumor and normal sample, the quality was overall fine (high per-base sequence quality, no signifcant detoirate towards 3' end, no adapter contamination), nothing alarming was found.

2. **Read trimming and filtering with fastp** \
   Run [`02a_fastP_raw_reads_normal.sh`](scripts/variant_calling_scripts/02a_fastP_raw_reads_normal.sh) and [`02b_fastP_raw_reads_tumor.sh`](scripts/variant_calling_scripts/02b_fastP_raw_reads_tumor.sh)
 
   - **Description**\§
   Improve the quality of the reads form both samples by trimming. It was run with paramter auto_detect_adapter_for_pe enabled, which allows fastp to automatically detect the adapter sequence and trim it from the paired end reads. 

   - **Main findings**\
   When looking at the output report of fastp, it was found that nothing was trimmed or filtered form the reads for boths samples. Which make sense, since as seen in the previous step the quality of both reads for both samples was overall good and therfroe not trimming/filtering was needed. The insert peaks were 169 for both samples, total reads before and after filtering for tumor sample is 15.913646 M and for normal sample 12.228064 M. No reads were dropped for both samples tumor/normal. (Here it was performed just as step for the sake of the completness of the workflow. It would have also beeen possible to skip initial fastqc and just do directly the fastp.)

3. **Quality control of trimmed reads with FastQC** \
   Run [`03a_fastQC_trimmed_reads_normal.sh`](scripts/variant_calling_scripts/03a_fastQC_trimmed_reads_normal.sh)
   and [`03b_fastQC_trimmed_reads_tumor.sh`](scripts/variant_calling_scripts/03b_fastQC_trimmed_reads_tumor.sh)
   with FastQC.

   - **Description**\
   Asses quality of the raw reads, as in step 1, but now for the trimmed reads.

   - **Main findings**\
   As seen in the previous step, nothinhg was trimmed or filtered from the reads, therefore the quality of the trimmed reads is the same as in step 1. Nothing alarming was found. 

4. **Initial quality-control report with MultiQC** \
   Run [`04_multiqc_fastQC_and_fastp.sh`](scripts/variant_calling_scripts/04_multiqc_fastQC_and_fastp.sh)
   with MultiQC.

   - **Description**\
   Here, the ouptut reports of the intital fastqc, fastp and the fastqc after trimming were aggregated into a single report for both samples.

   - **Main findings**\
   No new finidings were made (Findings from step 1-3), since the quality of the reads was overall good and nothing was trimmed or filtered from the reads.

5. **Read alignment with BWA-MEM2** \
   Run [`05a_mapping_BWA-MEM2_normal.sh`](scripts/variant_calling_scripts/05a_mapping_BWA-MEM2_normal.sh)
   and [`05b_mapping_BWA-MEM2_tumor.sh`](scripts/variant_calling_scripts/05b_mapping_BWA-MEM2_tumor.sh)
   with BWA-MEM2.

   - **Description**\
   Map the trimmed reads of both samples to the reference genome using BWA-MEM2. For this the reference genome FASTA file mus be indexed using bwa-mem2 index. The preindex reference genome was provided by the course. Morover in this step the ouput SAM files were directly converted to the compressed, binary BAM format using samtools view (To save disk sapce).


   - **Main findings**\
   The mapping was and the conversion from the humanreadable SAM files to BAM format was successful for both samples.


6. **Sorting and indexing with samtools** \
   Run [`06a_sort_index_samtools_normal.sh`](scripts/variant_calling_scripts/06a_sort_index_samtools_normal.sh)
   and [`06b_sort_index_samtools_tumor.sh`](scripts/variant_calling_scripts/06b_sort_index_samtools_tumor.sh)
   with samtools sort and index.

   - **Description**\
   For the downstream analysis/tools, the BAM files need to be sorted to query the BAM file seffciently. For thsi it has to be coordinate-sorted and habe and index file (.bai).
   
   - **Main findings**\
   The indexing and sorting was successful for both samples. The sorted BAM files and the index files (.bai) were generated successfully.


7. **Duplicate marking with GATK** \
   Run [`07a_GATK_MarkDuplicates_normal.sh`](scripts/variant_calling_scripts/07a_GATK_MarkDuplicates_normal.sh)
   and [`07b_GATK_MarkDupilcates_tumor.sh`](scripts/variant_calling_scripts/07b_GATK_MarkDupilcates_tumor.sh)
   with GATK MarkDuplicates.

   - **Description**\
   GATK MarkDuplicates marks PCR duplicates (identical DNA fragments produced by over-amplification during library preparation) and optical duplicates (generated during sequencing cluster generation). These are marked since they do not represent independent molecurar sampling. If we leave them uncorrected it can arificallc inflate  coverage and bias variant allele frequencies, leading to false-positive variant calls or distorted expression estimates. Makring let the downstream analysis/tools (e.g variant callers) decide if theses are inlincluded or ignored instead of removing them compeltely.

   - **Main findings**\
   For the normal sample 6'113'950 reads were examined, which contained 10.6% non-optical duplicate reads (648'943), with only about 0.3% of duplicate pairs classified as optical duplicates (2'011). For the normal sample 7'956'714 reads were exampined, which contained 10.8% non-optical duplicate  reads (856'347), with only about 0.3% of duplicate pairs classified as optical duplicates (2'571). Therefore the duplicate rate is acceptable.


8. **Alignment metrics with GATK** \
   Run [`08a_GATK_CollectMultipleMetrics_normal.sh`](scripts/variant_calling_scripts/08a_GATK_CollectMultipleMetrics_normal.sh)
   and [`08b_GATK_CollectMultipleMetrics_tumor.sh`](scripts/variant_calling_scripts/08b_GATK_CollectMultipleMetrics_tumor.sh)
   with GATK CollectMultipleMetrics.

   - **Description**\
   After aligning and marking the duplicates, we quantitatively assessed the quality of our BAM files in terms of various metrics (e.g., insert size distributions, mean read length, etc.). For thsi GATK CollectMultipleMetrics was used.

   - **Main findings**\
   Will be discussed in the next step 9. Multqic report. Since it genrate quite some metrics in .txt fromat and plots in .pdf format, it is more convenient to look at the aggregated report generated by MultiQC in the next step.

9. **Post-alignment quality-control report with MultiQC** \
   Run [`09_multiqc.sh`](scripts/variant_calling_scripts/09_multiqc.sh)
   with multiqc.

   - **Description**\
   Here again for a better overview of the quality of the BAM files a mutliqc report was genrated. In fact one complete multiqc report from intial fastqc, fastp, fastqc after trimming, and the post-alignment quality control metrics was generated in this step. You can find in here `output/multiqc/`.

   - **Main findings**\
   

10. **BASE QUALITY SCORE RECALIBRATION (BQSR)** \
    Run [`10a_GATK_BaseRecalibrator_normal.sh`](scripts/variant_calling_scripts/10a_GATK_BaseRecalibrator_normal.sh)
    and [`10b_GATK_BaseRecalibrator_tumor.sh`](scripts/variant_calling_scripts/10b_GATK_BaseRecalibrator_tumor.sh)
    with GATK BaseRecalibrator.

    - **Description**\
    BQSR is a tool which uses machine learning to model these errors adn adjust quality scores (The Phred scores assigned by the sequencing machines, which are often systematically biased by machine cycle, sequence context, or technical artifacts) to match true empirical error rate.

    - **Main findings**\
    The outut is just the caluclated error modle and it generates only the correction table, it doesnet actually change any bases or quality scores in our BAM files.


11. **Apply base quality score recalibration with ApplyBQSR** \
    Run [`11a_GATK_ApplyBQSR_normal.sh`](scripts/variant_calling_scripts/11a_GATK_ApplyBQSR_normal.sh)
    and [`11b_GATK_ApplyBQSR_tumor.sh`](scripts/variant_calling_scripts/11b_GATK_ApplyBQSR_tumor.sh)
    with GATK ApplyBQSR.

    - **Description**\
    ApplyBQSR uses thhe correction table produced in step 10. to rewrite the quality scores in our BAM files with the help of the empirical error models.

    - **Main findings**\
    The output is the recalibrated BAM files, where the read's Phred quality scores accurately reflect the true probability of error now.

**From this point onward, the provided BAM files from the course are used instead
of the BAM files generated in the preceding steps.**

12. **Inspect the provided BAM files** \

    Run [`12_inspect_quality_control_bam_files.sh`](scripts/variant_calling_scripts/12_inspect_quality_control_bam_files.sh)
    with samtools view.

    - **Description**\
    Quick inspection of the provided BAM files to understand file content and processing details with samtools view.

    - **Main findings**\
    The @HD tag shows "@HD	VN:1.6	SO:coordinate" which indicates that the bam file is sored by coordinate. The @SG tag shows "@SQ	SN:chr6	LN:170805979, @SQ	SN:chr17	LN:83257441" which indicates the that the chromosome 6 and 17 were used as the reference genome. The @PG tag shwos "@PG	ID:bwa	PN:bwa	VN:0.7.17-r1188	CL:bwa mem /config/data/reference//ref_genome.fa /config/data/reads/tumor_R1.fastq.gz /config/data/reads/tumor_R2.fastq.gz" which indicates the processing programm. Here the aligner bwa-mem was used. By inseocing a few alginemtn lines we can infer theat the original reads were 100 base pairs length based on from the CIGAR strings (100M, 100M, 100M).

13. **Calculate alignment statistics with samtools flagstat** \

    Run [`13a_samtools_flagstat_normal.sh`](scripts/variant_calling_scripts/13a_samtools_flagstat_normal.sh)
    and [`13b_samtools_flagstat_tumor.sh`](scripts/variant_calling_scripts/13b_samtools_flagstat_tumor.sh) with samtools flagstat.

    - **Description**\
    With samtools flagstat we get a comprehensive summary directly from our BAM files of some alignment categories, e.g. reporting total reads, mapped vs. unmapped reads, proper pairs, and duplicate statistics.

    - **Main findings**\
    For the tumor sample, there are 16674562 total readsand 1871521 duplicate alignements.
    For the normal sample, there are 12744793 total reads and 1397598 duplicate alignements.

14. **Calculate hybrid-selection metrics with GATK CollectHsMetrics** \

    Run [`14a_GATK_CollectHsMetrics_normal.sh`](scripts/variant_calling_scripts/14a_GATK_CollectHsMetrics_normal.sh)
    and [`14b_GATK_CollectHsMetrics_tumor.sh`](scripts/variant_calling_scripts/14b_GATK_CollectHsMetrics_tumor.sh)
    with GATK CollectHsMetrics. 

    - **Description**\
    Due to the fact that the data is whole-exome sequencing (WES), we want to asses/evaluate wheter the reads algin to the target regions and coverage.

    - **Main findings**\
    The resulting output .txt files for both sampels tumor and normal can be aggregate in a multiqcr report (next step 15.).

15. **Aggregate quality-control metrics with MultiQC** \

    Run [`15_multiqc_quality_bam_files.sh`](scripts/variant_calling_scripts/15_multiqc_quality_bam_files.sh) with multiqc.

    - **Description**\
    We inspect  hybrid-selection metrics such as target folding, mean target coverage, and zero-coverage genes

    - **Main findings**\
    For the tumor sample the Fold enrichment is approx. 23 and for the normal sample is approx. 22. For tumor sample 46.1 % usable on traget basse and for the normals ample 44.3%. Approximately 89.9% of bases are within 250 bp of target regions (selected bases) for normal sample and 90.9% for tumor sample. De-duplicated coverage is 84x for the normal sample and 114x for the tumor sample, indicating sufficient coverage for downstream analysis. All the stats can be seen in the corresponding multiqc report.


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
