# GME on Zig

This repository wraps the Game Music Emulators library's source code with Zig's build system.

Zig 0.15.2 is required.

## Installing as a `build.zig.zon` package

Run in your Zig project:
```sh
zig fetch --save-exact=gme git+https://github.com/lateleite/gme-on-zig.git
```

Then in your `build.zig` file:
```zig
pub fn build(b: *std.Build) !void {
    // ...

    // Add a reference to the package you've just fetched...
    const dep_gme = b.dependency("gme", .{
        .target = target,
        .optimize = optimize,
        // disable zlib file decompression support (it's enabled by default)
        // .@"enable-zlib" = false,
    });
    const lib_gme = dep_gme.artifact("gme");

    // ...then link the library to your module
    your_module.linkLibrary(lib_gme);

    // ...
}
```

After that, you may use GME's header files in your module.

## License

All (build) code here is released to public domain or under the BSD Zero Clause license, choose whichever you prefer.

You may find GME's license at [https://github.com/libgme/game-music-emu/blob/1815b97e01e68b16a8f07daef8c71bd52f36d307/license.txt](https://github.com/libgme/game-music-emu/blob/1815b97e01e68b16a8f07daef8c71bd52f36d307/license.txt).
