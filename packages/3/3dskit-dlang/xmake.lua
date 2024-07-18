package("3dskit-dlang")
  set_homepage("https://github.com/ys-3dskit/3dskit-dlang")
  set_description("D language bindings for 3ds homebrew")

  add_urls(
    "https://github.com/ys-3dskit/3dskit-dlang/archive/refs/tags/$(version).tar.gz",
    "https://github.com/ys-3dskit/3dskit-dlang.git"
  )

  add_versions("v0.2.3", "2c1ccc4558e134de1d0a33f1d393c8abd8d90f56c12c0b2c9b3c084ccc96ed63")
  add_versions("v0.2.1", "fe3b42b5ca5e00bb6c9f4a30309983845640da4ccdc75ba8a41966de43efa6e3")
  add_versions("v0.1.2", "1f621318f084b3c6d96fac8230005fafe81e7e88912dfa7b6f7ea5390491a394")
  add_versions("v0.1.1", "71951125d1762f7c8cbc9d309ec8e1e20790a5f3f41bc1acb3d27d5ef631357d")
  add_versions("v0.1.0", "88be563dd3690840049e7371751fa4a4438d6b0fac3adb79765a48e1964e0cff")
  add_versions("v0.0.3", "392a677ca64abc3d8c13b0a37ee8c616ff2a6429c57db4800ad1ae07c5a7234d")
  --add_versions("v0.0.2", "baedde8c82b2410da69433dcf62c2a378482a9ff82382c1fb674afe9bbba1720")
  --add_versions("v0.0.1", "0208b2c274ef6b48affad848827882f3a50575a1918ec354f96c70866a401573")

  add_links("ys3ds-dlang") -- this lib name would never be guessed by xmake, add it manually

  on_install(function (package)
    os.vrun("xmake f -p 3ds -m release -a arm --toolchain=devkitarm")
    os.vrun("xmake")

    os.cp("ys3ds", package:installdir("include"))
    os.cp("btl", package:installdir("include"))
    os.cp("3ds-d-runtime/druntime/src/*", package:installdir("include"))
    os.cp("3ds-d-runtime/phobos/*", package:installdir("include"))
    os.cp("build/3ds/arm/release/*", package:installdir("lib"))
  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
