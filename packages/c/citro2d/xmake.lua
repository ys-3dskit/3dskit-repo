package("citro2d")
  set_homepage("https://github.com/devkitpro/citro2d")
  set_description("Library for drawing 2D graphics using the Nintendo 3DS's PICA200 GPU")
  set_license("zlib")

  --add_deps("citro3d ^1.7.1")

  add_urls(
    "https://github.com/devkitpro/citro2d/archive/refs/tags/$(version).tar.gz",
    "https://github.com/devkitpro/citro2d.git"
  )

  add_versions("v1.6.0", "58ae66bb881838b085a1c01da549c5f0f14320fa7efdfc4791878bd7360ddc9a")

  on_install(function (package)

    -- patch for v1.6.0 being broken due to wrong returns, fixed in f5c2ec7
    os.vrun("git apply " .. path.join(os.scriptdir(), "fix-void-returns.diff"))

    import("package.tools.make").build(package)

    os.cp("include", package:installdir())
    os.cp("lib", package:installdir())

    -- in future versions, catnip will be required:
    --local dkp = os.getenv("DEVKITPRO")
    --dkp = dkp or "/opt/devkitpro"
    --os.vrun(path.join(dkp, "/tools/bin/catnip"))
    --os.cp("build/citro2d.release/libcitro2d.a", package:installdir("lib"))
  end)

  on_test(function (package)
    --assert(package:has_cfuncs("gfxInitDefault", {includes = "3ds.h"}))
  end)
