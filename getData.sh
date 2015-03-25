mkdir exampleData

samtools view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/other_exome_alignments/NA19914/exome_alignment/NA19914.mapped.illumina.mosaik.ASW.exome.20111114.bam 22 | samtools view -bS - > exampleData/dna-seq/NA19914.chr22.bam
samtools view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/other_exome_alignments/NA19909/exome_alignment/NA19909.mapped.illumina.mosaik.ASW.exome.20111114.bam 22 | samtools view -bS - > exampleData/dna-seq/NA19909.chr22.bam
samtools view -h ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/other_exome_alignments/NA19916/exome_alignment/NA19916.mapped.illumina.mosaik.ASW.exome.20111114.bam 22 | samtools view -bS - > exampleData/dna-seq/NA19916.chr22.bam

samtools index exampleData/NA19914.chr22.bam
samtools index exampleData/NA19909.chr22.bam
samtools index exampleData/NA19916.chr22.bam


bam2fastq --output example.#.fq exampleData/NA19914.chr22.bam 

head -n 4000000 example._1.fq > exampleData/sample.fq

samtools mpileup -uf human_g1k_v37.fasta.gz resources/dna-seq/NA*.bam | bcftools view -bvcg - > chr22.raw.bcf 

bcftools view chr22.raw.bcf  | vcfutils.pl varFilter  -D100 > chr22.flt.vcf  

bgzip -c chr22.flt.vcf  > chr22.flt.vcf.gz

tabix -p vcf chr22.flt.vcf.gz
