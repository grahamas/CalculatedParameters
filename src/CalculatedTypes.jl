module CalculatedTypes

using MacroTools, Espresso
using Parameters

abstract type CalculatedType{S} end

"""
    Calculated(obj::T)::CalculatedType{T}

Constructs the calculated version of `obj::T`, where the return type is a subtype of `CalculatedType{T}`. Must be implemented for every subtype of `CalculatedType`
"""
function Calculated(a::T) where T
    error("Calculated type undefined for type $T")
end

"""
    get_value(calculated_object::CalculatedType)

Return the precomputed value stored by `calculated_object`.
"""
function get_value(calculated_object::CalculatedType)
    calculated_object.value
end
"""
    get_source(calculated_object::CalculatedType)

Return the original object  that generated `calculated_object`.
"""
function get_source(calculated_object::CalculatedType)
    calculated_object.source
end

function update(olds::AACT, news::AbstractArray{T}) where {T, CT<:CalculatedType{T},AACT<:AbstractArray{CT}}
    AACT[update(pair...) for pair in zip(olds, news)]
end

function make_calculation_fn_expr(calculation_fn_expr, source_type_expr, field_names, whereparams)
    fn_dict = MacroTools.splitdef(calculation_fn_expr)
    fn_args = [:(source::$(source_type_expr)), fn_dict[:args]...]
    @assert all(!(name in fn_args) for name in field_names)
    field_mapping = Dict(name => :(source.$name) for name in field_names)

    fn_dict[:name] = :(CalculatedTypes.calculate)
    fn_dict[:args] = fn_args
    fn_dict[:body] = subs(fn_dict[:body], field_mapping)
    if :whereparams in keys(fn_dict)
        fn_dict[:whereparams] = union(fn_dict[:whereparams], whereparams)
    else
        fn_dict[:whereparams] = whereparams
    end
    return MacroTools.combinedef(fn_dict), fn_args
end

"""
    @calculated_type(type_def_expr, calculation_fn_expr=nothing, return_type=:Any)

Define a CalculatedType.
"""
macro calculated_type(type_def_expr, calculation_fn_expr=nothing, return_type=:Any)
    @capture(type_def_expr,
        struct (T_{PT__} | (T_{PT__} <: _))
            fields__
        end
        )
    field_names = [(@capture(field, name_::_) ? name : field) for field in fields]
    rt_sym = gensym(:RT)
    unparameterized_calculated_type_expr = Symbol(:Calculated,T)
    calculated_type_expr = :($unparameterized_calculated_type_expr{$(PT...), $rt_sym})
    source_type_expr = :($T{$(PT...)})
    calculation_fn_expr, calculation_fn_args = make_calculation_fn_expr(calculation_fn_expr, source_type_expr, field_names, PT)
    calculation_fn_arg_names = [splitarg(arg)[1] for arg in calculation_fn_args]

    return esc(quote
        Base.@__doc__($(type_def_expr))
        function $source_type_expr(; $(field_names...)) where {$(PT...)}
             $source_type_expr($(field_names...))
         end
         $(calculation_fn_expr)
         Base.@__doc__(struct $(calculated_type_expr) <: CalculatedType{$(source_type_expr)}
            source::$(source_type_expr)
            value::$rt_sym
            #$calculated_type_expr(source::$(source_type_expr), calculated::$rt_sym) where {$(PT...), $rt_sym} = new(source, calculated)
         end)
         function Calculated($(calculation_fn_args...)) where {$(PT...)}
             $(unparameterized_calculated_type_expr)(source, CalculatedTypes.calculate($(calculation_fn_arg_names...)))
         end
    end)
end

"""
    calculate(obj)

Return the value calculated for `obj`, to be stored in the `CalculatedType`'s `value` field.
"""
calculate(a::T) where T = error("calculate undefined for type $T.")

export CalculatedType, Calculated, update, get_value, @calculated_type, calculate

end
