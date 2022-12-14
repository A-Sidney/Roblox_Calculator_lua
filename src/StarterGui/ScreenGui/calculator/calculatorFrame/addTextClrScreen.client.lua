local UserInputService = game:GetService("UserInputService")

local calFrame = script.Parent
local screen = script.Parent.calScreen
local main = script.Parent:WaitForChild("calWorkspace")

-- tables containing numbers, signs and symbols
local nums = script.Parent.numbers:GetChildren() -- for numbers with text properties
local sign = script.Parent.sign:GetChildren() -- for signs with text properties
local brackets = script.Parent.brackets:GetChildren() -- for brackets with text properties

-- other buttons
local clrMain = script.Parent:FindFirstChild("clr")
local clrScr = script.Parent:FindFirstChild("clrScr")
local delScr = script.Parent:FindFirstChild("del")
local delMain = script.Parent:FindFirstChild("delMain")

local dec = script.Parent.decimal
local equals = script.Parent.equals
local neg = script.Parent.neg
local negSign = script.Parent.negSign
negSign.Visible = false
local negOn = false -- checks if negative sign is Visible
local counter = 0
local ANS

-- elements types
local Number = "Number"
local Sign = "Sign"

-- Memory tables
local hotCacheInputs = {}
local hotCacheScreenInputs = {}
local elementTypeArr = {} -- checks for the last element input into the screenInputs table

-- tables
local numsTable = {} -- for the main
local inputs = {} -- for the screen and behind the screen calculations
local screenInputs = {} -- for the screen contents to be dispayed to the user
local inputsCal = {} -- behind the screen array that's responsible for computation, obtains its values from inputs

-- functions
local function noNeg() -- turns off negaitve sign
    negSign.Visible = false
    negOn = false
end
-- remove neg sign
local function putNeg() -- turns on negative sign
    negSign.Visible = true
    negOn = true
end
-- ressets values on the main
local function resetMain()
    main.Text = ""
    noNeg()
    dec.Visible = true
    table.clear(numsTable)
end

