local tweenService = game:GetService("TweenService");
local runService = game:GetService("RunService");
local userInputService = game:GetService("UserInputService");
local playerName = game.Players.LocalPlayer.Name
local gameId = game.GameId
if menu then
    menu:unload();
end;

if not isfolder("riftpublic") then
    makefolder("riftpublic");
end;

local utility = {};

do

    utility.keyToString = {
        ["F1"] = "f1";
        ["F2"] = "f2";
        ["F3"] = "f3";
        ["F4"] = "f4";
        ["F5"] = "f5";
        ["F6"] = "f6";
        ["F7"] = "f7";
        ["F8"] = "f8";
        ["F9"] = "f9";
        ["F10"] = "f10";
        ["F11"] = "f11";
        ["F12"] = "f12";
        ["Insert"] = "ins";
        ["Home"] = "hm";
        ["PageUp"] = "pgu";
        ["PageDown"] = "pgd";
        ["Delete"] = "del";
        ["End"] = "end";
        ["LeftShift"] = "ls";
        ["LeftControl"] = "lc";
        ["LeftAlt"] = "la";
        ["RightShift"] = "rs";
        ["RightControl"] = "rc";
        ["RightAlt"] = "ra";
        ["Backspace"] = "bs";
        ["Enter"] = "ent";
        ["CapsLock"] = "cl";
        ["Tab"] = "tab";
        ["Space"] = "sp";
    };

    function utility:connect(signal, callback)

        local connection = signal:Connect(callback);

        return connection;

    end;

    function utility:draw(class, properties)
        
        local draw = Drawing.new(class);

        for key, value in next, properties or {} do
            
            draw[key] = value;

        end;

        return draw;

    end;

    function utility:create(class, properties)

        local instance = Instance.new(class);

        for key, value in next, properties or {} do
            
            instance[key] = value;

        end;

        return instance;

    end;

    function utility:replaceMissingData(original, data)
        
        if not original then
            return;
        end;

        for key, value in next, data do
            
            if original[key] ~= nil then
                continue;
            end;

            original[key] = value;

        end;

    end;

    function utility:floorVector2(vector)
        
        return Vector2.new(math.floor(vector.X), math.floor(vector.Y));

    end;

    function utility:clampVector2(vector, min, max)
        
        return Vector2.new(math.clamp(vector.X, min.X, max.X), math.clamp(vector.Y, min.Y, max.Y));

    end;

    function utility:lerp(alpha, v1, v2)
        
        if typeof(v1) == "number" then
            
            return (1 - alpha) * v1 + alpha * v2;

        end;

        return v1:Lerp(v2, alpha);

    end;

    function utility:tween(instance, data, to)
        
        local elapsed = 0;

        local original = {};

        for key, value in next, to do
            
            original[key] = instance[key];

        end;

        local connection; connection = self:connect(runService.Heartbeat, function(delta)
            
            elapsed = math.clamp(elapsed + delta, 0, data.Time);

            if data.Time <= elapsed then
                
                for key, value in next, to do
                    
                    instance[key] = value;

                end;

                connection:Disconnect();

            end;

            local alpha = tweenService:GetValue(elapsed / data.Time, data.EasingStyle, data.EasingDirection);

            for key, value in next, to do
                    
                instance[key] = self:lerp(alpha, original[key], value);

            end;

        end);

        return connection;

    end;

    function utility:positionInSquare(position, topRight, boxSize)

        local leftBottom = topRight + boxSize;

        return position.X >= topRight.X and position.Y >= topRight.Y and leftBottom.X >= position.X and leftBottom.Y >= position.Y;

    end;

    function utility:combine(v1, v2)
        
        local newTable = {};

        for index, value in next, v1 do
            
            table.insert(newTable, value);

        end;

        for index, value in next, v2 do
            
            table.insert(newTable, value);

        end;

        return newTable;

    end;

    function utility:getTextBounds(size, font, text)
        
        local label = self:draw("Text", {Size = size, Font = font, Text = text});

        local bounds = label.TextBounds;

        label:Remove();

        return bounds;

    end;

    function utility:tableToRGB(data)
        
        return Color3.fromRGB(data[1], data[2], data[3]);

    end;

    function utility:tableToHSV(data)
        
        return Color3.fromHSV(data[1], data[2], data[3]);

    end;

    function utility:loadFile(name, link)
        
        local path = string.format("dwv2/%s", name);

        if not isfile(path) then
            
            writefile(path, game:HttpGet(link));

        end;

        return readfile(path);

    end;

    function utility:color3ToTable(color)
        
        return {color:ToHSV()};

    end;

    function utility:keycodeToString(keycode)
        
        local expectedResponse = userInputService:GetStringForKeyCode(keycode);

        if #expectedResponse == 0 or expectedResponse == " " then

            expectedResponse = self.keyToString[keycode.Name];

        end;

        return string.lower(expectedResponse or "...");

    end;

end;

local library = {
    theme = {
        background = Color3.fromRGB(0, 0, 0);
        topbar = Color3.fromRGB(20, 20, 20);
        text = Color3.fromRGB(180, 180, 180);  -- Adjusted to improve contrast
        lightOutline = Color3.fromRGB(18, 18, 18);
        container = Color3.fromRGB(15, 15, 15);
        tab = Color3.fromRGB(0, 0, 0);
        tabActive = Color3.fromRGB(31, 30, 30);
        cursor = Color3.fromRGB(212, 0, 219);
        cursorOutline = Color3.fromRGB(89, 0, 255);
        elementDark = Color3.fromRGB(5, 5, 5);
        elementLight = Color3.fromRGB(20, 20, 20);
        accent = Color3.fromRGB(85, 18, 255);
    };
    images = {
        valsat = utility:loadFile("valsat.png", "https://r2.e-z.host/7832f20c-64f3-46ac-bbdc-24b47117be2a/5fz6ayvo.png");
        hue = crypt.base64.decode("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");
        transparency = utility:loadFile("transparency.png", "https://r2.e-z.host/7832f20c-64f3-46ac-bbdc-24b47117be2a/yuizbu1y.png");
    };
    connections = {};
    draws = {};
    originalDraws = {};
    offset = {};
    groups = {};
    pointers = {};
};

local sectionClass = {};
sectionClass.__index = sectionClass;

