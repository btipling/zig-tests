const std = @import("std");

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 1) {
        std.debug.print("call with some number as an unamed cli param\n", .{});
        return;
    }
    std.debug.print("called with `{s}`\n", .{args[1]});
    const n: u32 = try std.fmt.parseInt(u32, args[1], 10);
    std.debug.print("generating {d} items\n", .{n});
    var r = std.ArrayList([]u8).init(allocator);
    defer r.deinit();
    for (0..n) |i| {
        var buffer: [100]u8 = [_]u8{0} ** 100;
        const buf: []u8 = try allocator.alloc(u8, buffer.len);
        _ = try std.fmt.bufPrint(&buffer, "role-{d}", .{i});
        @memcpy(buf, &buffer);
        try r.append(buf);
    }
    const output = try std.mem.join(allocator, ",", r.items);
    defer for (r.items) |s| allocator.free(s);
    defer allocator.free(output);

    std.debug.print("{s}\n", .{output});
}
