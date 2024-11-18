local M = {}

-- VARIABLES --
local binaries
local plugin_dir
local cmd_path
local plugin_name = "prereq"
local pkg_manager

function M.setup(opts)
	-- OPTS --
	opts = opts or {}
	-- pkg_manager
	if opts.pkg_manager then
		pkg_manager = opts.pkg_manager
	else
		pkg_manager = "lazy"
	end
	-- plugin_dir
	if opts.plugin_dir then
		plugin_dir = opts.plugin_dir
	else
		plugin_dir = vim.fn.stdpath("data") .. "/" .. pkg_manager .. "/" .. plugin_name
	end
	-- binaries
	if opts.binaries then
		binaries = opts.binaries
	else
		binaries = { "ensure_exec", "test" }
	end
end

-- FUNCTIONS --
function M.ensure_executables(executables)
	local result
	-- construct path to ensure_exec binary
	cmd_path = plugin_dir .. "/bin/" .. binaries[1] -- lua arrays start at index '1' not '0'
	result = vim.fn.system(cmd_path .. " " .. table.concat(executables, " "))
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("error:" .. result)
	end
end

return M
