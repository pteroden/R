library(XML)
setwd("C:/Users/Piotrek/Desktop/PONS/Rosyjski")
file <- c("C:/Users/Piotrek/Desktop/PONS/Rosyjski/PONS.html")
doc <- htmlParse(file, useInternal = TRUE); rm(file)

# Lewa szpalta
lewe <- xpathSApply(doc, "//span[@class='left pull-left']", xmlValue, "class")
lewe <- gsub("\n        ", "", lewe)
lewe.lang <- xpathSApply(doc, "//span[@class='left pull-left']", xmlGetAttr, "data-pons-language")
lewe.dataset <- cbind(lewe.lang, lewe)
polskie1 <- lewe.dataset[lewe.dataset[, "lewe.lang"] == "pl", ]
rosyjskie1 <- lewe.dataset[lewe.dataset[, "lewe.lang"] == "ru", ]
rm(lewe, lewe.lang, lewe.dataset)

# Prawa szpalta
prawe <- xpathSApply(doc, "//span[@class='right pull-left']", xmlValue, "class")
prawe <- gsub("  \n          |\n          ", "", prawe)
prawe.lang <- xpathSApply(doc, "//span[@class='right pull-left']", xmlGetAttr, "data-pons-language")
prawe.dataset <- cbind(prawe.lang, prawe)
polskie2 <- prawe.dataset[prawe.dataset[, "prawe.lang"] == "pl", ]
rosyjskie2 <- prawe.dataset[prawe.dataset[, "prawe.lang"] == "ru", ]
rm(prawe, prawe.lang, prawe.dataset, doc)

# Kodowanie UTF-8
polskie1_utf8 <- iconv(polskie1, to='UTF-8')
rosyjskie1_utf8 <- iconv(rosyjskie1, to='UTF-8')
polskie2_utf8 <- iconv(polskie2, to='UTF-8')
rosyjskie2_utf8 <- iconv(rosyjskie2, to='UTF-8')
rm(polskie1, polskie2, rosyjskie1, rosyjskie2)

# Łączenie części 1 i 2
polskie <- rbind(polskie1_utf8, polskie2_utf8)
rosyjskie <- rbind(rosyjskie2_utf8, rosyjskie1_utf8)
rm(polskie1_utf8, polskie2_utf8, rosyjskie1_utf8, rosyjskie2_utf8)

# Łączenie w całość
wynik <- cbind(RU = rosyjskie[, "prawe"], PL = polskie[, "lewe"])

# Sprawdzanie duplikatów
wynik[duplicated(wynik[, "RU"], fromLast = TRUE), "PL"] <- paste(wynik[duplicated(wynik[, "RU"]), "PL"], wynik[duplicated(wynik[, "RU"], fromLast = TRUE), "PL"], sep = ", ")
wynik2 <- wynik[!duplicated(wynik[, "RU"]), ]


# # Wyróżnianie miękkich znaków
# # rosyjskie <- chartr("ь", "<font color=#aa00ff>ь</font>", rosyjskie)
# 
# Sys.setlocale(category = "LC_ALL", locale = "ru")
# rosyjskie <- gsub("ь", "<font color=#aa00ff>ь</font>", rosyjskie, perl = FALSE)
# rosyjskie1 <- gsub("<U+044C>", "<font color=#aa00ff><U+044C></font>", rosyjskie1)



# Eksport
write.table(x = wynik2, file = "rosyjski.csv", quote = TRUE, row.names = FALSE, col.names = FALSE)
