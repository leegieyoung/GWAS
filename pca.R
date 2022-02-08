library(ggplot2)
pca <- read.table("PCA.txt", sep=" ", head=T)

png(filename="pca.png", width=60, height=50, units="cm", res=200)
ggplot(pca, aes(x=PC1, y=PC2, shape=name, colour=name)) + geom_point() + geom_text(aes(label=sample), size=7)
dev.off()
