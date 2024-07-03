package("libctru")
  set_homepage("https://github.com/devkitpro/libctru")
  set_description("Homebrew development library for Nintendo 3DS/Horizon OS user mode (Arm11)")
  set_license("zlib")

  add_urls(
    "https://github.com/devkitpro/libctru/archive/refs/tags/$(version).tar.gz",
    "https://github.com/devkitpro/libctru.git"
  )

  add_versions("v2.3.1", "4fb01ac81f54609c953a3f1c03aad270fd8bb40ae1a51bc61e4e5ee726039b75")

  on_install(function (package)
    os.cd("libctru")
    -- see https://xmake.io/#/package/local_3rd_source_library?id=use-gnumake
    import("package.tools.make").build(package)
    os.cp("include", package:installdir())
    os.cp("lib", package:installdir())
  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
