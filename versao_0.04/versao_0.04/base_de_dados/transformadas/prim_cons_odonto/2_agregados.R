setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#Dimensão integralidade
#PREPARANDO A BASE
prim_cons_odonto <- read_csv("base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_ajustada_utf8.csv")
prim_cons_odonto$DATA <- as.yearmon(paste(prim_cons_odonto$ANO, prim_cons_odonto$MES), "%Y %m") #converntendo em formato date
prim_cons_odonto$AREA <- as.character(prim_cons_odonto$AREA)

#Transformando ano e mês em trimestre
prim_cons_odonto$TRIMESTRE <- as.yearqtr(prim_cons_odonto$DATA, format = "%d-%b-%y")
prim_cons_odonto$TRIMESTRE <- as.character(prim_cons_odonto$TRIMESTRE)

############################################################
#Equipes
############################################################
prim_cons_odonto_esf<-prim_cons_odonto[,c(1,2,5,6,8)]
prim_cons_odonto_esf<-aggregate(prim_cons_odonto_esf$QUANTIDADE, by = list(prim_cons_odonto_esf$DISTRITO, prim_cons_odonto_esf$UNIDADE,prim_cons_odonto_esf$AREA, prim_cons_odonto_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(prim_cons_odonto_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "VALOR")



############################################################
#CS
############################################################
prim_cons_odonto_cs<-prim_cons_odonto[,c(1,2,5,8)]
prim_cons_odonto_cs<-aggregate(prim_cons_odonto_cs$QUANTIDADE, by = list(prim_cons_odonto_cs$DISTRITO, prim_cons_odonto_cs$UNIDADE, prim_cons_odonto_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(prim_cons_odonto_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "VALOR")

############################################################
#Distrito
############################################################
prim_cons_odonto_distrito<-prim_cons_odonto[,c(1,5,8)]
prim_cons_odonto_distrito<-aggregate(prim_cons_odonto_distrito$QUANTIDADE, by = list(prim_cons_odonto_distrito$DISTRITO, prim_cons_odonto_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(prim_cons_odonto_distrito) <- c("DISTRITO", "TRIMESTRE", "VALOR")

############################################################
#Florianópolis
############################################################
prim_cons_odonto_florianopolis<-prim_cons_odonto[,c(5,8)]
prim_cons_odonto_florianopolis<-aggregate(prim_cons_odonto_florianopolis$QUANTIDADE, by = list( prim_cons_odonto_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(prim_cons_odonto_florianopolis) <- c("TRIMESTRE", "VALOR")


#Lendo as bases antigas
prim_cons_odonto_esf_old <- read_csv("base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_esf.csv", 
                                     col_types = cols(VALOR = col_double()))
prim_cons_odonto_cs_old <- read_csv("base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_cs.csv", 
                                    col_types = cols(VALOR = col_double()))
prim_cons_odonto_distrito_old <- read_csv("base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_distrito.csv", 
                                          col_types = cols(VALOR = col_double()))
prim_cons_odonto_florianopolis_old <- read_csv("base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_florianopolis.csv", 
                                               col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(prim_cons_odonto_esf_old, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_cs_old, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_distrito_old, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_florianopolis_old, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
prim_cons_odonto_esf_new <- rbind(prim_cons_odonto_esf, prim_cons_odonto_esf_old) 
prim_cons_odonto_cs_new <- rbind( prim_cons_odonto_cs, prim_cons_odonto_cs_old) 
prim_cons_odonto_distrito_new <- rbind(prim_cons_odonto_distrito, prim_cons_odonto_distrito_old) 
prim_cons_odonto_florianopolis_new <- rbind(prim_cons_odonto_florianopolis,prim_cons_odonto_florianopolis_old) 


#Escrever bases atualizadas
write.csv(prim_cons_odonto_esf_new, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_cs_new, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_distrito_new, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(prim_cons_odonto_florianopolis_new, "base_de_dados/transformadas/prim_cons_odonto/prim_cons_odonto_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)


