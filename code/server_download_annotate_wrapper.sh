#!/bin/bash

## USAGE: server_download_annotate_wrapper.sh <analysis ID> <analysis ID> <analysis ID> ...  

## DESCRIPTION: This script will download files needed for the pipeline from the IonTorrent server
## then annotate all VCF files found, and create the barcode : sample ID mappings
## needed for the pipeline
## This script operates on all supplied analyses


#~~~~~ CUSTOM ENVIRONMENT ~~~~~~# 
source "global_settings.sh"

#~~~~~ PARSE ARGS ~~~~~~# 
num_args_should_be "greater_than" "0" "$#"
echo_script_name


analysis_ID="${@:1}" # accept a space separated list of ID's

echo -e "Output directory is:\n$outdir"
echo -e "Analysis IDs are :\n$analysis_ID"

#~~~~~ RUN PIPELINE ~~~~~~# 
echo -e "Running pipeline..."

# download the files for all the ID's passed
echo -e "Downloading files from server..."
${codedir}/get_server_files.sh "$analysis_ID"

echo -e "Now running annotation and data summary steps for each analysis..."
for ID in $analysis_ID; do
    echo -e "Analyis is:\n$ID"

    # annotate all of the VCFs in the analysis dirs
    analysis_outdir="${outdir}/${ID}"
    echo -e "Analysis output directory is:\n$analysis_outdir"
    echo -e "Annotating analysis VCF files..."
    set -x
    ${codedir}/annotate_vcfs.sh "$analysis_outdir"
    set +x

    # make the barcode : sampleID mappings
    echo -e "Mapping barcode and sample IDs..."
    set -x
    ${codedir}/get_run_IDs.sh "$analysis_outdir"
    set +x

    # make the summary tables, etc., for each sample in the analysis
    echo -e "Making summary tables..."
    set -x
    ${codedir}/merge_vcf_annotations_wrapper.sh "$analysis_outdir" "$ID"
    set +x
done

