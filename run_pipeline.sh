#!/usr/bin/env bash


################# RUN_PIPELINE.SH
#
# AUTHOR : Felix VANDERMEEREN
# CONTACT : felix.deslacs@gmail.com
# DEPENDENCIES : Bash, Conda
#
# DESCRIPTION:
#    Wrapper around nf-core/rnavar pipeline
#


set -oeu pipefail  # Best practice


## Download "nf-core/rnavar" pipeline
PIPE=rnavar
PIPE_VERS=1.0.0
TO_PIPE=nf-core-"$PIPE"_"$PIPE_VERS"
GENOME=GRCh37

if [[ ! -d "$TO_PIPE" ]] ; then
    nf-core download "$PIPE" \
        --revision "$PIPE_VERS" \
        --download-configuration \
        --container-system none \
        --compress none

    # Run pipeline on test data:
    #nextflow run "$TO_PIPE" -profile test,singularity --max_memory 5.GB
    echo
fi


## Run pipeline on wanted data
# Create SampleSheet:
sample_sheet=SampleSheet.csv
base_URL="https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_RNAseq/AshkenazimTrio/HG002_NA24385_son/Google_Illumina/mRNA/reads"

echo "sample,fastq_1,fastq_2,strandedness" > "$sample_sheet"
echo "hg002_gm24385.mrna,$base_URL/hg002_gm24385.mrna.R1.fastq.gz,$base_URL/hg002_gm24385.mrna.R2.fastq.gz,reverse" >> "$sample_sheet"
echo "hg002_gm26105.mrna,$base_URL/hg002_gm26105.mrna.R1.fastq.gz,$base_URL/hg002_gm26105.mrna.R2.fastq.gz,reverse" >> "$sample_sheet"
echo "hg002_gm27730.mrna,$base_URL/hg002_gm27730.mrna.R1.fastq.gz,$base_URL/hg002_gm27730.mrna.R2.fastq.gz,reverse" >> "$sample_sheet"

# Reference information:
# 1st time use bellow and let pipeline download everything:
support="--genome $GENOME --save_reference --read_length 101"
# But then better to specify local support files with '--star_index' and '--fasta'
# Instead use only 'chr22' and generate STAR_index on-the-fly:
support="--read_length 150 --igenomes_ignore --fasta chr22.fa --gtf s3://ngi-igenomes/igenomes/Homo_sapiens/Ensembl/$GENOME/Annotation/Genes/genes.gtf"

# Annotation:
# Download VEP cache:
# IDEA: Use 'not refSeq' cache -> no need to later pass special options to VEP ?
# ENH: Use saref 'download_cache.nf' script to do that ?
wget https://ftp.ensembl.org/pub/release-104/variation/indexed_vep_cache/homo_sapiens_refseq_vep_104_GRCh37.tar.gz
tar xvzf homo_sapiens_refseq_vep_104_GRCh37.tar.gz
# Single quotes are needed around vep_cache_version because pipeline expect a string
annot="--annotate_tools vep --annotation_cache --vep_cache . --vep_genome $GENOME --vep_species homo_sapiens --vep_cache_version '104'"

# Use a config file to:
# * Tell GATK BedToIntervalList to '--DROP_MISSING_CONTIGS':
#   (see: https://github.com/nf-core/rnavar/issues/55)
#
# * To pass external args to VEP (needed because I use a 'refSeq' cache)
#
# With '--skip_baserecalibration', no need for '--dbsnp' or '--known_indels'
#
# WARN: When usin pre-built StarIndex, must ensure same read_length as my data
#       -> GIAB RNAseq FASTQ are 150pb, whereas iGenomes STARIndex is 100pb ?
#
# WARN: VEP cache version should be same as VEP version (here v104 -> OK)
#
nextflow run "$TO_PIPE"/1_0_0 \
    --input "$sample_sheet" \
    --outdir rnavar \
    $support \
    --skip_baserecalibration \
    $annot \
    --max_memory 30.GB \
    --max_cpus 8 \
    -c my_process.config \
    -profile singularity \
    -resume
