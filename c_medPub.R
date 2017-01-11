
### http://datascienceplus.com/search-pubmed-with-rismed/
## http://davetang.org/muse/2013/10/31/querying-pubmed-using-r/
### RISmed package


## PubMed, RISmed, 


library(RISmed)
res <- EUtilsSummary("oxalate", type="esearch", db="pubmed", 
                     datetype='pdat', mindate=2016, maxdate=2016, retmax=100)
head(res)
class(res)

QueryCount(res)
# t is character vector
t<-ArticleTitle(EUtilsGet(res))   # patience!

t

typeof(t)
# "character"



# careful with NA
y <- YearPubmed(EUtilsGet(res))
r <- YearReceived(EUtilsGet(res))

head(y)




################# another
## http://amunategui.github.io/pubmed-query/




