local prototype= require 'prototype'
local utf8=      require 'util.utf8'

local attribute_info= prototype {
    default= prototype.assignment_copy,
}

function attribute_info.parse(constant_pools, file)
    local attribute_name_index= file:read('u2')
    local const_utf8=           constant_pools[attribute_name_index]
    local attribute_name=       utf8.decode(const_utf8.bytes)

    if attribute_name == 'InnerClasses'           then return require('raw.attribute.inner_classes').new(constant_pools, file) end
    if attribute_name == 'ConstantValue'          then return require('raw.attribute.constant_value').new(constant_pools, file) end
    if attribute_name == 'Code'                   then return require('raw.attribute.code').new(constant_pools, file) end
    if attribute_name == 'Signature'              then return require('raw.attribute.signature').new(constant_pools, file) end
    if attribute_name == 'Exceptions'             then return require('raw.attribute.exceptions').new(constant_pools, file) end
    if attribute_name == 'LocalVariableTable'     then return require('raw.attribute.local_variable_table').new(constant_pools, file) end
    if attribute_name == 'LocalVariableTypeTable' then return require('raw.attribute.local_variable_type_table').new(constant_pools, file) end
    if attribute_name == 'Deprecated'             then return require('raw.attribute.deprecated').new(constant_pools, file) end
    if attribute_name == 'EnclosingMethod'        then return require('raw.attribute.enclosing_method').new(constant_pools, file) end

    -- when no matched, consume bytes
    local length= file:read('u4')
    local info=   file:read(length)

    return {
        kind= '<<unknown>>',
        attribute_name_index= attribute_name_index,
        attribute_length= length,
        info= info,
    }
end

return attribute_info
