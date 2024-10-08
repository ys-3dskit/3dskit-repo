# ys-3dskit repo

For using ys-3dskit to develop 3ds applications in C, C++, or D, this is the Xmake repo containing relevant packages:
- libctru
- citro2d
- citro3d

These packages do not depend on the devkitpro pacman packages for libraries, though you still need devkitarm.

## requirements

to build the packages you will need
- devkitarm
- libctru installed with dkp pacman
- citro3d via dkp pacman

// todo remove need for c3d
// todo remove need for ctru

## ported libs

package name prefixed with `3ds-`

- curl
- mbedtls
- zlib

## D usage

All packages have D bindings in a separate package.

The portlibs binding names are as so: `3ds-curl` → `3ds-d-curl`, and even for use in D code you will need to depend on the non-D package too.
(The D packages contain bindings, the main packages contain the binaries).

The bindings for ctru, c3d, and c2d, the 3ds ported D runtime and standard library, and the BTL D library are distributed together in `3dskit-dlang`.

Import as so:

```d
import ys3ds.ctru;
import ys3ds.curl;
```
