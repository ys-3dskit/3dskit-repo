package("citro3d")
  set_homepage("https://github.com/devkitpro/citro3d")
  set_description("Homebrew PICA200 GPU wrapper library for Nintendo 3DS")
  set_license("zlib")

  add_deps("libctru ^2.3.0")

  add_urls(
    "https://github.com/devkitpro/citro3d/archive/refs/tags/$(version).tar.gz",
    "https://github.com/devkitpro/citro3d.git"
  )

  add_versions("v1.7.1", "c920515a791442e81e0c2c8867dde81bf14aca17eacb2709b4a3a3c61699250c")

  on_install(function (package)
    import("package.tools.make").build(package)
    os.cp("include", package:installdir())
    os.cp("lib", package:installdir())
  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
