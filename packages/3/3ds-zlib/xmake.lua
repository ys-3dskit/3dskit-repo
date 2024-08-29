-- converted from https://github.com/devkitPro/pacman-packages/blob/54768a1/3ds/zlib/PKGBUILD

package("3ds-zlib")
  set_homepage("https://www.zlib.net")
  set_description("Deflate compression method library")
  set_license("zlib")

  add_urls("https://www.zlib.net/zlib-$(version).tar.xz")

  add_versions("1.3.1", "38ef96b8dfe510d42707d9c781877914792541133e1870841463bfa73f883e32")

  on_install(function (package)

    -- begin boilerplate portlibs env section
    -- i know, its not nice, with xmake there is no way to move this to another file
    dkp = os.getenv("DEVKITPRO")
    dka = os.getenv("DEVKITARM")
    os.setenv("PORTLIBS_ROOT", dkp .. "/portlibs")
    tp = "arm-none-eabi-"
    os.setenv("TOOL_PREFIX", tp)
    os.setenv("CC", tp .. "gcc")
    os.setenv("CXX", tp .. "g++")
    os.setenv("AR", tp .. "gcc-ar")
    os.setenv("RANLIB", tp .. "gcc-ranlib")
    plp = dkp .. "/portlibs/3ds"
    os.setenv("PORTLIBS_PREFIX", plp)
    os.setenv("PATH", plp .."/bin:" .. dkp .. "/tools/bin:" .. dka .. "/bin:" .. os.getenv("PATH"))
    cf = "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -O2 -mword-relocations -ffunction-sections -fdata-sections"
    os.setenv("CFLAGS", cf)
    os.setenv("CXXFLAGS", cf)
    os.setenv("CPPFLAGS", "-D_3DS -D__3DS__ -I" .. plp .. "/include -I" .. dkp .. "/libctru/include")
    os.setenv("LDFLAGS", "-L" .. plp .. "/lib" .. " -L" .. dkp .. "/libctru/lib")
    os.setenv("LIBS", "-lctru")
    -- end boilerplate portlibs env section

    os.setenv("CHOST", "arm-none-eabi")
    os.setenv("CFLAGS", os.getenv("CFLAGS") .. " -DUSE_FILE32API")

    os.vrun('./configure --static')

    os.vrun("make libz.a")

    -- libminizip
    os.cd("contrib/minizip")
    os.vrun("autoreconf --force --verbose --install")
    os.vrun('./configure --host=arm-none-eabi --disable-shared --enable-static')
    os.vrun("make")

    os.cd('../..')

    os.vrun('make DESTDIR="' .. package:installdir() .. '" install')
    os.rm(package:installdir() .. "/share")

    os.cd("contrib/minizip")
    os.vrun('make DESTDIR="' .. package:installdir() .. '" install')

    os.cd(package:installdir())

    -- only want the parts in /usr
    os.vrun("ls usr/local")
    os.mv("usr/local/lib", "lib")
    os.mv("usr/local/include", "include")
    os.rm("usr")

  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
