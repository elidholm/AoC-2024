const std = @import("std");

const input = @embedFile("input.txt");

pub fn main() !void {
    const totalDistance = try computeTotalDistance(input);
    try std.io.getStdOut().writer()
        .print("Total distance: {d}\n", .{totalDistance});
}

fn computeTotalDistance(data: []const u8) !u64 {
    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();

    var leftNumbers = std.ArrayList(u32).init(allocator.allocator());
    var rightNumbers = std.ArrayList(u32).init(allocator.allocator());

    try parseNumbers(data, &leftNumbers, &rightNumbers);
    sortNumbers(leftNumbers.items, rightNumbers.items);

    return calculateTotalDistance(leftNumbers.items, rightNumbers.items);
}

fn parseNumbers(
    inputData: []const u8,
    leftNumbers: *std.ArrayList(u32),
    rightNumbers: *std.ArrayList(u32)
) !void {
    var linesIter = std.mem.tokenizeScalar(u8, inputData, '\n');

    while (linesIter.next()) |line| {
        var numIter = std.mem.tokenizeScalar(u8, line, ' ');
        const leftNumber = try std.fmt.parseInt(u32, numIter.next().?, 10);
        const rightNumber = try std.fmt.parseInt(u32, numIter.next().?, 10);

        try leftNumbers.append(leftNumber);
        try rightNumbers.append(rightNumber);
    }
}

fn sortNumbers(left: []u32, right: []u32) void {
    std.sort.pdq(u32, left, {}, compareAscending);
    std.sort.pdq(u32, right, {}, compareAscending);
}

fn compareAscending(_: void, a: u32, b: u32) bool {
    return a < b;
}

fn calculateTotalDistance(left: []u32, right: []u32) u64 {
    var totalDistance: u64 = 0;
    for (left, right) |leftNum, rightNum| {
        totalDistance += if (leftNum > rightNum) leftNum - rightNum else rightNum - leftNum;
    }
    return totalDistance;
}

test "correct distance" {
    const test_input = "3 4\n4 3\n2 5\n1 3\n3 9\n3 3";

    const expected = 11;
    const result = try computeTotalDistance(test_input);

    try std.testing.expectEqual(expected, result);
}
