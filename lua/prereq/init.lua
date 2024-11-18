local M = {}

-- VARIABLES --
local plugin_name = "prereq"
local plugin_dir
local plugin_bin_dir
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

	plugin_bin_dir = plugin_dir .. "/bin"

	-- execs
	if opts.execs then
		execs = opts.execs
	else
		execs = { "curl", "nvim", "lua", "tar", "grep", "git" }
	end

	M.install_executables()
end

-- FUNCTIONS --
function M.install_executables()
	local shell = vim.fn.getenv("SHELL") or "/bin/sh"
	local cmd = table.concat({ plugin_bin_dir .. "/" .. modules[1], table.unpack(execs) }, " ")
	local result = vim.fn.system(shell .. " -c '" .. cmd .. "'")
	vim.api.nvim_out_write(result)
end

return M
