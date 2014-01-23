--[[ dietncl.nclaux -- Auxiliary functions.
     Copyright (C) 2013-2014 PUC-Rio/Laboratorio TeleMidia

This file is part of DietNCL.

DietNCL is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your
option) any later version.

DietNCL is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received a copy of the GNU General Public License along
with DietNCL.  If not, see <http://www.gnu.org/licenses/>.  ]]--

local nclaux = {}

local assert = assert
local math = math
local tonumber = tonumber
local type = type

local xml = require ('dietncl.xmlsugar')
_ENV = nil

---
-- Returns the number of seconds denoted by NCL time string STR or nil, if
-- STR is not a valid NCL time string.
--
function nclaux.timetoseconds (str)
   local h, m, s, f = 0, 0, str:match ('^(%d*)%.?(%d*)s')

   -- Try the alternate syntax.
   if s == nil and f == nil then
      h, m, s = str:match ('^(%d-):?(%d-):?([%d.]*)$')
      if s == nil then
         return nil             -- invalid str
      end
      h, m = tonumber (h) or 0, tonumber (m) or 0
      s, f = s:match ('^(%d*)%.?(%d*)$')
   end

   s, f = tonumber (s) or 0, tonumber (f) or 0
   if f > 0 then
      f = f / math.pow (10, math.floor (math.log (f, 10) + 1))
   end
   return 60*60*h + 60*m + s + f
end

---
-- Returns a new XML-ID string not defined in document NCL.
--
local GEN_ID_REP_CHAR = '_'
local GEN_ID_USERDATA_PREFIX = 'gen-id-prefix'
local GEN_ID_USERDATA_SERIAL = 'gen-id-serial'

function nclaux.gen_id (ncl)
   local prefix = ncl:getuserdata (GEN_ID_USERDATA_PREFIX)
   local serial = ncl:getuserdata (GEN_ID_USERDATA_SERIAL)

   -- Generate a new unique prefix.
   if not prefix then
      assert (not serial)

      -- Find the longest XML-ID string in NCL.
      serial = 0
      prefix = ''
      for e in ncl:gmatch (nil, 'id') do
         if #e.id > #prefix then
            prefix = e.id
         end
      end

      -- Initialize gen_id userdata.
      prefix = (GEN_ID_REP_CHAR):rep (#prefix + 1)
      ncl:setuserdata (GEN_ID_USERDATA_PREFIX, prefix)
      ncl:setuserdata (GEN_ID_USERDATA_SERIAL, serial)
   end

   assert (type (prefix) == 'string')
   assert (type (serial) == 'number')
   ncl:setuserdata (GEN_ID_USERDATA_SERIAL, serial + 1)

   return prefix..serial
end

---
-- Gets the last XML-ID generated by gen_id() for document NCL.
-- If gen_id was called for NCL, this function returns three values:
--  (1) the last XML-ID string;
--  (2) the prefix of the last XML-ID; and
--  (3) the serial of the last XML-ID.
-- Otherwise, it returns nil.
--
function nclaux.get_last_gen_id (ncl)
   local prefix
   local serial

   prefix = ncl:getuserdata (GEN_ID_USERDATA_PREFIX)
   if prefix == nil then
      return nil
   end

   serial = ncl:getuserdata (GEN_ID_USERDATA_SERIAL) - 1
   assert (serial >= 0)

   return prefix..serial, prefix, serial
end

---
-- Inserts into descriptor DESC a new descriptor parameter with name NAME
-- and value VALUE.  If DESC already contains a parameter with the given
-- name, do nothing.
--
function nclaux.insert_descparam (desc, name, value)
   if desc:match ('descriptorParam', 'name', name) then
      return                    -- avoid redefinition
   end
   local param = xml.new ('descriptorParam')
   param.name = name
   param.value = value
   desc:insert (param)
end

return nclaux
