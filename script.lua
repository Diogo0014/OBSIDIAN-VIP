--=============================================================
-- OBSIDIAN ELITE | VIP EDITION v3.3.2
-- Mobile | Delta Executor | Arsenal Focus
-- Criado por: Refild Systems
-- Senha padrão: obsidian2026
--=============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--========== CONFIGURAÇÕES ==========
local SENHA = "obsidian2026"
local VERSAO = "3.3.2 VIP"
local ARQUIVO_ALIADOS = "Obsidian_Aliados.json"
local ARQUIVO_PERFIS = "Obsidian_Perfis.json"
local ARQUIVO_KEYBINDS = "Obsidian_Keybinds.json"
local ARQUIVO_FLYPOS = "Obsidian_FlyPos.json"

--========== PALETA VIP ==========
local Palette = {
    Primary    = Color3.fromRGB(120, 40, 220),
    PrimaryLt  = Color3.fromRGB(180, 100, 255),
    PrimaryDk  = Color3.fromRGB(60, 15, 120),
    Gold       = Color3.fromRGB(255, 200, 80),
    GoldDark   = Color3.fromRGB(180, 130, 30),
    Cyan       = Color3.fromRGB(80, 220, 255),
    Bg         = Color3.fromRGB(4, 3, 8),
    BgPanel    = Color3.fromRGB(12, 8, 20),
    BgCard     = Color3.fromRGB(20, 14, 32),
    BgBtn      = Color3.fromRGB(28, 20, 44),
    Text       = Color3.fromRGB(250, 248, 255),
    TextDim    = Color3.fromRGB(140, 130, 170),
    Off        = Color3.fromRGB(40, 34, 56),
    Green      = Color3.fromRGB(90, 230, 130),
    Red        = Color3.fromRGB(240, 80, 90),
    Yellow     = Color3.fromRGB(255, 210, 70),
    Gray       = Color3.fromRGB(100, 100, 110)
}

--========== SONS ==========
local SoundIDs = {
    Click  = "rbxassetid://6895079853",
    Toggle = "rbxassetid://6895079853",
    Open   = "rbxassetid://9114385588",
    Close  = "rbxassetid://9114385551",
    Login  = "rbxassetid://9118823689",
    Error  = "rbxassetid://5153025458",
    Kill   = "rbxassetid://9114763740",
    Hit    = "rbxassetid://4612383585"
}

local function PlaySound(id, volume)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = volume or 0.5
    s.Parent = SoundService
    s:Play()
    task.delay(3, function() s:Destroy() end)
end

--========== GAME DB ==========
local GameDB = {
    [104522435597696] = "Arsenal",
    [1135105566]      = "Phantom Forces",
    [4777817887]      = "Rivals",
    [2788229376]      = "Da Hood",
    [142823291]       = "Murder Mystery 2"
}
local GameName = GameDB[game.PlaceId] or "Universal"

--========== ALIADOS ==========
local Aliados = {}
local AutoLimparAliados = false

local function CarregarAliados()
    if not (isfile and readfile) then return end
    local ok, data = pcall(function()
        if isfile(ARQUIVO_ALIADOS) then return HttpService:JSONDecode(readfile(ARQUIVO_ALIADOS)) end
    end)
    if ok and type(data) == "table" then Aliados = data end
end
local function SalvarAliados()
    if not writefile then return end
    pcall(function() writefile(ARQUIVO_ALIADOS, HttpService:JSONEncode(Aliados)) end)
end
local function IsAliado(p) return Aliados[tostring(p.UserId)] == true end
local function MarcarAliado(p) Aliados[tostring(p.UserId)] = true SalvarAliados() end
local function DesmarcarAliado(p) Aliados[tostring(p.UserId)] = nil SalvarAliados() end
CarregarAliados()

