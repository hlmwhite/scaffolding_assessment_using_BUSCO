### cumulative_buscos.sh

cumulative buscos graph - comparative of buscos in increasing contig/scaffold size (or generally between assemblies)

Requires running busco for each desired assembly, then copying all full_table*.tsv files into a single directory.
run the cumulative_buscos.sh script (the R script r_graph.R must also be present). may also want to rename the '.tsv' 
files with their respective assembly prefixes.

This script takes into account ONE busco type (complete, fragmented and duplicated). Or for all, use the option " all ".

 >  ./cumulative_buscos.sh [busco type - frag, dup, comp, or all]

The output should resemble something like this...

![Image of canu_scaf](https://github.com/hlmwhite/PhD_scripts/blob/master/canu_scaf.png)
