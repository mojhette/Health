#Library utilisée
library(dplyr)

#choix du répertoire pour le changement des csv MFP
setwd("/JLA/Sauvegarde/Dropbox/Santé/Raw_Data/Export_MFP/")
file_list <- list.files()
MFP <- do.call("rbind",lapply(file_list, FUN=function(files){read.csv(files)}))

#Modification du format de date dans les fichiers MyFitnessPal
Final_MFP  <- mutate(MFP, Date  = as.Date(Date, "%d-%b-%y"))

#choix du répertoire pour la suite
setwd("/JLA/Sauvegarde/Dropbox/Santé/Raw_Data/")

#Systeme de location pour le format des dates
lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")

#Ouverture des fichiers sources Jawbone et Withings
acti  <- read.csv("./Withings - Activité Julien.csv")
poids  <- read.csv("./Withings - Poids Julien.csv")
Jawbone  <- read.csv("./Jawbone.csv")

#Modification du fichier d'historique Jawbone
JB  <- select(Jawbone, DATE, m_calories, m_steps, m_distance, weight)
JB  <- mutate(JB, Date = as.Date(as.character(DATE),"%Y%m%d"), Cal_Burned = m_calories, Pas = m_steps, Distance = (m_distance)/1000, Weight = weight)
JB  <- select(JB, Date, Cal_Burned, Pas, Distance, Weight)

#Création d'une nouvelle table pour le poids, a cause du format de Date
New_Table_Poids <- mutate(poids, Date = substr(Date,1,10), Weight = Poids..kg.)
Poids  <- select(New_Table_Poids, Date, Weight)

#Renommage dans le fichier d'activité
Activity  <- mutate(acti, Date, Pas, Cal_Burned = Calories, Distance = Distance..km.)

#Jointure des fichiers poids et activités
Final <- merge(Activity,Poids, all = TRUE, sort = TRUE)
Withing  <- select(Final, Date, Pas, Distance, Cal_Burned, Weight)
Withing  <- mutate(Withing, Date = as.Date(Date))

#Dédoublonnage des valeurs de poids
Withing  <- distinct(Withing, Date)
JB  <- distinct(JB, Date)
JB  <- filter(JB, Date < "2014-12-11")

#fusion des données de Jawbone et Withing
Withing_JB  <- rbind(Withing,JB)
Withing_JB  <- distinct(Withing_JB, Date)

# jointure avec le fichier des calories
Global  <-  merge(Withing_JB, Final_MFP, all = TRUE, sort = TRUE)
View(Global)

#Export au format CSV et visualisation des résultats
write.table(Global, "data_health.csv", row.names=FALSE, sep=",",dec=".", na=" ")