--========== PERFIS ==========
local Perfis = {}
local function CarregarPerfis()
    if not (isfile and readfile) then return end
    local ok, data = pcall(function()
        if isfile(ARQUIVO_PERFIS) then return HttpService:JSONDecode(readfile(ARQUIVO_PERFIS)) end
    end)
    if ok and type(data) == "table" then Perfis = data end
end
local function SalvarPerfis()
    if not writefile then return end
    pcall(function() writefile(ARQUIVO_PERFIS, HttpService:JSONEncode(Perfis)) end)
end
CarregarPerfis()

--========== KEYBINDS ==========
local Keybinds = {}
local function CarregarKeybinds()
    if not (isfile and readfile) then return end
    local ok, data = pcall(function()
        if isfile(ARQUIVO_KEYBINDS) then return HttpService:JSONDecode(readfile(ARQUIVO_KEYBINDS)) end
    end)
    if ok and type(data) == "table" then Keybinds = data end
end
local function SalvarKeybinds()
    if not writefile then return end
    pcall(function() writefile(ARQUIVO_KEYBINDS, HttpService:JSONEncode(Keybinds)) end)
end
CarregarKeybinds()

--========== FLY POS ==========
local FlyPos = {Up = {0.85, 0.75}, Down = {0.85, 0.82}}
local function CarregarFlyPos()
    if not (isfile and readfile) then return end
    local ok, data = pcall(function()
        if isfile(ARQUIVO_FLYPOS) then return HttpService:JSONDecode(readfile(ARQUIVO_FLYPOS)) end
    end)
    if ok and type(data) == "table" then FlyPos = data end
end
local function SalvarFlyPos()
    if not writefile then return end
    pcall(function() writefile(ARQUIVO_FLYPOS, HttpService:JSONEncode(FlyPos)) end)
end
CarregarFlyPos()

--========== CONFIG ==========
local Config = {
    ESP_Box=false, ESP_Name=false, ESP_Distance=false,
    ESP_Skeleton=false, ESP_Arrow=false,
    ESP_Color = Palette.Primary,
    ESP_DeadGray=true,

    AimbotEnabled=false, AimbotFOV=120, AimbotSmooth=6,
    AimMode="Auto",
    StickyTarget=true, AimPrediction=false,

    HitboxExpand=false, HitboxSize=5, HitboxPart="Head",

    GroundBury=false, BuryMode="Down", BuryHeight=15,

    SpeedOn=false, SpeedVal=16,
    Noclip=false,
    FlyOn=false, FlySpeed=60, FlyEditMode=false,

    FOVDynamic=true, Crosshair=true, CrosshairColor=Palette.Primary,
    TargetInfo=true, PanicButton=true,

    Fullbright=false, KillNotify=true, KillCounter=true, HitSound=true,

    -- RGB simplificado
    RGBOn = false,

    IgnorarAliadosESP=true, IgnorarAliadosAim=true, IgnorarAliadosHitbox=true,
    PanelColor = Palette.Primary
}

local Original = {
    WalkSpeed=16, JumpPower=50, Brightness=Lighting.Brightness,
    ClockTime=Lighting.ClockTime, FogEnd=Lighting.FogEnd,
    GlobalShadows=Lighting.GlobalShadows
}

--========== LOOPS ==========
local ActiveLoops = {}
local ESPStore = {}
local HitboxStore = {}
local KillCount = 0
local CurrentTarget = nil
local TargetLocked = false

-- Apenas 3 strokes no RGB (leve)
local RGBStrokes = {}

local function KillLoop(n)
    if ActiveLoops[n] then ActiveLoops[n].Active = false ActiveLoops[n] = nil end
end
local function StartLoop(n, fn)
    KillLoop(n)
    local t = {Active=true}
    ActiveLoops[n] = t
    spawn(function()
        while t.Active do
            local ok, err = pcall(fn)
            if not ok then warn("[Obsidian]", n, err) break end
            RunService.Heartbeat:Wait()
        end
    end)
