#!/bin/bash

## cumulative buscos graph - comparative of buscos in increasing contig/scaffold size (or generally between assemblies)

## Requires running busco for each desired assembly, then copying all full_table*.tsv files into a single directory.
## run the cumulative_buscos.sh script (the R script r_graph.R must also be available! copy from bottom of this script).
## may also want to rename the  .tsv files with their respective assembly prefixes.

# This script takes into account ONE busco type (complete, fragmented and duplicated). Or for all, use the option " all ".
##   ./cumulative_buscos.sh [busco type - frag, dup, comp, or all]

grep1="$1"

# this requires editing to wherever the 'r_graph.R' file is present
cp /PATH/TO/r_graph.R .

for file in *tsv ; do

name=${file%.tsv}

mkdir work_dir_"$name"

if [ "$grep1" == "comp" ]; then
  grep 'Complete' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_complete_buscos.txt
elif
   [ "$grep1" == "frag" ]; then
  grep 'Fragmented' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_fragmented_buscos.txt
elif
   [ "$grep1" == "dup" ]; then
   grep 'Duplicated' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_duplicated_buscos.txt
elif
   [ "$grep1" == "all" ]; then
  grep 'Duplicated' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_duplicated_buscos.txt
  grep 'Complete' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_complete_buscos.txt
  grep 'Fragmented' "$file"  | awk '{print $3}'  > work_dir_"$name"/"$file"_fragmented_buscos.txt
else
        echo "Usage = ./cumulative_buscos.sh [busco type - frag (fragmented only), dup (duplicated only), comp (complete only), or all]"
        rm -r work_dir*
        exit 0
fi

cat work_dir_"$name"/"$file"_*_buscos.txt | sort -n | uniq -c | sort -n -r -k 1 | awk '{print $1}' | awk '{total += $0; $0 = total}1' > work_dir_"$name"/"$file"_points_to_plot

upper=$(wc -l work_dir_"$name"/*_points_to_plot | awk '{print $1}')

seq 1 $upper > work_dir_"$name"/count.list

paste work_dir_"$name"/count.list work_dir_"$name"/"$file"_points_to_plot | sed -e "s/$/\t$name/g"  > work_dir_"$name"/"$name".list

rm work_dir_"$name"/count.list

done

printf 'seq_num\tcumulative_buscos\tassembly\n' > header

cat header work_dir*/*list > for_R.coords

R CMD BATCH r_graph.R

rm -r work_dir* for_R.coords header r_graph.Rout Rplots.pdf

mv busco_plot.png "$grep1".png

#  r_graph.R

# dat<-read.table("for_R.coords", header=T)
# attach(dat)
# library(ggplot2)
# ggplot(dat, aes(seq_num, cumulative_buscos, group=assembly))+
# geom_line(aes(color=assembly))+
# geom_point(aes(color=assembly))+
# theme_classic()
# ggsave(file="busco_plot.png")
