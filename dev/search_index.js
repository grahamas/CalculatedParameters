var documenterSearchIndex = {"docs":
[{"location":"#CalculatedTypes-Documentation-1","page":"CalculatedTypes Documentation","title":"CalculatedTypes Documentation","text":"","category":"section"},{"location":"#","page":"CalculatedTypes Documentation","title":"CalculatedTypes Documentation","text":"DocTestSetup = quote\n    using CalculatedTypes\nend","category":"page"},{"location":"#","page":"CalculatedTypes Documentation","title":"CalculatedTypes Documentation","text":"Precompute expensive objects and/or generic interface for calculating parametrized objects.","category":"page"},{"location":"#","page":"CalculatedTypes Documentation","title":"CalculatedTypes Documentation","text":"Modules = [CalculatedTypes]","category":"page"},{"location":"#CalculatedTypes.calculate-Union{Tuple{T}, Tuple{T}} where T","page":"CalculatedTypes Documentation","title":"CalculatedTypes.calculate","text":"calculate(obj)\n\nReturn the value calculated for obj, to be stored in the CalculatedType's value field.\n\njulia> calc_sum_type = Calculated(sum_type);\n\n\n\n\n\n\n","category":"method"},{"location":"#CalculatedTypes.get_value-Tuple{CalculatedType}","page":"CalculatedTypes Documentation","title":"CalculatedTypes.get_value","text":"get_value(calculated_object::CalculatedType)\n\nReturn the precomputed value stored by calculated_object.\n\njulia> get_value(calc_sum_type)\n4.0\n\n\n\n\n\n","category":"method"},{"location":"#CalculatedTypes.@calculated_type","page":"CalculatedTypes Documentation","title":"CalculatedTypes.@calculated_type","text":"@calculated_type(type_def_expr, calculation_fn_expr=nothing, return_type=:Any)\n\nDefine a CalculatedType\n\njulia> @calculated_type(struct SumType{T}\n        fieldA{T}\n        fieldB{T}\n    end, function calculate()\n        fieldA + fieldB\n    end,\n    T\n);\n\njulia> sum_type = SumType(1.0, 3.0);\n\n\n\n\n\n","category":"macro"},{"location":"#CalculatedTypes.get_source-Tuple{CalculatedType}","page":"CalculatedTypes Documentation","title":"CalculatedTypes.get_source","text":"get_source(calculated_object::CalculatedType)\n\nReturn the original object  that generated calculated_object.\n\njulia> get_source(calc_sum_type)\nSumType{Float64}(1.0, 3.0)\n\n\n\n\n\n","category":"method"}]
}