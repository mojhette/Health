#choix du répertoire
setwd("/JLA/Sauvegarde/Dropbox/Santé/Raw_Data")

#Library utilisée
library(dplyr)

#Ouverture des fichiers sources
acti  <- read.csv("./Withings - Activité Julien.csv")
poids  <- read.csv("./Withings - Poids Julien.csv")
cal2014  <- read.csv("./MyFitnessPal_Food_Data_2014.csv")
cal2015  <- read.csv("./MyFitnessPal_Food_Data_2015.csv")
Jawbone  <- read.csv("./Jawbone.csv")

#Modification du fichier d'historique Jawbone
JB  <- select(Jawbone, DATE, m_calories, m_steps, m_distance, weight)
JB  <- mutate(JB, Date = as.Date(as.character(DATE),"%Y%m%d"), Cal_Burned = m_calories, Pas = m_steps, Distance = (m_distance)/1000, Weight = weight)
JB  <- select(JB, Date, Cal_Burned, Pas, Distance, Weight)

#Création d'un seul fichier pour les calories
MFP  <- rbind(cal2014,cal2015)

#Modification du format de date dans les fichiers MyFitnessPal
Final_MFP  <- mutate(MFP, Date  = as.Date(Date, "%d-%b-%y"))

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

#Export au format CSV
write.table(Global, "data_health.csv", row.names=FALSE, sep=",",dec=".", na=" ")