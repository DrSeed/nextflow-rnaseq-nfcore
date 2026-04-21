#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = 'data/*_{R1,R2}.fastq.gz'
params.outdir = 'results'
params.gtf = 'reference/genes.gtf'
params.star_idx = 'reference/star_index'

process FASTQC {
    tag "$sample_id"
    publishDir "${params.outdir}/fastqc", mode: 'copy'
    input: tuple val(sample_id), path(reads)
    output: path('*.{html,zip}')
    script: """fastqc -t ${task.cpus} ${reads}"""
}

process TRIM_GALORE {
    tag "$sample_id"
    input: tuple val(sample_id), path(reads)
    output: tuple val(sample_id), path('*_val_{1,2}.fq.gz'), emit: trimmed
    script: """trim_galore --paired --cores ${task.cpus} ${reads[0]} ${reads[1]}"""
}

process STAR_ALIGN {
    tag "$sample_id"
    cpus 8
    memory '32 GB'
    input: tuple val(sample_id), path(reads); path(star_index)
    output: tuple val(sample_id), path('${sample_id}.Aligned.sortedByCoord.out.bam'), emit: bam
    script: """
    STAR --runThreadN ${task.cpus} --genomeDir ${star_index} --readFilesIn ${reads} \\
        --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --outFileNamePrefix ${sample_id}.
    """
}

workflow {
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists: true)
    FASTQC(reads_ch)
    TRIM_GALORE(reads_ch)
    STAR_ALIGN(TRIM_GALORE.out.trimmed, Channel.fromPath(params.star_idx).collect())
}
