local curl = require("plenary.curl")

local M = {}

-- TODO: external config
M._api_endpoint = "http://localhost:8080/auth/"
M._ui_endpoint = "http://localhost:8000/auth/"

M._jwt_storage = vim.fn.stdpath("data") .. "/bugtrack.txt"
M._save_jwt = function(jwt)
    local file = io.open(M._jwt_storage, "w")
    if file then
        file:write(jwt)
        file:close()
    else
        error("Error: Unable to open file for writing")
    end
end
M._read_jwt = function()
    local file = io.open(M._jwt_storage, "r")
    if file then
        local jwt = file:read("*all")
        file:close()
        if string.len(jwt) > 0 then
            return jwt
        end
    end
    error("Error: Unable to read JWT from file")
end

M.auth_header = function()
    local jwt = M._read_jwt()
    return {
        content_type = "application/json",
        Authorization = "Bearer " .. jwt
    }
end

M.signup = function()
    local succsess, _ = pcall(vim.fn.system, "xdg-open " .. M._ui_endpoint .. "signup")
    if not succsess then
        error("Error: Could not open default browser")
    end
end

M.signin = function(username, password)
    local response = curl.post(M._api_endpoint .. "signin", {
        body = vim.fn.json_encode({
            username = username,
            password = password
        }),
        headers = { content_type = "application/json" }
    })
    if response.status ~= 200 then
        error("Error: Authentication failed")
    end
    local token = vim.fn.json_decode(response.body)["token"]
    M._save_jwt(token)
end

return M
