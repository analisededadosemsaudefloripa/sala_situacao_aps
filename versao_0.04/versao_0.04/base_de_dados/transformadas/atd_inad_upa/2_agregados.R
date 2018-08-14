setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
atd_inad_upa <- read_csv("base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_ajustada_utf8.csv")
atd_inad_upa$DATA <- as.yearmon(paste(atd_inad_upa$ANO, atd_inad_upa$MES), "%Y %m") #converntendo em formato date
atd_inad_upa$AREA <- as.character(atd_inad_upa$AREA)

#Transformando ano e mês em trimestre
atd_inad_upa$TRIMESTRE <- as.yearqtr(atd_inad_upa$DATA, format = "%d-%b-%y")
atd_inad_upa$TRIMESTRE <- as.character(atd_inad_upa$TRIMESTRE)
atd_inad_upa <- subset(atd_inad_upa, atd_inad_upa$TRIMESTRE != "2018 Q3")

############################################################
#Equipes
############################################################
atd_inad_upa_esf<-atd_inad_upa[,c(1,2,5,6,8)]
atd_inad_upa_esf<-aggregate(atd_inad_upa_esf$QUANTIDADE, by = list(atd_inad_upa_esf$DISTRITO, atd_inad_upa_esf$UNIDADE,atd_inad_upa_esf$AREA, atd_inad_upa_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(atd_inad_upa_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")



############################################################
#CS
############################################################
atd_inad_upa_cs<-atd_inad_upa[,c(1,2,5,8)]
atd_inad_upa_cs<-aggregate(atd_inad_upa_cs$QUANTIDADE, by = list(atd_inad_upa_cs$DISTRITO, atd_inad_upa_cs$UNIDADE, atd_inad_upa_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(atd_inad_upa_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "VALOR")

############################################################
#Distrito
############################################################
atd_inad_upa_distrito<-atd_inad_upa[,c(1,5,8)]
atd_inad_upa_distrito<-aggregate(atd_inad_upa_distrito$QUANTIDADE, by = list(atd_inad_upa_distrito$DISTRITO, atd_inad_upa_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(atd_inad_upa_distrito) <- c("DISTRITO", "TRIMESTRE", "VALOR")

############################################################
#Florianópolis
############################################################
atd_inad_upa_florianopolis<-atd_inad_upa[,c(5,8)]
atd_inad_upa_florianopolis<-aggregate(atd_inad_upa_florianopolis$QUANTIDADE, by = list( atd_inad_upa_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(atd_inad_upa_florianopolis) <- c("TRIMESTRE", "VALOR")


#Lendo as bases antigas
atd_inad_upa_esf_old <- read_csv("base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_esf.csv", 
                                 col_types = cols(VALOR = col_double()))
atd_inad_upa_cs_old <- read_csv("base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_cs.csv", 
                                col_types = cols(VALOR = col_double()))
atd_inad_upa_distrito_old <- read_csv("base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_distrito.csv", 
                                      col_types = cols(VALOR = col_double()))
atd_inad_upa_florianopolis_old <- read_csv("base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_florianopolis.csv", 
                                           col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(atd_inad_upa_esf_old, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_cs_old, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_distrito_old, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_florianopolis_old, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
atd_inad_upa_esf_new <- rbind(atd_inad_upa_esf, atd_inad_upa_esf_old) 
atd_inad_upa_cs_new <- rbind( atd_inad_upa_cs, atd_inad_upa_cs_old) 
atd_inad_upa_distrito_new <- rbind(atd_inad_upa_distrito, atd_inad_upa_distrito_old) 
atd_inad_upa_florianopolis_new <- rbind(atd_inad_upa_florianopolis,atd_inad_upa_florianopolis_old) 


#Escrever bases atualizadas
write.csv(atd_inad_upa_esf_new, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_cs_new, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_distrito_new, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(atd_inad_upa_florianopolis_new, "base_de_dados/transformadas/atd_inad_upa/atd_inad_upa_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)


                   
