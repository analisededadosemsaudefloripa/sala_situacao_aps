setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)


#PREPARANDO A BASE
sifilis <- read_csv("base_de_dados/transformadas/sifilis/sifilis_ajustada_utf8.csv")
sifilis$DATA <- as.yearmon(paste(sifilis$ANO, sifilis$MES), "%Y %m") #converntendo em formato date
sifilis$AREA <- as.character(sifilis$AREA)

#Transformando ano e mês em trimestre
sifilis$TRIMESTRE <- as.yearqtr(sifilis$DATA, format = "%d-%b-%y")
sifilis$TRIMESTRE <- as.character(sifilis$TRIMESTRE)
sifilis <- subset(sifilis, sifilis$TRIMESTRE != "2018 Q3")


############################################################
#Equipes
############################################################
sifilis_esf<-sifilis[,c(1,2,5,6,7,9)]
sifilis_esf<-aggregate(sifilis_esf[,c(3,4)], by = list(sifilis_esf$DISTRITO, sifilis_esf$UNIDADE,sifilis_esf$AREA, sifilis_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(sifilis_esf) <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE", "CASOS", "TRATADOS")
#Calculando a percentagem
sifilis_esf$PERC_TRATAMENTO <- sifilis_esf$TRATADOS/sifilis_esf$CASOS*100
#Transformando em tidy
sifilis_esf <- melt(sifilis_esf, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(sifilis_esf)[5:6] <- c("TIPO", "VALOR")


############################################################
#CS
############################################################
sifilis_cs<-sifilis[,c(1,2,5,6,9)]
sifilis_cs<-aggregate(sifilis_cs[,c(3,4)], by = list(sifilis_cs$DISTRITO, sifilis_cs$UNIDADE, sifilis_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(sifilis_cs) <- c("DISTRITO", "UNIDADE", "TRIMESTRE", "CASOS", "TRATADOS")
#Calculando a percentagem
sifilis_cs$PERC_TRATAMENTO <- sifilis_cs$TRATADOS/sifilis_cs$CASOS*100
#Transformando em Tidy
sifilis_cs <- melt(sifilis_cs, id.var = c("DISTRITO", "UNIDADE", "TRIMESTRE"))
colnames(sifilis_cs)[4:5] <- c("TIPO", "VALOR")


############################################################
#Distrito
############################################################
sifilis_distrito<-sifilis[,c(1,5,6,9)]
sifilis_distrito<-aggregate(sifilis_distrito[,c(2,3)], by = list(sifilis_distrito$DISTRITO, sifilis_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(sifilis_distrito) <- c("DISTRITO", "TRIMESTRE", "CASOS", "TRATADOS")
#Calculando a percentagem
sifilis_distrito$PERC_TRATAMENTO <- sifilis_distrito$TRATADOS/sifilis_distrito$CASOS*100
#Transformando em Tidy
sifilis_distrito <- melt(sifilis_distrito, id.var = c("DISTRITO", "TRIMESTRE"))
colnames(sifilis_distrito)[3:4] <- c("TIPO", "VALOR")

############################################################
#Florianópolis
############################################################
sifilis_florianopolis<-sifilis[,c(5,6,9)]
sifilis_florianopolis<-aggregate(sifilis_florianopolis[,c(1,2)], by = list( sifilis_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(sifilis_florianopolis) <- c("TRIMESTRE", "CASOS", "TRATADOS")
#Calculando a percentagem
sifilis_florianopolis$PERC_TRATAMENTO <- sifilis_florianopolis$TRATADOS/sifilis_florianopolis$CASOS*100
#Transformando em Tidy
sifilis_florianopolis <- melt(sifilis_florianopolis, id.var = c("TRIMESTRE"))
colnames(sifilis_florianopolis)[2:3] <- c("TIPO", "VALOR")



#Lendo as bases antigas
sifilis_esf_old <- read_csv("base_de_dados/transformadas/sifilis/sifilis_esf.csv", 
                            col_types = cols(VALOR = col_double()))
sifilis_cs_old <- read_csv("base_de_dados/transformadas/sifilis/sifilis_cs.csv", 
                           col_types = cols(VALOR = col_double()))
sifilis_distrito_old <- read_csv("base_de_dados/transformadas/sifilis/sifilis_distrito.csv", 
                                 col_types = cols(VALOR = col_double()))
sifilis_florianopolis_old <- read_csv("base_de_dados/transformadas/sifilis/sifilis_florianopolis.csv", 
                                      col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(sifilis_esf_old, "base_de_dados/transformadas/sifilis/sifilis_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_cs_old, "base_de_dados/transformadas/sifilis/sifilis_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_distrito_old, "base_de_dados/transformadas/sifilis/sifilis_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_florianopolis_old, "base_de_dados/transformadas/sifilis/sifilis_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
sifilis_esf_new <- rbind(sifilis_esf, sifilis_esf_old) 
sifilis_cs_new <- rbind( sifilis_cs, sifilis_cs_old) 
sifilis_distrito_new <- rbind(sifilis_distrito, sifilis_distrito_old) 
sifilis_florianopolis_new <- rbind(sifilis_florianopolis,sifilis_florianopolis_old) 


#Escrever bases atualizadas
write.csv(sifilis_esf_new, "base_de_dados/transformadas/sifilis/sifilis_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_cs_new, "base_de_dados/transformadas/sifilis/sifilis_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_distrito_new, "base_de_dados/transformadas/sifilis/sifilis_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(sifilis_florianopolis_new, "base_de_dados/transformadas/sifilis/sifilis_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)




