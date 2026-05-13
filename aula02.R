
# Curso SITS/PRODES
# Aula 02 - Exploração de amostras temporais com o pacote SITS

# ==============================================================================

# nota: Para essa aula, será utilizado o dataset Rondonia "deforestation_samples_v18", que é utilizado nos exemplos do sitsbook;
# mais informações em 2.1 https://e-sensing.github.io/sitsbook/intro_examples.html


# ==============================================================================
# 1. Carregamento de bibliotecas
# ==============================================================================

library(sits)

library(sitsdata)
# Pacote auxiliar do SITS com datasets de exemplo para testes, aprendizado e validação.

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
dir.create("~/curso_sits_prodes/samples/", recursive = TRUE, showWarnings = FALSE)

# 2.4 Definir caminho da pasta de amostras
samples_path <- paste0(main_dir_path, "/samples")

# 2.5 Criar pasta para armazenar imagens locais
dir.create("~/curso_sits_prodes/images", recursive = TRUE, showWarnings = FALSE)

# 2.6 Definir caminho da pasta de imagens locais
images_path <- paste0(main_dir_path, "/images")

# 2.7 Definir caminho do arquivo de amostras:
# este dataset está disponível em: 
# https://www.dropbox.com/scl/fo/i59k23t3a3ur42xnxrf0t/ACNB7UgZgO9dmv8pe2UNPQY/inst/extdata/samples?rlkey=gvdctc8hmiu1947i2ysmie3st&subfolder_nav_tracking=1&st=fby4dp1u&dl=0

# é necessário que dado deforestation_samples_v18.rds esteja na pasta "samples_path.
samples_rond_path <- paste0(samples_path, "/deforestation_samples_v18.rds")


# ==============================================================================
# 3. Exploração inicial do dataset
# ==============================================================================

# 3.1 Carregar arquivo de amostras
def_rond_samples_v18 <- readRDS(samples_rond_path)

# 3.2 Visualizar a distribuição espacial das amostras
sits_view(def_rond_samples_v18)

# 3.3 Verificar balanceamento e proporcionalidade das classes
summary(def_rond_samples_v18)


# ==============================================================================
# 4. Visualização tabular do dataset
# ==============================================================================

# 4.1 Visualizar linhas 1 a 10 e colunas 1 a 7
print(def_rond_samples_v18)[1:10, 1:7]

# 4.2 Visualizar as 50 primeiras linhas
print(def_rond_samples_v18, n = 50)


# ==============================================================================
# 5. Visualização da timeline das séries temporais
# ==============================================================================

# 5.1 Visualizar a timeline completa do dataset
sits_timeline(def_rond_samples_v18)

# 5.2 Visualizar a primeira data da série temporal
sits_timeline(def_rond_samples_v18)[1]

# 5.3 Visualizar a última data da série temporal

# Número de datas na timeline
quant_datas <- length(sits_timeline(def_rond_samples_v18))

# Última data usando o índice armazenado em quant_datas
sits_timeline(def_rond_samples_v18)[quant_datas]

# Alternativa direta
sits_timeline(def_rond_samples_v18)[length(sits_timeline(def_rond_samples_v18))]

# Alternativa mais simples
tail(sits_timeline(def_rond_samples_v18), 1)


# ==============================================================================
# 6. Filtragem e manipulação do dataset
# ==============================================================================

# 6.1 Selecionar classes, bandas e, opcionalmente, intervalo temporal
def_rond_samples_v18_select <- sits_select(
  data = def_rond_samples_v18,
  labels = c("Clear_Cut_Bare_Soil", "Clear_Cut_Vegetation"),
  bands = c("B11", "B08", "B04")
  # start_date = "2022-01-05",
  # end_date   = "2022-03-10"
)

# 6.2 Visualizar espacialmente as amostras selecionadas
sits_view(def_rond_samples_v18_select)

# 6.3 Verificar bandas selecionadas
sits_bands(def_rond_samples_v18_select)

# 6.4 Verificar timeline do dataset selecionado
sits_timeline(def_rond_samples_v18_select)


# ==============================================================================
# 7. Visualização dos padrões espectro-temporais
# ==============================================================================

# 7.1 Plotar séries temporais de todas as bandas e classes
# Este plot pode ser demorado, pois gera o conjunto completo de gráficos.
# Exemplo: 10 bandas x 9 classes = 90 gráficos.
plot(def_rond_samples_v18)

# 7.2 Plotar padrões suavizados por classe usando GAM
# A função sits_patterns() resume os padrões espectro-temporais por classe.
plot(sits_patterns(def_rond_samples_v18))


# ==============================================================================
# 8. Visualização de uma instância específica
# ==============================================================================

# 8.1 Selecionar e imprimir a instância 5 do dataset
def_rond_samples_v18 |>
  slice(5) |>
  print()

# 8.2 Plotar as séries temporais da instância 5
def_rond_samples_v18 |>
  slice(5) |>
  plot()


# ==============================================================================
# 9. Encadeamento de funções com pipe
# ==============================================================================

# 9.1 Exemplo 1:
# Selecionar a banda B11, a classe Clear_Cut_Bare_Soil e um intervalo temporal.
# Em seguida, plotar as séries temporais selecionadas.
def_rond_samples_v18 |>
  sits_select(
    bands = c("B11"),
    labels = c("Clear_Cut_Bare_Soil"),
    start_date = "2022-03-05",
    end_date = "2022-09-23"
  ) |>
  plot()

# Fluxo do exemplo:
# def_rond_samples_v18 |> sits_select() |> plot()


# 9.2 Exemplo 2:
# Selecionar a banda B11, a classe Forest e um intervalo temporal.
# Em seguida, calcular os padrões espectro-temporais e plotar o resultado.
def_rond_samples_v18 |>
  sits_select(
    bands = c("B11"),
    labels = c("Forest"),
    start_date = "2022-03-05",
    end_date = "2022-09-23"
  ) |>
  sits_patterns() |>
  plot()
