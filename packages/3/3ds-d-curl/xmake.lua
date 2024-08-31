package("3ds-d-curl")
  set_homepage("https://github.com/ys-3dskit/3dskit-d-ports")
  set_description("D binds for 3ds-curl")

  add_urls(
    "https://github.com/ys-3dskit/3dskit-d-ports/archive/refs/tags/$(version).tar.gz",
    "https://github.com/ys-3dskit/3dskit-d-ports.git"
  )

  add_versions("0.1.0", "33dc534f3e2e3663a053a7c824c5aa77fbd5e16d965a46ffaafec070c45078f5")

  on_install(function (package)
    os.cd("curl")

    os.vrun("xmake f -p 3ds -m release -a arm --toolchain=devkitarm")
    os.vrun("xmake")

    os.cp("ys3ds", package:installdir("include"))
    os.cp("build/3ds/arm/release/*", package:installdir("lib"))
  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