end
local function ClearESP()
    for _, objs in pairs(ESPStore) do
        for _, v in pairs(objs) do if v and v.Parent then v:Destroy() end end
    end
    ESPStore = {}
end
local function ClearHitbox()
    for uid, data in pairs(HitboxStore) do
        if data.part and data.part.Parent then
            data.part.Size = data.original
            data.part.Transparency = data.origTrans
            data.part.CanCollide = data.origCollide
        end
    end
    HitboxStore = {}
end

--========== HELPERS ==========
local function NewCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end
local function NewStroke(p, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = color or Palette.Primary
    s.Thickness = thick or 1
    s.Transparency = transp or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

--========== GUI RAIZ ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObsidianElite"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = CoreGui

--========== LOADING ==========
local LoadingScreen = Instance.new("Frame")
LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
LoadingScreen.BackgroundColor3 = Palette.Bg
LoadingScreen.BorderSizePixel = 0
LoadingScreen.ZIndex = 300
LoadingScreen.Parent = ScreenGui

local loadLogo = Instance.new("TextLabel")
loadLogo.Size = UDim2.new(1, 0, 0, 70)
loadLogo.Position = UDim2.new(0, 0, 0.35, 0)
loadLogo.BackgroundTransparency = 1
loadLogo.Text = "OBSIDIAN"
loadLogo.TextColor3 = Palette.PrimaryLt
loadLogo.TextSize = 52
loadLogo.Font = Enum.Font.GothamBlack
loadLogo.ZIndex = 301
loadLogo.Parent = LoadingScreen

local loadSub = Instance.new("TextLabel")
loadSub.Size = UDim2.new(1, 0, 0, 24)
loadSub.Position = UDim2.new(0, 0, 0.35, 68)
loadSub.BackgroundTransparency = 1
loadSub.Text = "E L I T E   •   " .. VERSAO
loadSub.TextColor3 = Palette.Gold
loadSub.TextSize = 14
loadSub.Font = Enum.Font.GothamBold
loadSub.ZIndex = 301
loadSub.Parent = LoadingScreen

local loadBarBg = Instance.new("Frame")
loadBarBg.Size = UDim2.new(0, 260, 0, 6)
loadBarBg.Position = UDim2.new(0.5, -130, 0.5, 60)
loadBarBg.BackgroundColor3 = Palette.BgBtn
loadBarBg.BorderSizePixel = 0
loadBarBg.ZIndex = 301
loadBarBg.Parent = LoadingScreen
NewCorner(loadBarBg, 3)

local loadBarFill = Instance.new("Frame")
loadBarFill.Size = UDim2.new(0, 0, 1, 0)
loadBarFill.BackgroundColor3 = Palette.PrimaryLt
loadBarFill.BorderSizePixel = 0
loadBarFill.ZIndex = 302
loadBarFill.Parent = loadBarBg
NewCorner(loadBarFill, 3)

local loadStatus = Instance.new("TextLabel")
loadStatus.Size = UDim2.new(1, 0, 0, 20)
loadStatus.Position = UDim2.new(0, 0, 0.5, 75)
loadStatus.BackgroundTransparency = 1
loadStatus.Text = "Inicializando..."
loadStatus.TextColor3 = Palette.TextDim
loadStatus.TextSize = 11
loadStatus.Font = Enum.Font.GothamMedium
loadStatus.ZIndex = 301
loadStatus.Parent = LoadingScreen

--========== LOGIN ==========
local LoginScreen = Instance.new("Frame")
LoginScreen.Size = UDim2.new(1, 0, 1, 0)
LoginScreen.BackgroundColor3 = Palette.Bg
LoginScreen.BorderSizePixel = 0
LoginScreen.ZIndex = 200
LoginScreen.Visible = false
LoginScreen.Parent = ScreenGui

local loginCard = Instance.new("Frame")
loginCard.Size = UDim2.new(0, 340, 0, 400)
loginCard.Position = UDim2.new(0.5, -170, 0.5, -200)
loginCard.BackgroundColor3 = Palette.BgPanel
loginCard.BorderSizePixel = 0
loginCard.ZIndex = 201
loginCard.Parent = LoginScreen
NewCorner(loginCard, 18)
local loginStroke = NewStroke(loginCard, Palette.Primary, 2, 0)

local loginLogo = Instance.new("TextLabel")
loginLogo.Size = UDim2.new(1, 0, 0, 60)
loginLogo.Position = UDim2.new(0, 0, 0, 30)
loginLogo.BackgroundTransparency = 1
loginLogo.Text = "OBSIDIAN"
loginLogo.TextColor3 = Palette.PrimaryLt
loginLogo.TextSize = 40
loginLogo.Font = Enum.Font.GothamBlack
loginLogo.ZIndex = 202
loginLogo.Parent = loginCard

local loginSub = Instance.new("TextLabel")
loginSub.Size = UDim2.new(1, 0, 0, 20)
loginSub.Position = UDim2.new(0, 0, 0, 92)
loginSub.BackgroundTransparency = 1
loginSub.Text = "E L I T E   E D I T I O N"
loginSub.TextColor3 = Palette.Gold
loginSub.TextSize = 11
loginSub.Font = Enum.Font.GothamBold
loginSub.ZIndex = 202
loginSub.Parent = loginCard

local passLabel = Instance.new("TextLabel")
passLabel.Size = UDim2.new(1, -40, 0, 20)
passLabel.Position = UDim2.new(0, 20, 0, 155)
passLabel.BackgroundTransparency = 1
passLabel.Text = "🔐  Chave de acesso:"
passLabel.TextColor3 = Palette.TextDim
passLabel.TextSize = 12
passLabel.Font = Enum.Font.GothamMedium
passLabel.TextXAlignment = Enum.TextXAlignment.Left
passLabel.ZIndex = 202
passLabel.Parent = loginCard

local passBox = Instance.new("TextBox")
passBox.Size = UDim2.new(1, -40, 0, 48)
passBox.Position = UDim2.new(0, 20, 0, 182)
passBox.BackgroundColor3 = Palette.BgBtn
passBox.BorderSizePixel = 0
passBox.Text = ""
passBox.PlaceholderText = "• • • • • • • •"
passBox.TextColor3 = Palette.Text
passBox.PlaceholderColor3 = Palette.TextDim
passBox.TextSize = 18
passBox.Font = Enum.Font.GothamMedium
passBox.ClearTextOnFocus = false
passBox.ZIndex = 202
passBox.Parent = loginCard
NewCorner(passBox, 10)
local passStroke = NewStroke(passBox, Palette.PrimaryDk, 1.5, 0.3)

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -40, 0, 50)
loginBtn.Position = UDim2.new(0, 20, 0, 248)
loginBtn.BackgroundColor3 = Palette.Primary
loginBtn.Text = "ACESSAR"
loginBtn.TextColor3 = Palette.Text
loginBtn.TextSize = 17
loginBtn.Font = Enum.Font.GothamBlack
loginBtn.AutoButtonColor = false
loginBtn.ZIndex = 202
loginBtn.Parent = loginCard
NewCorner(loginBtn, 10)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 20)
statusLabel.Position = UDim2.new(0, 20, 0, 308)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Palette.Red
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.ZIndex = 202
statusLabel.Parent = loginCard

