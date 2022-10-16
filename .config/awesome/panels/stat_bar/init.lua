local module = require("panels.stat_bar." .. cfg.panels.stats.version)

return {
    name = module.name,
    watchdogs = module.watchdogs,
    create = function(s)
        return createWidget(module, s)
    end
}