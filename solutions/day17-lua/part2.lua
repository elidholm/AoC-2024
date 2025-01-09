#!/usr/bin/env lua

local prog = {}
for line in io.lines() do
    local p = line:match("Program: (.+)")
    if p then
        for n in p:gmatch("%d+") do
            table.insert(prog, tonumber(n))
        end
    end
end

-- Code tailored to my input
local valid = { 0 }
for i = #prog, 1, -1 do
    local newValid = {}
    for _, val in ipairs(valid) do
        for n = 0, 7 do
            local a = (val << 3) + n
            local b = a % 8 ~ 1
            local c = math.floor(a / 2^b)
            b = b ~ 5 ~ c
            if b % 8 == prog[i] then
                table.insert(newValid, a)
            end
        end
    end
    valid = newValid
end

local min = math.huge
for _, n in ipairs(valid) do
    min = math.min(min, n)
end
print(min)
