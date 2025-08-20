const std = @import("std");
pub const c = @cImport({
    @cInclude("quickjs.h");
    @cInclude("quickjs-libc.h");
});