local function elementCheck(value) -- this function checks the value type or data type of the last value input into the screen.
    if value ~= nil then
        print("inputs are {" .. table.concat(inputs, ", ") .. "}")
        print("Value is " .. value)
    end
    if inputs[#inputs] == "+" or inputs[#inputs] == "-" or inputs[#inputs] == "??" or inputs[#inputs] == "??" then -- check if value is a sign
        print("Processing sign")
        table.insert(elementTypeArr, Sign)
    else -- value is a number
        print("Processing number")
        table.insert(elementTypeArr, Number)
    end
end

--------------------------------data reset and counter functions-------------------------------------------------------------
-- data reset function, clears all data in screen, screenInputs and inputsCal
local function dataReset()
    table.clear(inputs)
    table.clear(hotCacheInputs)
    table.clear(screenInputs)
    table.clear(hotCacheScreenInputs)
    table.clear(elementTypeArr)
    table.clear(inputsCal)
end
-- resets values on the screen
local function resetScreen(count) -- do not give any parameters or type "nil" in parameters when resetting the screen normally. To reset the screen and counter(counter = 0) then give any value greater than 0 in the parameters
    if count == 0 or count == nil then
        dataReset()
    elseif count > 0 then
        dataReset()
        counter = 0
    end
    screen.Text = table.concat(screenInputs)
end
------------------------------------------------------------------------------------------------------------------------------

----------------------------Screen Clear and Delete buttons-------------------------------------------------------------------
-- clears text on the screen when pressed
local function clearScreen()
    if screen.Text ~= "" then
        resetScreen(1) -- screen & counter reset
    end
end
clrScr.MouseButton1Click:Connect(clearScreen)

-- deletes the last thing input on the screen
local function delPress()
    table.remove(inputs, #inputs)
    table.remove(screenInputs, #screenInputs)

    -- for element type array
    table.remove(elementTypeArr, #elementTypeArr)

    -- for memory
    table.remove(hotCacheInputs, #hotCacheInputs)
    table.remove(hotCacheScreenInputs, #hotCacheScreenInputs)

    screen.Text = table.concat(screenInputs)
end
delScr.MouseButton1Click:Connect(delPress)
-- UserInputService.InputBegan:Connect()
------------------------------------------------------------------------------------------------------------------------------

------------------------------adding numbers to the main----------------------------------------------------------------------
local function addNumCounter(v)
    resetMain()
    resetScreen(1) -- sets counter to 0 and resets screen

    table.insert(numsTable, v.Text)
    main.Text = table.concat(numsTable)
end

local function addNumZeroCounter(v)
    table.insert(numsTable, v.Text)
    main.Text = table.concat(numsTable)
end

-- adds text to screen when a num button is pressed
local function numPress(number)
    if counter > 0 then
        addNumCounter(number)
        print("Counter has been reset")
    else
        addNumZeroCounter(number)
    end
end

for i, v in pairs(nums) do
    v.MouseButton1Click:Connect(function()
        numPress(v)
    end)
end

local function zeroDec() -- inserts a 0, then adds a decimal to main screen when empty [MAIN = '0.']. If main is not empty, it adds a decimal to the main normally [MAIN = '123.']
    if main.Text == "" then
        table.insert(numsTable, "0")
        table.insert(numsTable, dec.Text)
        main.Text = table.concat(numsTable)
        dec.Visible = false
    else
        table.insert(numsTable, dec.Text)
        main.Text = table.concat(numsTable)
        dec.Visible = false
    end
end

-- for decimal button press
local function decimalPress()
    if counter > 0 then
        resetMain()
        resetScreen(1) -- counter and screen reset

        zeroDec()
    else
        zeroDec()
    end
end
dec.MouseButton1Click:Connect(decimalPress)

-- neg button pressed, adds neg sign or removes neg sign
-- add neg sign function
local function negPress()
    if negOn then
        noNeg()
    else
        putNeg()
    end
end
neg.MouseButton1Click:Connect(negPress)
------------------------------------------------------------------------------------------------------------------------------

---------------------------Main functions----------------------------------------------
-- funciton that removes the last numer/value on the main screen
local function remLastMain()
    table.remove(numsTable, #numsTable)
    if table.find(numsTable, ".") == nil then
        dec.Visible = true
    else
        dec.Visible = false
    end
    main.Text = table.concat(numsTable)
end

-- button that removes the last number/value on the main screen
delMain.MouseButton1Click:Connect(remLastMain)

-- funciton that resets the main screen
local function clearMain()
    main.Text = ""
    dec.Visible = true
    noNeg()
    table.clear(numsTable)
end

-- clears the screen text when ClrScr button is pressed
clrMain.MouseButton1Click:Connect(clearMain)
------------------------------------------------------------------------------------------

----------------------------------adding numbers to calscreen on sign button press---------------------------------------------------------------------------------------------------
local function inputSignData(text, v, inputText) -- inputs the main data and sign into the screen and inputs. [text]: the value to be added to the inputs and the screenInputs(if inputText == nil), [v]: the sign *button*, [inputText]:
    table.insert(screenInputs, text)
    table.insert(screenInputs, v.Text)
    -- for memory
    table.insert(hotCacheScreenInputs, text)
    table.insert(hotCacheScreenInputs, v.Text)

    if inputText == nil then
        tonumber(text) ------------------------------last fix
        table.insert(inputs, text)
        -- for element arr
        elementCheck(text)

        table.insert(inputs, v.Text)
        -- for element arr
        elementCheck(v.Text)
        -- for memory
        table.insert(hotCacheInputs, text)
        table.insert(hotCacheInputs, v.Text)

        screen.Text = table.concat(screenInputs)
        resetMain()
    elseif inputText == tonumber(inputText) then -- checks whether the inputText is already a number and doesn't need function tonumber()
        table.insert(inputs, inputText)
        -- for element arr
        elementCheck(inputText)

        table.insert(inputs, v.Text)
        -- for element arr
        elementCheck(v.Text)
        -- for memory
        table.insert(hotCacheInputs, inputText)
        table.insert(hotCacheInputs, v.Text)

        screen.Text = table.concat(screenInputs)
        resetMain()
    else
        inputText = tonumber(inputText)
        table.insert(inputs, inputText)

        -- for element arr
        elementCheck(inputText)

        table.insert(inputs, v.Text)
        -- for element arr
        elementCheck(v.Text)
        -- for memory
        table.insert(hotCacheInputs, inputText)
        table.insert(hotCacheInputs, v.Text)

        screen.Text = table.concat(screenInputs)
        resetMain()
    end
end

local function insertSignOnly(v)
    table.insert(inputs, v.Text)
    table.insert(elementTypeArr, Sign)
    -- for memory
    table.insert(hotCacheInputs, v.Text)

    table.insert(screenInputs, v.Text)
    -- for memory
    table.insert(hotCacheScreenInputs, v.Text)

    screen.Text = table.concat(screenInputs)
end

local function addTextZeroCounter(v) -- function that adds text to the screen and screenInputs when counter = 0
    if main.Text ~= "" then -- when main is not empty
        if negOn == true then -- if number if negative
            -- this one just fixes where brackets should and should not be put for negaitve numbers
            if screen.Text ~= "" then -- when screen is not empty
                local text = "(-" .. main.Text .. ")"
                local inputText = "-" .. main.Text

                inputSignData(text, v, inputText)
            else -- when screen ~= empty
                local text = "-" .. main.Text

                inputSignData(text, v, nil)
            end
        else
            local text = main.Text
            inputSignData(text, v, nil)
        end
    else
        local text = "0"
        inputSignData(text, v, nil)
    end
end

local function addTextCounter(v)
    print("SIGNS: Counter is at " .. counter)
    print("ANS is currently: " .. ANS)
    -- adding ANS to the screen
    local text = "ANS"
    local inputText = ANS -- i did this just for the sake of simplicity, otherwise i could've just added ANS directly to the text parameter in inputSignData()
    counter = 0
    inputSignData(text, v, inputText)
end

local function signPress(sign)
    if counter > 0 then
        addTextCounter(sign)
    else
        if elementTypeArr[#elementTypeArr] == Number then
            print("insertSignOnly is running")
            insertSignOnly(sign)
        else
            print("no number found in last")
            addTextZeroCounter(sign)
        end
        print("elementTypeArr is: {" .. table.concat(elementTypeArr, ", "), "}")
    end
end

local function addRemoveText() -- adds text to screen
    for i, v in pairs(sign) do
        v.MouseButton1Click:Connect(function()
            signPress(v)
        end)
        counter = 0
    end
end
addRemoveText()
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------- big big process, calculations--------------------------------------------------------------------------------
local function calculate(answer, inputsCalculator)
    if inputs[1] == nil then
        print("No inputs")
    else
        print("...")
    end

    local function printSuccess(success)
        screen.BackgroundColor = BrickColor.new("White")
    end
    local function printError(errormessage)
        screen.BackgroundColor = BrickColor.new("Medium red")
        warn("Syntax error: " .. errormessage)
    end
    ------------------------insert last value/number into the inputs and screenInputs on equal sign press-------------------------------
    local function insert(text, inputText) -- inserts values to screen from main: Requires [text] variable to be made before calling it out, Optional[inputText] or say "nil"
        if inputText == nil then
            table.insert(screenInputs, text)
            -- for memory
            table.insert(hotCacheScreenInputs, text)

            text = tonumber(text)
            table.insert(inputs, text)
            -- for element arr
            elementCheck(text)
            -- for memory
            table.insert(hotCacheInputs, text)

            screen.Text = table.concat(screenInputs)
            resetMain()
        else
            table.insert(screenInputs, text)
            -- for memory
            table.insert(hotCacheScreenInputs, text)

            inputText = tonumber(inputText)
            table.insert(inputs, inputText)
            -- for element arr
            elementCheck(inputText)
            -- for memory
            table.insert(hotCacheInputs, inputText)

            screen.Text = table.concat(screenInputs)
            resetMain()
        end
    end

    local function inputZero() -- adds zero to screen and inputs
        if counter == 0 then
            local text = "0"
            table.insert(screenInputs, text)
            -- for memory
            table.insert(hotCacheScreenInputs, text)

            text = tonumber(text)
            table.insert(inputs, text)
            -- for element arr
            elementCheck(text)
            -- for memory
            table.insert(hotCacheInputs, text)
        else
            local text = "0"
            table.insert(screenInputs, text)

            text = tonumber(text)
            table.insert(inputs, text)
            -- for element arr
            elementCheck(text)
        end

        screen.Text = table.concat(screenInputs)
        resetMain()
    end

    local function inputMain() -- inputs main into the screen
        if main.Text == nil then -- nothing inside the main
            inputZero()
        else -- something inside the main
            if negOn == true then
                -- inputs main with negative sign
                local text = "(-" .. main.Text .. ")"
                local inputText = "-" .. main.Text
                insert(text, inputText)
            else
                local text = main.Text
                insert(text, nil)
            end
        end
    end

    if counter == 0 then
        inputMain()
        inputsCal = inputs -- obtains values from "inputs" in order to calculate them separately to give results
        
        --fixes the single digit calculation. If the inputs only contatins 1 value.
        if #inputs == 1 then
            ANS = inputs[1]
        else
            ANS = 0
        end
    else
        ANS = answer
    end
    --------------------------------------------------------------------------------------------------------------------------------------

    -----------------------Array Alteration and Replacement Schematic for Calculations[AARSC]---------------------------------------------

    -----FUTURE DEVELOPMENT-------
    -- This AARSC will have different version to calter for diffent levels and types of calculations, for example; exponent and root processing, parenthesis(brackets) processing ....etc

    -- //CODE HERE// --

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

    ----------------------------------------------------CALCULATIONS-----------------------------------------------------------------------

    -- list of computatble Operations(Will add more variables with computatble operations)--
    local divide = 0
    local multi = 0
    local addSub = 0
    ----------------------------------------------------------------------------------------
    local function checkOps()
        for i, v in pairs(inputsCal) do -- counts how many operations need to be made with respect to the list of computatble operations
            if v == "??" or v == "/" then
                divide = divide + 1
            end
            if v == "??" then
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
                        if v == "??" or v == "/" then
                            local success, errormessage = pcall(function()
                                ANS = inputs[i - 1] / inputs[i + 1] -- division process
                                replace(i)
                            end)
                            if success then
                                printSuccess()
                            else
                                printError(errormessage)
                            end
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
                        if v == "??" then
                            local success, errormessage = pcall(function()
                                ANS = inputs[i - 1] * inputs[i + 1]
                                replace(i)
                            end)
                            if success then
                                printSuccess()
                            else
                                printError(errormessage)
                            end
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
                            if success then
                                printSuccess()
                            else
                                printError(errormessage)
                            end
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
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------when equal button pressed------------------------------------------------------

-- FUTURE UPDATE--
-- to include memory log function before resetting the main

local function showAns(answer)
    table.clear(inputsCal)
    table.insert(inputsCal, 1, answer)

    resetMain()
    table.insert(numsTable, 1, tostring(ANS))
    main.Text = table.concat(numsTable) -- main was already reset

    -- reformatting the inputs table and screenInputs table to match with inputsCal table. NB: screenInputs are still being displayed to the user.
    table.clear(inputs)
    table.clear(elementTypeArr)
    table.clear(screenInputs)
end

local function initCalculate(answer)
    calculate(answer)
    print("Answer = " .. ANS)
    showAns(ANS)

    counter = counter + 1
    print("Counter is now at " .. counter)
end

-- calculates the answer when equals is pressed
local function equalPress()
    print("Counter when equals is pressed is at " .. counter)
    if counter == 0 then
        initCalculate()
    else
        print("Counter over 0. Counter is at " .. counter)
    end
end
equals.MouseButton1Click:Connect(equalPress)

-----------------------------------------------------------------------------------------------------------
-- Calculations are sorted!
-- Continuous calculations sorted!
-- Rounding off final answer sorted!
-- Next Update: Brackets :3

----------------------------------------------------------------------OTHER CONTROLS----------------------------------------------------------------------------------------
-------------------Keyboard Input Functions and operations-------------------------------------------------
-- Keyboard input tables
local keyboardNumbers = {"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero"}
local keyboardNumArr = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0}
local keyboardSigns = {
    divisionTable = {"Slash", "KeypadDivide"},
    multiplicationTable = {"KeypadMultiply"},
    addTable = {"KeypadPlus", "Equals"},
    minusTable = {"KeypadMinus", "Minus"},
    miscellaneousTable = {"Return", "Backspace", "Q", "Z", "X", "C"}
}
local signsArr = {"??", "??", "+", "-"}

----------------Info on Keyboard inputs----------------
-- Deleting numbers from the main        backspace
-- Deleting values on the screen         Z
-- Clearing the Main                     C
-- Clearing the Screen                   X
-- Divide                                /(either)
-- multiply                              *(Numpad only)
-- add                                   = or +
-- subtract                              -(either)
--------------------------------------------------------
-- functions

local function whileOnHold(button, passFunction, firstDelay, reccursiveDelay) -- function that delays an operation while a certain button is held, then repeats the operation in quick succession while on hold. whileOnHold(key, passFunction, firstdelay[1], recursiveDelay[0.1]). **[Recommended values]**
    local timer = firstDelay
    passFunction()
    wait(timer)
    while wait() do
        if UserInputService:IsKeyDown(Enum.KeyCode[button]) then
            passFunction()
        else
            break
        end
        wait(reccursiveDelay)
    end
end

local function keyboardInput(input, gameProccessedEvent)
    if input.UserInputType == Enum.UserInputType["Keyboard"] then -- checks if the input is from a keyboard
        ---------------Inputting numbers using the keyboard
        for i, v in pairs(keyboardNumbers) do
            if input.KeyCode == Enum.KeyCode[v] then
                local value = tostring(keyboardNumArr[i])
                for pos, val in pairs(nums) do
                    if val.Text == value then
                        numPress(val)
                    end
                end
            end
        end
        ---------------Inputting operation signs and symbols using keyboard
        for i, v in pairs(keyboardSigns) do
            for pos, val in pairs(v) do
                if input.KeyCode == Enum.KeyCode[val] then
                    print("Val is = " .. val)
                    local sign = script.Parent.sign
                    if val == "Slash" or val == "KeypadDivide" then
                        signPress(sign:FindFirstChild("divide"))
                    elseif val == "KeypadMultiply" then
                        signPress(sign:FindFirstChild("times"))
                    elseif val == "Equals" or val == "KeypadPlus" then
                        signPress(sign:FindFirstChild("plus"))
                    elseif val == "KeypadMinus" or val == "Minus" then
                        signPress(sign:FindFirstChild("minus"))
                    elseif val == "Return" then
                        equalPress()
                    elseif val == "Backspace" then
                        whileOnHold(val, remLastMain, 1, 0.1)
                    elseif val == "Z" then
                        whileOnHold(val, delPress, 1, 0.1)
                    elseif val == "C" then
                        clearMain()
                    elseif val == "X" then
                        clearScreen()
                    end
                end
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if calFrame.Visible == true then
        keyboardInput(input, gameProcessedEvent)
    end
end)
