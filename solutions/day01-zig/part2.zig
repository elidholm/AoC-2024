const std = @import("std");

const input = @embedFile("input.txt");

pub fn main() !void {
    const similarity = try computeSimilarity(input);
    try std.io.getStdOut().writer()
        .print("Similarity: {d}\n", .{similarity});
}

fn computeSimilarity(data: []const u8) !u32 {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();

    var leftLocations = std.ArrayList(u32).init(allocator.allocator());
    var rightOccurrences = std.AutoArrayHashMap(u32, u16).init(allocator.allocator());

    try parseInput(data, &leftLocations, &rightOccurrences);
    return calculateSimilarity(leftLocations.items, rightOccurrences);
}

// ziglint: ignore
fn parseInput(inputData: []const u8, leftLocations: *std.ArrayList(u32), rightOccurrences: *std.AutoArrayHashMap(u32, u16)) !void {
    var linesIter = std.mem.tokenizeScalar(u8, inputData, '\n');

    while (linesIter.next()) |line| {
        var numIter = std.mem.tokenizeScalar(u8, line, ' ');
        const leftLocation = try std.fmt.parseInt(u32, numIter.next().?, 10);
        const rightLocation = try std.fmt.parseInt(u32, numIter.next().?, 10);

        try leftLocations.append(leftLocation);
        const getOrPut = try rightOccurrences.getOrPutValue(rightLocation, 1);
        if (getOrPut.found_existing) {
            getOrPut.value_ptr.* += 1;
        }
    }
}

fn calculateSimilarity(leftLocations: []u32, rightOccurrences: std.AutoArrayHashMap(u32, u16)) u32 {
    var similarity: u32 = 0;
    for (leftLocations) |leftLoc| {
        const occurenceCount: u32 = @intCast(rightOccurrences.get(leftLoc) orelse 0);
        similarity += leftLoc * occurenceCount;
    }
    return similarity;
}

test "correct similarity" {
    const test_input = "3 4\n4 3\n2 5\n1 3\n3 9\n3 3\n";

    const expected = 31;
    const result = try computeSimilarity(test_input);

    try std.testing.expectEqual(expected, result);
}
