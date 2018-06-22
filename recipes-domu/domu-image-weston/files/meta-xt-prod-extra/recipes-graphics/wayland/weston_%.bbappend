FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

SRC_URI_append = " \
                  file://add_screen_remove_layer_API.patch \
"

