# ==============================================================================
# Curso SITS/PRODES
# Aula 03 - Extração de séries temporais em cubos de dados multitemporais
# ==============================================================================


# ==============================================================================
# 1. Carregamento de bibliotecas
# ==============================================================================

library(sits)

library(sitsdata)
# Pacote auxiliar do SITS com datasets de exemplo para testes,
# aprendizado e validação.

library(sf)
# Pacote para manipulação de dados vetoriais espaciais em R.

library(tibble)
# Pacote para manipulação de tabelas no formato tibble.

library(dplyr)
# Pacote para manipulação eficiente de dados tabulares.

library(rstac)
# Pacote para interação com catálogos STAC, como o Brazil Data Cube.


# ==============================================================================
# 2. Diretórios, pastas e caminhos
# ==============================================================================

# 2.1 Criar diretório principal do curso
dir.create("~/curso_sits_prodes",
           recursive = TRUE,
           showWarnings = FALSE)

# 2.2 Definir caminho do diretório principal
main_dir_path <- "~/curso_sits_prodes"

# 2.3 Criar pasta para armazenar amostras
dir.create("~/curso_sits_prodes/samples",
           recursive = TRUE,
           showWarnings = FALSE)

# 2.4 Definir caminho da pasta de amostras
samples_path <- paste0(main_dir_path, "/samples")

# 2.5 Criar pasta para armazenar imagens locais
dir.create("~/curso_sits_prodes/images",
           recursive = TRUE,
           showWarnings = FALSE)

# 2.6 Definir caminho da pasta de imagens locais
images_path <- paste0(main_dir_path, "/images")

# ==============================================================================
# 3. Criação e exploração de cubos de dados multitemporais
# ==============================================================================
# ------------------------------------------------------------------------------
# 3.1 Criação de cubo temporal SENTINEL-2-16D
# ------------------------------------------------------------------------------

# Criar um cubo temporal utilizando a coleção regularizada
# SENTINEL-2-16D do Brazil Data Cube.

cube_015002 <- sits_cube(
  source = "BDC",
  collection = "SENTINEL-2-16D",
  tiles = "015002",
  bands = c("B11", "B08", "B04"),
  start_date = "2022-01-05",
  end_date = "2022-12-23"
)

# ------------------------------------------------------------------------------
# 3.2 Exploração da estrutura interna do cubo temporal
# ------------------------------------------------------------------------------

# O objeto cube_015002 é um tibble contendo metadados do cubo temporal.
# Algumas colunas armazenam informações sobre:
#
# - timeline
# - bandas
# - arquivos raster
# - ids das imagens
# - porcentagem de nuvens
# - localização dos arquivos
#
# Os comandos abaixo exploram algumas dessas informações internas.

# ------------------------------------------------------------------------------
# 3.2.1 Acessar informações internas das imagens do cubo
# ------------------------------------------------------------------------------

# Explicação:
#
# cube_015002[[12]]
# -> acessa a coluna "file_info"
#
# [[1]]
# -> acessa os metadados da primeira imagem do cubo

print(cube_015002[[12]][[1]])

# ------------------------------------------------------------------------------
# 3.2.2 Visualizar IDs das imagens do cubo temporal
# ------------------------------------------------------------------------------

# A função unique() remove repetições associadas às bandas espectrais.

unique(cube_015002[[12]][[1]][[1]])

# ------------------------------------------------------------------------------
# 3.2.3 Visualizar porcentagem de nuvens das imagens
# ------------------------------------------------------------------------------

# A coleção SENTINEL-2-16D possui metadados relacionados
# à cobertura de nuvens.

unique(cube_015002[[12]][[1]][[14]])

# ------------------------------------------------------------------------------
# 3.2.4 Visualizar timeline do cubo temporal
# ------------------------------------------------------------------------------

sits_timeline(cube_015002)

# ------------------------------------------------------------------------------
# 3.2.5 Visualizar bandas espectrais do cubo
# ------------------------------------------------------------------------------

