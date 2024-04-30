local curl = require("plenary.curl")
local auth = require("bugtrack.auth")

local M = {}

M.get = function(url)
    local response = curl.get(url, {
        headers = auth.auth_header()
    })
    if response.status == 403 then
        error("Error: Not authenticated")
    end
    return response
end

M.post = function(url, body_table)
    local response = curl.post(url, {
        body = vim.fn.json_encode(body_table),
        headers = auth.auth_header()
    })
    if response.status == 403 then
        error("Error: Not authenticated")
    end
    return response
end

return M
