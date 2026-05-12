# 1. Instalando as bibliotecas e os pacotes:

library(sits)

library(sitsdata)
# https://github.com/e-sensing/sitsdata 
# A sits auxiliary package that provides example datasets for testing, learning, and validating sits functions.
# Contains ready-made data cubes and time series examples.

library(sf)
# https://r-spatial.github.io/sf/
# Pacote para manipulação de dados vetoriais espaciais em R (uma alternativa moderna ao sp).
# Permite trabalhar com shapefiles, GeoJSON e outros formatos vetoriais, além de realizar operações espaciais como interseções, buffers e transformações de projeção.

library(tibble)
# https://tibble.tidyverse.org/
# Pacote para manipulação de tabelas no formato tibble, uma versão moderna e aprimorada do data.frame.
# Oferece melhor visualização, indexação mais clara e integração perfeita com pacotes do tidyverse.

library(dplyr)
# https://dplyr.tidyverse.org/
# Pacote para manipulação eficiente de dados tabulares.
# Permite realizar operações como filtrar, selecionar, modificar, resumir e agrupar de forma clara, rápida e legível.
# Essencial para análise de dados, especialmente em fluxos de trabalho do tidyverse.

library(rstac)
# https://brazil-data-cube.github.io/rstac/
# Pacote que permite interagir com catálogos de dados que seguem o padrão STAC (SpatioTemporal Asset Catalog).
# Facilita buscas, filtragem e acesso a metadados e ativos (imagens, mosaicos, coleções) hospedados em catálogos STAC, como BDC, AWS, etc.

###################################### // ###################################### // ######################################


rond <- samples_l8_rondonia_2bands
library(sitsdata)
devtools::install_github("e-sensing/sitsdata")


# 2. Diretórios, pastas e caminhos:

# criação de diretório principal
dir.create("~/curso_sits_prodes", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para o diretório principal
main_dir_path <- ("~/curso_sits_prodes")

# criação de pasta de amostras
dir.create("~/curso_sits_prodes/samples_path/", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para a pasta de amostras
samples_path <- paste0(main_dir_path,"/samples_path")

# criação de pasta de imagens locais
dir.create("~/curso_sits_prodes/images_path", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para a pasta de amostras
images_path <- paste0(main_dir_path,"/images_path")



###################################### // ###################################### // ######################################

# caminho para acessar o dataset
samples_rond_path <- paste0(samples_path, "/deforestation_samples_v18.rds")


# Carregando o arquivo dataset
def_rond_samples_v18 <- readRDS(samples_rond_path)

#____________________________________ /____________________________________

# 6.2 Exploração do dataset

### Visualização da espacialização do dataset
sits_view(def_rond_samples_v18)

### Balanceamento e propocionalidade do dataset por classe (label)
summary(def_rond_samples_v18)

#____________________________________ /____________________________________

### Visualização (print) de informações do dataset

## Exemplos:

# Visualizando da (linha 1 até linha 10 e coluna 1 até 7)
print(def_rond_samples_v18)[1:10 , 1:7] 
                                
# Visualizando as 100 primeiras linhas
print(def_rond_samples_v18, n=100)

#____________________________________ /____________________________________

### Visualizando das datas que compoem a série temporal

## Exemplos:

# Visualizando a serie temporal completa do dataset
sits_timeline(def_rond_samples_v18)

# Visualizando a primeira data da série temporal
sits_timeline(def_rond_samples_v18)[1]

# Visualizando a última data da série temporal

# Quantifica a o número de datas 
quant_datas <- length(def_rond_samples_v18) 

# Realiza o print reutilizando o numero registrado em quant_datas
sits_timeline(def_rond_samples_v18)[quant_datas]

# ou

# Encadeamento de operações para visualizar
sits_timeline(def_rond_samples_v18)[length(def_rond_samples_v18)]

#____________________________________ /____________________________________
### Filtragem e manipulação do dataset

### Filtrando sérites temporais do dataset
def_rond_samples_v18_select <- sits_select(data = def_rond_samples_v18, 
                                           labels = c("Clear_Cut_Bare_Soil", "Clear_Cut_Vegetation"),
                                           bands = c("B11", "B08", "B04"),
                                           #start_date = "2022-01-05",
                                           #end_date = "2022-03-10"
                                           )


### Visualização espacial de amostras das classes (labels) selecionadas 
sits_view(def_rond_samples_v18_select)

### Bandas selecionadas
sits_bands(def_rond_samples_v18_select)

### Visualização da timeline selecionada (start e end_date)
sits_timeline(def_rond_samples_v18_select)
  

###################################### // ###################################### // ######################################

# Visualização de gráficos dos padrões espectro-temporais

# Plot das séries temporais de todas as bandas e classes (labels) do dataset.
# Esse plot é o mais demorado pois gera o conjunto de gráficos completo (bandas x classes)
# No exemplo do dataset avaliado: 10 bandas x 9 classes =  90 gráficos
plot(def_rond_samples_v18)

# Plot de gráficos suavizados usando Generalized additive model (GAM)
# Esse plot apresenta gráficos simplificados representando os padrões espectro-temporais das classes
# Os gráficos são agrupados e simplificam a interpretação dos padrões
plot(sits_patterns(def_rond_samples_v18))

# Visualização de instância (linha) do dataset
# Seleção da instância 5 do dataset
def_rond_samples_v18|> slice(5)|> print() # printar informações da instância
def_rond_samples_v18|> slice(5)|> plot()  # plot das séries temporais de cada banda da instância

# Encadeamento de funções para filtragem de dataset e visualização de séries temporais
# Exemplo 01 : 
def_rond_samples_v18|> sits_select(bands = c("B11"),                  # seleção apenas da banda B11
                                   labels = c("Clear_Cut_Bare_Soil"), # seleção das classes
                                   start_date ="2022-03-05",  # "2022-01-05" (data inicial original)
                                   end_date =  "2022-09-23",  # "2022-12-23" (data final original)
                                   )|> plot() # encadeamento com a função plot()

# No exemplo acima foram encadeadas 2 funções apenas:
# def_rond_samples_v18 |> sits_select() |> plot()

# Exemplo02: 
def_rond_samples_v18|> sits_select(bands = c("B11"),         # seleção apenas da banda B11
                                   labels = c("Forest"),     # seleção das classes
                                   start_date ="2022-03-05", # "2022-01-05" (data inicial original)
                                   end_date =  "2022-09-23", # "2022-12-23" (data final original)
                                   ) |> sits_patterns() |> plot() # encadeamento com a funçãosits_patterns() e plot()

# def_rond_samples_v18 |> sits_select() |> sits_patterns() |> plot()
