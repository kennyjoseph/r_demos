##FROM https://github.com/geoffjentry/twitteR##

#I generally recommend that users track this GitHub version as opposed to the CRAN version as releases only happen every few months (if not more) and many fixes can show up in that time. Currently there's also a dependence on the github version of httr. To do this:

# Create a Twitter application at http://dev.twitter.com. Make sure to give the app read, write and direct message authority.
#Take note of the following values from the Twitter app page: "API key", "API secret", "Access token", and "Access token secret".

install.packages(c("devtools", "rjson", "bit64", "httr","igraph"))

#Make sure to restart your R session at this point
library(devtools)
install_github("geoffjentry/twitteR")
library(twitteR)

#The API key and API secret are from the Twitter app page above. This will lead you through httr's OAuth authentication process. I recommend you look at the man page for Token in httr for an explanation of how it handles caching.
#You should be ready to go!
setup_twitter_oauth("API KEY", "API SECRET")

source("demo_func.R")
library(igraph)

network_tweets <-  searchTwitter("#sna", n=300)
igraph_network <- get_reply_network(network_tweets)


##no retweets!
kennys_tweets <- userTimeline('kjoseph5', n=100)
igraph_kenny <- get_reply_network(kennys_tweets)

##how would we do a "snowball sample"?

