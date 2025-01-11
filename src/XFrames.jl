module XFrames

using Libdl, JSON

# Define the callback types using Ptr{Function}
COnInitCb = Ptr{Function}
COnTextChangedCb = Ptr{Function}
COnComboChangedCb = Ptr{Function}
COnNumericValueChangedCb = Ptr{Function}
COnBooleanValueChangedCb = Ptr{Function}
COnMultipleNumericValuesChangedCb = Ptr{Function}
COnClickCb = Ptr{Function}

# Define the callback functions in Julia

function on_init()
    println("Initialization complete!")
end

function on_text_changed(id::Cint, text::Cstring)
    println("Text changed for id $id: $text")
end

function on_combo_changed(id::Cint, value::Cint)
    println("Combo box changed for id $id: $value")
end

function on_numeric_value_changed(id::Cint, value::Cfloat)
    println("Numeric value changed for id $id: $value")
end

function on_boolean_value_changed(id::Cint, value::Cint)
    println("Boolean value changed for id $id: $(value != 0)")
end

function on_multiple_numeric_values_changed(id::Cint, values::Ptr{Cfloat}, count::Cint)
    julia_values = unsafe_wrap(Array, values, count)
    println("Multiple numeric values changed for id $id: $julia_values")
end

function on_click(id::Cint)
    println("Button clicked with id $id")
end

# xframes = Libdl.dlopen(abspath("./libxframesshared.so"))

xframes = dlopen("./libxframesshared.so")
init = dlsym(xframes, :init)

# Convert Julia functions to C function pointers
on_init_ptr = @cfunction(on_init, Cvoid, ())
on_text_changed_ptr = @cfunction(on_text_changed, Cvoid, (Cint, Cstring))
on_combo_changed_ptr = @cfunction(on_combo_changed, Cvoid, (Cint, Cint))
on_numeric_value_changed_ptr = @cfunction(on_numeric_value_changed, Cvoid, (Cint, Cfloat))
on_boolean_value_changed_ptr = @cfunction(on_boolean_value_changed, Cvoid, (Cint, Cint))
on_multiple_numeric_values_changed_ptr = @cfunction(on_multiple_numeric_values_changed, Cvoid, (Cint, Ptr{Cfloat}, Cint))
on_click_ptr = @cfunction(on_click, Cvoid, (Cint,))

fontDefs = Dict(
    "defs" => vcat(map(
        def -> [Dict("name" => def.name, "size" => size) for size in def.sizes],
        [
            (name = "roboto-regular", sizes = [16, 18, 20, 24, 28, 32, 36, 48]),
        ]
    )...)
)

# Convert to JSON string if needed
fontDefsJson = JSON.json(fontDefs)

println(fontDefsJson)

baseAssetsPath = "./assets"
rawFontDefs = "{}"
rawStyleOverrides = "{}"

@ccall $init(
    baseAssetsPath::Cstring,
    rawFontDefs::Cstring,
    rawStyleOverrides::Cstring,
    on_init_ptr::Ptr{Cvoid},
    on_text_changed_ptr::Ptr{Cvoid},
    on_combo_changed_ptr::Ptr{Cvoid},
    on_numeric_value_changed_ptr::Ptr{Cvoid},
    on_boolean_value_changed_ptr::Ptr{Cvoid},
    on_multiple_numeric_values_changed_ptr::Ptr{Cvoid},
    on_click_ptr::Ptr{Cvoid}
)::Cvoid

println("Press Enter to continue...")
readline()

end
