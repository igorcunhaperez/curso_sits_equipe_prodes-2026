# ==============================================================================
# Curso SITS/PRODES
# Aula 01 - Criação e manipulação de cubos de dados multitemporais
# ==============================================================================

# nota: as imagens utilizadas para construção do cubo regularizado estão disponíveis no link do dropbox indicado no tópico 2.6

# ==============================================================================
# 1. Carregamento de bibliotecas
# ==============================================================================

library(sits)

library(sitsdata)
# Pacote auxiliar do SITS com datasets de exemplo para testes, aprendizado e
# validação.

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
dir.create("~/curso_sits_prodes", recursive = TRUE, showWarnings = FALSE)

# 2.2 Definir caminho do diretório principal
main_dir_path <- "~/curso_sits_prodes"

# 2.3 Criar pasta para armazenar amostras
dir.create("~/curso_sits_prodes/samples", recursive = TRUE, showWarnings = FALSE)

# 2.4 Definir caminho da pasta de amostras
samples_path <- paste0(main_dir_path, "/samples")

# 2.5 Criar pasta para armazenar imagens locais
dir.create("~/curso_sits_prodes/images", recursive = TRUE, showWarnings = FALSE)

# 2.6 Definir caminho da pasta de imagens locais
images_path <- paste0(main_dir_path, "/images")

# as imagens estão disponíveis em: https://www.dropbox.com/scl/fo/i59k23t3a3ur42xnxrf0t/AIK0g2rk4TDJQ-eyv17uJKI/inst/extdata/images?rlkey=gvdctc8hmiu1947i2ysmie3st&subfolder_nav_tracking=1&st=kp1ft35y&dl=0
# é necessário que essas imagens estejam na pasta "images"


# ==============================================================================
# 3. Cubos de dados multitemporais
# ==============================================================================


# ------------------------------------------------------------------------------
# 3.1 Criação de cubo não regular
# ------------------------------------------------------------------------------

# Criar um cubo de dados a partir da coleção SENTINEL-2-L2A.
cube <- sits_cube(
  source = "MPC",                 # provedor das imagens ARD
  collection = "SENTINEL-2-L2A",  # coleção de imagens ARD
  bands = c("B11", "B8A", "B04"), # bandas espectrais selecionadas
  tiles = "20LMR",                # tile de interesse
  start_date = "2022-08-23",      # data inicial
  end_date = "2022-12-23"         # data final
)

# 3.1.1 Visualizar timeline do cubo não regular
sits_timeline(cube)

# 3.1.2 Visualizar bandas espectrais do cubo não regular
sits_bands(cube)

# 3.1.3 Plotar imagem do cubo não regular
plot(
  cube,
  red = "B11",
  green = "B8A",
  blue = "B04",
  date = "2022-11-24"
)


# ------------------------------------------------------------------------------
# 3.2 Criação de cubo com dados locais
# ------------------------------------------------------------------------------

# Criar cubo e armazenar os dados localmente no diretório images_path.
cube_reg <- sits_cube(
  source = "MPC",
  collection = "SENTINEL-2-L2A",
  tiles = "20LMR",
  bands = c("B11", "B8A", "B08", "B04"),
  start_date = "2022-08-23",
  end_date = "2022-12-23",
  data_dir = images_path
)

# 3.2.1 Visualizar timeline do cubo
sits_timeline(cube_reg)

# 3.2.2 Visualizar bandas espectrais do cubo
sits_bands(cube_reg)

# 3.2.3 Plotar imagem do cubo
plot(
  cube_reg,
  red = "B11",
  green = "B8A",
  blue = "B04",
  date = "2022-11-21"
)


# ==============================================================================
# 4. Operações com cubos de dados multitemporais
# ==============================================================================


# ------------------------------------------------------------------------------
# 4.1 Cálculo do NDVI
# ------------------------------------------------------------------------------

# 4.1.1 Selecionar bandas e intervalo temporal para o cálculo do NDVI
cube_ndvi <- sits_select(
  cube_reg,
  bands = c("B11", "B08", "B04"),
  start_date = "2022-09-23",
  end_date = "2022-12-23"
)

# 4.1.2 Calcular NDVI a partir das bandas B08 e B04
cube_ndvi <- sits_apply(
  cube_ndvi,
  NDVI = (B08 - B04) / (B08 + B04),
  output_dir = images_path
)

# 4.1.3 Plotar imagem NDVI em uma data específica
plot(
  cube_ndvi,
  band = "NDVI",
  date = "2022-11-21"
)
