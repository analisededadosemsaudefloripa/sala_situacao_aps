setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
tratam_compl_odonto <- read_csv("base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_ajustada_utf8.csv")
tratam_compl_odonto$DATA <- as.yearmon(paste(tratam_compl_odonto$ANO, tratam_compl_odonto$MES), "%Y %m") #converntendo em formato date
tratam_compl_odonto$AREA <- as.character(tratam_compl_odonto$AREA)

#Transformando ano e mês em trimestre
tratam_compl_odonto$TRIMESTRE <- as.yearqtr(tratam_compl_odonto$DATA, format = "%d-%b-%y")
tratam_compl_odonto$TRIMESTRE <- as.character(tratam_compl_odonto$TRIMESTRE)

############################################################
#Equipes
############################################################
tratam_compl_odonto_esf<-tratam_compl_odonto[,c(1,2,5,6,8)]
tratam_compl_odonto_esf<-aggregate(tratam_compl_odonto_esf$QUANTIDADE, by = list(tratam_compl_odonto_esf$DISTRITO, tratam_compl_odonto_esf$UNIDADE,tratam_compl_odonto_esf$AREA, tratam_compl_odonto_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(tratam_compl_odonto_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")



############################################################
#CS
############################################################
tratam_compl_odonto_cs<-tratam_compl_odonto[,c(1,2,5,8)]
tratam_compl_odonto_cs<-aggregate(tratam_compl_odonto_cs$QUANTIDADE, by = list(tratam_compl_odonto_cs$DISTRITO, tratam_compl_odonto_cs$UNIDADE, tratam_compl_odonto_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(tratam_compl_odonto_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "VALOR")

############################################################
#Distrito
############################################################
tratam_compl_odonto_distrito<-tratam_compl_odonto[,c(1,5,8)]
tratam_compl_odonto_distrito<-aggregate(tratam_compl_odonto_distrito$QUANTIDADE, by = list(tratam_compl_odonto_distrito$DISTRITO, tratam_compl_odonto_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(tratam_compl_odonto_distrito) <- c("DISTRITO", "TRIMESTRE", "VALOR")

############################################################
#Florianópolis
############################################################
tratam_compl_odonto_florianopolis<-tratam_compl_odonto[,c(5,8)]
tratam_compl_odonto_florianopolis<-aggregate(tratam_compl_odonto_florianopolis$QUANTIDADE, by = list( tratam_compl_odonto_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(tratam_compl_odonto_florianopolis) <- c("TRIMESTRE", "VALOR")


#Lendo as bases antigas
tratam_compl_odonto_esf_old <- read_csv("base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_esf.csv", 
                                        col_types = cols(VALOR = col_double()))
tratam_compl_odonto_cs_old <- read_csv("base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_cs.csv", 
                                       col_types = cols(VALOR = col_double()))
tratam_compl_odonto_distrito_old <- read_csv("base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_distrito.csv", 
                                             col_types = cols(VALOR = col_double()))
tratam_compl_odonto_florianopolis_old <- read_csv("base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_florianopolis.csv", 
                                                  col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(tratam_compl_odonto_esf_old, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_cs_old, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_distrito_old, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_florianopolis_old, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
tratam_compl_odonto_esf_new <- rbind(tratam_compl_odonto_esf, tratam_compl_odonto_esf_old) 
tratam_compl_odonto_cs_new <- rbind( tratam_compl_odonto_cs, tratam_compl_odonto_cs_old) 
tratam_compl_odonto_distrito_new <- rbind(tratam_compl_odonto_distrito, tratam_compl_odonto_distrito_old) 
tratam_compl_odonto_florianopolis_new <- rbind(tratam_compl_odonto_florianopolis,tratam_compl_odonto_florianopolis_old) 


#Escrever bases atualizadas
write.csv(tratam_compl_odonto_esf_new, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_cs_new, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_distrito_new, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(tratam_compl_odonto_florianopolis_new, "base_de_dados/transformadas/tratam_compl_odonto/tratam_compl_odonto_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




