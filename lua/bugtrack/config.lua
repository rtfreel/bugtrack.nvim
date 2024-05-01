local M = {}

function M.defaults()
    return {
        api_endpoint = "http://localhost:8080/",
        ui_endpoint = "http://localhost:8000/",
    }
end

M.options = {}

function M.setup(options)
    M.options = vim.tbl_deep_extend(
        "force",
        {},
        M.defaults(),
        options or {}
    )
end

return M