local creditMini = Instance.new("TextLabel")
creditMini.Size = UDim2.new(1, 0, 0, 20)
creditMini.Position = UDim2.new(0, 0, 1, -32)
creditMini.BackgroundTransparency = 1
creditMini.Text = "© 2026 Obsidian Systems • " .. VERSAO
creditMini.TextColor3 = Palette.TextDim
creditMini.TextSize = 10
creditMini.Font = Enum.Font.Gotham
creditMini.ZIndex = 202
creditMini.Parent = loginCard

--========== MAIN HOLDER ==========
local MainHolder = Instance.new("Frame")
MainHolder.Size = UDim2.new(1, 0, 1, 0)
MainHolder.BackgroundTransparency = 1
MainHolder.Visible = false
MainHolder.Parent = ScreenGui

--========== WATERMARK VIP ==========
local Watermark = Instance.new("Frame")
Watermark.Size = UDim2.new(0, 260, 0, 56)
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.BackgroundColor3 = Palette.BgPanel
Watermark.BorderSizePixel = 0
Watermark.ZIndex = 50
Watermark.Parent = MainHolder
NewCorner(Watermark, 10)
local WmStroke = NewStroke(Watermark, Palette.Primary, 1.5, 0)
table.insert(RGBStrokes, WmStroke) -- RGB

