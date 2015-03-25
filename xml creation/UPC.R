setwd("C:/Users/Piotrek/Desktop/UPC/")

all <- read.csv(file = "./csv/all.csv", header = TRUE, sep = ";", nrow = 15)
fb <- read.csv(file = "./csv/fb.csv", header = TRUE, sep = ";", nrow = 15)

all[, c("picture", "FULL.URL.", "gemius.AV")] <- list(NULL)
fbAdd <- fb[, c("Offer.ID.", "FB.Copy...title", "FB.COPY...copy", "FULL.LANDING.URL_v1._.ORIGINAL...difference..gemius.pre.tag.of.the.link.")]
names(fbAdd) <- c("OfferID", "FBtitle", "FBcopy", "FullUrl1")
names(all) <- c("pictureUrl", "Service", "OfferID", "Category", "ShortDescName", "ShortDescBody", "Price", "LegalNote", "FullURL")
mergedData = merge(all, fbAdd, by.x = "OfferID", by.y = "OfferID")

library(XML)

n = xmlNode("Offers")

for(i in 1:nrow(mergedData)){
      n = append.xmlNode(n, xmlNode("Offer",
                                    xmlNode(names(mergedData)[1], mergedData[i,1]),
                                    xmlNode(names(mergedData)[2], mergedData[i,2]),
                                    xmlNode(names(mergedData)[3], mergedData[i,3]),
                                    xmlNode(names(mergedData)[4], mergedData[i,4]),
                                    xmlNode(names(mergedData)[5], mergedData[i,5]),
                                    xmlNode(names(mergedData)[6], mergedData[i,6]),
                                    xmlNode(names(mergedData)[7], mergedData[i,7]),
                                    xmlNode(names(mergedData)[8], mergedData[i,8]),
                                    xmlNode(names(mergedData)[9], mergedData[i,9]),
                                    xmlNode(names(mergedData)[10], mergedData[i,10]),
                                    xmlNode(names(mergedData)[11], mergedData[i,11]),
                                    xmlNode(names(mergedData)[12], mergedData[i,12])))
}


a <- toString.XMLNode(n)
write.table(a, file = "upc.xml", fileEncoding = "UTF-8", quote = FALSE, row.names = FALSE, col.names = FALSE)

