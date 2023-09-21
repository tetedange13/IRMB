# IRMB

Wrapper around [nf-core/rnavar](https://nf-co.re/rnavar/1.0.0) pipeline, to analyse RNA-seq (Illumina mRNA) data from [GIAB](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_RNAseq/AshkenazimTrio/HG002_NA24385_son/Google_Illumina/mRNA/reads/)


## Installation

This script must be run inside an activated conda environment
It can be obtained with following commands:
```
conda create --yes --name irmb --channel conda-forge --channel bioconda --channel defaults nf-core singularity nextflow=22.10
conda activate irmb

# Clone present repository and move inside it:
git clone https://github.com/tetedange13/IRMB.git
cd IRMB
```


## Usage

Simply run:
```
./run_pipeline.sh
```

After pipeline complete, result files will be under 'rnavar' sub-directory


## Known limitations

* Only chr22 from GRCh37 is analyzed

* Recommand 'base recalibration' step is skipped

* A STAR index is built with a given read length
  Here iGenomes' index is 100 pb and GIAB data are 150 pb
