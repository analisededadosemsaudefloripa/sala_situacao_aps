setwd("~/ShinyApps/aps/producao")
#Tabela de contagem por áreas
library(readr)
library(tidyverse)
library(data.table)
library(zoo)



#Dimensão integralidade
#PREPARANDO A BASE
demanda_consulta <- read_csv("base_de_dados/transformadas/demanda_consulta/demanda_consulta_ajustada_utf8.csv")
demanda_consulta$DATA <- as.yearmon(paste(demanda_consulta$ANO, demanda_consulta$MES), "%Y %m") #converntendo em formato date
demanda_consulta$AREA <- as.character(demanda_consulta$AREA)


#Transformando ano e mês em trimestre
demanda_consulta$TRIMESTRE <- as.yearqtr(demanda_consulta$DATA, format = "%d-%b-%y")
demanda_consulta$TRIMESTRE <- as.character(demanda_consulta$TRIMESTRE)
demanda_consulta <- subset(demanda_consulta, demanda_consulta$TRIMESTRE != "2018 Q3")

############################################################
#Equipes
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
demanda_consulta_esf<-demanda_consulta[,c(1,2,5:14,16)]
demanda_consulta_esf$ESPONTANEA_ODO[is.na(demanda_consulta_esf$ESPONTANEA_ODO)] <- 0
demanda_consulta_esf<-aggregate(demanda_consulta_esf[,3:11], by = list(demanda_consulta_esf$DISTRITO, demanda_consulta_esf$UNIDADE,demanda_consulta_esf$AREA, demanda_consulta_esf$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(demanda_consulta_esf)[1:4] <- c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE")


#Calculando a porcentagem de demanda espontanea e agendada para médicos, enfermeiros e odontólogos
demanda_consulta_esf$PORCENT_ESP_MED <- round(demanda_consulta_esf$ESPONTANEA_MED/demanda_consulta_esf$CONS_MED *100, 2)
demanda_consulta_esf$PORCENT_ESP_ENF <- round(demanda_consulta_esf$ESPONTANEA_ENF/demanda_consulta_esf$CONS_ENF *100, 2)
demanda_consulta_esf$PORCENT_ESP_ODO <- round(demanda_consulta_esf$ESPONTANEA_ODO/demanda_consulta_esf$CONS_ODO *100, 2)

#data.frame só com a quantidade, retirado número de consultas totais, pois não será utilizado
demanda_consulta_esf <- demanda_consulta_esf[, c(1:4,14:16)]

#Transformando em Tidy
demanda_consulta_esf <- melt(demanda_consulta_esf, id.var = c("DISTRITO", "UNIDADE", "AREA", "TRIMESTRE"))
colnames(demanda_consulta_esf)[5:6] <- c("TIPO", "VALOR")



############################################################
#CS
############################################################
#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
demanda_consulta_cs<-demanda_consulta[,c(1,2,5:13,16)]
demanda_consulta_cs$ESPONTANEA_ODO[is.na(demanda_consulta_cs$ESPONTANEA_ODO)] <- 0
demanda_consulta_cs<-aggregate(demanda_consulta_cs[,3:11], by = list(demanda_consulta_cs$DISTRITO, demanda_consulta_cs$UNIDADE, demanda_consulta_cs$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(demanda_consulta_cs)[1:3] <- c("DISTRITO", "UNIDADE", "TRIMESTRE")


#Calculando a porcentagem de demanda espontanea e agendada para médicos, enfermeiros e odontólogos
demanda_consulta_cs$PORCENT_ESP_MED <- round(demanda_consulta_cs$ESPONTANEA_MED/demanda_consulta_cs$CONS_MED *100, 2)
demanda_consulta_cs$PORCENT_ESP_ENF <- round(demanda_consulta_cs$ESPONTANEA_ENF/demanda_consulta_cs$CONS_ENF *100, 2)
demanda_consulta_cs$PORCENT_ESP_ODO <- round(demanda_consulta_cs$ESPONTANEA_ODO/demanda_consulta_cs$CONS_ODO *100, 2)

#data.frame só com a quantidade, retirado número de consultas totais, pois não será utilizado
demanda_consulta_cs <- demanda_consulta_cs[, c(1:3,13:15)]

#Transformando em Tidy
demanda_consulta_cs <- melt(demanda_consulta_cs, id.var = c("DISTRITO", "UNIDADE", "TRIMESTRE"))
colnames(demanda_consulta_cs)[4:5] <- c("TIPO", "VALOR")


############################################################
#Distrito
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
demanda_consulta_distrito<-demanda_consulta[,c(1,5:13,16)]
demanda_consulta_distrito$ESPONTANEA_ODO[is.na(demanda_consulta_distrito$ESPONTANEA_ODO)] <- 0
demanda_consulta_distrito<-aggregate(demanda_consulta_distrito[,2:10], by = list(demanda_consulta_distrito$DISTRITO, demanda_consulta_distrito$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(demanda_consulta_distrito)[1:2] <- c("DISTRITO",  "TRIMESTRE")


#Calculando a porcentagem de demanda espontanea e agendada para médicos, enfermeiros e odontólogos
demanda_consulta_distrito$PORCENT_ESP_MED <- round(demanda_consulta_distrito$ESPONTANEA_MED/demanda_consulta_distrito$CONS_MED *100, 2)
demanda_consulta_distrito$PORCENT_ESP_ENF <- round(demanda_consulta_distrito$ESPONTANEA_ENF/demanda_consulta_distrito$CONS_ENF *100, 2)
demanda_consulta_distrito$PORCENT_ESP_ODO <- round(demanda_consulta_distrito$ESPONTANEA_ODO/demanda_consulta_distrito$CONS_ODO *100, 2)

#data.frame só com a quantidade, retirado número de consultas totais, pois não será utilizado
demanda_consulta_distrito <- demanda_consulta_distrito[, c(1:2,12:14)]

#Transformando em Tidy
demanda_consulta_distrito <- melt(demanda_consulta_distrito, id.var = c("DISTRITO", "TRIMESTRE"))
colnames(demanda_consulta_distrito)[3:4] <- c("TIPO", "VALOR")


############################################################
#Florianópolis
############################################################

#Contar por área e TRIMESTRE - retirado o total de consultas, pois não será utilizado
demanda_consulta_florianopolis<-demanda_consulta[,c(5:13,16)]
demanda_consulta_florianopolis$ESPONTANEA_ODO[is.na(demanda_consulta_florianopolis$ESPONTANEA_ODO)] <- 0
demanda_consulta_florianopolis<-aggregate(demanda_consulta_florianopolis[,1:9], by = list(demanda_consulta_florianopolis$TRIMESTRE), FUN = sum) #Como o trimestre é a composição de três meses, os valores precisam ser somados
colnames(demanda_consulta_florianopolis)[1] <- c("TRIMESTRE")


#Calculando a porcentagem de demanda espontanea e agendada para médicos, enfermeiros e odontólogos
demanda_consulta_florianopolis$PORCENT_ESP_MED <- round(demanda_consulta_florianopolis$ESPONTANEA_MED/demanda_consulta_florianopolis$CONS_MED *100, 2)
demanda_consulta_florianopolis$PORCENT_ESP_ENF <- round(demanda_consulta_florianopolis$ESPONTANEA_ENF/demanda_consulta_florianopolis$CONS_ENF *100, 2)
demanda_consulta_florianopolis$PORCENT_ESP_ODO <- round(demanda_consulta_florianopolis$ESPONTANEA_ODO/demanda_consulta_florianopolis$CONS_ODO *100, 2)

#data.frame só com a quantidade, retirado número de consultas totais, pois não será utilizado
demanda_consulta_florianopolis <- demanda_consulta_florianopolis[, c(1,11:13)]

#Transformando em Tidy
demanda_consulta_florianopolis <- melt(demanda_consulta_florianopolis, id.var = c("TRIMESTRE"))
colnames(demanda_consulta_florianopolis)[2:3] <- c("TIPO", "VALOR")


#Lendo as bases antigas
demanda_consulta_esf_old <- read_csv("base_de_dados/transformadas/demanda_consulta/demanda_consulta_esf.csv", 
                                     col_types = cols(VALOR = col_double()))
demanda_consulta_cs_old <- read_csv("base_de_dados/transformadas/demanda_consulta/demanda_consulta_cs.csv", 
                                    col_types = cols(VALOR = col_double()))
demanda_consulta_distrito_old <- read_csv("base_de_dados/transformadas/demanda_consulta/demanda_consulta_distrito.csv", 
                                          col_types = cols(VALOR = col_double()))
demanda_consulta_florianopolis_old <- read_csv("base_de_dados/transformadas/demanda_consulta/demanda_consulta_florianopolis.csv", 
                                               col_types = cols(VALOR = col_double()))

#Salvando as bases antigas como old
write.csv(demanda_consulta_esf_old, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_esf_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_cs_old, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_cs_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_distrito_old, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_distrito_old.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_florianopolis_old, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_florianopolis_old.csv", fileEncoding = "UTF-8", row.names = F)


#Fazendo rbind das bases antigas com as novas
demanda_consulta_esf_new <- rbind(demanda_consulta_esf, demanda_consulta_esf_old) 
demanda_consulta_cs_new <- rbind( demanda_consulta_cs, demanda_consulta_cs_old) 
demanda_consulta_distrito_new <- rbind(demanda_consulta_distrito, demanda_consulta_distrito_old) 
demanda_consulta_florianopolis_new <- rbind(demanda_consulta_florianopolis,demanda_consulta_florianopolis_old) 


#Escrever bases atualizadas
write.csv(demanda_consulta_esf_new, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_esf.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_cs_new, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_cs.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_distrito_new, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_distrito.csv", fileEncoding = "UTF-8", row.names = F)
write.csv(demanda_consulta_florianopolis_new, "base_de_dados/transformadas/demanda_consulta/demanda_consulta_florianopolis.csv", fileEncoding = "UTF-8", row.names = F)

                   
