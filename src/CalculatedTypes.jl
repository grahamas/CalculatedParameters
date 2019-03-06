module CalculatedTypes

using MacroTools, Espresso
using Parameters

abstract type CalculatedType{S} end

function Calculated(a::T) where T
    error("Calculated type undefined for type $T")
end

function get_value(calculated_object::CalculatedType)
    calculated_object.value
end

function update(olds::AACT, news::AbstractArray{T}) where {T, CT<:CalculatedType{T},AACT<:AbstractArray{CT}}
    AACT[update(pair...) for pair in zip(olds, news)]
end

macro calculated_type(type_def_expr, calculation_body_expr=nothing, return_type=:Any)
    @capture(type_def_expr,
        struct (T_{PT__} | (T_{PT__} <: _))
            fields__
        end
        )
    field_names = [(@capture(field, name_::_) ? name : field) for field in fields]
    field_mapping = Dict(name => :(source.$name) for name in field_names)
    calculation_body_expr = subs(calculation_body_expr, field_mapping)
    rt_sym = gensym(:RT)
    unparameterized_calculated_type_expr = Symbol(:Calculated,T)
    calculated_type_expr = :($unparameterized_calculated_type_expr{$(PT...), $rt_sym})
    source_type_expr = :($T{$(PT...)})
    if calculation_body_expr == nothing
        calculate_fn_expr = :()
    else
        calculate_fn_expr = :(function calculate(source::$(source_type_expr)) where {$(PT...)}
            $(calculation_body_expr)
        end)
    end
    return esc(quote
        $(type_def_expr)
        function $source_type_expr(; $(field_names...)) where {$(PT...)}
             $source_type_expr($(field_names...))
         end
         $(calculate_fn_expr)
        struct $(calculated_type_expr) <: CalculatedType{$(source_type_expr)}
            source::$(source_type_expr)
            value::$rt_sym
            #$calculated_type_expr(source::$(source_type_expr), calculated::$rt_sym) where {$(PT...), $rt_sym} = new(source, calculated)
        end
        function Calculated(source::$(source_type_expr)) where {$(PT...)}
            $(unparameterized_calculated_type_expr)(source, calculate(source))
        end
    end)
end

export CalculatedType, Calculated, update, get_value, @calculated_type

end
