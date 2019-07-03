dat<-read.table("for_R.coords", header=T)
attach(dat)
library(ggplot2)
ggplot(dat, aes(seq_num, cumulative_buscos, group=assembly))+
geom_line(aes(color=assembly))+
geom_point(aes(color=assembly))+
theme_classic()
ggsave(file="busco_plot.png")
