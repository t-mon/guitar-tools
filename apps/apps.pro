TEMPLATE = subdirs

android {
    message("Building android version")
    SUBDIRS += android
}

ubuntu {
    message("Building ubuntu phone version")
    SUBDIRS += ubuntu
}

buildGeneric = $$find(CONFIG, "android") $$find(CONFIG, "ubuntu")
count(buildGeneric, 0) {
    message("Building generic version")
    SUBDIRS += generic
}
