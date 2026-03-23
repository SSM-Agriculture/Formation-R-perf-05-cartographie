library(here)
library(tidyverse)
library(sf)
library(tmap)
library(knitr)
library(janitor)
library(RColorBrewer)
library(cols4all)
library(ragg)         # remplace grDevices (défaut) <https://ragg.r-lib.org/>
options(OutDec = ".")

gpkg <- fs::path_home_r(
    "CERISE",
    "03-Espace-de-Diffusion",
    "000_Referentiels",
    "0040_Geo",
    "IGN",
    "adminexpress",
    "adminexpress_cog_simpl_000_2025.gpkg"
)

st_layers(gpkg)

# https://r-spatial.github.io/sf/reference/st_read.html
dep <- read_sf(gpkg, layer = "departement") |>
    filter(insee_reg > "06") |>
    st_transform("EPSG:2154")

head(dep)
plot(dep)

ragg::agg_png("images/2-2-cas_part_expl_bio-plot_x4.png")
plot(dep)
invisible(dev.off())

expl_ra <- fs::path_home_r(
    "CERISE",
    "03-Espace-de-Diffusion",
    "030_Structures_exploitations",
    "3020_Recensements",
    "RA_2020",
    "01_BASES DIFFUSION RA2020",
    "DEF_240112",
    "RA2020_EXPLOITATIONS_240112.rds"
)

exp_dep <- read_rds(expl_ra) |>
    as_tibble(.name_repair = make_clean_names) |>
    filter(champ_geo == "1") |>
    group_by(siege_dep) |>
    summarise(n_exp = n(), n_exp_bio = sum(bio_fil, na.rm = TRUE)) |>
    mutate(part_exp_bio = n_exp_bio / n_exp * 100)

head(exp_dep) |> kable()

bio <- dep |>
    left_join(exp_dep, by = c("insee_dep" = "siege_dep"))

plot(bio |> select(geom, part_exp_bio))

ragg::agg_png("images/2-2-cas_part_expl_bio-plot.png")
plot(bio |> select(geom, part_exp_bio))
invisible(dev.off())
