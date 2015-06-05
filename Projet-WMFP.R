#choix du répertoire
setwd("/JLA/Sauvegarde/Dropbox/Santé")

#Library utilisée
library(dplyr)

#Ouverture des fichiers sources
acti  <- read.csv("./Withings - Activité Julien.csv")
poids  <- read.csv("./Withings - Poids Julien.csv")

#Création d'une nouvelle table pour le poids, a cause du format de Date
New_Table_Poids <- mutate(poids, Date = substr(Date,1,10))
Poids  <- select(New_Table_Poids, Date, Poids..kg.)

#Jointure des 2 fichiers
Final <- merge(acti,Poids, all = TRUE, sort = TRUE)
Withing  <- arrange(Final, Date, Pas, Distance..km., Calories, Poids..kg.)

#Export au format CSV
write.table(Withing, "data_withings.csv", row.names=FALSE, sep=",",dec=".", na=" ")

