local xml = require("simplelib")
local type = type
local tostring = tostring
local setmetatable = setmetatable
local io = io
local ipairs = ipairs
local pairs = pairs
local assert = assert
_ENV = nil

-- Symbolic name for tag index, this allows accessing the tag by
-- var[xml.TAG].
local TAG = 0

-- Sets or returns tag of a LuaXML object.
function xml.tag (var, tag)
   if tag == nil then
      return var[TAG]
   end

   var[TAG] = assert (tostring (tag))
end

-- Creates a new LuaXML object either by setting the metatable of an
-- existing Lua table or by setting its tag.
function xml.new (arg)
   if type (arg) == "table" then
      setmetatable(arg, {__index=xml, __tostring=xml.str})
      return arg
   end

   local var = {}
   setmetatable (var, {__index=xml, __tostring=xml.str})

   if type (arg) == "string" then
      var[TAG] = arg
   end

   return var
end

-- Appends a new subordinate LuaXML object to an existing one,
-- optionally setting its tag.
function xml.append (var, tag)
   local newVar = xml.new (tag)
   var[#var+1] = newVar
   return newVar
end

-- Converts any Lua var into a XML string
function xml.str (var, level)
   local level = level or 0
   local s = ''
   local indent = '\t'
   local child = ''

   s = indent:rep (level) .. '<' .. var[TAG]

   for k, v in pairs (var) do
      if type (k) == "string" then
         s = s .. ' ' .. k .. '="' .. v .. '"'
      end
   end

   for _, v in ipairs (var) do
      child = child .. xml.str (v, level +1)
   end

   if child == '' then
      s = s .. '/>\n'
   else
      s = s .. '>\n' .. child .. indent:rep (level) .. '</' .. var[TAG] .. '>\n'
   end
   return s
end

-- Saves a Lua var as XML file
function xml.save(var,filename)
   local file = io.open (assert (tostring (filename)), "w")
   file:write ("<?xml version=\"1.0\"?>\n<!-- file \"", filename,
              "\", generated by LuaXML -->\n\n")
   file:write (xml.str (var))
   io.close (file)
end


-- Recursively parses a Lua table for a substatement fitting to the provided
-- tag and attribute.
function xml.find (var, tag, key, value)
   if type (var) ~= "table" then
      return nil
   end

   -- compare this table:
   if var[TAG] == tag and (value == nil or var[key] == value) then
      setmetatable (var, {__index=xml, __tostring=xml.str})
      return var
   end
   if tag == nil and var[key] == value then
      setmetatable (var, {__index=xml, __tostring=xml.str})
      return var
   end

   -- recursively parse subtags:
   for _, v in ipairs (var) do
      local ret = xml.find (v, tag, key, value)
      if ret ~= nil then
         return ret
      end
   end
end

return xml
