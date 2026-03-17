library(tmap)
library(cols4all)
library(ggplot2)
library(glue)
library(classInt)
library(patchwork)

tmap_mode("plot")
methodes <- c(
    "sd",
    "equal",
    "pretty",
    "quantile",
    "kmeans",
    "hclust",
    "bclust",
    "fisher",
    "jenks",
    "dpih",
    "headtails"
)

# Part des exploitation en AB, avec différentes méthodes de discrétisation
generer <- function(methode) {
    cesures <- classIntervals(bio$part_exp_bio, style = methode, n = 5)
    palette <- c4a("viridis", n = length(cesures$brks) - 1)

    carte <- tm_shape(bio) +
        tm_polygons(
            "part_exp_bio",
            col = "grey30",
            fill.scale = tm_scale_intervals(
                style = "fixed",
                breaks = cesures$brks,
                values = palette,
            ),
            fill.legend = tm_legend(
                title = "Part en %",
                lwd = 0.25, # lwd = line width
                reverse = TRUE,
            )
        ) +
        tm_layout(
            frame = FALSE,
            bg = FALSE,
            legend.outside = TRUE,
            legend.outside.position = "bottom"
        )
    out <- tmap_grob(carte)

    graphique <- density(bio$part_exp_bio)[c("x", "y")] |>
        as_tibble() |>
        mutate(intervalle = findInterval(x, cesures$brks)) |>
        filter(between(intervalle, 1, length(cesures$brks) - 1)) |>
        mutate(couleur = palette[intervalle]) |>
        ggplot(aes(x, y)) +
        geom_area(aes(fill = couleur)) +
        geom_line() +
        scale_fill_identity() +
        labs(
            title = glue("Méthode de classification {methode}"),
            x = "Part des exploitations en AB (%)",
            y = "densité"
        ) +
        theme_minimal()

    composition <- graphique + out
    ggsave(glue("images/3-1-classification-{methode}.png"), plot = composition)
    composition
}

exemples_classes <- methodes |>
    map(generer)
exemples_classes


## Classes manuelles

cesures <- classIntervals(bio$part_exp_bio, style = "quantile", n = 5)
cesures

tm_shape(bio) +
    tm_polygons(
        "part_exp_bio",
        col = "grey30",
        fill.scale = tm_scale_intervals(
            style = "fixed",
            breaks = round(cesures$brks, 1),
            values = c4a("viridis", n = 5),
        ),
        fill.legend = tm_legend(
            title = "Part en %",
            lwd = 0.25, # lwd = line width
            reverse = TRUE,
        )
    ) +
    tm_layout(
        frame = FALSE,
        bg = FALSE,
        legend.outside = TRUE,
        legend.outside.position = "bottom"
    )

classIntervals(bio$part_exp_bio, style = "jenks", n = 5)
