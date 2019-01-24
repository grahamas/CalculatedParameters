module CalculatedTypes


abstract type CalculatedType{S} end
function get_value(calculated_object::CalculatedType)
    calculated_object.value
end

function update(olds::AACT}, news::AbstractArray{T}) where {T, CT<:CalculatedType{T},AACT<:AbstractArray{CT}}
    AACT[update(pair...) for pair in zip(olds, news)]
end

function Calculated(a::T) where T
	error("Calculated type undefined for type $T")
end

export zero, default_value, bounds
export update
export get_value

end