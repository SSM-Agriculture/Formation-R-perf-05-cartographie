library(here)
library(sf)
library(tmap)
library(cols4all)
library(janitor)
library(tidyverse)

com <- read_sf(here("data", "ComD02.TAB")) |>
    clean_names()

pop <- read_rds(here("data", "/popD02_2013.rds")) |>
    as_tibble(.name_repair = make_clean_names)

com_pop <- com |>
    select(-libgeo, -surf) |>
    left_join(pop, by = join_by(codgeo)) |>
    mutate(
        dpop_habkm2 = pop13 / surf,
        evol_pop_pcent = 100 * (pop13 - pop08) / pop08
    )

com_pop

question_2 <-
    com_pop |>
    tm_shape() +
    tm_polygons(
        "dpop_habkm2",
        fill.scale = tm_scale_intervals(
            style = "kmeans",
            values = "viridis"
        ),
        fill.legend = tm_legend(
            title = "Densité de population\n(en hab. / km²)",
            position = tm_pos_in("right", "bottom"),
            reverse = TRUE,
            frame = FALSE,
            bg.alpha = 0.0
        )
    ) +
    tm_layout(
        text.fontfamily = "Marianne"
    ) +
    tm_title_out(
        text = "Densité de population communale du département de l'Aisne (02)"
    ) +
    tm_credits(
        text = "Données fournies par la formation.",
        position = tm_pos_in("left", "bottom")
    ) +
    tm_scalebar(
        color.dark = "grey40",
        width = 16,
        position = tm_pos_in("right", "bottom")
    ) +
    tm_compass(
        type = "rose",
        size = 2,
        position = tm_pos_in("right", "top")
    )


tmap_save(
    question_2,
    "images/6-2-densite_population.png"
)

question_3 <-
    com_pop |>
    tm_shape() +
    tm_polygons(
        "evol_pop_pcent",
        fill.scale = tm_scale_intervals(
            style = "pretty",
            n = 5,
            values = "brewer.prgn",
            midpoint = 0,
            label.format = tm_label_format(
                text.separator = " à "
            )
        )
    )
question_3

tmap_save(
    question_3,
    "images/6-3-evolution_population.png"
)


question_4 <-
    com_pop |>
    tm_shape() +
    tm_polygons(
        "evol_pop_pcent",
        fill.scale = tm_scale_intervals(
            style = "fixed",
            breaks = c(-20, -10, -5, 5, 10, 20),
            values = "brewer.prgn",
            midpoint = 0,
            label.format = tm_label_format(
                text.separator = " à "
            )
        ),
        fill.legend = tm_legend(
            title = "Evolution de population (%)",
            position = tm_pos_in("right", "bottom"),
            reverse = TRUE,
            frame = FALSE,
            bg.alpha = 0.0
        )
    )
question_4

tmap_save(
    question_4,
    "images/6-4-evolution_population_rupture.png"
)


question_5 <- question_4 +
    tm_layout(
        text.fontfamily = "Marianne"
    ) +
    tm_title_out(
        text = "Evolution de la population communale du département de l'Aisne (02)"
    ) +
    tm_credits(
        text = "Données fournies par la formation.",
        position = tm_pos_in("left", "bottom")
    ) +
    tm_scalebar(
        color.dark = "grey40",
        width = 16,
        position = tm_pos_in("right", "bottom")
    ) +
    tm_compass(
        type = "rose",
        size = 2,
        position = tm_pos_in("right", "top")
    )
question_5

tmap_save(
    question_5,
    "images/6-5_population_002_2008-2013.pdf",
    width = 20,
    height = 28.7,
    units = "cm",
    dpi = 300,
    device = cairo_pdf
)