local WmAvatarFrame = Instance.new("Frame")
WmAvatarFrame.Size = UDim2.new(0, 36, 0, 36)
WmAvatarFrame.Position = UDim2.new(0, 6, 0, 10)
WmAvatarFrame.BackgroundColor3 = Palette.BgBtn
WmAvatarFrame.BorderSizePixel = 0
WmAvatarFrame.ZIndex = 51
WmAvatarFrame.Parent = Watermark
NewCorner(WmAvatarFrame, 18)
NewStroke(WmAvatarFrame, Palette.Gold, 1.5, 0)

local WmAvatar = Instance.new("ImageLabel")
WmAvatar.Size = UDim2.new(1, -4, 1, -4)
WmAvatar.Position = UDim2.new(0, 2, 0, 2)
WmAvatar.BackgroundTransparency = 1
WmAvatar.ZIndex = 52
WmAvatar.Parent = WmAvatarFrame
NewCorner(WmAvatar, 16)
pcall(function()
    WmAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local WmLabel = Instance.new("TextLabel")
WmLabel.Size = UDim2.new(1, -50, 0, 16)
WmLabel.Position = UDim2.new(0, 48, 0, 4)
WmLabel.BackgroundTransparency = 1
WmLabel.Text = "OBSIDIAN ELITE"
WmLabel.TextColor3 = Palette.Text
WmLabel.TextSize = 11
WmLabel.Font = Enum.Font.GothamBlack
WmLabel.TextXAlignment = Enum.TextXAlignment.Left
WmLabel.ZIndex = 51
WmLabel.Parent = Watermark

local WmStatus = Instance.new("TextLabel")
WmStatus.Size = UDim2.new(1, -50, 0, 12)
WmStatus.Position = UDim2.new(0, 48, 0, 20)
WmStatus.BackgroundTransparency = 1
WmStatus.Text = "Timer: 00:00:00 | 💀 0 | FPS: 60"
WmStatus.TextColor3 = Palette.PrimaryLt
WmStatus.TextSize = 9
WmStatus.Font = Enum.Font.GothamMedium
WmStatus.TextXAlignment = Enum.TextXAlignment.Left
WmStatus.ZIndex = 51
WmStatus.Parent = Watermark

local WmTarget = Instance.new("TextLabel")
WmTarget.Size = UDim2.new(1, -50, 0, 12)
WmTarget.Position = UDim2.new(0, 48, 0, 34)
WmTarget.BackgroundTransparency = 1
WmTarget.Text = "🎯 Sem alvo"
WmTarget.TextColor3 = Palette.Red
WmTarget.TextSize = 9
WmTarget.Font = Enum.Font.GothamBold
WmTarget.TextXAlignment = Enum.TextXAlignment.Left
WmTarget.ZIndex = 51
WmTarget.Parent = Watermark

--========== FLUTUANTE ==========
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 74, 0, 74)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -37)
FloatingBtn.BackgroundColor3 = Color3.new(0,0,0)
FloatingBtn.Text = ""
FloatingBtn.AutoButtonColor = false
FloatingBtn.Active = true
FloatingBtn.Parent = MainHolder
NewCorner(FloatingBtn, 37)
local FloatStroke = NewStroke(FloatingBtn, Palette.Primary, 2.5, 0)
table.insert(RGBStrokes, FloatStroke) -- RGB

