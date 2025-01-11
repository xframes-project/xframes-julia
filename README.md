# xframes-julia

## Instructions

### Install Julia

https://julialang.org/downloads/

julia --project=. -e 'using Pkg; Pkg.add("JSON")'

### Install the dependencies

`julia --project=. -e 'using Pkg; Pkg.instantiate()'`

### Running the application

`julia --project=. src/XFrames.jl`