# CalculatedTypes Documentation

```@meta
DocTestSetup = quote
    using CalculatedTypes
end
```

Precompute expensive objects and/or generic interface for calculating parametrized objects.

## Example

```jldoctest SumType
julia> @calculated_type(struct SumType{T}
            fieldA::T
            fieldB::T
        end, function calculate()
            fieldA + fieldB
        end,
        T
        );

julia> sum_type = SumType(1.0, 3.0);

julia> calc_sum_type = Calculated(sum_type);

julia> get_source(calc_sum_type)
SumType{Float64}(1.0, 3.0)

julia> get_value(calc_sum_type)
4.0
```

## Functions

```@autodocs
Modules = [CalculatedTypes]
```
