const std = @import("std");

pub fn main() void {
    // test vars:
    const items: [2]f32 align(8) = [_]f32{ 3.14, 1.23 };
    const datas: []const u8 = std.mem.sliceAsBytes(&items);

    // Turn it back to f32s:
    const datasptr: []align(4) const u8 = @alignCast(datas);
    const rv_items: []const f32 = std.mem.bytesAsSlice(f32, datasptr);
    std.debug.print("rva: {d}, rvb: {d}\n", .{ rv_items[0], rv_items[1] });
}
