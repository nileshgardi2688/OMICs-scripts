source /opt/apps/anaconda2/bin/activate

PyClone build_mutations_file --in_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/tsv/02_Bio_312.tsv" --out_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/yaml/02_Bio.yaml"
PyClone build_mutations_file --in_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/tsv/02_Sur_312.tsv" --out_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/yaml/02_Sur.yaml"
PyClone build_mutations_file --in_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/tsv/02_Rec1_312.tsv" --out_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/yaml/02_Rec1.yaml"
PyClone build_mutations_file --in_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/tsv/02_Rec2_312.tsv" --out_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/yaml/02_Rec2.yaml"
PyClone build_mutations_file --in_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/tsv/02_Rec3_312.tsv" --out_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/yaml/02_Rec3.yaml"

PyClone run_analysis --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml"

#####################Loci
#PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_density --plot_type density --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3
PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_sim_matrix --plot_type similarity_matrix --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_par_coordinates --plot_type parallel_coordinates --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_scatter --plot_type scatter --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_vaf_parallel_coordinates --plot_type vaf_parallel_coordinates --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_loci --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/loci/02_loci_vaf_scatter --plot_type vaf_scatter --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

################Clusters
PyClone plot_clusters --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/cluster/02_cluster_Density --plot_type density --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_clusters --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/cluster/02_cluster_par_coordinates --plot_type parallel_coordinates --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

PyClone plot_clusters --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --plot_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/cluster/02_cluster_scatter --plot_type scatter --samples 02_Bio 02_Sur 02_Rec1 02_Rec2 02_Rec3

###########################Table
PyClone build_table --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --out_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/02_loci --table_type loci

PyClone build_table --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --out_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/02_cluster --table_type cluster

PyClone build_table --config_file "/scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/config.yaml" --out_file /scratch/csllab/Nilesh/Analysis/Mapping/pyclone/deep_correction_June_2021/02/02_old_style --table_type old_style





