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

macro calculated_type(type_def_expr, calculation_body_expr, return_type=:Any)
    @capture(type_def_expr,
        struct (T_{PT__} | (T_{PT__} <: _))
            fields__
        end
        )
    field_names = [(@capture(field, name_::_) ? name : field) for field in fields]
    field_mapping = Dict(name => :(source.$name) for name in field_names)
    calculation_body_expr = subs(calculation_body_expr, field_mapping)
    calculated_type_expr = :($(Symbol(:Calculated,T)){$(PT...)})
    source_type_expr = :($T{$(PT...)})
    return esc(quote
        $(type_def_expr)
        function $source_type_expr(; $(field_names...)) where {$(PT...)}
             $source_type_expr($(field_names...))
         end
        function calculate(source::$(source_type_expr)) where {$(PT...)}
            $(calculation_body_expr)
        end
        struct $(calculated_type_expr) <: CalculatedType{$(source_type_expr)}
            source::$(source_type_expr)
            value::$return_type
            $calculated_type_expr(source::$(source_type_expr)) where {$(PT...)} = new(source, calculate(source))
        end
        function Calculated(source::$(source_type_expr)) where {$(PT...)}
            $(calculated_type_expr)(source)
        end
    end)
end

export CalculatedType, Calculated, update, get_value, @calculated_type

end
