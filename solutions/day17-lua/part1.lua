#!/usr/bin/env lua

-- Function to split a string by a delimiter
local function split(inputstr, sep)
    sep = sep or ":"
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

-- Function to read the entire content of a file
local function readFile(filename)
    local file = io.open(filename, "rb")
    if not file then
        error("Cannot open file: " .. filename)
    end
    local content = file:read("*all")
    file:close()
    return content
end

-- Initialize registers and program data
local content = split(readFile("input.txt"), "\n")

local Registers = {
    a = tonumber(split(content[1])[2]),
    b = tonumber(split(content[2])[2]),
    c = tonumber(split(content[3])[2])
}

local Instructions = {}
for _, value in ipairs(split(split(content[4])[2], ",")) do
    table.insert(Instructions, tonumber(value))
end

local IPointer = 1
local Output = {}

-- Check if an opcode uses a combo operand
local function isCombo(opcode)
    return opcode == 0 or opcode == 2 or opcode == 5 or opcode == 6 or opcode == 7
end

-- Get the value of a combo operand
local function getComboOperand(operand)
    if operand <= 3 then
        return operand
    elseif operand == 4 then
        return Registers.a
    elseif operand == 5 then
        return Registers.b
    elseif operand == 6 then
        return Registers.c
    else
        error("Invalid combo operand: " .. operand)
    end
end

-- Instruction implementations
local function adv(operand)
    Registers.a = math.floor(Registers.a / (2 ^ operand))
    IPointer = IPointer + 2
end

local function bxl(operand)
    Registers.b = Registers.b ~ operand
    IPointer = IPointer + 2
end

local function bst(operand)
    Registers.b = operand % 8
    IPointer = IPointer + 2
end

local function jnz(operand)
    if Registers.a ~= 0 then
        IPointer = operand + 1
    else
        IPointer = IPointer + 2
    end
end

local function bxc(_)
    Registers.b = Registers.b ~ Registers.c
    IPointer = IPointer + 2
end

local function out(operand)
    table.insert(Output, operand % 8)
    IPointer = IPointer + 2
end

local function bdv(operand)
    Registers.b = math.floor(Registers.a / (2 ^ operand))
    IPointer = IPointer + 2
end

local function cdv(operand)
    Registers.c = math.floor(Registers.a / (2 ^ operand))
    IPointer = IPointer + 2
end

-- Execute a single instruction
local function execute(opcode, operand)
    if isCombo(opcode) then
        operand = getComboOperand(operand)
    end

    if opcode == 0 then
        adv(operand)
    elseif opcode == 1 then
        bxl(operand)
    elseif opcode == 2 then
        bst(operand)
    elseif opcode == 3 then
        jnz(operand)
    elseif opcode == 4 then
        bxc(operand)
    elseif opcode == 5 then
        out(operand)
    elseif opcode == 6 then
        bdv(operand)
    elseif opcode == 7 then
        cdv(operand)
    else
        error("Unknown opcode: " .. opcode)
    end
end

-- Main execution loop
while IPointer <= #Instructions do
    execute(Instructions[IPointer], Instructions[IPointer + 1])
end

-- Print the final output
print(table.concat(Output, ","))

