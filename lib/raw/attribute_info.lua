local prototype= require 'prototype'
local youjo=     require 'util.youjo'

local attribute_info= prototype {
    default= prototype.assignment_copy,
}

function attribute_info.parse(constant_pools, reader)
    local attribute_name_index= reader:read_int16()
    local const_utf8=           constant_pools[attribute_name_index]
    local attribute_name=       youjo:decode_utf8(const_utf8.bytes)

    if attribute_name == 'InnerClasses' then return require('raw.attribute.inner_classes').new(constant_pools, reader) end
    if attribute_name == 'ConstantValue' then return require('raw.attribute.constant_value').new(constant_pools, reader) end
    if attribute_name == 'Code' then return require('raw.attribute.code').new(constant_pools, reader) end

    -- when no matched, consume bytes
    local length= reader:read_int32()
    local info= reader:read(length)

    return {
        kind= '<<unknown>>',
        attribute_name_index= attribute_name_index,
        attribute_length= length,
        info= info,
    }
end

return attribute_info