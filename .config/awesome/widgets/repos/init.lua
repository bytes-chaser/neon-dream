local awful       = require("awful")
local wibox       = require("wibox")
local dpi         = require("beautiful").xresources.apply_dpi
local commands    = require("commons.commands")
local shape_utils = require("commons.shape")

local repo_card   = require("widgets.repos.repo_card")

return {
  create = function()

    local scroll = {
      widget = wibox.widget.separator,
      shape  = shape_utils.default_frr,
    }

    local base_widget = wibox.widget({
  		layout           = require("dependencies.overflow").vertical,
  		spacing          = dpi(5),
      scrollbar_width  = dpi(8),
  		step             = 50,
  		scrollbar_widget = scroll,
  	})

    function get_url(text) return text:match('Fetch URL: (.+)%.git\n%s+Push') end

    function get_source_code_icon(url)
      local source_icon = ""

      if url:find('github') then
        source_icon = ''
      elseif url:find('gitlab') then
        source_icon = ""
      elseif url:find('bitbucket') then
        source_icon = ""
      end

      return source_icon
    end


    function create_repo_card(out)
      local url         = get_url(out)
      local source_icon = get_source_code_icon(url)
      local card        = repo_card.create(repo_info, url, source_icon)
      base_widget:add(card)
    end

    awesome.connect_signal("sysstat::git_repos", function(repos)
      for _, repo_info in pairs(repos) do
        local path          = repo_info.path
        local repo_info_cmd = commands.git_repo_info(path)
        awful.spawn.easy_async_with_shell(repo_info_cmd, create_repo_card)

      end
    end)

    return base_widget

  end
}
