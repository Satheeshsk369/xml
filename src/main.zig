const std = @import("std");
const Xml = @import("xml");

/// Run with
/// zig build run -- <xml_file_path>
pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();
    const args = try std.process.argsAlloc(arena);
    const input_file = args[1];
    const max_bytes = std.math.maxInt(u32);
    var xml: Xml = .{ .bytes = try std.fs.cwd().readFileAlloc(arena, input_file, max_bytes) };
    var bw = std.io.bufferedWriter(std.io.getStdOut().writer());
    const writer = bw.writer();
    while (true) {
        const token = xml.next();
        try writer.print("{s}: {s}\n", .{ @tagName(token.tag), token.bytes });
        if (token.tag == .eof) break;
    }
    try bw.flush();
}
