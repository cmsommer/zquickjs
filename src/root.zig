pub const c = @cImport({
    @cInclude("quickjs.h");
});

pub const Runtime = struct {
    ptr: *c.JSRuntime,
    pub fn init() !Runtime {
        const rt = c.JS_NewRuntime();
        if (rt == null)
            return error.CreationFailed;

        return Runtime{
            .ptr = rt.?,
        };
    }

    pub fn deinit(self: Runtime) void {
        c.JS_FreeRuntime(self.ptr);
    }
};

pub const Context = struct {
    ptr: *c.JSContext,
    pub fn init(runtime: *Runtime) !Context {
        const ctx = c.JS_NewContext(runtime.ptr);
        if (ctx == null)
            return error.CreationFailed;

        return Context{
            .ptr = ctx.?,
        };
    }

    pub fn deinit(self: Context) void {
        c.JS_FreeContext(self.ptr);
    }

    pub fn getGlobalObject(self: Context) c.JSValue {
        return c.JS_GetGlobalObject(self.ptr);
    }
};

pub const Value = struct {
    ptr: *c.JSValue,
    pub fn from(ptr: *c.JSValue) Value {
        return Value{
            .ptr = ptr,
        };
    }
};
