tm_shape(bio) + tm_polygons(fill = "part_exp_bio")
qtm(bio, fill = "part_exp_bio")

tmap_mode()
tmap_mode("view")
tmap_mode("plot")

# original
# tm_shape(bio) +
#     tm_polygons(
#         "part_exp_bio",
#         style = "pretty",
#         n = 5,
#         title = "part en %",
#         palette = "BuGn",
#         border.col = "grey30",
#         lwd = 0.25,
#         legend.reverse = TRUE,
#         legend.format = list(text.separator = " - ")
#     )


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
            title = "part en %",
            lwd = 0.25, # lwd = line width
            reverse = TRUE,
        )
    )
