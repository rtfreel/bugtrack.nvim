local auth = require("bugtrack.auth")
return function()
    vim.ui.select({
        {
            "Sign up (opens browser)",
            callback = function()
                vim.print("Opening signup URL...")
                local succsess, _ = pcall(auth.signup)
                if not succsess then
                    vim.schedule(function()
                        vim.print("Failed to open signup URL!")
                    end)
                end
            end
        },
        {
            "Sign in",
            callback = function()
                local username = vim.fn.input("Username: ") or ""
                if string.len(username) == 0 then
                    vim.schedule(function()
                        vim.print("Username cannot be empty!")
                    end)
                    return
                end
                local password = vim.fn.inputsecret("Password: ")
                local success, _ = pcall(auth.signin, username, password)
                if not success then
                    vim.schedule(function()
                        vim.print("Authentication failed!")
                    end)
                else
                    vim.schedule(function()
                        vim.print("Authentication for user " .. username .. " was successful!")
                    end)
                end
            end
        }
    }, {
        prompt = "Do you have an account?",
        format_item = function(item)
            return item[1]
        end
    }, function(choice)
        if choice then
            vim.schedule(choice.callback)
        end
    end)
end
