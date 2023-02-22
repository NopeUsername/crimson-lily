return function(UILib, window)
    local tab = window:AddTab("Test")
    local box = tab:AddLeftGroupbox("Box")

    box:AddLabel("asd")
    box:AddButton({
        Text = "Unload",
        Func = function()
            ODYSSEY.Maid:Destroy()
        end
    })
end