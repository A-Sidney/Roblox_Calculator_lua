--local inputs = {"(", 1, "+", 4, ")", "/", "(", 16, "-", 1, ")"}
local inputs = {1, "+", 4, "/", 2}
local ANS
local inputsCal = {}

print(table.concat(inputs))

-----------------------CALCULATIONS-----------------------
local function calculate(answer, inputsCalculator)
    inputsCal = inputs -- obtains values from "inputs" in order to calculate them separately to give results

    -- fixes the single digit calculation. If the inputs only contatins 1 value.
    if #inputs == 1 then
        ANS = inputs[1]
    else
        ANS = 0
    end
    -------------------------------Basic Operations [lvl 1 AARSC]--------------------------------------------------------------------------
    local function replace(i) -- its removes data from inputsCal array after it has been calculated. For Basic Operations[add, sub, div, mul]
        table.remove(inputsCal, i)
        table.insert(inputsCal, i, ANS)
        table.remove(inputsCal, i - 1)
        table.remove(inputsCal, i) -- pay very close attention to why i said this and not [i + 1]
        local t = table.concat(inputsCal, "")
        print(t)
    end
    ---------------------------------------------------------------------------------------------------------------------------------------
    -- list of computatble Operations(Will add more variables with computatble operations)--
    local divide = 0
    local multi = 0
    local addSub = 0
    ----------------------------------------------------------------------------------------
    local function checkOps()
        for i, v in pairs(inputsCal) do -- counts how many operations need to be made with respect to the list of computatble operations
            if v == "÷" or v == "/" then
                divide = divide + 1
            end
            if v == "×" then
                multi = multi + 1
            end
            if v == "+" then
                addSub = addSub + 1
            end
            if v == "-" then
                addSub = addSub + 1
            end
        end
    end
    checkOps()
    local function division()
        -- DIVISION
        if divide > 0 then
            while divide > 0 do
                    for i, v in pairs(inputsCal) do
                        if v == "÷" or v == "/" then
                            local success, errormessage = pcall(function()
                                ANS = inputs[i - 1] / inputs[i + 1] -- division process
                                replace(i)
                            end)
                        end
                    end
                divide = divide - 1
            end
        end
    end
    local function multiplication()
        -- MULTIPLICATION
        if multi > 0 then
            while multi > 0 do
                    for i, v in pairs(inputsCal) do
                        if v == "×" then
                            local success, errormessage = pcall(function()
                                ANS = inputs[i - 1] * inputs[i + 1]
                                replace(i)
                            end)
                        end
                    end
                multi = multi - 1
            end
        end
    end
    local function addSubtract()
        -- ADDITION AND SUBTRACTION
        if addSub > 0 then
            while addSub > 0 do
                    for i, v in pairs(inputsCal) do
                        if v == "+" or v == "-" then
                            local success, errormessage = pcall(function()
                                if v == "+" then
                                    ANS = inputs[i - 1] + inputs[i + 1]
                                    replace(i)
                                else
                                    ANS = inputs[i - 1] - inputs[i + 1]
                                    replace(i)
                                end
                            end)
                        end
                    end
                addSub = addSub - 1
            end
        end
    end
    -- NEVER CHANGE THE ORDER IN WHICH 'DIVISION' 'MULTIPLICATION' 'ADDITION-SUBTRACTION' ARE ARRANGED --
    local function calculateBasic()
        division()
        multiplication()
        addSubtract()
    end
    calculateBasic()

    ------------------- ROUNDING OFF PROCESS(11 s.f.) -----------------------------------------------------------------
    -- this part rounds off the answer to the nearest 11 significat figures

    local function roundOff(number, sigFigure)

        local function round(number)
            local answer = math.floor(number + 0.5)
            return answer
        end

        local function unitDec(number)
            local displacement = 0
            while number > 0 and number < 1 do
                number = number * 10
                displacement = displacement + 1
            end
            local answer = number
            return answer, displacement
        end

        local function signify(unitVal, sigFigure)
            sigFigure = sigFigure - 1
            while sigFigure ~= 0 do
                unitVal = unitVal * 10
                sigFigure = sigFigure - 1
            end
            return unitVal
        end

        local function divideTen(number, sigFigure)
            while sigFigure ~= 0 do
                number = number / 10
                sigFigure = sigFigure - 1
            end
            local answer = number
            return answer
        end

        local function revert(number, displacement)
            displacement = displacement - 1
            while displacement ~= 0 do
                number = number / 10
                displacement = displacement - 1
            end
            local answer = number
            return answer
        end

        local function computeDec(number, sigFigure)
            local unitVal, displacement = unitDec(number)
            print("UnitVal = " .. unitVal)
            local sigUnit = signify(unitVal, sigFigure)
            print("Rounding off this number " .. sigUnit)
            local roundedSigUnit = round(sigUnit)
            print("Rounded unit is " .. roundedSigUnit)
            local answer = revert(roundedSigUnit, sigFigure)
            print("unit answer = " .. answer)
            answer = divideTen(answer, displacement)
            return answer
        end

        local function unit(number)
            local unit
            local displacement = 1
            while number >= 10 do
                number = number / 10
                displacement = displacement + 1
            end
            unit = number
            return unit, displacement
        end

        local function multiTen(roundedUnit, displacement)
            while displacement ~= 0 do
                roundedUnit = roundedUnit * 10
                displacement = displacement - 1
            end
            local answer = roundedUnit
            return answer
        end

        local function compute(number, sigFigure)
            local unit, displacement = unit(number)
            local sigUnit = signify(unit, sigFigure)
            print("Rounding off this number " .. sigUnit)
            local roundedSigUnit = round(sigUnit)
            print("Rounded unit is " .. roundedSigUnit)
            local diff
            if displacement > sigFigure then
                diff = displacement - sigFigure
                local answer = multiTen(roundedSigUnit, diff)
                return answer
            else
                diff = sigFigure - displacement
                local answer = divideTen(roundedSigUnit, diff)
                return answer
            end
        end

        local function solve()
            if number > 0 and number < 1 then
                ANS = computeDec(number, sigFigure)
                print("Answer is " .. ANS)
            else
                ANS = compute(number, sigFigure)
                print("Answer is " .. ANS)
            end
        end
        solve()
    end
    roundOff(ANS, 11)
end

local function showAns(answer)
    local numsTable = {}

    -- reformatting the inputs table and screenInputs table to match with inputsCal table. NB: screenInputs are still being displayed to the user.
    table.clear(inputs)
end

local function initCalculate(answer)
    calculate(answer)
    print("Answer = " .. ANS)
end
initCalculate()