pub const cdef = @cImport({
    @cInclude("quickjs.h");
});

pub const Runtime = struct {
    ptr: *cdef.JSRuntime,
    pub fn init() !Runtime {
        const rt = cdef.JS_NewRuntime();
        if (rt == null)
            return error.CreationFailed;

        return Runtime{
            .ptr = rt.?,
        };
    }

    pub fn deinit(self: Runtime) void {
        cdef.JS_FreeRuntime(self.ptr);
    }
};

pub const Context = struct {
    ptr: *cdef.JSContext,
    pub fn init(runtime: *Runtime) !Context {
        const ctx = cdef.JS_NewContext(runtime.ptr);
        if (ctx == null)
            return error.CreationFailed;

        return Context{
            .ptr = ctx.?,
        };
    }

    pub fn deinit(self: Context) void {
        cdef.JS_FreeContext(self.ptr);
    }

    pub fn getGlobalObject(self: Context) cdef.JSValue {
        return cdef.JS_GetGlobalObject(self.ptr);
    }
};

pub const Value = struct {
    ptr: *cdef.JSValue,
    pub fn from(ptr: *cdef.JSValue) Value {
        return Value{
            .ptr = ptr,
        };
    }

    pub fn newObject(ctx: *Context) Value {
        return Value.from(cdef.JS_NewObject(ctx.ptr));
    }

    pub fn newObjectProto(ctx: *Context, proto: Value) Value {
        return Value.from(cdef.JS_NewObjectProto(ctx.ptr, proto.ptr));
    }

    pub fn isException(self: Value) bool {
        return cdef.JS_IsException(self.ptr) != 0;
    }
};
