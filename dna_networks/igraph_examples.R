##Install missing packages that we'll use here
packages <- c("ggplot2", "dplyr","igraph")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

##load these packages into your environment
library(igraph)
library(dplyr)
library(ggplot2)

##load in the Senate voting network data
votes_network <- read.csv("vote_network.csv",sep="\t")

##take a look at some info about the data
head(votes_network)
nrow(votes_network)
##how many Senators do we have?
length(unique(c(votes_network$name1,votes_network$name2)))

##summary statistics for the edge weights
mean(votes_network$weight)
sd(votes_network$weight)

##plot the edge weight distribution
ggplot(votes_network, aes(weight))+ geom_histogram()

##lets use dplyr to filter out low-weight edges
##see http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html 
###for a dplyr intro
votes_network <- filter(votes_network, weight > 60)

##lets look at the edge weight distribution now
ggplot(votes_network, aes(weight))+ geom_histogram()

##okay, lets construct the network from the voting data
igraph_vote_net <- graph.data.frame(votes_network)

##check the edge distribution
mean(E(igraph_vote_net)$weight)

##ugh, this plot is ugly! Lets make it prettier
##check out your options at ?igraph.plotting
plot(igraph_vote_net)

##much nicer 
plot(igraph_vote_net,
     layout=layout.kamada.kawai,
     vertex.size=3,
     vertex.label=NA,
     edge.width=log(E(igraph_vote_net)$weight+1)-3,
     edge.arrow.size=0)

##do some community detection
mc <- multilevel.community(igraph_vote_net)

##oops! have to make it undirected
igraph_vote_undir <- as.undirected(igraph_vote_net,
                                   mode="collapse",
                                   edge.attr.comb=list(weight=mean))

##now do the clustering and then plot
mc <- multilevel.community(igraph_vote_undir)
plot(mc,igraph_vote_net,
     layout=layout.kamada.kawai,
     vertex.size=5,
     vertex.label=NA,
     edge.arrow.size=0)

##lets re-get the edge list (handy). Note edges are stored as indexes!
edgelist <- cbind(get.edgelist(igraph_vote_net,names=F), E(igraph_vote_net)$weight)

##get the components
comps <- clusters(igraph_vote_net, mode="weak")

##run some other metrics
metric_list = list(
  n_nodes=vcount(igraph_vote_net),
  n_edge=ecount(igraph_vote_net),
  density = graph.density(igraph_vote_net),
  mean_tie_str = mean(E(igraph_vote_net)$weight),
  n_components=comps$no,
  modularity = max(mc$modularity))

