library(here)
library(tidyverse)
library(sf)
library(tmap)
library(maptiles)
library(cols4all)
options(OutDec = ".")


admin_express <- fs::path_home_r(
    "CERISE",
    "03-Espace-de-Diffusion",
    "000_Referentiels",
    "0040_Geo",
    "IGN",
    "adminexpress",
    "adminexpress_cog_simpl_000_2025.gpkg"
)

st_layers(admin_express)
departements_r84 <- read_sf(admin_express, layer = "departement") |>
    filter(insee_reg == "84") |>
    st_transform("EPSG:2154")

france <- read_sf(admin_express, layer = "departement") |>
    filter(insee_reg > "06") |>
    st_transform("EPSG:2154") |>
    summarise()

tm_shape(france) +
    tm_polygons(
        # fill = "insee_reg",
        fill.scale = tm_scale_categorical(values = "hcl.dynamic"),
        fill.legend = tm_legend(show = FALSE)
    ) +
    tm_shape(departements_r84) +
    tm_polygons(
        fill = "insee_dep",
        fill.scale = tm_scale_categorical(values = "hcl.dynamic"),
        fill.legend = tm_legend(show = FALSE)
    )


url_ortho <- paste0(
    "https://data.geopf.fr/wmts?",
    "request=GetTile",
    "&service=WMTS",
    "&version=1.0.0",
    "&style=normal",
    "&tilematrixset=PM_6_18",
    "&format=image/jpeg",
    "&layer=ORTHOIMAGERY.ORTHOPHOTOS.BDORTHO",
    "&tilematrix={z}",
    "&tilerow={y}",
    "&tilecol={x}"
)

url_plan <- paste0(
    "https://data.geopf.fr/wmts?",
    "request=GetTile",
    "&service=WMTS",
    "&version=1.0.0",
    "&style=normal",
    "&tilematrixset=PM_0_19",
    "&format=image/png",
    "&layer=GEOGRAPHICALGRIDSYSTEMS.PLANIGNV2",
    "&tilematrix={z}",
    "&tilerow={y}",
    "&tilecol={x}"
)


tm_shape(departements_r84) +
    tm_polygons(
        fill = "insee_dep",
        fill.scale = tm_scale_categorical(values = "hcl.dynamic"),
        fill.legend = tm_legend(show = FALSE),
        fill_alpha = 0.5
    ) +
    tm_text(
        text = "nom"
    ) +
    tm_basemap(url_plan)
