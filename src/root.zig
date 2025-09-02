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

    // JS_Object
    pub fn newObject(ctx: *Context) Value {
        return Value.from(cdef.JS_NewObject(ctx.ptr));
    }

    pub fn newObjectProto(ctx: *Context, proto: Value) Value {
        return Value.from(cdef.JS_NewObjectProto(ctx.ptr, proto.ptr));
    }

    // JS_Function
    pub fn newFunction(ctx: *Context, name: []const u8) Value {
        return Value.from(cdef.JS_NewFunction(ctx.ptr, name.ptr));
    }

    pub fn newFunctionProto(ctx: *Context, proto: Value) Value {
        return Value.from(cdef.JS_NewFunctionProto(ctx.ptr, proto.ptr));
    }

    // JS_String
    pub fn newString(ctx: *Context, str: []const u8) Value {
        return Value.from(cdef.JS_NewString(ctx.ptr, str.ptr));
    }

    pub fn newStringLen(ctx: *Context, str: []const u8) Value {
        return Value.from(cdef.JS_NewStringLen(ctx.ptr, str.ptr, str.len));
    }

    pub fn newAtomString(ctx: *Context, str: []const u8) Value {
        return Value.from(cdef.JS_NewAtomString(ctx.ptr, str.ptr));
    }

    pub fn isException(self: Value) bool {
        return cdef.JS_IsException(self.ptr) != 0;
    }

    // JS_Number
    pub fn newInt32(ctx: *Context, val: i32) Value {
        return Value.from(cdef.JS_NewInt32(ctx.ptr, val));
    }

    pub fn newUint32(ctx: *Context, val: u32) Value {
        return Value.from(cdef.JS_NewUint32(ctx.ptr, val));
    }

    pub fn newFloat64(ctx: *Context, val: f64) Value {
        return Value.from(cdef.JS_NewFloat64(ctx.ptr, val));
    }

    pub fn newBigInt64(ctx: *Context, val: i64) Value {
        return Value.from(cdef.JS_NewBigInt64(ctx.ptr, val));
    }

    pub fn newBigUint64(ctx: *Context, val: u64) Value {
        return Value.from(cdef.JS_NewBigUint64(ctx.ptr, val));
    }

    // JS_Class
    pub fn newClass(ctx: *Context, name: []const u8) Value {
        return Value.from(cdef.JS_NewClass(ctx.ptr, name.ptr));
    }

    pub fn newClassProto(ctx: *Context, proto: Value) Value {
        return Value.from(cdef.JS_NewClassProto(ctx.ptr, proto.ptr));
    }

    // JS_Array
    pub fn newArray(ctx: *Context) Value {
        return Value.from(cdef.JS_NewArray(ctx.ptr));
    }

    // JS_Boolean
    pub fn newBoolean(ctx: *Context, val: bool) Value {
        return Value.from(cdef.JS_NewBool(ctx.ptr, @intFromBool(val)));
    }
};
