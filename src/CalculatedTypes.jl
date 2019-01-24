module CalculatedTypes

abstract type CalculatedType{S} end

function Calculated(a::T) where T
    error("Calculated type undefined for type $T")
end

function update(olds::AACT}, news::AbstractArray{T}) where {T, CT<:CalculatedType{T},AACT<:AbstractArray{CT}}
    AACT[update(pair...) for pair in zip(olds, news)]
end

export CalculatedType, Calculated, update

end