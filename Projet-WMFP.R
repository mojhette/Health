#choix du répertoire
setwd("/JLA/Sauvegarde/Dropbox/Santé/Raw_Data")

#Library utilisée
library(dplyr)

#Ouverture des fichiers sources
acti  <- read.csv("./Withings - Activité Julien.csv")
poids  <- read.csv("./Withings - Poids Julien.csv")
cal2014  <- read.csv("./MyFitnessPal_Food_Data_2014.csv")
cal2015  <- read.csv("./MyFitnessPal_Food_Data_2015.csv")

#Création d'un seul fichier pour les calories
MFP  <- merge(cal2014,cal2015, all=TRUE, sort = TRUE)

#Création d'une nouvelle table pour le poids, a cause du format de Date
New_Table_Poids <- mutate(poids, Date = substr(Date,1,10), Poids = Poids..kg.)
Poids  <- select(New_Table_Poids, Date, Poids)

#Jointure des fichiers poids et activités
Final <- merge(acti,Poids, all = TRUE, sort = TRUE)
Withing  <- arrange(Final, Date, Pas, Distance..km., Calories, Poids)

# jointure avec le fichier des claories
Global  <-  merge(Withing, MFP, all = TRUE, sort = TRUE)

#Export au format CSV
write.table(Global, "data_health.csv", row.names=FALSE, sep=",",dec=".", na=" ")
