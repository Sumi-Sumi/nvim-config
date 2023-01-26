local settings = {}
local utils = require("utils")
local global = require("core.global")

settings["use_ssh"] = true
settings["lazy_path"] = utils.joinpath(global.vim_path, "lazy", "lazy.nvim")
settings["format_on_save"] = true
settings["format_disabled_dirs"] = {
    global.home .. "/format_disabled_dir_under_home",
}
settings["palette_overwrite"] = {}

return settings
