library(cartogram)
library(tilemaps)

## Habillage de carte ---------------------------------------------------------

tmap_mode("plot")
m_base <- tm_shape(bio) +
    tm_polygons(
        fill = "part_exp_bio",
        col = "grey60",
        fill.scale = tm_scale_intervals(
            values = "brewer.bu_gn",
        ),
        fill.legend = tm_legend(
            title = "Part en %",
            reverse = TRUE,
            position = tm_pos_in("left", "bottom"),
            frame = FALSE,
            bg.alpha = 0.0
        ),
        fill_alpha = 0.8
    )

# Pas de fond IGN dans les fournisseurs, OpenTopoMap
tmap_providers()
m_base + tm_basemap("OpenStreetMap")
m_base +
    tm_basemap(
        server = "https://{s}.tile.openstreetmap.fr/osmfr/{z}/{x}/{y}.png"
    )

m <- m_base +
    tm_layout(
        text.fontfamily = "Marianne"
    ) +
    tm_text(
        text = "insee_dep",
        size = 0.5,
        options = opt_tm_text(remove_overlap = TRUE)
    ) +
    tm_title_out(
        text = "Exploitations (ayant au moins une parcelle)\nen Agriculture Biologique (AB)"
    ) +
    tm_credits(
        text = "Recensement Agricole 2020 - Agreste.\nFond carto. IGN Admin Express 2025.",
        position = tm_pos_in("left", "bottom")
    ) +
    tm_scalebar(
        color.dark = "grey40",
        width = 24,
        position = tm_pos_in("center", "bottom")
    ) +
    tm_compass(
        type = "4star",
        size = 5,
        position = tm_pos_in("right", "top")
    ) +
    tm_logo(
        file = "./img/logos/png/logoMASAF.png",
        position = tm_pos_in("left", "top"),
        height = 5
    )
m

tmap_save(
    m,
    "images/4-1-habillage_carte.png",
    width = 20,
    units = "cm",
    asp = 1.618,
    dpi = 300,
    device = ragg::agg_png
)


# tmap_mode("view")
# tmap_save(m, "pcent_bio_fr.html")

## Facettes -------------------------------------------------------------------

tmap_mode("plot")
m_facet <- tm_shape(bio) +
    tm_polygons(
        fill = "part_exp_bio",
        col = "grey60",
        fill.scale = tm_scale_intervals(
            values = "brewer.bu_gn",
        ),
        fill.legend = tm_legend(
            title = "Part en %",
            reverse = TRUE,
            position = tm_pos_out(),
        )
    ) +
    tm_facets(by = "insee_reg") +
    tm_title(text = "Exploitations en AB par région")

m_facet

tmap_save(
    m_facet,
    "images/4-2-facettes_regions.png",
    device = ragg::agg_png
)

## Cartogramme ----------------------------------------------------------------

m_cartogram <- bio |>
    cartogram_dorling("n_exp") |>
    tm_shape() +
    tm_polygons(
        fill = "n_exp",
        fill.scale = tm_scale_intervals(
            values = "brewer.bu_gn",
            style = "quantile",
            n = 5
        ),
        fill.legend = tm_legend(
            title = "Nombre d'exploitations",
            reverse = TRUE
        )
    ) +
    tm_text(
        text = "insee_dep",
        size = 0.8,
        options = opt_tm_text(remove_overlap = TRUE)
    )

m_cartogram

tmap_save(
    m_cartogram,
    "images/4-3-cartogramme_dorling.png",
    # width = 2048 * 16 / 9,
    # height = 2048,
    device = ragg::agg_png
)

## Pavage hexagonal ---------------------------------------------------------

bio_metropole <- bio |>
    filter(insee_reg != "94") |>
    mutate(
        tile_map = generate_map(geom, square = FALSE, flat_topped = TRUE)
    )

# bio |>
#     filter(insee_reg == "94") |>
#     mutate(
#         tile_map = generate_map(geom, square = FALSE)
#     )

# bio_tiles <- bio_metropole |>
#     add_row(
#         bio |>
#             filter(insee_reg == "94") |>
#             mutate(
#                 tile_map = create_island(
#                     bio_metropole$tile_map,
#                     "lower right"
#                 )
#             )
#     )

m_bio_tiles <- bio_metropole |>
    st_set_geometry("tile_map") |>
    tm_shape() +
    tm_polygons(
        fill = "part_exp_bio",
        fill.legend = tm_legend(
            title = "Part d'expl. en AB",
            reverse = TRUE
        )
    ) +
    tm_text("insee_dep")


tmap_save(
    m_bio_tiles,
    "images/4-4-grilles_hexagonales.png",
    device = ragg::agg_png
)
