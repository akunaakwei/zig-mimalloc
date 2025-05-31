const std = @import("std");
const Allocator = std.mem.Allocator;
const BasicAllocator = @import("BasicAllocator.zig");

pub const basic_allocator = Allocator{
    .ptr = undefined,
    .vtable = &BasicAllocator.vtable,
};
