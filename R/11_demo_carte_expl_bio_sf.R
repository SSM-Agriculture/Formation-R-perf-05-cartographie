tm_shape(bio) + tm_polygons(fill = "part_exp_bio")
qtm(bio, fill = "part_exp_bio")


## 2.4 Carte interactive
tmap_mode()
tmap_mode("view")
tmap_mode("plot")

# original v3.0
tm_shape(bio) +
    tm_polygons(
        "part_exp_bio",
        style = "pretty",
        n = 5,
        title = "part en %",
        palette = "BuGn",
        border.col = "grey30",
        lwd = 0.25,
        legend.reverse = TRUE,
        legend.format = list(text.separator = " - ")
    )

# reprise v4.0
tm_shape(bio) +
    tm_polygons(
        "part_exp_bio",
        col = "grey60",
        fill.scale = tm_scale_intervals(
            style = "pretty", # default
            n = 5,
            values = "brewer.bu_gn",
            label.format = tm_label_format(
                text.separator = " - "
            )
        ),
        fill.legend = tm_legend(
            title = "Part en %",
            lwd = 0.25, # lwd = line width
            reverse = TRUE,
        )
    )


## 2.5 Carte à symboles proportionnels
tmap_mode("plot")
tm_shape(bio) +
    tm_borders(col = "grey30", lwd = 0.25) +
    tm_symbols(
        fill = "darkolivegreen4",
        size = "n_exp",
        size.scale = tm_scale(values.scale = 1.5),
        size.legend = tm_legend(
            title = "Nombre d'exploitations en AB",
            orientation = "landscape",
            position = tm_pos_in()
        )
    )

## 2.6 Carte choroplèthe + symboles proportionnels

tm_shape(bio) +
    tm_polygons(
        "part_exp_bio",
        col = "grey60",
        fill.scale = tm_scale_intervals(
            values = "brewer.bu_gn",
        ),
        fill.legend = tm_legend(
            title = "Part d'exploitations en AB (en %)",
            reverse = TRUE,
        )
    ) +
    tm_symbols(
        fill = "darkolivegreen4",
        size = "n_exp",
        size.scale = tm_scale(values.scale = 1.5),
        size.legend = tm_legend(
            title = "Nombre d'exploitations en AB",
            reverse = TRUE,
        )
    ) +
    tm_title_out(
        text = "Exploitations (ayant au moins une parcelle) en Agriculture Biologique (AB)"
    ) +
    tm_credits(
        text = "Recensement Agricole 2020 - Agreste",
        position = c("left", "bottom")
    )


## 2.7 Variante

# [v3->v4] `tm_symbols()`: migrate the argument(s) related to the scale of the visual variable `fill` namely 'palette' (rename to 'values'), 'legend.format' (rename to
# 'label.format') to fill.scale = tm_scale(<HERE>).
# [v3->v4] `symbols()`: migrate the argument(s) related to the legend of the visual variable `fill` namely 'title.col' (rename to 'title'), 'legend.format' (rename to
# 'format') to 'fill.legend = tm_legend(<HERE>)'

m <- tm_shape(bio) +
    tm_borders(col = "grey30", lwd = 0.25) +
    tm_symbols(
        fill = "part_exp_bio",
        fill.scale = tm_scale(
            values = "brewer.bu_gn"
        ),
        fill.legend = tm_legend(
            title = "Part\nd'expl. en AB (en %)",
            reverse = TRUE,
            position = tm_pos_in("left", "bottom"),
        ),
        size = "n_exp",
        size.scale = tm_scale(
            values.scale = 1.5
        ),
        size.legend = tm_legend(
            title = "Nombre\nd'expl. en AB",
            position = tm_pos_in("left", "bottom"),
            frame = FALSE,
            bg.alpha = 0.0
        ),
    )
m |> tmap_save("images/2-7-cas_part_expl_bio-variante_symbole.png")

## 2.8 Couleurs et palettes

pal_vir <- c4a("viridis", n = 5)
colorspace::specplot(pal_vir)

pal_div <- c4a("brewer.prgn", n = 7)
colorspace::specplot(pal_div)


library(RColorBrewer)
head(brewer.pal.info)

c4a("brewer.prgn", n = 7) |> c4a_plot_hex()

c4a_types()
c4a_overview()
c4a_scores("brewer.prgn")
c4a_scores(series = "brewer", type = "div") |> as_tibble()
