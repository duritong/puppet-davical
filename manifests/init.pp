# modules/davical/manifests/init.pp - manage davical stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

class davical {
    case $::operatingsystem {
        default: { include davical::base }
    }
}
