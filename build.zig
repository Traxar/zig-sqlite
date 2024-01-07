const std = @import("std");
const LazyPath = std.Build.LazyPath;

pub fn build(b: *std.Build) void {
    var flags = std.ArrayList([]const u8).init(b.allocator);

    if (b.option(bool, "enable_column_metadata", "SQLITE_ENABLE_COLUMN_METADATA") orelse false) {
        flags.append("-DSQLITE_ENABLE_COLUMN_METADATA") catch @panic("OOM");
    }

    if (b.option(bool, "enable_dbstat_vtab", "SQLITE_ENABLE_DBSTAT_VTAB") orelse false) {
        flags.append("-DSQLITE_ENABLE_DBSTAT_VTAB") catch @panic("OOM");
    }

    if (b.option(bool, "enable_fts3", "SQLITE_ENABLE_FTS3") orelse false) {
        flags.append("-DSQLITE_ENABLE_FTS3") catch @panic("OOM");
    }

    if (b.option(bool, "enable_fts4", "SQLITE_ENABLE_FTS4") orelse false) {
        flags.append("-DSQLITE_ENABLE_FTS4") catch @panic("OOM");
    }

    if (b.option(bool, "enable_fts5", "SQLITE_ENABLE_FTS5") orelse false) {
        flags.append("-DSQLITE_ENABLE_FTS5") catch @panic("OOM");
    }

    if (b.option(bool, "enable_geopoly", "SQLITE_ENABLE_GEOPOLY") orelse false) {
        flags.append("-DSQLITE_ENABLE_GEOPOLY") catch @panic("OOM");
    }

    if (b.option(bool, "enable_icu", "SQLITE_ENABLE_ICU") orelse false) {
        flags.append("-DSQLITE_ENABLE_ICU") catch @panic("OOM");
    }

    if (b.option(bool, "enable_math_functions", "SQLITE_ENABLE_MATH_FUNCTIONS") orelse false) {
        flags.append("-DSQLITE_ENABLE_MATH_FUNCTIONS") catch @panic("OOM");
    }

    if (b.option(bool, "enable_rbu", "SQLITE_ENABLE_RBU") orelse false) {
        flags.append("-DSQLITE_ENABLE_RBU") catch @panic("OOM");
    }

    if (b.option(bool, "enable_rtree", "SQLITE_ENABLE_RTREE") orelse false) {
        flags.append("-DSQLITE_ENABLE_RTREE") catch @panic("OOM");
    }

    if (b.option(bool, "enable_stat4", "SQLITE_ENABLE_STAT4") orelse false) {
        flags.append("-DSQLITE_ENABLE_STAT4") catch @panic("OOM");
    }

    if (b.option(bool, "omit_decltype", "SQLITE_OMIT_DECLTYPE") orelse false) {
        flags.append("-DSQLITE_OMIT_DECLTYPE") catch @panic("OOM");
    }

    if (b.option(bool, "omit_json", "SQLITE_OMIT_JSON") orelse false) {
        flags.append("-DSQLITE_OMIT_JSON") catch @panic("OOM");
    }

    if (b.option(bool, "use_uri", "SQLITE_USE_URI") orelse false) {
        flags.append("-DSQLITE_USE_URI") catch @panic("OOM");
    }

    const sqlite = b.addModule("sqlite", .{ .root_source_file = LazyPath.relative("src/lib.zig") });
    const sqlite_dep = b.dependency("sqlite", .{});

    sqlite.addIncludePath(sqlite_dep.path("."));
    sqlite.addCSourceFile(.{ .file = sqlite_dep.path("sqlite3.c"), .flags = flags.items });

    // Tests
    const tests = b.addTest(.{ .root_source_file = LazyPath.relative("src/test.zig") });
    tests.addIncludePath(sqlite_dep.path("."));
    tests.addCSourceFile(.{ .file = sqlite_dep.path("sqlite3.c"), .flags = flags.items });

    const run_tests = b.addRunArtifact(tests);

    b.step("test", "Run tests").dependOn(&run_tests.step);
}