# prereq.nvim

## About

## Functions

### install_execs

```lua
return {
    "any/plugin",
    dependencies = {
        "onexbash/prereq.nvim",
        opts = {}, -- opts are required because it calls the setup function for you automatically
		init = function()
            -- add any executables that are required for the current plugin
			local execs = { "curl", "tar", "grep", "ripgrep", "go" } -- these are just example values
		    -- call the install_execs() function provided by prereq.nvim and pass the execs table
            require("prereq").install_execs(execs)
		end,
    }
}
```
