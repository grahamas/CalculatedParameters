using Documenter, CalculatedTypes

makedocs(
    sitename="CalculatedTypes",
    modules=[CalculatedTypes],
    pages = ["index.md"]
)

deploydocs(
    repo = "github.com/grahamas/CalculatedTypes.git"
)
