const std = @import("std");
const Allocator = std.mem.Allocator;
const Alignment = std.mem.Alignment;

const mimalloc = @import("mimalloc");

pub const vtable = Allocator.VTable{
    .alloc = alloc,
    .resize = resize,
    .remap = remap,
    .free = free,
};

fn alloc(self: *anyopaque, len: usize, alignment: Alignment, ret_addr: usize) ?[*]u8 {
    _ = self;
    _ = ret_addr;

    const ptr = mimalloc.mi_malloc_aligned(len, alignment.toByteUnits()) orelse return null;
    return @ptrCast(ptr);
}

fn resize(self: *anyopaque, memory: []u8, alignment: Alignment, new_len: usize, ret_addr: usize) bool {
    _ = self;
    _ = alignment;
    _ = ret_addr;

    return mimalloc.mi_expand(memory.ptr, new_len) != null;
}

fn remap(self: *anyopaque, memory: []u8, alignment: Alignment, new_len: usize, ret_addr: usize) ?[*]u8 {
    _ = self;
    _ = ret_addr;
    const ptr = mimalloc.mi_realloc_aligned(memory.ptr, new_len, alignment.toByteUnits()) orelse return null;
    return @ptrCast(ptr);
}

fn free(self: *anyopaque, memory: []u8, alignment: Alignment, ret_addr: usize) void {
    _ = self;
    _ = ret_addr;
    mimalloc.mi_free_aligned(memory.ptr, alignment.toByteUnits());
}
