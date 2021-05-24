# Most functionality and settings are defiend in xt-images.
# Only some minimal tuning is required by environment variables.

# We use SRC_URI provided by meta-xt-images

# Android itself doesn't care about hardware, but graphics does.
# That's why we need to check that we are building for supported hardware.
python () {
    hw_supported_by_gfx = ["r8a7795-es3"]
    hw_is_supported = False
    machines = d.getVar("MACHINEOVERRIDES", expand=True).lower().split(":")
    for hw in hw_supported_by_gfx:
        if (hw.lower() in machines):
            hw_is_supported = True
            break

    if not hw_is_supported:
        bb.warn("Build may be not working. DomA tested on %s. Your MACHINEOVERRIDES: '%s'."
            % (hw_supported_by_gfx, d.getVar("MACHINEOVERRIDES", expand=True)))
}

# For proper build of graphics we need to set proper SOC.
# If hardware is not in following list, we will get SOC_FAMILY
# with intentionaly incorrect value set in recipe.
SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7795-es3 = "r8a7795"
SOC_FAMILY_r8a7796 = "r8a7796"
SOC_FAMILY_r8a77965 = "r8a77965"

# SOC_REVISION is taking into account for H3 because we have two options ES2 and ES3.
# ES3 is default option and is used if SOC_REVISION is not set.
# So we need to set SOC_REVISION only for H3 ES2.
SOC_REVISION = ""
SOC_REVISION_r8a7795-es2 = "es2"
