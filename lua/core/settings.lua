local settings = {}
local home = require("core.global").home

settings["use_ssh"] = true
settings["format_on_save"] = true
settings["format_disabled_dirs"] = {
    home .. "/format_disabled_dir_under_home",
}

return settings
