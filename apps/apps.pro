TEMPLATE = subdirs

android {
    message("Building android version")
    SUBDIRS += android
}

ubuntu {
    message("Building ubuntu phone version")
    SUBDIRS += ubuntu
}

generic {
    message("Building generic version")
    SUBDIRS += generic
}
