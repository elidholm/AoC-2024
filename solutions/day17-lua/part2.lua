#!/usr/bin/env lua

local function mySplit (inputstr, sep)
    if sep == nil then
        sep = ":"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function readAll (file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local content = mySplit(readAll("input.txt"), "\n")

local function setRegisters(a)
    Registers["a"] = a
    Registers["b"] = tonumber(mySplit(content[1+1])[1+1])
    Registers["c"] = tonumber(mySplit(content[2+1])[1+1])
end

Instructions = {}
for _, nuts in ipairs(mySplit(mySplit(content[3+1])[1+1], ",")) do
    Instructions[#Instructions+1] = tonumber(nuts)
end

local function isCombo(opcode)
    if opcode == 0 or opcode == 2 or opcode == 5 or opcode == 6 or opcode == 7 then
        return true
    end

    return false
end

local function getComboOperand(operand)
    if operand <= 3 then
        return operand
    elseif operand == 4 then
        return Registers["a"]
    elseif operand == 5 then
        return Registers["b"]
    elseif operand == 6 then
        return Registers["c"]
    elseif operand == 7 then
        os.exit(1)
    else
        os.exit(2)
    end
end

local function adv(operand)
    local numerator = Registers["a"]
    local denominator = 2^operand

    Registers["a"] = math.floor(numerator / denominator)
    IPointer = IPointer + 2
end

local function bxl(operand)
    Registers["b"] = Registers["b"] ~ operand
    IPointer = IPointer + 2
end

local function bst(operand)
    Registers["b"] = math.fmod(operand, 8)
    IPointer = IPointer + 2
end

local function jnz(operand)
    if Registers["a"] == 0 then
        IPointer = IPointer + 2
        return
    end

    IPointer = operand + 1
end

local function bxc(_)
    Registers["b"] = Registers["b"] ~ Registers["c"]
    IPointer = IPointer + 2
end

local function out(operand)
    Output[#Output+1] = math.fmod(operand, 8)
    IPointer = IPointer + 2
end

local function bdv(operand)
    local numerator = Registers["a"]
    local denominator = 2^operand

    Registers["b"] = math.floor(numerator / denominator)
    IPointer = IPointer + 2
end

local function cdv(operand)
    local numerator = Registers["a"]
    local denominator = 2^operand

    Registers["c"] = math.floor(numerator / denominator)
    IPointer = IPointer + 2
end

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
    end
end

local function compare(a,b)
    local count = 0
    local i, j = #a, #b

    while i > 0 and j > 0 do
        if a[i] == b[j] then
            count = count + 1
        else
            goto continue
        end
        i = i - 1
        j = j - 1
    end

    ::continue::
    return count
end

Success = false
A = 74000000000000
Registers = {}
Delta = 1
local delta = Delta
Result = ""
Guess = 0

IPointer = 1
Output = {}
setRegisters(A)
while IPointer <= #Instructions do
    execute(Instructions[IPointer], Instructions[IPointer+1])
end
TestRes = compare(Output, Instructions)

while true do
    if delta > A then
        Delta = Delta + 1
        delta = Delta
    end


    IPointer = 1
    Output = {}
    Guess = A + delta
    setRegisters(Guess)
    while IPointer <= #Instructions do
        execute(Instructions[IPointer], Instructions[IPointer+1])
    end
    if table.concat(Output, ",") == table.concat(Instructions, ",") then
        print(A)
        print(Guess)
        print(table.concat(Output, ","))
        print(table.concat(Instructions, ","))
        os.exit(0)
    end
    HighRes = compare(Output, Instructions)



    IPointer = 1
    Output = {}
    Guess = A - delta
    setRegisters(Guess)
    while IPointer <= #Instructions do
        execute(Instructions[IPointer], Instructions[IPointer+1])
    end
    if table.concat(Output, ",") == table.concat(Instructions, ",") then
        print(A)
        print(Guess)
        print(table.concat(Output, ","))
        print(table.concat(Instructions, ","))
        os.exit(0)
    end
    LowRes = compare(Output, Instructions)

    if HighRes > TestRes then
        A = A + delta
        TestRes = HighRes
    elseif LowRes > TestRes then
        A = A - delta
        TestRes = LowRes
    else
        delta = delta * 2
    end
end

