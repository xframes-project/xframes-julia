module XFrames

using Libdl, JSON

const ImGuiCol = Dict(
    :Text => 0,
    :TextDisabled => 1,
    :WindowBg => 2,
    :ChildBg => 3,
    :PopupBg => 4,
    :Border => 5,
    :BorderShadow => 6,
    :FrameBg => 7,
    :FrameBgHovered => 8,
    :FrameBgActive => 9,
    :TitleBg => 10,
    :TitleBgActive => 11,
    :TitleBgCollapsed => 12,
    :MenuBarBg => 13,
    :ScrollbarBg => 14,
    :ScrollbarGrab => 15,
    :ScrollbarGrabHovered => 16,
    :ScrollbarGrabActive => 17,
    :CheckMark => 18,
    :SliderGrab => 19,
    :SliderGrabActive => 20,
    :Button => 21,
    :ButtonHovered => 22,
    :ButtonActive => 23,
    :Header => 24,
    :HeaderHovered => 25,
    :HeaderActive => 26,
    :Separator => 27,
    :SeparatorHovered => 28,
    :SeparatorActive => 29,
    :ResizeGrip => 30,
    :ResizeGripHovered => 31,
    :ResizeGripActive => 32,
    :Tab => 33,
    :TabHovered => 34,
    :TabActive => 35,
    :TabUnfocused => 36,
    :TabUnfocusedActive => 37,
    :PlotLines => 38,
    :PlotLinesHovered => 39,
    :PlotHistogram => 40,
    :PlotHistogramHovered => 41,
    :TableHeaderBg => 42,
    :TableBorderStrong => 43,
    :TableBorderLight => 44,
    :TableRowBg => 45,
    :TableRowBgAlt => 46,
    :TextSelectedBg => 47,
    :DragDropTarget => 48,
    :NavHighlight => 49,
    :NavWindowingHighlight => 50,
    :NavWindowingDimBg => 51,
    :ModalWindowDimBg => 52,

   # COUNT can be included if needed
   :COUNT => 53
)

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

const theme2Colors = Dict(
    :darkestGrey => "#141f2c",
    :darkerGrey => "#2a2e39",
    :darkGrey => "#363b4a",
    :lightGrey => "#5a5a5a",
    :lighterGrey => "#7A818C",
    :evenLighterGrey => "#8491a3",
    :black => "#0A0B0D",
    :green => "#75f986",
    :red => "#ff0062",
    :white => "#fff"
)

const theme = Dict(
    :colors => Dict(
        string(ImGuiCol[:Text]) => [theme2Colors[:white], 1],
        string(ImGuiCol[:TextDisabled]) => [theme2Colors[:lighterGrey], 1],
        string(ImGuiCol[:WindowBg]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:ChildBg]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:PopupBg]) => [theme2Colors[:white], 1],
        string(ImGuiCol[:Border]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:BorderShadow]) => [theme2Colors[:darkestGrey], 1],
        string(ImGuiCol[:FrameBg]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:FrameBgHovered]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:FrameBgActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:TitleBg]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:TitleBgActive]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:TitleBgCollapsed]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:MenuBarBg]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:ScrollbarBg]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:ScrollbarGrab]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:ScrollbarGrabHovered]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:ScrollbarGrabActive]) => [theme2Colors[:darkestGrey], 1],
        string(ImGuiCol[:CheckMark]) => [theme2Colors[:darkestGrey], 1],
        string(ImGuiCol[:SliderGrab]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:SliderGrabActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:Button]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:ButtonHovered]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:ButtonActive]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:Header]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:HeaderHovered]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:HeaderActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:Separator]) => [theme2Colors[:darkestGrey], 1],
        string(ImGuiCol[:SeparatorHovered]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:SeparatorActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:ResizeGrip]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:ResizeGripHovered]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:ResizeGripActive]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:Tab]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:TabHovered]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:TabActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:TabUnfocused]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:TabUnfocusedActive]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:PlotLines]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:PlotLinesHovered]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:PlotHistogram]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:PlotHistogramHovered]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:TableHeaderBg]) => [theme2Colors[:black], 1],
        string(ImGuiCol[:TableBorderStrong]) => [theme2Colors[:lightGrey], 1],
        string(ImGuiCol[:TableBorderLight]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:TableRowBg]) => [theme2Colors[:darkGrey], 1],
        string(ImGuiCol[:TableRowBgAlt]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:TextSelectedBg]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:DragDropTarget]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:NavHighlight]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:NavWindowingHighlight]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:NavWindowingDimBg]) => [theme2Colors[:darkerGrey], 1],
        string(ImGuiCol[:ModalWindowDimBg]) => [theme2Colors[:darkerGrey], 1]
    )
)

themeJson = JSON.json(theme)

baseAssetsPath = "./assets"

@ccall $init(
    baseAssetsPath::Cstring,
    fontDefsJson::Cstring,
    themeJson::Cstring,
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
