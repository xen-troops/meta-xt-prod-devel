
# Most functionality and settings are defiend in xt-images.
# Only some minimal tuning is required by environment variables.

# In most cases we can use default source of android's repo, provided in xt-images
#SRC_URI = " \
#    repo://... \
#"

# For proper build of graphics we need to set proper SOC. This info is available
# for us from local.conf and we do not need to run do_domd_install_machine_overrides.
# H3 ES3
SOC_FAMILY_r8a7795 = "r8a7795"
SOC_FAMILY_r8a7795-es3 = "r8a7795"
# M3
#SOC_FAMILY_r8a7796 = "r8a7796"
# M3N
#SOC_FAMILY_r8a77965 = "r8a77965"

# If SOC_REVISION is not set, then ES3 is used as default.
# Pay atention that ES2 is not supported anymore.
SOC_REVISION_r8a7795-es3 = ""
#SOC_REVISION_r8a7795-es2 = "es2"

