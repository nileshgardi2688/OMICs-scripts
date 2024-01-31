############################################################################################################################
#################################  Whole Exome Sequencing pipeline #########################################################
############################################################################################################################

#####################BWA alignment of normal sample#########################################################################
bsub -J bwa -e error/normal_bwa_error.err -o log/normal_bwa_out.log -n 10 /opt/apps/bwa/gcc/0.7.17/bwa mem -t 2 -R "@RG\\tID:normal\\tPL:ILLUMINA\\tLB:TruSeq\\tSM:normal\\tPI:200" "/scratch/csllab/Nilesh/Raw_data/example/WholeExomeSequencing/Resources/chr22.fa" Raw_input/normal_read1.fastq.gz Raw_input/normal_read2.fastq.gz -f output/normal.sam

#####################BWA alignment of tumor sample##########################################################################
bsub -J bwa -e error/tumor_bwa_error.err -o log/tumor_bwa_out.log -n 10 /opt/apps/bwa/gcc/0.7.17/bwa mem -t 2 -R "@RG\\tID:tumor\\tPL:ILLUMINA\\tLB:TruSeq\\tSM:tumor\\tPI:200" "/scratch/csllab/Nilesh/Raw_data/example/WholeExomeSequencing/Resources/chr22.fa" Raw_input/tumor_read1.fastq.gz Raw_input/tumor_read2.fastq.gz -f output/tumor.sam

#####################Fixmate and SAM_To_BAM conversion in normal sample#####################################################
bsub -J samtools -e error/normal_samtools_error.err -o log/normal_samtools_out.log -n 10 /opt/apps/samtools/gcc/1.1/bin/samtools fixmate -O bam output/normal.sam output/normal_fixmate.bam

#####################Fixmate and SAM_To_BAM conversion in tumor sample######################################################
bsub -J samtools -e error/tumor_samtools_error.err -o log/tumor_samtools_out.log -n 10 /opt/apps/samtools/gcc/1.1/bin/samtools fixmate -O bam output/tumor.sam output/tumor_fixmate.bam

#####################Sorting based on chromosome and cordinates in normal sample############################################
bsub -J picard_sort_sam -e error/normal_picard_sort_sam_error.err -o log/normal_picard_sort_sam_out.log -n 10 java -jar /opt/apps/picard-2.18.9/build/libs/picard.jar SortSam I=output/normal_fixmate.bam O=output/normal_fixmate_sorted.bam SORT_ORDER=coordinate TMP_DIR=output/tmp/

#####################Sorting based on chromosome and cordinates in tumor sample#############################################
bsub -J picard_sort_sam -e error/tumor_picard_sort_sam_error.err -o log/tumor_picard_sort_sam_out.log -n 10 java -jar /opt/apps/picard-2.18.9/build/libs/picard.jar SortSam I=output/tumor_fixmate.bam O=output/tumor_fixmate_sorted.bam SORT_ORDER=coordinate TMP_DIR=output/tmp/

#####################Markduplicates and removal in normal sample############################################################
bsub -J picard_MarkDuplicates -e error/normal_picard_MarkDuplicates_error.err -o log/normal_picard_MarkDuplicates_out.log -n 10 java -jar /opt/apps/picard-2.18.9/build/libs/picard.jar MarkDuplicates I=output/normal_fixmate_sorted.bam O=output/normal_fixmate_sorted_duprm.bam M=output/normal_fixmate_sorted_duprminformation.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT CREATE_INDEX=TRUE TMP_DIR=output/tmp/

#####################Markduplicates and removal in tumor sample#############################################################
bsub -J picard_MarkDuplicates -e error/tumor_picard_MarkDuplicates_error.err -o log/tumor_picard_MarkDuplicates_out.log -n 10 java -jar /opt/apps/picard-2.18.9/build/libs/picard.jar MarkDuplicates I=output/tumor_fixmate_sorted.bam O=output/tumor_fixmate_sorted_duprm.bam M=output/tumor_fixmate_sorted_duprminformation.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT CREATE_INDEX=TRUE TMP_DIR=output/tmp/


######################################### Mutation Calling #################################################################

