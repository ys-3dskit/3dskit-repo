-- converted from https://github.com/devkitPro/pacman-packages/tree/54768a1/3ds/mbedtls

package("3ds-mbedtls")
  set_homepage("https://tls.mbed.org")
  set_description("An open source, portable, easy to use, readable and flexible SSL library")
  set_license("apache")

  add_deps("3ds-zlib ^1.3.1")

  add_urls(
    "https://github.com/mbed-tls/mbedtls/archive/refs/tags/$(version).tar.gz",
    "https://github.com/mbed-tls/mbedtls.git"
  )

  add_versions("v2.28.8", "4fef7de0d8d542510d726d643350acb3cdb9dc76ad45611b59c9aa08372b4213")

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

    os.vrun("patch -Np1 -i " .. path.join(os.scriptdir(), "mbedtls-2.28.8.patch"))

    os.vrun("./scripts/config.pl set MBEDTLS_ENTROPY_HARDWARE_ALT")
    os.vrun("./scripts/config.pl set MBEDTLS_NO_PLATFORM_ENTROPY")
    os.vrun("./scripts/config.pl set MBEDTLS_CMAC_C")

    os.vrun("./scripts/config.pl unset MBEDTLS_SELF_TEST")
    os.vrun("./scripts/config.pl unset MBEDTLS_TIMING_C")

    -- i love package.tools.cmake not letting me change the cmake
    local zlibdep = package:dep("3ds-zlib")
    local zlibroot = zlibdep:installdir()

    os.vrun('arm-none-eabi-cmake -DCMAKE_C_FLAGS="' .. cf .. ' ' .. os.getenv("CPPFLAGS") .. '" '
      .. '-DCMAKE_CXX_FLAGS="CFLAGS -fno-exceptions -fno-rtti" '
      .. '-DZLIB_ROOT="' .. zlibroot .. '" '
      .. '-DENABLE_ZLIB_SUPPORT=TRUE -DENABLE_TESTING=FALSE -DENABLE_PROGRAMS=FALSE .')

    os.vrun("make")

    os.vrun('make install DESTDIR="' .. package:installdir() .. '"')

    os.cd(package:installdir())

    os.mv("opt/devkitpro/portlibs/3ds/include", "include")
    os.mv("opt/devkitpro/portlibs/3ds/lib", "lib")
    os.rm("opt")

  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
