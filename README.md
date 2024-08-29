# ys-3dskit repo

For using ys-3dskit to develop 3ds applications in C, C++, or D, this is the Xmake repo containing relevant packages:
- libctru
- citro2d
- citro3d

These packages do not depend on the devkitpro pacman packages for libraries, though you still need devkitarm.

## D usage

! TODO !

All packages have D bindings in a separate package.

The bindings names are as so: `3ds-curl` → `3ds-d-curl`<!-- , and for use in D code you do not need to depend on the non-D package -->.

Import as so:

```d
import ys3ds.ctru;
```
