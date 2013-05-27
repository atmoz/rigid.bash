DESTDIR?=
PREFIX?=/usr/local
P=${DESTDIR}/${PREFIX}

all: install

install:
		mkdir -p ${P}/bin
		cp -f rigid ${P}/bin/rigid
		cp -f md2html.awk ${P}/bin/md2html.awk
		chmod +x ${P}/bin/rigid
		chmod +x ${P}/bin/md2html.awk