do

    local button = {};
    button.__index = button;

    do
        
        function button:new(section, info)
            
            local buttonInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, enabled = true, sizeDecrease = 0}, button);

            local library = buttonInstance.window.library;

            do

                buttonInstance.info.title = buttonInstance.section.info.title .. buttonInstance.info.title;
                
                library:draw("Square", {`section{buttonInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `button{buttonInstance.info.title}Container`);

                library:draw("Square", {`button{buttonInstance.info.title}Container`, Vector2.new(8, 3)}, {
                    Filled = true;
                    Color = library.theme.elementDark;
                }, "elementDark", `button{buttonInstance.info.title}Outline`);

                library:draw("Square", {`button{buttonInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Color = library.theme.elementLight;
                }, "elementLight", `button{buttonInstance.info.title}Main`);

                library:draw("Text", {`button{buttonInstance.info.title}Main`, Vector2.new(0, 1)}, {
                    Size = 13;
                    Font = 2;
                    Text = buttonInstance.title;
                    Color = library.theme.text;
                    Center = true;
                }, "text", `button{buttonInstance.info.title}Title`);

            end;

            if buttonInstance.info.pointer then
                
                buttonInstance.window.library.pointers[buttonInstance.info.pointer] = buttonInstance;

            end;

            return buttonInstance;

        end;

        function button:onClick(mouseLocation)

            local library = self.window.library;
            
            local container = library:findById(`button{self.info.title}Container`);

            if utility:positionInSquare(mouseLocation, container.Position, container.Size) and not self.window:isMouseOverContent() then
                
                self.info.callback();

            end;

        end;

        function button:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`button{self.info.title}Container`);
                library:findById(`button{self.info.title}Outline`);
                library:findById(`button{self.info.title}Main`);
                library:findById(`button{self.info.title}Title`);
            };

        end;

        function button:show()

            self.enabled = true;
            
            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

        end;

        function button:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

        end;

        function button:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);
            elements[2].Size = Vector2.new(elements[1].Size.X - 16, 19);
            elements[3].Size = elements[2].Size - Vector2.new(1, 1) * 4;

            library.offset[elements[4]][2] = Vector2.new(elements[3].Size.X / 2, 0);

        end;

    end;

    local textbox = {};
    textbox.__index = textbox;

    do
        
        function textbox:new(section, info)
            
            local textboxInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, value = "", focus = false, enabled = true, sizeDecrease = 0}, textbox);

            local library = textboxInstance.window.library;

            do

                textboxInstance.info.title = textboxInstance.section.info.title .. textboxInstance.info.title;
                
                library:draw("Square", {`section{textboxInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `textbox{textboxInstance.info.title}Container`);

                library:draw("Square", {`textbox{textboxInstance.info.title}Container`, Vector2.new(8, 3)}, {
                    Filled = true;
                    Color = library.theme.elementDark;
                }, "elementDark", `textbox{textboxInstance.info.title}Outline`);

                library:draw("Square", {`textbox{textboxInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Color = library.theme.elementLight;
                }, "elementLight", `textbox{textboxInstance.info.title}Main`);

                library:draw("Text", {`textbox{textboxInstance.info.title}Main`, Vector2.new(2, 0)}, {
                    Size = 13;
                    Font = 2;
                    Text = textboxInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `textbox{textboxInstance.info.title}Title`);

            end;

            if textboxInstance.info.pointer then
                
                textboxInstance.window.library.pointers[textboxInstance.info.pointer] = textboxInstance;

            end;

            textboxInstance:set(textboxInstance.info.value or "");

            return textboxInstance;

        end;

        function textbox:set(value)
            
            self.value = value;

            self:update();

            self.info.callback(self.value);

        end;

        function textbox:get()
            
            return self.value;

        end;

        function textbox:onClick(mouseLocation)
            
            local elements = self:getAllContent();

            if utility:positionInSquare(mouseLocation, elements[1].Position, elements[1].Size) and not self.window:isMouseOverContent() then
                
                self.focus = true;

                local connection; connection = library:connect(userInputService.InputBegan, function(input)
                    
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        
                        local mouseLocation = userInputService:GetMouseLocation();

                        if not utility:positionInSquare(mouseLocation, elements[1].Position, elements[1].Size) then

                            self.focus = false;
                            connection:Disconnect();

                        end;

                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        
                        

                        if input.KeyCode == Enum.KeyCode.Backspace then

                            self:set(string.sub(self.value, 1, -2));

                        else

                            local toAdd = userInputService:GetStringForKeyCode(input.KeyCode);

                            self:set(self.value .. string.lower(toAdd));

                        end;

                    end;

                end);

                task.spawn(function()
                    
                    while self.focus and task.wait() do

                        self:update();

                    end;

                end);

            end;

        end;

        function textbox:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`textbox{self.info.title}Container`);
                library:findById(`textbox{self.info.title}Outline`);
                library:findById(`textbox{self.info.title}Main`);
                library:findById(`textbox{self.info.title}Title`);
            };

        end;

        function textbox:show()
            
            self.enabled = true;
            
            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

        end;

        function textbox:hide()
            
            self.enabled = true;
            
            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

        end;

        function textbox:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);
            elements[2].Size = Vector2.new(elements[1].Size.X - 16, 19);
            elements[3].Size = elements[2].Size - Vector2.new(1, 1) * 4;

            local elements = self:getAllContent();

            local result = self.focus and self.value .. ((tick() % 1 > 0.5) and "|" or "") or not self.focus and (self.value == "" and self.title) or self.value;

            if utility:getTextBounds(13, 2, result).X > elements[3].Size.X then
                
                local newResult = result;
                local removeSymbols = 1;

                local attempts = 0;

                repeat

                    attempts = attempts + 1;

                    removeSymbols = removeSymbols + 1;
                    
                    newResult = newResult:sub(1, -removeSymbols);

                    if attempts > 1000 then

                        break;

                    end;

                until utility:getTextBounds(13, 2, newResult).X < elements[3].Size.X;

                result = newResult:sub(1, -4) .. "...";

            end;

            elements[4].Text = result;

        end;

    end;

    local colorPicker = {};
    colorPicker.__index = colorPicker;

    do
        
        function colorPicker:new(section, info)
            
            local colorPickerInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, value = {}, enabled = false, instances = {}, sizeDecrease = 0}, colorPicker);

            local library = colorPickerInstance.window.library;

            do
                
                colorPickerInstance.info.title = colorPickerInstance.section.info.title .. colorPickerInstance.info.title;

                library:draw("Square", {`section{colorPickerInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `colorpicker{colorPickerInstance.info.title}Container`);

                library:draw("Text", {`colorpicker{colorPickerInstance.info.title}Container`, Vector2.new(8, 3)}, {
                    Size = 13;
                    Font = 2;
                    Text = colorPickerInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `colorpicker{colorPickerInstance.info.title}Title`);

                library:draw("Square", {`colorpicker{colorPickerInstance.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.elementDark;
                    Size = Vector2.new(18, 14);
                }, "elementDark", `colorpicker{colorPickerInstance.info.title}Outline`);

                library:draw("Square", {`colorpicker{colorPickerInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true,
                    Color = colorPickerInstance.info.value;
                    Size = Vector2.new(14, 10);
                }, nil, `colorpicker{colorPickerInstance.info.title}Color`);

            end;

            if colorPickerInstance.info.pointer then
                
                library.pointers[colorPickerInstance.info.pointer] = colorPickerInstance;

            end;

            colorPickerInstance:set({utility:color3ToTable(colorPickerInstance.info.value), colorPickerInstance.info.transparency});

            return colorPickerInstance;

        end;

        function colorPicker:set(value)
            
            self.value = value;

            self:update();

            self.info.callback(self.value);

        end;

        function colorPicker:get()
            
            return self.value;

        end;

        function colorPicker:getAllContent()
            
            local library = self.window.library;

            local content = {
                library:findById(`colorpicker{self.info.title}Container`);
                library:findById(`colorpicker{self.info.title}Title`);
                library:findById(`colorpicker{self.info.title}Outline`);
                library:findById(`colorpicker{self.info.title}Color`);
            };

            if self.newPicker then
                
                content = utility:combine(content, self.newPicker:getAllContent());

            end;

            return content;

        end;

        function colorPicker:getPicker()
            
            return self.newPicker;

        end;

        function colorPicker:onClick(mouseLocation)

            local elements = self:getAllContent();

            if utility:positionInSquare(mouseLocation, elements[3].Position, elements[3].Size) and not self.window:isMouseOverContent() then

                if #self.instances > 0 then
                    
                    self.window:closeContent();

                else

                    self:open();

                end;

            end;

            if #self.instances > 0 then
                
                local instances = self.instances;

                if utility:positionInSquare(mouseLocation, instances[1].Position, instances[1].Size) then

                    local connectionType;
                    
                    if utility:positionInSquare(mouseLocation, instances[3].Position, instances[3].Size) then

                        connectionType = "valsat";

                    elseif utility:positionInSquare(mouseLocation, instances[5].Position, instances[5].Size) then
                        
                        connectionType = "hue";

                    elseif utility:positionInSquare(mouseLocation, instances[7].Position, instances[7].Size) then

                        connectionType = "transparency";

                    end;

                    if connectionType ~= nil then

                        if connectionType == "valsat" then

                            local offset = (mouseLocation - instances[3].Position) / instances[3].Size;

                            local saturation, value = offset.X, 1 - offset.Y;

                            local hue = utility:tableToHSV(self.value[1]):ToHSV();

                            self.value[1] = utility:color3ToTable(Color3.fromHSV(hue, saturation, value));

                        elseif connectionType == "hue" then
                            
                            local offset = (mouseLocation.Y - instances[5].Position.Y) / instances[5].Size.Y;

                            local hue, saturation, value = utility:tableToHSV(self.value[1]):ToHSV();

                            self.value[1] = utility:color3ToTable(Color3.fromHSV(math.clamp(offset, 0.001, 1 - 0.001), saturation, value));

                        elseif connectionType == "transparency" then

                            local offset = (mouseLocation.X - instances[7].Position.X) / instances[7].Size.X;

                            self.value[2] = offset;

                        end;

                        self.window:update();

                        self:set(self.value);

                        local start = os.clock();
                        
                        local connection; connection = self.window.library:connect(userInputService.InputChanged, function(input)
                    
                            if not userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                                
                                connection:Disconnect();
    
                            end;

                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                
                                local mouseLocation = userInputService:GetMouseLocation();

                                if connectionType == "valsat" then

                                    local offset = (mouseLocation - instances[3].Position) / instances[3].Size;
        
                                    local saturation, value = offset.X, 1 - offset.Y;
        
                                    local hue = utility:tableToHSV(self.value[1]):ToHSV();
        
                                    self.value[1] = utility:color3ToTable(Color3.fromHSV(hue, math.clamp(saturation, 0, 1), math.clamp(value, 0, 1)));
        
                                elseif connectionType == "hue" then
                                    
                                    local offset = (mouseLocation.Y - instances[5].Position.Y) / instances[5].Size.Y;
        
                                    local hue, saturation, value = utility:tableToHSV(self.value[1]):ToHSV();
        
                                    self.value[1] = utility:color3ToTable(Color3.fromHSV(math.clamp(offset, 0.001, 1 - 0.001), saturation, value));
        
                                elseif connectionType == "transparency" then
        
                                    local offset = (mouseLocation.X - instances[7].Position.X) / instances[7].Size.X;
        
                                    self.value[2] = math.clamp(offset, 0, 1);
        
                                end;
        
                                self.window:update();
                                self:set(self.value);

                            end;
    
                        end);

                    end;

                end;

            end;

            if self.newPicker then
                
                self.newPicker:onClick(mouseLocation);

            end;

        end;

        function colorPicker:open()
            
            self.window:closeContent();

            local library = self.window.library;

            do
                
                library:draw("Square", {`colorpicker{self.info.title}Outline`, Vector2.new(20, 0)}, {
                    Filled = true,
                    Color = library.theme.elementDark;
                    Size = Vector2.new(1, 1) * 189;
                }, "elementDark", `colorpicker{self.info.title}ContentContainer`);

                library:draw("Square", {`colorpicker{self.info.title}ContentContainer`, Vector2.new(2, 2)}, {
                    Filled = true,
                    Color = library.theme.elementLight;
                    Size = Vector2.new(1, 1) * 185;
                }, "elementLight", `colorpicker{self.info.title}ContentMain`);

                library:draw("Square", {`colorpicker{self.info.title}ContentMain`, Vector2.new(5, 5)}, {
                    Filled = true,
                    Size = Vector2.new(1, 1) * 150;
                }, nil, `colorpicker{self.info.title}ContentValsatBackground`);

                library:draw("Image", {`colorpicker{self.info.title}ContentMain`, Vector2.new(5, 5)}, {
                    Data = library.images.valsat;
                    Size = Vector2.new(1, 1) * 150;
                }, nil, `colorpicker{self.info.title}ContentValsat`);

                library:draw("Image", {`colorpicker{self.info.title}ContentMain`, Vector2.new(160, 5)}, {
                    Data = library.images.hue;
                    Size = Vector2.new(20, 150);
                }, nil, `colorpicker{self.info.title}ContentHue`);

                library:draw("Square", {`colorpicker{self.info.title}ContentHue`, Vector2.new(-2, 0)}, {
                    Filled = true;
                    Color = Color3.new(0, 0, 0);
                    Size = Vector2.new(24, 2);
                }, nil, `colorpicker{self.info.title}ContentHuePicker`);

                library:draw("Image", {`colorpicker{self.info.title}ContentMain`, Vector2.new(5, 160)}, {
                    Data = library.images.transparency;
                    Size = Vector2.new(150, 20);
                }, nil, `colorpicker{self.info.title}ContentTransparency`);

                library:draw("Square", {`colorpicker{self.info.title}ContentTransparency`, Vector2.new(0, -2)}, {
                    Filled = true;
                    Color = Color3.new(0, 0, 0);
                    Size = Vector2.new(2, 24);
                }, nil, `colorpicker{self.info.title}ContentTransparencyPicker`);

                library:draw("Square", {`colorpicker{self.info.title}ContentMain`, Vector2.new(160, 160)}, {
                    Filled = true;
                    Color = Color3.new(0, 0, 0);
                    Size = Vector2.new(1, 1) * 20;
                }, nil, `colorpicker{self.info.title}ContentColor`);

                self.instances = {library:findById(`colorpicker{self.info.title}ContentContainer`), library:findById(`colorpicker{self.info.title}ContentMain`), library:findById(`colorpicker{self.info.title}ContentValsatBackground`), library:findById(`colorpicker{self.info.title}ContentValsat`), library:findById(`colorpicker{self.info.title}ContentHue`), library:findById(`colorpicker{self.info.title}ContentHuePicker`), library:findById(`colorpicker{self.info.title}ContentTransparency`), library:findById(`colorpicker{self.info.title}ContentTransparencyPicker`), library:findById(`colorpicker{self.info.title}ContentColor`)};

                self.window.customZIndex[`colorpicker{self.info.title}ContentContainer`] = 10^4 + 1;
                self.window.customZIndex[`colorpicker{self.info.title}ContentMain`] = 10^4 + 2;
                self.window.customZIndex[`colorpicker{self.info.title}ContentValsatBackground`] = 10^4 + 3;
                self.window.customZIndex[`colorpicker{self.info.title}ContentValsat`] = 10^4 + 4;
                self.window.customZIndex[`colorpicker{self.info.title}ContentHue`] = 10^4 + 4;
                self.window.customZIndex[`colorpicker{self.info.title}ContentHuePicker`] = 10^4 + 5;
                self.window.customZIndex[`colorpicker{self.info.title}ContentTransparency`] = 10^4 + 4;
                self.window.customZIndex[`colorpicker{self.info.title}ContentTransparencyPicker`] = 10^4 + 5;
                self.window.customZIndex[`colorpicker{self.info.title}ContentColor`] = 10^4 + 4;

            end;

            table.insert(self.window.content, {library:findById(`colorpicker{self.info.title}ContentContainer`), self});

            self.window:update();

        end;

        function colorPicker:close()
            
            for index, draw in next, self.instances do
                
                self.window.customZIndex[draw] = nil;

                draw:Remove();

            end;

            table.clear(self.instances);

        end;

        function colorPicker:show()
            
            self.enabled = true;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

            if self.newPicker then
                
                self.newPicker:show();

            end;

            self:update();

        end;

        function colorPicker:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do

                draw.Visible = false;

            end;

            if self.newPicker then
                
                self.newPicker:hide();

            end;

        end;

        function colorPicker:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 21);
            elements[4].Color = utility:tableToHSV(self.value[1]);

            library.offset[elements[3]][2] = Vector2.new(elements[1].Size.X - (18 + 8), 5);

            if #self.instances > 0 then
                
                local instances = self.instances;

                for index, draw in next, instances do
                    
                    draw.Visible = true;

                end;

                local valsatBackground, valsat = instances[3], instances[4];
                local hue, huePicker = instances[5], instances[6];
                local transparency, transparencyPicker = instances[7], instances[8];

                local hueValue, saturation, value = utility:tableToHSV(self.value[1]):ToHSV();
                local transparencyValue = self.value[2];

                valsatBackground.Color = Color3.fromHSV(hueValue, 1, 1);

                huePicker.Color = Color3.fromHSV((hueValue + 1) % 0.5, 1, 1);

                transparencyPicker.Color = Color3.fromHSV(transparencyValue, 1, 1);

                instances[9].Color = utility:tableToHSV(self.value[1]);
                instances[9].Transparency = 1 - transparencyValue;

                library.offset[huePicker][2] = Vector2.new(-2, hueValue * (hue.Size.Y - 2));

                library.offset[transparencyPicker][2] = Vector2.new(transparencyValue * (transparency.Size.X - 2), -2);

            end;

            if self.newPicker then
                
                self.newPicker.sizeDecrease = elements[1].Size.X;

                self.newPicker:update();

                library.offset[self.newPicker:getAllContent()[3]][2] = Vector2.new(-22, 0);

            end;
            
        end;

        function colorPicker:colorPicker(info)
            
            info = info or {};

            utility:replaceMissingData(info, {
                value = Color3.new(1, 1, 1);
                transparency = 0;
                callback = function() end;
            });

            info.title = self.info.title .. "colorPicker";

            local newPicker = colorPicker:new(self.section, info);

            local elements = newPicker:getAllContent();

            library.offset[elements[3]][1] = `colorpicker{self.info.title}Outline`;
            elements[2].Text = "";

            self.newPicker = newPicker;

            return newPicker;

        end;

    end;

    local keybind = {};
    keybind.__index = keybind;

    do
        
        function keybind:new(section, info)
            
            local keybindInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, active = info.active, value = {}, bindStart = 0, enabled = false, binding = false, instances = {}, sizeDecrease = 0}, keybind);

            local library = keybindInstance.window.library;

            do

                library:draw("Square", {`section{keybindInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `keybind{keybindInstance.info.title}Container`);

                library:draw("Text", {`keybind{keybindInstance.info.title}Container`, Vector2.new(8, 4)}, {
                    Size = 13;
                    Font = 2;
                    Text = keybindInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `keybind{keybindInstance.info.title}Title`);

                library:draw("Square", {`keybind{keybindInstance.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Size = Vector2.new(26, 17);
                    Color = library.theme.elementDark;
                }, "elementDark", `keybind{keybindInstance.info.title}Outline`);

                library:draw("Square", {`keybind{keybindInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true,
                    Size = Vector2.new(22, 13);
                    Color = library.theme.elementLight;
                }, "elementLight", `keybind{keybindInstance.info.title}Main`);

                library:draw("Text", {`keybind{keybindInstance.info.title}Main`, Vector2.new(11, -1)}, {
                    Size = 13;
                    Font = 3;
                    Text = "del";
                    Color = library.theme.text;
                    Center = true;
                }, "text", `keybind{keybindInstance.info.title}Value`);

            end;

            if keybindInstance.info.pointer then
                
                library.pointers[keybindInstance.info.pointer] = keybindInstance;

            end;

            keybindInstance:set({{Enum.UserInputType.Keyboard, keybindInstance.info.value}, keybindInstance.info.mode});

            return keybindInstance;

        end;

        function keybind:set(value)
            
            self.value = value;

            self:update();

            self.info.callback(self.value);

            if self.window.keybindList ~= nil then

                self.window.keybindList:redraw();
                self.window.keybindList:update();

            end;

        end;

        function keybind:get()
            
            return self.value;

        end;
        
        function keybind:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`keybind{self.info.title}Container`);
                library:findById(`keybind{self.info.title}Title`);
                library:findById(`keybind{self.info.title}Outline`);
                library:findById(`keybind{self.info.title}Main`);
                library:findById(`keybind{self.info.title}Value`);
            };

        end;

        function keybind:isHolding()
            
            return self.value[1][1] ~= Enum.UserInputType.Keyboard and userInputService:IsMouseButtonPressed(self.value[1][1]) or userInputService:IsKeyDown(self.value[1][2]);

        end;

        function keybind:onClick(mouseLocation)
            
            local elements = self:getAllContent();

            local library = self.window.library;

            if utility:positionInSquare(mouseLocation, elements[3].Position, elements[3].Size) and not self.window:isMouseOverContent() then
                
                self.bindStart = os.clock();
                self.binding = true;

            end;

            if #self.instances > 0 then
                
                local container = self.instances[1];

                if utility:positionInSquare(mouseLocation, container.Position, container.Size) then

                    local selected = math.max(math.floor(math.clamp(mouseLocation.Y - container.Position.Y - 2, 0, container.Size.Y - 4) / 15), 0);

                    self.value[2] = selected;
  
                    self:set(self.value);

                end;

            end;

        end;

        function keybind:onInput(input)
            
            local elements = self:getAllContent();

            if input.UserInputType == Enum.UserInputType.MouseButton2 and utility:positionInSquare(userInputService:GetMouseLocation(), elements[3].Position, elements[3].Size) then
                
                if #self.instances > 0 then
                    
                    self.window:closeContent();

                else

                    self:open();

                end;

            end;

            if not self.binding then
                    
                if input.UserInputType == self.value[1][1] and input.KeyCode == self.value[1][2] then
                    
                    if self.value[2] == 0 then
                    
                        self.active = not self.active;
    
                    elseif self.value[2] == 1 then
    
                        self.active = true;
    
                        task.spawn(function()
                            
                            repeat task.wait() until self:isHolding() == false;
    
                            self.active = false;

                            if self.window.keybindList then

                                self.window.keybindList:update();

                            end;
    
                        end);
    
                    elseif self.value[2] == 2 then
    
                        self.active = true;
    
                    end;

                end;

            elseif self.binding and os.clock() - self.bindStart > 1/60 then

                if input.KeyCode ~= Enum.KeyCode.Escape then
                    
                    self.value[1] = {input.UserInputType, input.KeyCode};

                end;

                self.binding = false;

                self:set(self.value);

            end;

        end;

        function keybind:isActive()
            
            return self.active;

        end;
        
        function keybind:open()
            
            self.window:closeContent();

            local library = self.window.library;

            do
                
                library:draw("Square", {`keybind{self.info.title}Outline`, Vector2.new(0, 19)}, {
                    Filled = true,
                    Size = Vector2.new(44, 49);
                    Color = library.theme.elementDark;
                }, "elementDark", `keybind{self.info.title}ContentContainer`);

                library:draw("Square", {`keybind{self.info.title}ContentContainer`, Vector2.new(2, 2)}, {
                    Filled = true,
                    Size = Vector2.new(40, 45);
                    Color = library.theme.elementLight;
                }, "elementLight", `keybind{self.info.title}ContentMain`);

                self.instances = {library:findById(`keybind{self.info.title}ContentContainer`), library:findById(`keybind{self.info.title}ContentMain`)};

                for index, value in next, {"toggle", "hold", "always"} do
                    
                    local id = string.format(`keybind{self.info.title}Content%s`, value);

                    library:draw("Text", {`keybind{self.info.title}ContentContainer`, Vector2.new(4, 2 + (index - 1) * 14)}, {
                        Size = 13;
                        Font = 2;
                        Text = value;
                        Color = table.find({"toggle", "hold", "always"}, value) == self.value[2] and library.theme.accent or library.theme.text;
                        Center = false;
                    }, nil, id);

                    table.insert(self.instances, library:findById(id));

                    self.window.customZIndex[id] = 10^4 + 3;

                end;

                self.window.customZIndex[`keybind{self.info.title}ContentContainer`] = 10^4 + 1;
                self.window.customZIndex[`keybind{self.info.title}ContentMain`] = 10^4 + 2;

            end;

            table.insert(self.window.content, {self.instances[1], self});

            self.window:update();

        end;
        
        function keybind:close()

            for index, draw in next, self.instances do
                
                draw:Remove();

            end;

            table.clear(self.instances);

        end;
        
        function keybind:show()
            
            self.enabled = true;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

        end;
        
        function keybind:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

        end;
        
        function keybind:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 23);

            local inputType = self.value[1][1];
            local enumInputType = Enum.UserInputType;

            elements[5].Text = inputType.Name:find("MouseButton") and string.lower("m" .. inputType.Name:split("MouseButton")[2]) or self.binding and "..." or utility:keycodeToString(self.value[1][2]);

            library.offset[elements[3]][2] = Vector2.new((self.window.info.size.X - (50 + 16 + 52)) / 2, 3);

            if #self.instances > 0 then

                for index, draw in next, self.instances do

                    draw.Visible = true;

                    if index > 2 then

                        draw.Color = table.find({"toggle", "hold", "always"}, draw.Text) - 1 == self.value[2] and library.theme.accent or library.theme.text;

                    end;

                end;

            end;

        end;

    end;

    local toggle = {};
    toggle.__index = toggle;

    do
        function toggle:new(section, info)
            
            local toggleInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, sizeDecrease = 0, enabled = true, state = info.state}, self);

            local library = toggleInstance.window.library;

            do

                toggleInstance.info.title = toggleInstance.section.info.title .. toggleInstance.info.title;
                
                library:draw("Square", {`section{toggleInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `toggle{toggleInstance.info.title}Container`);

                library:draw("Square", {`toggle{toggleInstance.info.title}Container`, Vector2.new(8, 3)}, {
                    Filled = true;
                    Color = library.theme.elementDark;
                    Size = Vector2.new(1, 1) * 19;
                }, "elementDark", `toggle{toggleInstance.info.title}Outline`);

                library:draw("Square", {`toggle{toggleInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Color = library.theme.accent;
                    Size = Vector2.new(1, 1) * 15;
                }, "accent", `toggle{toggleInstance.info.title}Switch`);

                library:draw("Text", {`toggle{toggleInstance.info.title}Container`, Vector2.new(34, 6)}, {
                    Size = 13;
                    Font = 2;
                    Text = toggleInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `toggle{toggleInstance.info.title}Title`);

            end;

            if toggleInstance.info.pointer then
                
                library.pointers[toggleInstance.info.pointer] = toggleInstance;

            end;

            toggleInstance:set(toggleInstance.state);

            return toggleInstance;

        end;

        function toggle:set(value)
            
            self.state = value;

            self:update();

            self.info.callback(self.state);

        end;

        function toggle:get()
            
            return self.state;

        end;

        function toggle:getAllContent()
            
            local library = self.window.library;

            local content = {
                library:findById(`toggle{self.info.title}Container`);
                library:findById(`toggle{self.info.title}Outline`);
                library:findById(`toggle{self.info.title}Switch`);
                library:findById(`toggle{self.info.title}Title`);
            };
            
            if self.newPicker then
                
                content = utility:combine(content, self.newPicker:getAllContent());

            end;

            if self.newKeybind then
                
                content = utility:combine(content, self.newKeybind:getAllContent());

            end;

            return content;

        end;

        function toggle:onClick(mouseLocation)
            
            local container = self:getAllContent()[1];

            if utility:positionInSquare(mouseLocation, container.Position, container.Size) and not self.window:isMouseOverContent() then
                
                self:set(not self.state);

            end;

            if self.newPicker then
                
                self.newPicker:onClick(mouseLocation);

            end;

            if self.newKeybind then
                
                self.newKeybind:onClick(mouseLocation);

            end;

        end;

        function toggle:show()

            self.enabled = true;
            
            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

            self:update();

        end;

        function toggle:hide()

            self.enabled = false;
            
            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

            self:update();

        end;

        function toggle:update()
            
            local elements = self:getAllContent();

            local library = self.window.library;

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);
            elements[3].Size = self.state and Vector2.new(1, 1) * 15 or Vector2.zero;

            if self.newPicker then

                local totalOffset = 27;
                local lastPicker = self.newPicker;

                local attempts = 0;

                repeat

                    attempts = attempts + 1;
                    
                    local expectedPicker = lastPicker:getPicker();

                    if expectedPicker then
                        
                        lastPicker = expectedPicker;
                        totalOffset = totalOffset + 22;

                    end;

                    if attempts > 1000 then

                        break;

                    end;

                until lastPicker:getPicker() == nil;

                self.sizeDecrease = totalOffset;

                elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);

                local pickerElements = self.newPicker:getAllContent();

                self.newPicker.sizeDecrease = (self.window.info.size.X - 50) / 2;

                self.newPicker:update();

                library.offset[pickerElements[3]][2] = Vector2.new((self.window.info.size.X - 102) / 2, 7);

            end;

            if self.newKeybind then
                
                self.sizeDecrease = 35;

                elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);

                local keybindElements = self.newKeybind:getAllContent();

                self.newKeybind.sizeDecrease = (self.window.info.size.X - 50) / 2;

                self.newKeybind:update();

                library.offset[keybindElements[3]][2] = Vector2.new((self.window.info.size.X - (50 + 16 + 52)) / 2, 3);

            end;

        end;

        function toggle:colorPicker(info)
            
            info = info or {};

            utility:replaceMissingData(info, {
                value = Color3.new(1, 1, 1);
                transparency = 0;
                callback = function() end;
            });

            info.title = self.info.title .. "colorPicker";

            local newPicker = colorPicker:new(self.section, info);

            local elements = newPicker:getAllContent();

            library.offset[elements[3]][1] = `toggle{self.info.title}Container`;
            elements[2].Text = "";

            self.newPicker = newPicker;

            return newPicker;

        end;

        function toggle:keybind(info)
            
            info = info or {};

            utility:replaceMissingData(info, {
                mode = 0;
                value = Enum.KeyCode.Unknown;
                callback = function() end;
            });

            info.title = self.info.title .. "keybind";

            local newKeybind = keybind:new(self.section, info);

            newKeybind.title = self.title;

            local elements = newKeybind:getAllContent();

            library.offset[elements[3]][1] = `toggle{self.info.title}Container`;
            elements[2].Text = "";

            self.newKeybind = newKeybind;

            table.insert(self.window.keybinds, newKeybind);

            return newKeybind;

        end;

    end
    local slider = {};
    slider.__index = slider;

    do
        
        function slider:new(section, info)
            
            local sliderInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, value = info.value, enabled = false, sizeDecrease = 0}, slider)

            local library = sliderInstance.window.library;

            do

                sliderInstance.info.title = sliderInstance.section.info.title .. sliderInstance.info.title;
                
                library:draw("Square", {`section{sliderInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `slider{sliderInstance.info.title}Container`);

                library:draw("Text", {`slider{sliderInstance.info.title}Container`, Vector2.new(8, 2)}, {
                    Size = 13;
                    Font = 2;
                    Text = sliderInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `slider{sliderInstance.info.title}Title`);

                library:draw("Square", {`slider{sliderInstance.info.title}Container`, Vector2.new(8, 17)}, {
                    Filled = true;
                    Color = library.theme.elementDark;
                }, "elementDark", `slider{sliderInstance.info.title}Outline`);

                library:draw("Square", {`slider{sliderInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Color = library.theme.accent;
                    Size = Vector2.new(12, 17);
                }, "accent", `slider{sliderInstance.info.title}Bar`);

                library:draw("Text", {`slider{sliderInstance.info.title}Outline`, Vector2.new(0, 2)}, {
                    Size = 13;
                    Font = 2;
                    Text = tostring(sliderInstance.value);
                    Color = library.theme.text;
                    Center = true;
                }, "text", `slider{sliderInstance.info.title}Value`);

            end;

            if sliderInstance.info.pointer then
                
                library.pointers[sliderInstance.info.pointer] = sliderInstance;

            end;

            sliderInstance:set(sliderInstance.value);

            return sliderInstance;

        end;

        function slider:set(value)
            
            self.value = math.clamp(value, self.info.min, self.info.max);

            self.window:update();

            self.info.callback(value);

        end;

        function slider:get()
            
            return self.value;

        end;

        function slider:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`slider{self.info.title}Container`);
                library:findById(`slider{self.info.title}Title`);
                library:findById(`slider{self.info.title}Outline`);
                library:findById(`slider{self.info.title}Bar`);
                library:findById(`slider{self.info.title}Value`);
            };

        end;

        function slider:calculateOffset(mouseLocation)
            
            local elements = self:getAllContent();

            return mouseLocation.X - elements[3].Position.X;

        end;

        function slider:onClick(mouseLocation)
            
            local elements = self:getAllContent();

            if not utility:positionInSquare(mouseLocation, elements[1].Position, elements[1].Size) or self.window:isMouseOverContent() then
                
                return;

            end;

            local percent = math.clamp(self:calculateOffset(mouseLocation) / elements[1].Size.X, 0, 1);

            local newValue = math.floor((self.info.min + (self.info.max - self.info.min) * percent) * self.info.dec) / self.info.dec;

            self:set(newValue);

            local moveConnection; moveConnection = library:connect(userInputService.InputChanged, function(input)
                
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    
                    percent = self:calculateOffset(userInputService:GetMouseLocation()) / elements[1].Size.X;

                    newValue = math.floor((self.info.min + (self.info.max - self.info.min) * percent) * self.info.dec) / self.info.dec;

                    self:set(newValue);

                end;

            end);

            local holdConnection; holdConnection = library:connect(userInputService.InputEnded, function(input)
                
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    
                    percent = self:calculateOffset(userInputService:GetMouseLocation()) / elements[1].Size.X;

                    newValue = math.floor((self.info.min + (self.info.max - self.info.min) * percent) * self.info.dec) / self.info.dec;

                    self:set(newValue);

                    moveConnection:Disconnect();
                    holdConnection:Disconnect();

                end;

            end);

        end;

        function slider:show()
            
            self.enabled = true;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

            self:update();

        end;

        function slider:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

        end;

        function slider:update()

            local library = self.window.library;
            
            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 39);
            elements[3].Size = Vector2.new(elements[1].Size.X - 16, 19);
            elements[4].Size = Vector2.new(12, elements[3].Size.Y - 4);
            elements[5].Text = tostring(self.value) .. self.info.suf;

            local percent = 1 - (self.info.max - self.value) / (self.info.max - self.info.min);

            library.offset[elements[4]][2] = Vector2.new(2 + math.floor(percent * (elements[3].Size.X - (elements[4].Size.X + 4))), 2);
            library.offset[elements[5]][2] = Vector2.new(elements[3].Size.X / 2, 3);

        end;

    end;

    local label = {};
    label.__index = label;

    do
        
        function label:new(section, info)
            
            local labelInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, enabled = false, sizeDecrease = 0}, label);

            local library = labelInstance.window.library;

            do
                
                labelInstance.info.title = labelInstance.section.info.title .. labelInstance.info.title;

                library:draw("Square", {`section{labelInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `label{labelInstance.info.title}Container`);

                library:draw("Text", {`label{labelInstance.info.title}Container`, Vector2.new(8, 0)}, {
                    Size = 13;
                    Font = 2;
                    Text = labelInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `label{labelInstance.info.title}Title`);

            end;

            if labelInstance.info.pointer then
                
                library.pointers[labelInstance.info.pointer] = labelInstance;

            end;

            return labelInstance;

        end;

        function label:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`label{self.info.title}Container`);
                library:findById(`label{self.info.title}Title`);
            };

        end;

        function label:onClick()
            
        end;

        function label:show()
            
            self.enabled = true;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = true;

            end;

            self:update();

        end;

        function label:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do
                
                draw.Visible = false;

            end;

        end;

        function label:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 25);

        end;

    end;

    local dropdown = {};
    dropdown.__index = dropdown;

    do
        
        function dropdown:new(section, info)
            
            local dropdownInstance = setmetatable({info = info, title = info.title, section = section, tab = section.tab, window = section.tab.window, sizeDecrease = 0, scroll = {0, 0}, value = nil, instances = {}}, dropdown);

            local library = dropdownInstance.window.library;

            do

                dropdownInstance.info.title = dropdownInstance.section.info.title .. dropdownInstance.info.title;

                library:draw("Square", {`section{dropdownInstance.section.info.title}Container`, Vector2.zero}, {
                    Filled = true,
                    Color = library.theme.container;
                }, "container", `dropdown{dropdownInstance.info.title}Container`);

                library:draw("Text", {`dropdown{dropdownInstance.info.title}Container`, Vector2.new(8, 1)}, {
                    Size = 13;
                    Font = 2;
                    Text = dropdownInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `dropdown{dropdownInstance.info.title}Title`);

                library:draw("Square", {`dropdown{dropdownInstance.info.title}Container`, Vector2.new(8, 16)}, {
                    Filled = true;
                    Color = library.theme.elementDark;
                }, "elementDark", `dropdown{dropdownInstance.info.title}Outline`);

                library:draw("Square", {`dropdown{dropdownInstance.info.title}Outline`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Color = library.theme.elementLight;
                }, "elementLight", `dropdown{dropdownInstance.info.title}Main`);

                library:draw("Text", {`dropdown{dropdownInstance.info.title}Main`, Vector2.new(2, 0)}, {
                    Size = 13;
                    Font = 2;
                    Text = dropdownInstance.title;
                    Color = library.theme.text;
                    Center = false;
                }, "text", `dropdown{dropdownInstance.info.title}Value`);

            end;

            if dropdownInstance.info.pointer then
                
                library.pointers[dropdownInstance.info.pointer] = dropdownInstance;

            end;

            dropdownInstance:set(dropdownInstance.info.value or dropdownInstance.info.multi and {dropdownInstance.info.options[1]} or dropdownInstance.info.options[1]);

            return dropdownInstance;

        end;

        function dropdown:set(value)
            
            self.value = value;

            self:update();

            self.info.callback(self.value);

        end;

        function dropdown:get()
            
            return self.value;

        end;

        function dropdown:getAllContent()
            
            local library = self.window.library;

            return {
                library:findById(`dropdown{self.info.title}Container`);
                library:findById(`dropdown{self.info.title}Title`);
                library:findById(`dropdown{self.info.title}Outline`);
                library:findById(`dropdown{self.info.title}Main`);
                library:findById(`dropdown{self.info.title}Value`);
            };

        end;

        function dropdown:onClick(mouseLocation)
            
            local elements = self:getAllContent();

            if utility:positionInSquare(mouseLocation, elements[1].Position, elements[1].Size) and not self.window:isMouseOverContent() then
                
                if #self.instances == 0 then
                    
                    self:open();

                else

                    self.window:closeContent();

                end;

            end;

            if #self.instances > 0 then
                
                local bigContainer = self.instances[1];

                if utility:positionInSquare(mouseLocation, bigContainer.Position, bigContainer.Size) then

                    local selected = self.info.options[math.max(math.floor((mouseLocation.Y - self.instances[2].Position.Y + 22 + self.scroll[2]) / 22), 1)];

                    if self.info.multi then
                        
                        if table.find(self.value, selected) then
                            
                            if #self.value > self.info.min then

                                table.remove(self.value, table.find(self.value, selected));

                            end;

                        else

                            table.insert(self.value, selected);

                        end;

                    end;

                    self:set(self.info.multi and self.value or selected);

                end;

            end;

        end;

        function dropdown:getValueString()

            local elements = self:getAllContent();

            local result = self.info.multi and table.concat(self.value, ", ") or self.value;

            if utility:getTextBounds(13, 2, result).X > elements[4].Size.X then
                
                local newResult = result;
                local removeSymbols = 1;

                local attempts = 0;

                repeat

                    attempts = attempts + 1

                    removeSymbols = removeSymbols + 1;
                    
                    newResult = newResult:sub(1, -removeSymbols);

                    if attempts > 1000 then

                        break;

                    end;

                until utility:getTextBounds(13, 2, newResult).X < elements[4].Size.X;

                result = newResult:sub(1, -4) .. "...";

            end;

            return result;

        end;

        function dropdown:refresh(newOptions)
            
            self.info.options = newOptions;

        end;

        function dropdown:open()

            self.scroll[2] = 0;

            self.window:closeContent();
            
            local library = self.window.library;

            local elements = self:getAllContent();

            do

                library:draw("Square", {`dropdown{self.info.title}Outline`, Vector2.new(0, 17)}, {
                    Filled = true;
                    Size = Vector2.new(elements[3].Size.X, math.min(#self.info.options * 22, 110));
                    Color = library.theme.elementDark;
                }, "elementDark", `dropdown{self.info.title}ContentContainer`);

                library:draw("Square", {`dropdown{self.info.title}ContentContainer`, Vector2.new(2, 2)}, {
                    Filled = true;
                    Size = Vector2.new(elements[3].Size.X - 4, math.min(#self.info.options * 22, 110) - 4);
                    Color = library.theme.elementLight;
                }, "elementLight", `dropdown{self.info.title}ContentMain`);

                library:draw("Square", {`dropdown{self.info.title}ContentMain`, Vector2.zero}, {
                    Filled = true;
                    Size = Vector2.new(0, math.min(#self.info.options * 22, 110) - 4);
                    Color = library.theme.accent;
                }, "accent", `dropdown{self.info.title}ContentScrollbar`);

                self.instances = {library:findById(`dropdown{self.info.title}ContentContainer`), library:findById(`dropdown{self.info.title}ContentMain`), library:findById(`dropdown{self.info.title}ContentScrollbar`)}

                for index, option in next, self.info.options do

                    library:draw("Text", {`dropdown{self.info.title}ContentMain`, Vector2.new(1, 1)}, {
                        Size = 13;
                        Font = 2;
                        Text = option;
                        Color = library.theme.text;
                        Center = false;
                    }, "text", `dropdown{self.info.title}ContentOption{option}`);

                    table.insert(self.instances, library:findById(`dropdown{self.info.title}ContentOption{option}`));

                end;

            end;

            self.scroll[1] = math.max(#self.info.options * 22 - 110, 0);

            self.connection = library:connect(userInputService.InputChanged, function(input)

                local mouseLocation = userInputService:GetMouseLocation();

                if input.UserInputType == Enum.UserInputType.MouseWheel and utility:positionInSquare(mouseLocation, self.instances[1].Position, self.instances[1].Size) then
                    
                    if self.scroll[1] == 0 then
                        
                        return;

                    end;

                    local wheelDirection = input.Position.Z > 0 and -1 or 1;

                    self.scroll[2] = math.clamp(self.scroll[2] + wheelDirection * 22, 0, self.scroll[1]);

                    self.window:update();

                end;

            end);

            table.insert(self.window.content, {library:findById(`dropdown{self.info.title}ContentContainer`), self});

            self.window:update();

        end;

        function dropdown:close()
            
            if self.connection then
                
                self.connection:Disconnect();

                self.connection = nil;

            end;

            for index, draw in next, self.instances do
                
                draw:Remove();

            end;

            table.clear(self.instances);

        end;

        function dropdown:show()

            self.enabled = true;
            
            for index, draw in next, self:getAllContent() do

                draw.Visible = true;

            end;

            self:update();

        end;

        function dropdown:hide()
            
            self.enabled = false;

            for index, draw in next, self:getAllContent() do

                draw.Visible = false;

            end;

        end;

        function dropdown:update()
            
            local library = self.window.library;

            local elements = self:getAllContent();

            elements[1].Size = Vector2.new((self.window.info.size.X - (50 + self.sizeDecrease * 2)) / 2, 39);
            elements[3].Size = Vector2.new(elements[1].Size.X - 16, 19);
            elements[4].Size = elements[3].Size - Vector2.new(1, 1) * 4;

            elements[5].Text = self:getValueString();

            if #self.instances > 0 then

                local instances = self.instances;
                
                for index, draw in next, instances do
                    
                    draw.Visible = true;

                    if index > 3 then
                        
                        local expectedPosition = Vector2.new(3, (index - 4) * 22 - self.scroll[2]);

                        if expectedPosition.Y < 0 or expectedPosition.Y + 22 > 110 then
                            
                            draw.Visible = false;

                        else

                            draw.Visible = true;
                            library.offset[draw][2] = expectedPosition + Vector2.new(0, 2);

                        end;

                    end;

                end;

                if self.scroll[1] > 0 then
                    
                    local scrollbar = instances[3];

                    scrollbar.Size = Vector2.new(2, (106 / ((#instances - 3) * 22)) * 106);

                    local maxScrollOffset = 106 - scrollbar.Size.Y;

                    library.offset[scrollbar][2] = Vector2.new(instances[2].Size.X - 2, (self.scroll[2] / self.scroll[1]) * maxScrollOffset);

                else

                    instances[3].Size = Vector2.zero;

                end;

            end;

        end;

    end;

    function sectionClass:toggle(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "toggle";
            state = false;
            callback = function() end;
        });

        local toggleInstance = toggle:new(self, info);

        table.insert(self.content, toggleInstance);

        return toggleInstance;

    end;

    function sectionClass:button(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "button";
            callback = function() end;
        });

        local buttonInstance = button:new(self, info);

        table.insert(self.content, buttonInstance);

        return buttonInstance;

    end;

    function sectionClass:slider(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "slider";
            value = 10;
            min = 0;
            max = 20;
            dec = 1;
            suf = "";
            callback = function() end;
        });

        local sliderInstance = slider:new(self, info);

        table.insert(self.content, sliderInstance);

        return sliderInstance;

    end;

    function sectionClass:label(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "text label";
        });

        local labelInstance = label:new(self, info);

        table.insert(self.content, labelInstance);

        return labelInstance;

    end;

    function sectionClass:dropdown(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "dropdown";
            options = {"1", "2"};
            multi = false;
            min = 0;
            callback = function() end;
        });

        local dropdownInstance = dropdown:new(self, info);

        table.insert(self.content, dropdownInstance);

        return dropdownInstance;

    end;

    function sectionClass:textbox(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "textbox";
            callback = function() end;
        });

        local textboxInstance = textbox:new(self, info);

        table.insert(self.content, textboxInstance);

        return textboxInstance;

    end;

    function sectionClass:colorPicker(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "colorpicker";
            value = Color3.new(1, 1, 1);
            transparency = 0;
            callback = function() end;
        });

        local colorPickerInstance = colorPicker:new(self, info);

        table.insert(self.content, colorPickerInstance);

        return colorPickerInstance;

    end;

    function sectionClass:keybind(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "keybind";
            mode = 0;
            value = Enum.KeyCode.Unknown;
            callback = function() end;
        });

        local keybindInstance = keybind:new(self, info);

        table.insert(self.content, keybindInstance);
        table.insert(self.window.keybinds, keybindInstance);

        return keybindInstance;

    end;

    function sectionClass:update()
        
        local library = self.window.library;

        local size = library:findById(`section{self.info.title}Container`).Size.Y - 26;

        local calculatedOffset = 25;

        for index, element in next, self.content do
            
            element:update();

            local container = element:getAllContent()[1];

            calculatedOffset = calculatedOffset + container.Size.Y + 1;

            if calculatedOffset - (self.scrollAmount[2] + container.Size.Y + 1) >= 25 and calculatedOffset - self.scrollAmount[2] <= size + 26 then
                
                library.offset[container][2] = Vector2.new(0, calculatedOffset - (self.scrollAmount[2] + container.Size.Y + 1));

                element:show();

            else

                element:hide();

            end;

        end;

        local scrollbar = library:findById(`section{self.info.title}Scrollbar`);

        if calculatedOffset - 25 > size then

            self.scrollAmount[1] = calculatedOffset - size - 25;

            local scrollbarSize = (size / calculatedOffset) * size;

            scrollbar.Size = Vector2.new(2, scrollbarSize);
            library.offset[scrollbar][2] = Vector2.new((self.window.info.size.X - 54) / 2, 25 + (self.scrollAmount[2] / self.scrollAmount[1]) * (size - scrollbarSize));

        else

            scrollbar.Size = Vector2.zero;

        end;

    end;

    function sectionClass:show()
        
        local library = self.window.library;

        local outline = library:findById(`section{self.info.title}Outline`);
        local container = library:findById(`section{self.info.title}Container`);
        local title = library:findById(`section{self.info.title}Title`);
        local separator = library:findById(`section{self.info.title}Separator`);
        local scrollbar = library:findById(`section{self.info.title}Scrollbar`); 

        outline.Visible = true;
        container.Visible = true;
        title.Visible = true;
        separator.Visible = true;
        scrollbar.Visible = true;

        for index, element in next, self.content do
            
            element:show();

        end;

        self.scrollAmount[2] = 0;

        self:update();

    end;

    function sectionClass:hide()
        
        local library = self.window.library;

        local outline = library:findById(`section{self.info.title}Outline`);
        local container = library:findById(`section{self.info.title}Container`);
        local title = library:findById(`section{self.info.title}Title`);
        local separator = library:findById(`section{self.info.title}Separator`);
        local scrollbar = library:findById(`section{self.info.title}Scrollbar`);

        outline.Visible = false;
        container.Visible = false;
        title.Visible = false;
        separator.Visible = false;
        scrollbar.Visible = false;

        for index, element in next, self.content do
            
            element:hide();

        end;

    end;

    function sectionClass:getAllContent()
        
        local library = self.window.library;

        local content = {
            library:findById(`section{self.info.title}Outline`);
            library:findById(`section{self.info.title}Container`);
            library:findById(`section{self.info.title}Title`);
            library:findById(`section{self.info.title}Separator`);
            library:findById(`section{self.info.title}Scrollbar`);
        };

        for index, element in next, self.content do
            
            content = utility:combine(content, element:getAllContent());

        end;

        return content;

    end;

    function sectionClass:resize(ySize)
        
        local library = self.window.library;

        local outline = library:findById(`section{self.info.title}Outline`);
        local container = library:findById(`section{self.info.title}Container`);

        outline.Size = Vector2.new((self.window.info.size.X - 46) / 2, ySize);
        container.Size = Vector2.new((self.window.info.size.X - 50) / 2, ySize - 2);

    end;

end;

local tabClass = {};
tabClass.__index = tabClass;

do
    
    function tabClass:update(isEnabled)
        
        local library = self.window.library;

        local mainContainer = library:findById(`tabButton{self.info.title}`)

        mainContainer.Color = isEnabled and library.theme.tabActive or library.theme.tab;

        library.offset[library:findById(`tabButton{self.info.title}Title`)][2] = Vector2.new(mainContainer.Size.X / 2, 2);

        if not isEnabled then
            
            return;

        end;

        -- // reposition;

        for side = 1, 2 do
            
            local sideOffset = side == 1 and 8 or (self.window.info.size.X - 8) / 2;

            local sectionSide = self.sides[side];

            for index, section in next, sectionSide do

                section:update();

                local previous = sectionSide[index - 1];

                local newSize = section.info.size;

                if section.info.autofill and table.find(sectionSide, section) == #sectionSide then
                    
                    local outlineFrame = previous and library:findById(`section{previous.info.title}Outline`);

                    local startPosition = (outlineFrame and library.offset[outlineFrame][2] + outlineFrame.Size) or (Vector2.new(1, 0) * 8);

                    newSize = self.window.info.size.Y - (startPosition.Y + 91);

                end;

                section:resize(newSize);

                local newPosition = Vector2.new(sideOffset, 8);

                if previous then

                    local previousOutline = library:findById(`section{previous.info.title}Outline`);
                    
                    newPosition = library.offset[previousOutline][2] + Vector2.new(0, 8 + previousOutline.Size.Y);

                end;

                library.offset[library:findById(`section{section.info.title}Outline`)][2] = newPosition;

            end;

        end;

    end;

    function tabClass:getAllContent()
        
        local library = self.window.library;

        local content = {
            library:findById(`tabButton{self.info.title}`);
            library:findById(`tabButton{self.info.title}Title`);
        };

        for index, section in next, self.sections do
            
            content = utility:combine(content, section:getAllContent());

        end;

        return content;

    end;

    function tabClass:show()
        
        for index, section in next, self.sections do

            section:show();

        end;

    end;

    function tabClass:hide()

        for index, section in next, self.sections do

            section:hide();

        end;
        
    end;

    function tabClass:section(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "section";
            side = 0;
            autofill = true;
            size = 300;
        });

        local section = setmetatable({info = info, tab = self, window = self.window, content = {}, scrollAmount = {0, 0}}, sectionClass);

        local library = section.window.library;

        do
            
            library:draw("Square", {"contentContainerMain", Vector2.new(section.info.side == 1 and (self.window.info.size.X - 8) / 2 or 8, 8)}, {
                Size = Vector2.new((self.window.info.size.X - 46) / 2, self.window.info.size.Y - 91);
                Color = self.window.library.theme.lightOutline;
                Filled = true;
            }, "lightOutline", `section{section.info.title}Outline`);

            library:draw("Square", {`section{section.info.title}Outline`, Vector2.new(1, 1)}, {
                Size = Vector2.new((self.window.info.size.X - 50) / 2, self.window.info.size.Y - 93);
                Color = self.window.library.theme.container;
                Filled = true;
            }, "container", `section{section.info.title}Container`);

            library:draw("Text", {`section{section.info.title}Container`, Vector2.new(8, 5)}, {
                Size = 13;
                Font = 2;
                Text = section.info.title;
                Color = self.window.library.theme.text;
                Center = false;
            }, "text", `section{section.info.title}Title`);

            library:draw("Square", {`section{section.info.title}Container`, Vector2.new(3, 21)}, {
                Size = Vector2.new((self.window.info.size.X - 62) / 2, 1);
                Color = self.window.library.theme.lightOutline;
                Filled = true;
            }, "lightOutline", `section{section.info.title}Separator`);

            library:draw("Square", {`section{section.info.title}Container`, Vector2.new((self.window.info.size.X - 52) / 2, 0)}, {
                Size = Vector2.zero;
                Filled = true;
                Color = self.window.library.theme.accent;
                ZIndex = 1;
            }, "accent", `section{section.info.title}Scrollbar`);

            self.window.customZIndex[`section{section.info.title}Title`] = 10^4-1;
            self.window.customZIndex[`section{section.info.title}Scrollbar`] = 10^4;

        end;

        do
            
            library:connect(userInputService.InputBegan, function(input)

                if input.UserInputType == Enum.UserInputType.MouseButton1 then

                    local mouseLocation = userInputService:GetMouseLocation();

                    if self.window.selected == self then

                        for index, element in next, section.content do
                        
                            if not element.enabled then
                                
                                continue;

                            end;

                            element:onClick(mouseLocation);

                        end;

                    end;

                end;

            end);

            library:connect(userInputService.InputChanged, function(input)

                local mouseLocation = userInputService:GetMouseLocation();

                local container = library:findById(`section{section.info.title}Container`);
                
                if input.UserInputType == Enum.UserInputType.MouseWheel and not self.window:isMouseOverContent() then
                    
                    if section.scrollAmount[1] == 0 or not utility:positionInSquare(mouseLocation, container.Position, container.Size) then
                        
                        return;

                    end;

                    local wheelDirection = input.Position.Z > 0 and -1 or 1;

                    section.scrollAmount[2] = math.clamp(section.scrollAmount[2] + wheelDirection * 25, 0, section.scrollAmount[1]);

                    self.window:update();

                end;

            end);

        end;

        table.insert(self.sections, section);
        table.insert(self.sides[section.info.side + 1], section);

        return section;

    end;

end;

do

    function library:draw(class, data, properties, group, id)
        
        local newDraw = utility:draw(class, properties);

        if group then
            
            if self.groups[group] == nil then
            
                self.groups[group] = {};

            end;

            table.insert(self.groups[group], newDraw);

        end;

        self.offset[newDraw] = data or {nil, Vector2.zero};

        self.draws[id or #self.draws + 1] = newDraw;
        table.insert(self.originalDraws, newDraw);

        return newDraw;

    end;

    function library:findById(id)
        
        return self.draws[id];

    end;

    function library:connect(signal, callback)
        
        local connection = utility:connect(signal, callback);

        table.insert(self.connections, connection);

        return connection;

    end;
    
    function library:menu(info)
        
        info = info or {};

        utility:replaceMissingData(info, {
            title = "rift.cc private";
            size = Vector2.new(446, 399);
        });

        local window = {info = info, library = self, state = false, fading = false, position = Vector2.zero, tabs = {}, selected = nil, keybinds = {}, content = {}, customZIndex = {}};

        do
            
            library:draw("Square", nil, {
                Size = window.info.size;
                Color = self.theme.background;
                Filled = true;
            }, "background", "background");

            library:draw("Square", {"background", Vector2.zero}, {
                Size = Vector2.new(window.info.size.X, 18);
                Color = self.theme.topbar;
                Filled = true;
            }, "topbar", "topbar");

            library:draw("Text", {"topbar", Vector2.new(window.info.size.X / 2, 3)}, {
                Size = 13;
                Font = 2;
                Text = window.info.title;
                Color = self.theme.text;
                Center = true;
            }, "text", "title");

            library:draw("Square", {nil, Vector2.zero}, {
                Size = window.info.size;
                Color = self.theme.background;
                Filled = true;
                ZIndex = -1;
            }, "background", "drag");

            library:draw("Square", {"background", Vector2.new(8, 27)}, {
                Size = Vector2.new(window.info.size.X - 16, 35);
                Color = self.theme.lightOutline;
                Filled = true;
            }, "lightOutline", "tabContainerOutline");

            library:draw("Square", {"tabContainerOutline", Vector2.new(1, 1)}, {
                Size = Vector2.new(window.info.size.X - 18, 33);
                Color = self.theme.container;
                Filled = true;
            }, "container", "tabContainerMain");

            library:draw("Square", {"background", Vector2.new(8, 66)}, {
                Size = window.info.size - Vector2.new(16, 73);
                Color = self.theme.lightOutline;
                Filled = true;
            }, "lightOutline", "contentContainerOutline");

            library:draw("Square", {"contentContainerOutline", Vector2.new(1, 1)}, {
                Size = window.info.size - Vector2.new(18, 75);
                Color = self.theme.container;
                Filled = true;
            }, "container", "contentContainerMain");

            window.customZIndex["drag"] = 0;

        end;

        -- // Connections

        do

            local isDragging, dragDelta = false, Vector2.zero;
            
            self:connect(runService.RenderStepped, function()
                
                --local cursor, cursorOutline = self:findById("cursor"), self:findById("cursorOutline");

                local cursor = self:findById("cursor");

                local mouseLocation = userInputService:GetMouseLocation();

                if cursor then

                    cursor.PointA = mouseLocation;
                    cursor.PointB = mouseLocation + Vector2.new(15, 6);
                    cursor.PointC = mouseLocation + Vector2.new(6, 15);

                    --[[ krnl issues

                    cursorOutline.PointA = cursor.PointA;
                    cursorOutline.PointB = cursor.PointB;
                    cursorOutline.PointC = cursor.PointC;]]

                end;

                userInputService.MouseIconEnabled = not window.state;

                if isDragging and not window.fading then

                    local dragFrame = self:findById("drag");
                    
                    dragFrame.Position = mouseLocation + dragDelta;

                end;

            end);

            library:connect(userInputService.InputBegan, function(input)

                for index, keybind in next, window.keybinds do

                    keybind:onInput(input);

                end;

                if window.keybindList ~= nil then

                    window.keybindList:update();

                end;

                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    
                    local mouseLocation = userInputService:GetMouseLocation();

                    local topbar = self:findById("topbar");
                    local tabContainerMain = self:findById("tabContainerMain");

                    if utility:positionInSquare(mouseLocation, topbar.Position, topbar.Size) then
                        
                        isDragging = true;

                        dragDelta = window.position - mouseLocation;

                    end;

                    if utility:positionInSquare(mouseLocation, tabContainerMain.Position, tabContainerMain.Size) then
                        
                        for index, tab in next, window.tabs do
                            
                            local tabButton = self:findById(`tabButton{tab.info.title}`);

                            if utility:positionInSquare(mouseLocation, tabButton.Position, tabButton.Size) then
                                
                                window:select(tab.info.title);

                                break;

                            end;

                        end;

                    end;

                end;

            end);

            library:connect(userInputService.InputEnded, function(input)
                
                if input.UserInputType == Enum.UserInputType.MouseButton1 then

                    local mouseLocation = userInputService:GetMouseLocation();

                    if isDragging then
                        
                        isDragging = false;

                        local dragFrame = self:findById("drag");

                        self.offset[dragFrame][2] = Vector2.new(1, 1) * -2^16;

                        window:move(mouseLocation + dragDelta);

                    end;

                end;

            end);

        end;

        do
            
            function window:unload()

                self:closeContent();
                
                for key, connection in next, self.library.connections do
                    
                    connection:Disconnect();

                    self.library.connections[key] = nil;

                end;

                for key, draw in next, self.library.draws do
                    
                    pcall(function()
                        
                        draw:Remove();

                    end);

                    self.library.draws[key] = nil;

                end;

            end;

            function window:cursor()
                
                self.library:draw("Triangle", {nil, Vector2.zero}, {
                    Filled = true;
                    Color = self.library.theme.cursor;
                    ZIndex = 3;
                }, "cursor", "cursor");
    
                --[[library:draw("Triangle", {nil, Vector2.zero}, {
                    Filled = true;
                    Thickness = 2;
                    Color = self.theme.cursorOutline;
                    ZIndex = 2;
                }, "cursorOutline", "cursorOutline");]]

                self.customZIndex["cursor"] = 10^5;

            end;
            function window:watermark()
                
                local library = self.library;

                do
                    
                    library:draw("Square", nil, {
                        Size = Vector2.new(0, 17);
                        Color = library.theme.elementDark;
                        Filled = true;
                        ZIndex = 10^5 - 3;
                    }, "elementDark", "watermarkOutline");
    
                    library:draw("Square", {"watermarkOutline", Vector2.new(2, 2)}, {
                        Size = Vector2.new(0, 13);
                        Color = library.theme.elementLight;
                        Filled = true;
                        ZIndex = 10^5 - 2;
                    }, "elementLight", "watermarkMain");
    
                    library:draw("Text", {"watermarkMain", Vector2.new(2, -1)}, {
                        Size = 13;
                        Font = 2;
                        Text = "rift.cc bypassed";
                        Color = library.theme.text;
                        Center = false;
                        ZIndex = 10^5 - 1;
                    }, "text", "watermarkTitle");

                end;

                local watermark = "rift.cc | Name:" .. playerName .. " | Game ID: " .. gameId

                -- Create watermark table
                local watermark = {
                    position = Vector2.new(30, 20),
                    visible = false,
                    text = watermark,
                    window = self
                }
                do
                    
                    function watermark:getAllContent()
                        
                        return {
                            library:findById("watermarkOutline");
                            library:findById("watermarkMain");
                            library:findById("watermarkTitle");
                        };

                    end;

                    function watermark:reposition(position)
                        
                        self.position = position;

                    end;

                    function watermark:toggle(visibility)
                        
                        self.visible = visibility;

                    end;

                    function watermark:rename(text)
                        
                        self.text = text;

                    end;

                    function watermark:update()
                        
                        local elements = self:getAllContent();

                        for index, draw in next, elements do

                            draw.Visible = self.visible;

                        end;

                        local textSize = utility:getTextBounds(13, 2, self.text).X + 4

                        elements[1].Position = self.position;
                        elements[2].Position = elements[1].Position + Vector2.new(2, 2);
                        elements[3].Position = elements[2].Position + Vector2.new(2, -1);

                        elements[1].Size = Vector2.new(textSize + 4, 17);
                        elements[2].Size = elements[1].Size - Vector2.new(4, 4);
                        
                        elements[3].Text = self.text;

                    end;

                end;

                self.watermark = watermark;

            end;

            
            

            
            function window:keybindsList()
                
                local library = self.library;

                do
                    
                    library:draw("Square", nil, {
                        Color = library.theme.elementDark;
                        Filled = true;
                        ZIndex = 10^4 + 100;
                    }, "elementDark", "keybindsOutline");
    
                    library:draw("Square", {"keybindsOutline", Vector2.new(2, 2)}, {
                        Color = library.theme.elementLight;
                        Filled = true;
                        ZIndex = 10^4 + 101;
                    }, "elementLight", "keybindsMain");
    
                    library:draw("Text", {"keybindsMain", Vector2.new(2, -1)}, {
                        Size = 13;
                        Font = 2;
                        Text = "keybinds";
                        Color = library.theme.text;
                        Center = false;
                        ZIndex = 10^4 + 102;
                    }, "text", "keybindsTitle");

                end;

                local keybindList = {position = Vector2.new(20, 400), visible = false, window = self};

                do

                    function keybindList:getAllContent()

                        local library = self.window.library;

                        local keybinds = self.window.keybinds;

                        local content = {
                            library:findById("keybindsOutline");
                            library:findById("keybindsMain");
                            library:findById("keybindsTitle");
                        };

                        for index, keybind in next, keybinds do

                            if not library:findById(`keybinds{keybind.title}Title`) then

                                continue;

                            end;

                            table.insert(content, library:findById(`keybinds{keybind.title}Title`));

                        end;

                        return content;

                    end;

                    function keybindList:reposition(position)

                        self.position = position;

                    end;

                    function keybindList:toggle(visibility)

                        self.visible = visibility;

                    end;

                    function keybindList:redraw()

                        for index, draw in next, self:getAllContent() do

                            if index < 4 then

                                continue;

                            end;

                            draw:Remove();

                        end;

                        for index, keybind in next, self.window.keybinds do

                            if keybind:get()[1][1] == Enum.UserInputType.Keyboard and keybind:get()[1][2] == Enum.KeyCode.Unknown then

                                continue;

                            end;

                            library:draw("Text", {"keybindsMain", Vector2.new(2, -1)}, {
                                Size = 13;
                                Font = 2;
                                Text = `{keybind.section.info.title} - {keybind.title} ({({"toggle", "hold", "always"})[keybind.value[2] + 1]})`;
                                Color = library.theme.text;
                                Center = false;
                                ZIndex = 10^4 + 102;
                            }, nil, `keybinds{keybind.title}Title`);

                        end;

                    end;

                    function keybindList:update()

                        local elements = self:getAllContent();

                        local library = self.window.library;

                        elements[1].Position = self.position;
                        elements[2].Position = elements[1].Position + Vector2.new(2, 2);
                        elements[3].Position = elements[2].Position + Vector2.new(2, 0);

                        for index, draw in next, elements do

                            draw.Visible = self.visible;

                        end;

                        local calculatedSize = 13;
                        local longestSize = utility:getTextBounds(13, 2, elements[3].Text).X;

                        for index, keybind in next, self.window.keybinds do

                            local text = library:findById(`keybinds{keybind.title}Title`);

                            if not text then

                                continue;

                            end;

                            text.Position = elements[2].Position + Vector2.new(2, calculatedSize);
                            text.Color = keybind:isActive() and library.theme.accent or library.theme.text;
                            text.Text = `{keybind.section.info.title} - {keybind.title} ({({"toggle", "hold", "always"})[keybind.value[2] + 1]})`;

                            calculatedSize = calculatedSize + 14

                            local bounds = utility:getTextBounds(13, 2, text.Text);

                            if bounds.X > longestSize then

                                longestSize = bounds.X;

                            end;

                        end;

                        elements[1].Size = Vector2.new(longestSize + 8, calculatedSize + 5);
                        elements[2].Size = elements[1].Size - Vector2.new(4, 4);

                    end;
                    
                end;

                self.keybindList = keybindList;

            end;

            function window:changeTheme(newTheme)

                utility:replaceMissingData(newTheme, self.library.theme);

                for group, color in next, newTheme do

                    if self.library.groups[group] == nil then
                        
                        continue;

                    end;
                    
                    for index, draw in next, self.library.groups[group] do

                        draw.Color = color;

                    end;

                end;

                self:update();

            end;

            function window:rename(name)

                self.library:findById("title").Text = name;

            end;

            function window:isMouseOverContent()
                
                local mouseLocation = userInputService:GetMouseLocation();

                for index, drawData in next, self.content do
                    
                    if utility:positionInSquare(mouseLocation, drawData[1].Position, drawData[1].Size) then
                        
                        return true;

                    end;

                end;

                return false;

            end;

            function window:closeContent()
                
                for index, drawData in next, self.content do

                    drawData[2]:close();

                end;

                table.clear(self.content);

            end;

            function window:getVisibleAllContent()
                
                local library = self.library;

                local content = utility:combine({
                    library:findById("background");
                    library:findById("topbar");
                    library:findById("title");
                    library:findById("drag");
                    library:findById("tabContainerOutline");
                    library:findById("tabContainerMain");
                    library:findById("contentContainerOutline");
                    library:findById("contentContainerMain");
                    library:findById("cursor");
                    library:findById("cursorOutline");
                }, self.selected and self.selected:getAllContent() or {});

                for index, tab in next, self.tabs do
                    
                    if tab == self.selected then
                        
                        continue;

                    end;

                    table.insert(content, library:findById(`tabButton{tab.info.title}`));
                    table.insert(content, library:findById(`tabButton{tab.info.title}Title`));

                end;

                return content;

            end;

            function window:fade()
                
                if self.fading then
                    
                    return;

                end;

                self:closeContent();

                local tweenInfo = TweenInfo.new(0.17, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);

                if self.state then

                    self.fading = true;

                    for key, draw in next, self:getVisibleAllContent() do
                        
                        utility:tween(draw, tweenInfo, {Transparency = 0});

                    end;

                    task.delay(0.17, function()

                        self.fading = false;
                        
                        for key, draw in next, self:getVisibleAllContent() do

                            draw.Visible = false;

                        end;

                    end);

                else

                    self.fading = true;

                    for key, draw in next, self:getVisibleAllContent() do
                        
                        draw.Visible = true;
                        draw.Transparency = 0;

                        utility:tween(draw, tweenInfo, {Transparency = 1});

                    end;

                    task.delay(0.17, function()

                        self.fading = false;

                    end);

                    while self.fading and task.wait() do

                        self:update();

                    end;
                    
                end;

                self.state = not self.state;

            end;

            function window:update()

                local tabButtonSize = math.floor(((self.info.size.X - 34) - ( 9 * (#self.tabs - 1))) / #self.tabs);

                for index, tab in next, self.tabs do
                    
                    local tabButton = self.library:findById(`tabButton{tab.info.title}`);

                    tabButton.Size = Vector2.new(tabButtonSize, 19);

                    self.library.offset[tabButton][2] = Vector2.new(8 + (tabButtonSize + 9) * (index - 1), 8);

                    tab:update(self.selected == tab);

                end;

                local visibleContent = self:getVisibleAllContent();

                for index, drawData in next, self.content do
                    
                    visibleContent = utility:combine(visibleContent, drawData[2].instances)

                end;

                for key, draw in next, self.library.originalDraws do

                    if table.find(visibleContent, draw) == nil then
                        
                        continue;

                    end;

                    local data = self.library.offset[draw];

                    local hasPosition = pcall(function()

                        return draw.Position;

                    end);

                    if not hasPosition then
                        
                        continue;

                    end;

                    draw.ZIndex = key;

                    pcall(function()
                        draw.Position = data[1] and self.library:findById(data[1]).Position + data[2] or self.position + data[2];
                    end)
                end;

                for id, zindex in next, self.customZIndex do
                    
                    local draw = self.library:findById(id);

                    if not draw then
                        
                        continue;

                    end;

                    draw.ZIndex = zindex;

                end;

            end;

            function window:move(position)
                
                self.position = utility:clampVector2(position, Vector2.new(1, 1) * 10, workspace.CurrentCamera.ViewportSize - (self.info.size + Vector2.new(1, 1) * 10));

                self:update();

            end;

            function window:select(tabName)
                
                for index, tab in next, self.tabs do
                    
                    if tab.info.title == tabName then
                        
                        self.selected = tab;

                        tab:show();

                    else

                        tab:hide();

                    end;

                end;

                self:update();
		        self:update(); -- // weird but i have to

            end;

            function window:getConfig()
                
                local configTable = {};

                for name, element in next, self.library.pointers do

                    configTable[name] = element:get();

                end;

                return game:GetService("HttpService"):JSONEncode(configTable);

            end;

            function window:loadConfig(config)
                
                for index, value in next, config do
                    
                    if not self.library.pointers[index] then
                        
                        continue;

                    end;

                    self.library.pointers[index]:set(value);

                end;

            end;

            function window:initialize()

                self:cursor();
                self:watermark();
                self:keybindsList();

                self.keybindList:redraw();

                self:select(self.tabs[1].info.title);
                self:move(utility:floorVector2(workspace.CurrentCamera.ViewportSize / 2 - window.info.size / 2));

                self:fade();

                self:update();

            end;

            function window:tab(info)

                info = info or {};

                utility:replaceMissingData(info, {
                    title = "tab";
                });
                
                local tab = setmetatable({info = info, window = self, sections = {}, sides = {{}, {}}}, tabClass);

                local library = tab.window.library;

                do
                    
                    library:draw("Square", {"tabContainerMain", Vector2.new(8, 8)}, {
                        Filled = true;
                        Color = self.library.theme.tab;
                    }, nil, `tabButton{tab.info.title}`);

                    library:draw("Text", {`tabButton{tab.info.title}`, Vector2.new(0, 3)}, {
                        Size = 13;
                        Font = 2;
                        Text = tab.info.title;
                        Color = self.library.theme.text;
                        Center = true;
                    }, "text", `tabButton{tab.info.title}Title`);

                end;

                table.insert(self.tabs, tab);

                return tab;

            end;

        end;

        return window;

    end;

end;
--// End Of UI
