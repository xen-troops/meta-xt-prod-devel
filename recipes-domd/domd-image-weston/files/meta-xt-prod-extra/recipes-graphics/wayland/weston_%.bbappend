FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"

# Only build IVI shell if not building for DomU:
# by default, the product is built with IVI shell for Weston
# which is not needed in case of DomU guest. Check XT_GUESTS_INSTALL
# variable and skip configuration of IVI shell in weston.ini for DomU.
# This is a workaround as display manager and backend are still
# built with ivi-extensions.
python __anonymous () {
    guests = (d.getVar("XT_GUESTS_INSTALL", True) or "").split()
    if "domu" not in guests :
        d.appendVar("EXTRA_OECONF", " --enable-ivi-shell")
}

SRC_URI_IVI_ID_AGENT = " \
    file://0001-ivi-shell-rework-goto-labels-to-avoid-memory-leaks.patch \
    file://0002-ivi-shell-removed-assert.patch \
    file://0003-ivi-shell-introduction-of-IVI_INVALID_ID.patch \
    file://0004-layout-interface-added-interface-to-change-surface-i.patch \
    file://0005-ivi-layout-introduced-configure_desktop_changed.patch \
    file://0006-ivi-layout-introduced-surface-create-and-configure.patch \
    file://0007-ivi-shell-linked-libweston-desktop-and-added-structs.patch \
    file://0008-ivi-layout-use-libweston-desktop-api-for-views.patch \
    file://0009-ivi-shell-added-libweston-desktop-api-implementation.patch \
    file://0010-ivi-shell-remove-surface_destroy_listener.patch \
    file://0011-ivi-shell-create-weston_desktop-in-wet_shell_init.patch \
    file://0012-hmi-controller-register-for-desktop_surface_configur.patch \
    file://0013-simple-egl-remove-ivi-application-support.patch \
    file://0014-simple-shm-remove-ivi-application-support.patch \
    file://0015-window-client-remove-ivi-application-support.patch \
"

# Add experimental vps2 renderer for weston 5
# origin of patches - https://github.com/thayama/weston/commits/gl-fallback-5.0.0
SRC_URI_V4L2_RENDERER = " \
    file://0001-compositor-drm-map-framebuffers-with-read-write-perm.patch \
    file://0002-Add-V4L2-media-controller-renderer.patch                   \
    file://0003-Add-support-for-V4L2-renderer-in-DRM-compositor.patch      \
    file://0004-Add-R-Car-VSP2-device-support-for-V4L2-renderer.patch      \
    file://0005-v4l2-renderer-Release-dma-buf-when-attaching-null-bu.patch \
    file://0006-v4l2-renderer-implement-surface_copy_content.patch         \
    file://0007-vsp2-renderer-implement-surface_copy_content.patch         \
    file://0008-composirot-drm-destroy-buffers-for-v4l2-renderer-whe.patch \
    file://0009-v4l2-renderer-fix-build-error-when-gl-fallback-and-v.patch \
    file://0010-v4l2-renderer-fix-header-file-name-in-Makefile.am.patch    \
    file://0012-v4l2-renderer-add-support-dmabuf-buffer-offset.patch       \
    file://0001-v4l2-renderer-Introduce-detach_buffer-op-to-v4l2_dev.patch \
    file://vsp2.rules                                                      \
"

SRC_URI_append = "file://weston-seats.rules \
                  file://camera_front.rules \
                  ${@bb.utils.contains('DISTRO_FEATURES', 'ivi-shell', SRC_URI_IVI_ID_AGENT, '', d)} \
                  ${@bb.utils.contains('DISTRO_FEATURES', 'v4l2-renderer', SRC_URI_V4L2_RENDERER, '', d)} \
"

FILES_${PN} += " \
    ${sysconfdir}/udev/rules.d/weston-seats.rules \
    ${sysconfdir}/udev/rules.d/camera_front.rules \
    ${@bb.utils.contains('DISTRO_FEATURES', 'v4l2-renderer', '${sysconfdir}/udev/rules.d/vsp2.rules', '', d)} \
"

python __anonymous () {
    if bb.utils.contains('DISTRO_FEATURES', 'v4l2-renderer', True, False, d):
        d.appendVar('PACKAGECONFIG', ' v4l2')
        d.setVarFlag('PACKAGECONFIG', 'v4l2', '--enable-v4l2, --disable-v4l2, , kernel-module-vsp2driver')
}

do_install_append() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/weston-seats.rules ${D}${sysconfdir}/udev/rules.d/weston-seats.rules
    install -m 0644 ${WORKDIR}/camera_front.rules ${D}${sysconfdir}/udev/rules.d/camera_front.rules
    if ${@bb.utils.contains('DISTRO_FEATURES', 'v4l2-renderer', 'true', 'false', d)}; then
        install -m 0644 ${WORKDIR}/vsp2.rules ${D}${sysconfdir}/udev/rules.d/vsp2.rules
    fi
}
