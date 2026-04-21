# Nextflow RNA-seq Pipeline (DSL2)

> If you're still running bioinformatics pipelines with bash scripts and praying nothing breaks between steps, it's time to learn Nextflow. This is the tool that makes your analysis reproducible, scalable, and resume-able.

## Why Nextflow and Not Just a Bash Script

You can chain together FastQC, STAR, and featureCounts with bash. Then one of three things happens:

1. A step fails at 3am and the whole thing stops, wasting 8 hours of alignment.
2. You need to run it on a cluster and your paths and environments are all wrong.
3. Someone asks to reproduce your analysis and you spend two days figuring out which version of STAR you used.

Nextflow solves all of this. It caches completed steps, handles resource allocation, and the pipeline definition IS the documentation.

## Quick Start
```bash
nextflow run main.nf --reads 'data/*_{R1,R2}.fastq.gz' --genome GRCh38 -profile docker
```

The `-profile docker` flag means every tool runs in a container. No installation headaches. Same container, same results, every time.

## When a Step Fails

```bash
nextflow run main.nf -resume
```

That's it. Nextflow checks which steps completed and only re-runs what's needed.

## STAR vs HISAT2: Stop Debating, Start Aligning

Both achieve ~95% alignment rates. STAR uses more RAM but is faster. HISAT2 is more memory-efficient. This pipeline uses STAR because it's what nf-core/rnaseq uses. If you're RAM-limited, swap in HISAT2 and move on with your life.
