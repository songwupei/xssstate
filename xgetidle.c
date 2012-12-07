/*
 * See LICENSE file for copyright and license details.
 */

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdbool.h>
#include <libgen.h>
#include <X11/extensions/scrnsaver.h>

#include "arg.h"

char *argv0;

void
die(const char *errstr, ...) {
	va_list ap;

	va_start(ap, errstr);
	vfprintf(stderr, errstr, ap);
	va_end(ap);
	exit(EXIT_FAILURE);
}

void
usage(void)
{
	die("usage: %s [-sv]\n", basename(argv0));
}

int
main(int argc, char *argv[]) {
	XScreenSaverInfo *info;
	Display *dpy;
	int base, errbase;
	Bool inseconds;

	inseconds = False;

	ARGBEGIN {
	case 's':
		inseconds = true;
		break;
	case 'v':
		die("xgetidle-"VERSION", © 2008-2012 xgetidle engineers"
				", see LICENSE for details.\n");
	default:
		usage();
	} ARGEND;

	if(!(dpy = XOpenDisplay(0)))
		die("Cannot open display.\n");

	if(!XScreenSaverQueryExtension(dpy, &base, &errbase))
		die("Screensaver extension not activated.\n");

	info = XScreenSaverAllocInfo();
	XScreenSaverQueryInfo(dpy, DefaultRootWindow(dpy), info);

	printf("%ld\n", info->idle / ((inseconds)? 1000 : 1));

	XCloseDisplay(dpy);

	return 0;
}

