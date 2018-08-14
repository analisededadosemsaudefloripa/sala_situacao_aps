setwd("~/ShinyApps/aps/producao")
#Organizando os dados
#Pacotes
library(readr)
library(tidyverse)
library(DT)
library(reshape2)


#Dimensão acesso
##Pacientes diferentes
pacientes_diferentes <- read_csv("base_de_dados/extraidas/pacientes_diferentes/pacientes_diferentes.csv", 
                                 col_names = T)
names(pacientes_diferentes) <- c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES", "Médico e Enfermeiro", "Enfermeiro", "Médico", "Odontólogo", "Total")
pacientes_diferentes <- melt(pacientes_diferentes, id.vars = c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES"), measure.vars = c("Médico e Enfermeiro", "Enfermeiro", "Médico", "Odontólogo", "Total"))
names(pacientes_diferentes) <- c("DISTRITO", "UNIDADE", "AREA", "ANO", "MES", "ESPECIALIDADE", "VALOR")

#Escrevendo tabela pronta completa pronta
write.csv(pacientes_diferentes, "base_de_dados/transformadas/pacientes_diferentes/pacientes_diferentes_ajustada_utf8.csv", fileEncoding = "UTF-8", row.names=FALSE)


