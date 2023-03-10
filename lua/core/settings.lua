local settings = {}
local utils = require("utils")
local global = require("core.global")

settings["use_ssh"] = false
settings["lazy_path"] = utils.joinpath(global.data_dir, "lazy", "lazy.nvim")
settings["format_on_save"] = true
settings["format_disabled_dirs"] = {
    global.home .. "/format_disabled_dir_under_home",
}
settings["palette_overwrite"] = {}

return settings
