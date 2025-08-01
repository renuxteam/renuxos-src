// Re-export the `video` namespace from `video/mod.zig`,
// allowing any code that does `@import("lib").video` to access
// all video-related drivers and utilities.
pub const video: type = @import("video/mod.zig");

// Re-export the `input` namespace from `input/mod.zig`,
// so that `@import("lib").input` provides access to
// keyboard, mouse, and other input device drivers.
pub const input: type = @import("input/mod.zig");
