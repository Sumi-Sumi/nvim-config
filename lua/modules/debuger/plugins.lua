local debug = {}
local conf = require("modules.debug.config")

debug["mfussenegger/nvim-dap"] = {
    cmd = {
        "DapSetLogLevel",
        "DapShowLog",
        "DapContinue",
        "DapToggleBreakpoint",
        "DapToggleRepl",
        "DapStepOver",
        "DapStepInto",
        "DapStepOut",
        "DapTerminate",
    },
    dependencies = {
        { "rcarriga/nvim-dap-ui", config = conf.dapui },
    },
    config = conf.dap,
}

return debug
