local M = {}

-- VARIABLES --
local plugin_dir
local cmd_path
local plugin_name = "prereq"
local pkg_manager
local modules
local execs

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
	-- modules
	if opts.modules then
		modules = opts.modules
	else
		modules = { "ensure_exec", "test" }
	end
	-- execs
	if opts.execs then
		execs = opts.execs
	else
		execs = { "curl", "nvim", "lua", "tar", "grep", "git" }
	end
end

-- FUNCTIONS --
EXECUTABLES = execs
function M.ensure_execs(EXECUTABLES)
	cmd_path = plugin_dir .. "/" .. modules[1]
	local result = vim.fn.system(cmd_path .. " " .. table.concat(EXECUTABLES, " "))
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Failed to ensure executables: " .. result)
	end
end

return M
