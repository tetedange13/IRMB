# IRMB

Wrapper around [nf-core/rnavar](https://nf-co.re/rnavar/1.0.0) pipeline, to analyse RNA-seq (Illumina mRNA) data from [GIAB](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data_RNAseq/AshkenazimTrio/HG002_NA24385_son/Google_Illumina/mRNA/reads/)


## Installation

This script requires an activated Conda environment with:
* [nf-core/tools](https://nf-co.re/tools)
* [Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html)
* [Nextflow](https://www.nextflow.io/)

It can be obtained with following commands:
```shell
conda create --yes --name irmb --channel conda-forge --channel bioconda --channel defaults nf-core singularity nextflow=22.10
conda activate irmb

# Then clone present repository and move inside it:
git clone https://github.com/tetedange13/IRMB.git
cd IRMB
```


## Usage

Simply run:
```shell
./run_pipeline.sh
```

After pipeline complete, result files will be under `rnavar` sub-directory


## Known limitations

* Only chr22 from GRCh37 is analyzed

* Recommended "base recalibration" step is skipped

* A STAR index is built with a given read length
  Here iGenomes' index is 100 pb and GIAB data are 150 pb

