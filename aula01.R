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

# 2. Diretórios, pastas e caminhos:

# criação de diretório principal
dir.create("~/curso_sits_prodes", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para o diretório principal
main_dir_path <- ("~/curso_sits_prodes")

# criação de pasta de amostras
dir.create("~/curso_sits_prodes/samples_path", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para a pasta de amostras
samples_path <- paste0(main_dir_path,"samples_path")

# criação de pasta de imagens locais
dir.create("~/curso_sits_prodes/images_path", recursive = TRUE, showWarnings = FALSE)

# definição do caminho para a pasta de amostras
images_path <- paste0(main_dir_path,"images_path")

###################################### // ###################################### // ######################################

##### 3. Cubos de dados multitemporais:

### 3.1 Cubo não-regular
# usar a função sits_cube para criar cubo de dados.

cube <- sits_cube(
  source = "MPC",                 # definir o provedor das imagens ARD
  collection = "SENTINEL-2-L2A",  # definir o provedor de coleção de imagens ARD
  bands = c("B11", "B8A", "B04"), # definir bandas espectrais 
  tiles = "20LMR",                # definir o tile para seleção de imagens
  start_date = '2022-08-23',      # data inicial do cubo
  end_date = '2022-12-23'         # data final do cubo
)

## 3.1.1 Visualizar (print) timeline do cubo temporal
sits_timeline(cube_reg)

## 3.1.2 Visualizar (print) das bandas especrtrais do cubo temporal
sits_bands(cube_reg)

## 3.1.3 Visualizar (plot) imagem do cubo temporal não-regular
plot(cube, red = "B11", green = "B8A", blue = "B04", date = "2022-11-24")

### 3.2 Cubo regularizado
cube_reg <- sits_cube(
  source = "MPC", 
  collection = "SENTINEL-2-L2A",
  tiles = "20LMR",
  bands = c("B11", "B8A","B08", "B04"), 
  start_date = '2022-08-23', 
  end_date = '2022-12-23',
  data_dir =  images_path
)

## 3.2.1 Visualizar (print) timeline do cubo temporal
sits_timeline(cube_reg)

## 3.2.2 Visualizar (plot) imagem do cubo temporal
plot(cube_reg, red = "B11", green = "B8A", blue = "B04", date = "2022-11-21")

###################################### // ###################################### // ######################################

##### 4. Operação com Cubos de dados multitemporais:

### 4.1 Calculando NDVI

## 4.1.1 Selecionando bandas para operação
cube_ndvi <- sits_select(cube_reg,                                           
                         bands = c('B11', 'B08', 'B04'), # seleção de bandas                        
                         start_date = '2022-09-23',                          
                         end_date = '2022-12-23')  

## 4.1.2 Operação com bandas espectrais no cubo temporal
cube_ndvi <- sits_apply (cube_ndvi,                      # reutilização do cubo com as bandas selecionadas
                         NDVI = (B08 - B04)/(B08 + B04), # operação matemática com as bandas
                         output_dir = images_path)       # pasta onde os arquivo serão salvos

## 4.1.3 Visualizar (plot) imagem NDVI do cubo temporal
plot(cube_ndvi, band = "NDVI", date = "2022-11-21")
