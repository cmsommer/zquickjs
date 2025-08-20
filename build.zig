const std = @import("std");

const version: []const u8 = "2025-04-26"; // copied from quickjs/VERSION
const version_flag = "-DCONFIG_VERSION=\"" ++ version ++ "\"";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const quickjs_dep = b.dependency("quickjs", .{
        .target = target,
        .optimize = optimize,
    });

    const lib_mod = b.addModule("zquickjs", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib_mod.addIncludePath(quickjs_dep.path("."));
    lib_mod.addCSourceFiles(.{
        .root = quickjs_dep.path("."),
        .flags = &.{
            version_flag,
        },
        .files = &.{
            "libregexp.c",
            "libunicode.c",
            "cutils.c",
            "dtoa.c",
            "quickjs.c",
        },
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("zquickjs", lib_mod);

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "zquickjs",
        .root_module = lib_mod,
    });

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "zquickjs",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