local FloatLabel = Instance.new("TextLabel")
FloatLabel.Size = UDim2.new(1, 0, 1, 0)
FloatLabel.BackgroundTransparency = 1
FloatLabel.Text = "◆\nOBSIDIAN"
FloatLabel.TextColor3 = Palette.Text
FloatLabel.TextSize = 11
FloatLabel.Font = Enum.Font.GothamBlack
FloatLabel.TextWrapped = true
FloatLabel.Parent = FloatingBtn

--========== PAINEL ==========
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0.92, 0, 0.78, 0)
Panel.Position = UDim2.new(0.04, 0, 0.11, 0)
Panel.BackgroundColor3 = Palette.Bg
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.Active = true
Panel.ClipsDescendants = true
Panel.Parent = MainHolder
NewCorner(Panel, 18)
local PanelStroke = NewStroke(Panel, Palette.Primary, 2, 0)
table.insert(RGBStrokes, PanelStroke) -- RGB

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 66)
TopBar.BackgroundColor3 = Palette.BgPanel
TopBar.BorderSizePixel = 0
TopBar.Parent = Panel
NewCorner(TopBar, 18)

local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 46, 0, 46)
AvatarFrame.Position = UDim2.new(0, 12, 0, 10)
AvatarFrame.BackgroundColor3 = Palette.BgBtn
AvatarFrame.BorderSizePixel = 0
AvatarFrame.Parent = TopBar
NewCorner(AvatarFrame, 23)
NewStroke(AvatarFrame, Palette.Gold, 2, 0)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(1, -4, 1, -4)
AvatarImg.Position = UDim2.new(0, 2, 0, 2)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Parent = AvatarFrame
NewCorner(AvatarImg, 21)
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -260, 0, 28)
Title.Position = UDim2.new(0, 68, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "OBSIDIAN ELITE"
Title.TextColor3 = Palette.Text
Title.TextSize = 21
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -260, 0, 16)
Subtitle.Position = UDim2.new(0, 68, 0, 36)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "◆ " .. GameName .. "  •  " .. LocalPlayer.DisplayName
Subtitle.TextColor3 = Palette.Gold
Subtitle.TextSize = 11
Subtitle.Font = Enum.Font.GothamBold
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

local PanicBtn = Instance.new("TextButton")
PanicBtn.Size = UDim2.new(0, 36, 0, 36)
PanicBtn.Position = UDim2.new(1, -134, 0, 15)
PanicBtn.BackgroundColor3 = Palette.Red
PanicBtn.Text = "!"
PanicBtn.TextColor3 = Palette.Text
PanicBtn.TextSize = 20
PanicBtn.Font = Enum.Font.GothamBlack
PanicBtn.AutoButtonColor = false
PanicBtn.Parent = TopBar
NewCorner(PanicBtn, 10)

local ResizeBtn = Instance.new("TextButton")
ResizeBtn.Size = UDim2.new(0, 36, 0, 36)
ResizeBtn.Position = UDim2.new(1, -90, 0, 15)
ResizeBtn.BackgroundColor3 = Palette.BgBtn
ResizeBtn.Text = "⛶"
ResizeBtn.TextColor3 = Palette.Text
ResizeBtn.TextSize = 18
ResizeBtn.Font = Enum.Font.GothamBold
ResizeBtn.AutoButtonColor = false
ResizeBtn.Parent = TopBar
NewCorner(ResizeBtn, 10)
NewStroke(ResizeBtn, Palette.PrimaryDk, 1, 0.3)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -46, 0, 15)
CloseBtn.BackgroundColor3 = Palette.BgBtn
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Palette.Text
CloseBtn.TextSize = 18
Cl
