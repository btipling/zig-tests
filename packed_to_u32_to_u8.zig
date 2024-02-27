const std = @import("std");

const Voxel = packed struct {
    block_id: u8, // 256 different block types,
    andorment_id: u7, // 128 different adornments
    up_x: i2,
    up_y: i2,
    up_z: i2,
    health: u4,
    lighting: u4,
    opacity: u3,
};

pub fn main() void {
    const v1: Voxel = .{
        .block_id = 1,
        .andorment_id = 2,
        .up_x = -1,
        .up_y = 1,
        .up_z = 0,
        .health = 15,
        .lighting = 7,
        .opacity = 7,
    };
    const v2: Voxel = .{
        .block_id = 101,
        .andorment_id = 39,
        .up_x = 1,
        .up_y = 0,
        .up_z = -1,
        .health = 8,
        .lighting = 15,
        .opacity = 0,
    };
    const voxels: [2]Voxel align(8) = [_]Voxel{ v1, v2 };
    for (voxels) |v| {
        printVoxel(v);
    }

    // turn into bytes:
    const datas: []const u8 = std.mem.sliceAsBytes(&voxels);
    std.debug.print("\n\nas bytes:\n", .{});
    for (datas) |d| {
        std.debug.print("{d} ", .{d});
    }
    std.debug.print("\n", .{});

    // turn into u32s:
    const datasptr: []align(4) const u8 = @alignCast(datas);
    const items: []const u32 = std.mem.bytesAsSlice(u32, datasptr);
    for (items) |d| {
        std.debug.print("voxel as u32: {d}\n", .{d});
    }
    // Turn it back to voxels:
    const rv_voxels: []const Voxel align(4) = std.mem.bytesAsSlice(Voxel, datasptr);
    for (rv_voxels) |v| {
        printVoxel(v);
    }
}

fn printVoxel(v: Voxel) void {
    std.debug.print("\nVoxel:\n", .{});
    std.debug.print("block_id: {}\n", .{v.block_id});
    std.debug.print("andorment_id:  {}\n", .{v.andorment_id});
    std.debug.print("up_x: {}\n", .{v.up_x});
    std.debug.print("up_y:  {}\n", .{v.up_y});
    std.debug.print("up_z:  {}\n", .{v.up_z});
    std.debug.print("health:  {}\n", .{v.health});
    std.debug.print("lighting:  {}\n", .{v.lighting});
    std.debug.print("opacity:  {}\n", .{v.opacity});
    std.debug.print("\n", .{});
}

// run  :
// $ zig run .\packed_to_u32_to_u8.zig

// Voxel:
// block_id: 1
// andorment_id:  2
// up_x: -1
// up_y:  1
// up_z:  0
// health:  15
// lighting:  7
// opacity:  7

// Voxel:
// block_id: 101
// andorment_id:  39
// up_x: 1
// up_y:  0
// up_z:  -1
// health:  8
// lighting:  15
// opacity:  0

// as bytes:
// 1 130 227 239 101 167 24 31
// voxel as u32: 4024664577
// voxel as u32: 521709413

// Voxel:
// block_id: 1
// andorment_id:  2
// up_x: -1
// up_y:  1
// up_z:  0
// health:  15
// lighting:  7
// opacity:  7

// Voxel:
// block_id: 101
// andorment_id:  39
// up_x: 1
// up_y:  0
// up_z:  -1
// health:  8
// lighting:  15
// opacity:  0
