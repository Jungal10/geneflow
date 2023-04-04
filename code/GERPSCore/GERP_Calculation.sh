conda activate snakemake
snakemake --use-conda -j 2 --configfile ConfigFile4GERP.yaml -R align
snakemake --use-conda -j 1 --configfile ConfigFile4GERP.yaml -R roast
snakemake --use-conda -j 2 --configfile ConfigFile4GERP.yaml -R call_conservation