#########################################Variant Calling using normal and tumor files#######################################
bsub -J varscan_variant_calling -e error/varscan_variant_calling_error.err -o log/varscan_variant_calling_out.log -n 10 /opt/apps/samtools/gcc/1.1/bin/samtools mpileup -f "/scratch/csllab/Nilesh/Raw_data/example/WholeExomeSequencing/Resources/chr22.fa" -q 1 -B output/normal_fixmate_sorted_duprm.bam output/tumor_fixmate_sorted_duprm.bam | java -jar /opt/apps/varscan-2.4.2/VarScan.v2.4.2.jar somatic -mpileup output/tumor --min-var-freq 0.02 --output-vcf 1

#########################################Separating Germline, Somatic and LOH events #######################################
bsub -J varscan_somaticFilter -e error/varscan_somaticFilter_error.err -o log/varscan_somaticFilter_out.log -n 10 java -jar /opt/apps/varscan-2.4.2/VarScan.v2.4.2.jar processSomatic output/tumor.snp.vcf --min-tumor-freq 0.02

#########################################Filtering of Somatic Variants based on technical filters###########################
bsub -J varscan_somaticFilter -e error/varscan_somaticFilter_error.err -o log/varscan_somaticFilter_out.log -n 10 java -jar /opt/apps/varscan-2.4.2/VarScan.v2.4.2.jar somaticFilter output/tumor.snp.hc.vcf -indel-file output/tumor.indel.vcf --min-var-freq 0.02 --min-coverage 5 -output-file output/tumor.snp.hc.filtered.vcf

###########################################################Input for bamreadcount for somatic HC variants#################################################

awk 'BEGIN {OFS="\t"} {if (!/^#/) { isDel=(length($4) > length($5)) ? 1 : 0; print $1,($2+isDel),($2+isDel); }}' output/tumor.snp.hc.filtered.vcf > output/tumor.snp.hc.filtered.vcf .var


awk 'BEGIN {OFS="\t"} {if (!/^#/) { isDel=(length($4) > length($5)) ? 1 : 0; print $1,($2+isDel),($2+isDel); }}' "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.snp.LOH.hc.vcf" > "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.snp.LOH.hc.vcf.var"

##############################Running bamreadcount for somatic HC (filtered)and LOH HC variants##############################
/opt/apps/samtools/gcc/1.1/bin/samtools fixmate "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor_fixmate_sorted.bam" /scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor_fixmate_sorted.bai -@ 20

source /opt/apps/anaconda2/bin/activate
bam-readcount -q 1 -b 20 -w1 -l \
"/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.filtered.vcf.var" \
-f "/scratch/reference_indexes/N_references/hg19_ref_index/hg19.fasta" \
"/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor_fixmate_sorted_duprm.bam" > "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor_fixmate_sorted_duprm.readcount"

java -jar /opt/apps/varscan-2.4.2/VarScan.v2.4.2.jar fpfilter \
"/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.filtered.vcf" \
"/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor_fixmate_sorted_duprm.readcount" \
--output-file "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.filtered_fpfilter.vcf" --min-var-freq 0.02


########################################################################Analysis for Indels############################################################
java -jar /opt/apps/varscan-2.4.2/VarScan.v2.4.2.jar processSomatic \
"/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.indel.vcf" --min-tumor-freq 0.02

###########################Annotationg the variants using Annovar method #######################
egrep -v '#' "/scratch/csllab/Nilesh/Raw_data/nilesh/output/tumor.filtered_fpfilter.dream3.vcf" | awk '{print $1,"\t",$2,"\t",$3=length($4)+$2-1,"\t",$4,"\t",$5}' >> output/tumor.filtered_annovar_input.txt

############################################################Annotating the variants#########################################
perl "/scratch/csllab/Nilesh/Softwares/annovar/table_annovar.pl" output/tumor.filtered_annovar_input.txt /scratch/csllab/Nilesh/Softwares/annovar/humandb/ -buildver hg19 -out output/tumor.filtered_output_annovar -remove -protocol refGene,cytoBand,exac03,exac03nontcga,avsnp147,dbnsfp30a,esp6500si_all,nci60,icgc21,cosmic70,gnomad_exome,clinvar_20170905 -operation g,r,f,f,f,f,f,f,f,f,f,f -nastring . 










