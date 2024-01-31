module load samtools/1.9-intel

mkdir /scratch/csllab/Nilesh/Analysis/Mapping/star_index_hg19_99/fusion_analysis/02_1/
STAR-Fusion-v1.12.0/STAR-Fusion"--left_fq "/Transcriptome/02_1/02_1_1.fq.gz" --right_fq "/Transcriptome/02_1/02_1_2.fq.gz" --genome_lib_dir /references/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/ --output_dir /fusion_analysis/02_1/ --FusionInspector validate --examine_coding_effect --denovo_reconstruct --STAR_PATH /scratch/csllab/Nilesh/Analysis/Mapping/star_index_hg19_99/fusion_analysis/STAR-2.7.10b/bin/Linux_x86_64_static/STAR --CPU 10
