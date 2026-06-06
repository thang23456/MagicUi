## Tutorial MagicUi Use Made by Magic_Master Thank you https://github.com/notzanocoddz4 for the sample
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/thang23456/MagicUi/refs/heads/main/MagicUiXZano.luau")) 
local Window = Library:CreateWindow({ 
   Title = "MagicHub | Doors", 
   SubName = "V1",
   Folder = "MagicHub", 
   Size = UDim2.fromOffset(600, 480), 
   Background = true, 
   BackgroundColor = Color3.fromRGB(10, 10, 14), 
   Discord = true, 
   Url = "https://discord.gg/magichub" 
}) 

local MainTab = Window:CreateTab("Main")

MainTab:CreateButton("Hello Zano =]]", function() 
  print("Hello World =]]") 
  Library:Notify("Notify", "Zano Rất Bell", 6) 
end)
