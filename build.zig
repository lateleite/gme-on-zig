const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const pic = b.option(bool, "pic", "Produce Position Independent Code");

    const upstream = b.dependency("gme", .{});

    const dep_zlib = b.dependency("zlib", .{
        .target = target,
        .optimize = optimize,
    });
    const lib_zlib = dep_zlib.artifact("z");

    const lib = b.addLibrary(.{
        .name = "gme",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = true,
            .pic = pic,
        }),
    });

    const cflags_little = [_][]const u8{
        "-DVGM_YM2612_NUKED",
        "-DBLARGG_LITTLE_ENDIAN=1",
        "-DHAVE_ZLIB_H",
    };
    const cflags_big = [_][]const u8{
        "-DVGM_YM2612_NUKED",
        "-DBLARGG_BIG_ENDIAN=1",
        "-DHAVE_ZLIB_H",
    };
    const cflags = if (target.result.cpu.arch.endian() == .little) &cflags_little else &cflags_big;

    lib.root_module.addCSourceFiles(.{
        .root = upstream.path("gme"),
        .files = &.{
            "Ay_Apu.cpp",
            "Ay_Cpu.cpp",
            "Ay_Emu.cpp",
            "Blip_Buffer.cpp",
            "Classic_Emu.cpp",
            "Data_Reader.cpp",
            "Dual_Resampler.cpp",
            "Effects_Buffer.cpp",
            "Fir_Resampler.cpp",
            "Gb_Apu.cpp",
            "Gb_Cpu.cpp",
            "Gb_Oscs.cpp",
            "Gbs_Emu.cpp",
            "Gme_File.cpp",
            "Gym_Emu.cpp",
            "Hes_Apu.cpp",
            "Hes_Cpu.cpp",
            "Hes_Emu.cpp",
            "Kss_Cpu.cpp",
            "Kss_Emu.cpp",
            "Kss_Scc_Apu.cpp",
            "M3u_Playlist.cpp",
            "Multi_Buffer.cpp",
            "Music_Emu.cpp",
            "Nes_Apu.cpp",
            "Nes_Cpu.cpp",
            "Nes_Fds_Apu.cpp",
            "Nes_Fme7_Apu.cpp",
            "Nes_Namco_Apu.cpp",
            "Nes_Oscs.cpp",
            "Nes_Vrc6_Apu.cpp",
            "Nes_Vrc7_Apu.cpp",
            "Nsf_Emu.cpp",
            "Nsfe_Emu.cpp",
            "Sap_Apu.cpp",
            "Sap_Cpu.cpp",
            "Sap_Emu.cpp",
            "Sms_Apu.cpp",
            "Snes_Spc.cpp",
            "Spc_Cpu.cpp",
            "Spc_Dsp.cpp",
            "Spc_Emu.cpp",
            "Spc_Filter.cpp",
            "Vgm_Emu.cpp",
            "Vgm_Emu_Impl.cpp",
            "Ym2413_Emu.cpp",
            "Ym2612_GENS.cpp",
            "Ym2612_MAME.cpp",
            "Ym2612_Nuked.cpp",
            "gme.cpp",
        },
        .flags = cflags,
        .language = .cpp,
    });
    lib.root_module.addCSourceFiles(.{
        .root = upstream.path("gme/ext"),
        .files = &.{
            "emu2413.c",
            "panning.c",
        },
        .flags = cflags,
    });

    lib.root_module.linkLibrary(lib_zlib);

    lib.root_module.addIncludePath(upstream.path("gme"));

    lib.installHeadersDirectory(
        upstream.path("gme"),
        "gme",
        .{ .include_extensions = &.{"gme.h"} },
    );
    b.installArtifact(lib);
}
