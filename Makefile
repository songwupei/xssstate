# xgetidle – display the X idle time
# See LICENSE file for copyright and license details.

include config.mk

SRC = xgetidle.c
OBJ = ${SRC:.c=.o}

all: options xgetidle

options:
	@echo xgetidle build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.mk

xgetidle: xgetidle.o
	@echo CC -o $@
	@${CC} -o $@ xgetidle.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f xgetidle ${OBJ} xgetidle-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p xgetidle-${VERSION}
	@cp -R LICENSE Makefile README config.mk \
		xgetidle.1 arg.h ${SRC} xgetidle-${VERSION}
	@tar -cf xgetidle-${VERSION}.tar xgetidle-${VERSION}
	@gzip xgetidle-${VERSION}.tar
	@rm -rf xgetidle-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f xgetidle ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/xgetidle
	@echo installing manual page to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@sed "s/VERSION/${VERSION}/g" < xgetidle.1 > ${DESTDIR}${MANPREFIX}/man1/xgetidle.1
	@chmod 644 ${DESTDIR}${MANPREFIX}/man1/xgetidle.1

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/xgetidle
	@echo removing manual page from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/xgetidle.1

.PHONY: all options clean dist install uninstall
