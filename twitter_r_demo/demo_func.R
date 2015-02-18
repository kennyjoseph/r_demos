library(igraph)

get_reply_network <- function(tweets){
  df <- data.frame(sender=c(),receiver=c())
  ##for each tweet
  for(t in tweets){
    ##if it is a reply
    if(length(t$replyToSN) > 0){
      ##print the link
      print(paste0(t$screenName,"->",t$replyToSN))
      ##add the link to our set of replies
      if(t$screenName != t$replyToSN){
        df <- rbind(df,data.frame(sender=t$screenName,receiver=t$replyToSN))
      }
    }
  }
  ##return an igraph object
  return(graph.data.frame(df))
}