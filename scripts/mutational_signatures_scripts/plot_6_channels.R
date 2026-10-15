input_dir <- "input"
output_dir <- "output"

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

subs <- c("C>A", "C>G", "C>T", "T>A", "T>C", "T>G")

colors <- c(
  "C>A" = "#1f77b4",
  "C>G" = "#ff7f0e",
  "C>T" = "#2ca02c",
  "T>A" = "#d62728",
  "T>C" = "#9467bd",
  "T>G" = "#8c564b"
)

comp <- c(A = "T", T = "A", C = "G", G = "C")

vcf_files <- sort(list.files(
  input_dir,
  pattern = "^sample_.*\\.vcf$",
  full.names = TRUE
))

if (length(vcf_files) == 0) {
  stop("No sample VCF files found in input/")
}

all_counts <- data.frame(Sample = character())

for (vcf_file in vcf_files) {
  counts <- setNames(integer(length(subs)), subs)

  vcf <- readLines(vcf_file)
  vcf <- vcf[!startsWith(vcf, "#")]

  for (line in vcf) {
    fields <- strsplit(trimws(line), "[[:space:]]+")[[1]]

    if (length(fields) < 5) next

    ref <- toupper(fields[4])
    alt <- toupper(fields[5])

    # Keep only single-nucleotide substitutions.
    if (nchar(ref) != 1 || nchar(alt) != 1) next
    if (!ref %in% names(comp) || !alt %in% names(comp)) next
    if (ref == alt) next

    # Normalize to pyrimidine convention.
    if (ref %in% c("A", "G")) {
      ref <- unname(comp[ref])
      alt <- unname(comp[alt])
    }

    channel <- paste0(ref, ">", alt)

    if (channel %in% subs) {
      counts[channel] <- counts[channel] + 1L
    }
  }

  sample_name <- sub("\\.vcf$", "", basename(vcf_file))

  all_counts <- rbind(
    all_counts,
    data.frame(Sample = sample_name, as.list(counts), check.names = FALSE)
  )

  svg(
    file.path(output_dir, paste0(sample_name, "_6channels.svg")),
    width = 12, height = 6
  )

  par(mar = c(5, 5, 4, 2))
  barplot(
    counts,
    col = colors[names(counts)],
    border = NA,
    main = paste("6-channel Mutational Spectrum:", sample_name),
    xlab = "Substitution Type",
    ylab = "Mutation Counts",
    las = 2
  )
  dev.off()

  cat(sample_name, "- SNVs counted:", sum(counts), "\n")
}

write.csv(
  all_counts,
  file.path(output_dir, "six_channel_counts.csv"),
  row.names = FALSE
)

cat("Finished. Results saved in", output_dir, "\n")
