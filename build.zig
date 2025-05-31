const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mimalloc_dep = b.dependency("mimalloc", .{});

    const mimalloc_h = b.addTranslateC(.{
        .root_source_file = mimalloc_dep.path("include/mimalloc.h"),
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("mimalloc", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_mod.addImport("mimalloc", mimalloc_h.createModule());

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "mimalloc",
        .root_module = lib_mod,
    });
    lib.addCSourceFiles(.{
        .root = mimalloc_dep.path("src"),
        .files = &.{"static.c"},
    });
    lib.addIncludePath(mimalloc_dep.path("include"));
    lib.installHeadersDirectory(mimalloc_dep.path("include"), ".", .{});
    b.installArtifact(lib);
}