sits_bands(cube_015002)

# ------------------------------------------------------------------------------
# 3.2.6 Plotar uma imagem do cubo temporal
# ------------------------------------------------------------------------------

# Importante:
# A data escolhida deve existir na timeline do cubo temporal.

plot(cube_015002, red = "B11", green = "B08", blue = "B04", date = "2022-11-01")

# ==============================================================================
# 4. Extração de séries temporais utilizando amostras espaciais
# ==============================================================================
# ------------------------------------------------------------------------------
# 4.1 Definir caminho do shapefile de amostras
# ------------------------------------------------------------------------------

# IMPORTANTE:
# Substitua o caminho abaixo pelo caminho correto do seu shapefile.

samp_path_015002 <- "~/curso_sits_prodes/samples/amostras_espaciais_15002.shp"

# ------------------------------------------------------------------------------
# 4.2 Carregar shapefile de amostras espaciais
# ------------------------------------------------------------------------------

# O shapefile contém:

# - geometrias espaciais (pontos)
# - rótulos/classes associados às amostras

# Essas amostras ainda NÃO representam séries temporais.
# Elas apenas indicam localizações espaciais rotuladas.

samples_015002 <- st_read(samp_path_015002)

# ------------------------------------------------------------------------------
# 4.3 Visualizar rótulos presentes no shapefile
# ------------------------------------------------------------------------------

unique(samples_015002[[1]])

# ------------------------------------------------------------------------------
# 4.4 Extração de séries temporais com sits_get_data()
# ------------------------------------------------------------------------------

# A função sits_get_data():
# 1. acessa cada ponto espacial do shapefile;
# 2. localiza os pixels correspondentes no cubo temporal;
# 3. extrai os valores espectrais ao longo do tempo;
# 4. associa os valores extraídos ao rótulo da amostra;

# O resultado é um dataset de séries temporais rotuladas.

timeseries_015002 <- sits_get_data(
  cube = cube_015002,
  samples = samples_015002,
  multicores = 3,
  progress = TRUE
)

# ------------------------------------------------------------------------------
# 4.5 Salvar séries temporais extraídas
# ------------------------------------------------------------------------------

# As séries temporais serão armazenadas em formato .rds.

# O formato .rds preserva:
# - estrutura do objeto
# - atributos
# - metadados

# Isso permite reutilizar os dados posteriormente sem necessidade de nova extração.

saveRDS(timeseries_015002, paste0(samples_path, "/series_temporais_015002.rds"))

# A função paste0() é utilizada para concatenar textos sem adicionar espaços.
# Neste caso, ela une: o caminho da pasta armazenado em samples_path + o nome do arquivo "series_temporais_015002.rds"

# Resultado esperado:
# "~/curso_sits_prodes/samples/series_temporais_015002.rds"

# ==============================================================================
# 5. Exploração das séries temporais extraídas
# ==============================================================================
# ------------------------------------------------------------------------------
# 5.1 Visualização espacial das amostras
# ------------------------------------------------------------------------------

sits_view(timeseries_015002)

# ------------------------------------------------------------------------------
# 5.2 Distribuição de amostras por classe
# ------------------------------------------------------------------------------

summary(timeseries_015002)

# ------------------------------------------------------------------------------
# 5.3 Visualização de padrões espectro-temporais
# ------------------------------------------------------------------------------

# A função sits_patterns() calcula padrões médios suavizados
# das séries temporais para cada classe.

plot(sits_patterns(timeseries_015002))

# ------------------------------------------------------------------------------
# 5.4 Exploração complementar do dataset
# ------------------------------------------------------------------------------

# Utilize funções das aulas anteriores para explorar:
#
# - timeline
# - bandas espectrais
# - instâncias específicas
# - padrões temporais
# - visualizações gráficas
#
# Exemplos:
#
# sits_timeline(timeseries_015002)
# sits_bands(timeseries_015002)
# plot(timeseries_015002)
# sits_select()
# sits_patterns()
#
        
