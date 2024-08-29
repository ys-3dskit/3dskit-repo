-- converted from https://github.com/devkitPro/pacman-packages/tree/54768a1/3ds/curl

package("3ds-curl")
  set_homepage("https://curl.haxx.se")
  set_description("Library for transferring data with URLs")
  set_license("MIT")

  add_deps("3ds-zlib ^1.3.1", "3ds-mbedtls ^2.28.8")

  add_urls("https://curl.haxx.se/download/curl-$(version).tar.xz")

  add_versions("8.4.0", "16c62a9c4af0f703d28bda6d7bbf37ba47055ad3414d70dec63e2e6336f2a82d")

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

    -- patch for 3ds
    os.vrun("patch -Np1 -i " .. path.join(os.scriptdir(), "curl-8.4.0.patch"))

    local zlibroot = package:dep("3ds-zlib"):installdir()
    local mbedtlsroot = package:dep("3ds-mbedtls"):installdir()

    os.vrun('./configure'
      .. ' CFLAGS="' .. os.getenv("CFLAGS") .. '"'
      .. ' CPPFLAGS="' .. os.getenv("CPPFLAGS") .. '"'
      .. ' LIBS="-lctru" '
      .. ' --host=arm-none-eabi --disable-shared --enable-static --disable-ipv6 --disable-unix-sockets'
      .. ' --disable-threaded-resolver --disable-manual --disable-pthreads --disable-socketpair'
      .. ' --with-mbedtls="' .. mbedtlsroot .. '"'
      .. ' --disable-ntlm-wb --with-ca-bundle=sdmc:/config/ssl/cacert.pem')

    os.vrun("make -C lib")

    os.vrun('make DESTDIR="' .. package:installdir() .. '" -C lib install')
    os.vrun('make DESTDIR="' .. package:installdir() .. '" -C include install')
    os.vrun('make DESTDIR="' .. package:installdir() .. '" install-binSCRIPTS install-pkgconfigDATA')

    os.cp("COPYING", package:installdir())

    os.cd(package:installdir())
    os.mv("usr/local/*", ".")
    os.rm("usr")

  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
