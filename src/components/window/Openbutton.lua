local OpenButton = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")


function OpenButton.New(Window)
    local OpenButtonMain = {
        Button = nil
    }

    local Title = New("TextLabel", {
        Text = Window.Title,
        TextSize = 17,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        BackgroundTransparency = 1,
        AutomaticSize = "XY",
    })

    -- Area Logo (paling kiri)
    local LogoArea = New("Frame", {
        Size = UDim2.new(0,44-8,0,44-8),
        BackgroundTransparency = 1, 
        Name = "LogoArea",
    }, {
        New("ImageLabel", {
            Image = "rbxassetid://100253708538", -- Ganti dengan ID logo kamu
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Crop, -- Full area
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
        })
    })

    -- Divider 1 (setelah logo)
    local Divider1 = New("Frame", {
        Size = UDim2.new(0,1,1,0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .9,
    })

    -- Area Drag (paling kanan)
    local Drag = New("Frame", {
        Size = UDim2.new(0,44-8,0,44-8),
        BackgroundTransparency = 1, 
        Name = "Drag",
    }, {
        New("ImageLabel", {
            Image = Creator.Icon("vector-square")[1],
            ImageRectOffset = Creator.Icon("vector-square")[2].ImageRectPosition,
            ImageRectSize = Creator.Icon("vector-square")[2].ImageRectSize,
            Size = UDim2.new(0,18,0,18),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5),
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .3,
        })
    })

    -- Divider 2 (sebelum drag)
    local Divider2 = New("Frame", {
        Size = UDim2.new(0,1,1,0),
        BackgroundColor3 = Color3.new(1,1,1),
        BackgroundTransparency = .9,
    })

    local Container = New("Frame", {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0,6+44/2),
        AnchorPoint = Vector2.new(0.5,0.5),
        Parent = Window.Parent,
        BackgroundTransparency = 1,
        Active = true,
        Visible = false,
    })
    
    local Button = New("TextButton", {
        Size = UDim2.new(0,0,0,44),
        AutomaticSize = "X",
        Parent = Container,
        Active = false,
        BackgroundTransparency = .25,
        ZIndex = 99,
        BackgroundColor3 = Color3.new(0,0,0),
    }, {
	    New("UICorner", {
            CornerRadius = UDim.new(1,0)
        }),
        New("UIStroke", {
            Thickness = 1,
            ApplyStrokeMode = "Border",
            Color = Color3.new(1,1,1),
            Transparency = 0,
        }, {
            New("UIGradient", {
                Color = ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff"))
            })
        }),
        
        -- URUTAN: Logo | Divider | TextButton | Divider | Drag
        LogoArea,
        Divider1,
        
        New("TextButton",{
            AutomaticSize = "XY",
            Active = true,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,44-(4*2)),
            BackgroundColor3 = Color3.new(1,1,1),
        }, {
            New("UICorner", {
                CornerRadius = UDim.new(1,-4)
            }),
            New("UIListLayout", {
                Padding = UDim.new(0, Window.UIPadding),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
            }),
            Title,
            New("UIPadding", {
                PaddingLeft = UDim.new(0,7+4),
                PaddingRight = UDim.new(0,7+4),
            }),
        }),
        
        Divider2,
        Drag,
        
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
        }),
        
        New("UIPadding", {
            PaddingLeft = UDim.new(0,4),
            PaddingRight = UDim.new(0,4),
        })
    })
    
    OpenButtonMain.Button = Button
    
    function OpenButtonMain:SetIcon(newIcon)
        return 
    end
    Creator.AddSignal(Button:GetPropertyChangedSignal("AbsoluteSize"), function()
        Container.Size = UDim2.new(
            0, Button.AbsoluteSize.X,
            0, Button.AbsoluteSize.Y
        )
    end)
    
    Creator.AddSignal(Button.TextButton.MouseEnter, function()
        Tween(Button.TextButton, .1, {BackgroundTransparency = .93}):Play()
    end)
    Creator.AddSignal(Button.TextButton.MouseLeave, function()
        Tween(Button.TextButton, .1, {BackgroundTransparency = 1}):Play()
    end)
    
    local DragModule = Creator.Drag(Container)
    
    
    function OpenButtonMain:Visible(v)
        Container.Visible = v
    end
    
    function OpenButtonMain:Edit(OpenButtonConfig)
        local OpenButtonModule = {
            Title = OpenButtonConfig.Title,
            Enabled = OpenButtonConfig.Enabled,
            Position = OpenButtonConfig.Position,
            OnlyIcon = OpenButtonConfig.OnlyIcon or false,
            Draggable = OpenButtonConfig.Draggable,
            OnlyMobile = OpenButtonConfig.OnlyMobile,
            CornerRadius = OpenButtonConfig.CornerRadius or UDim.new(1, 0),
            StrokeThickness = OpenButtonConfig.StrokeThickness or 2,
            Color = OpenButtonConfig.Color 
                or ColorSequence.new(Color3.fromHex("40c9ff"), Color3.fromHex("e81cff")),
        }
        
        if OpenButtonModule.Enabled == false then
            Window.IsOpenButtonEnabled = false
        end
        
        if OpenButtonModule.OnlyMobile ~= false then
            OpenButtonModule.OnlyMobile = true
        else
            Window.IsPC = false
        end
        
        
        if OpenButtonModule.Draggable == false and Drag and Divider2 then
            Drag.Visible = OpenButtonModule.Draggable
            Divider2.Visible = OpenButtonModule.Draggable
            
            if DragModule then
                DragModule:Set(OpenButtonModule.Draggable)
            end
        end
        
        if OpenButtonModule.Position and Container then
            Container.Position = OpenButtonModule.Position
        end
        
        if OpenButtonModule.OnlyIcon and Title then
            Title.Visible = false
            Button.TextButton.UIPadding.PaddingLeft = UDim.new(0,7)
            Button.TextButton.UIPadding.PaddingRight = UDim.new(0,7)
        end
        
        if Title then
            if OpenButtonModule.Title then
                Title.Text = OpenButtonModule.Title
                Creator:ChangeTranslationKey(Title, OpenButtonModule.Title)
            end
        end

        Button.UIStroke.UIGradient.Color = OpenButtonModule.Color
        if Glow then
            Glow.UIGradient.Color = OpenButtonModule.Color
        end

        Button.UICorner.CornerRadius = OpenButtonModule.CornerRadius
        Button.TextButton.UICorner.CornerRadius = UDim.new(OpenButtonModule.CornerRadius.Scale, OpenButtonModule.CornerRadius.Offset-4)
        Button.UIStroke.Thickness = OpenButtonModule.StrokeThickness
    end

    return OpenButtonMain
end



return OpenButton

