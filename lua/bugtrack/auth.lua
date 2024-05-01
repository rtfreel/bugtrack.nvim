local curl = require("plenary.curl")
local config = require("bugtrack.config")

local M = {}

M._service_path = "auth/"

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
    local url = config.options.ui_endpoint .. M._service_path .. "signup"
    local succsess, _ = pcall(vim.fn.system, "xdg-open " .. url)
    if not succsess then
        error("Error: Could not open default browser")
    end
end

M.signin = function(username, password)
    local url = config.options.api_endpoint .. M._service_path .. "signin"
    local response = curl.post(url, {
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
