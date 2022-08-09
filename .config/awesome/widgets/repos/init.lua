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

    function get_url(text)
      local url = text:match('Fetch URL: (.+)%.git\n%s+Push')
      return url or 'No connection'
    end

    function get_source_code_icon(url)
      local source_icon = ""

      if url == nil then
        source_icon = ""
      elseif url:find('github') then
        source_icon = ''
      elseif url:find('gitlab') then
        source_icon = ""
      elseif url:find('bitbucket') then
        source_icon = ""
      end

      return source_icon
    end


    function create_repo_card(out, repo_info)
      local url         = get_url(out)
      local source_icon = get_source_code_icon(url)
      local card        = repo_card.create(repo_info, url, source_icon)
      base_widget:add(card)
    end

    awesome.connect_signal("sysstat::git_repos", function(repos)
      for _, repo_info in pairs(repos) do

        awful.spawn.easy_async_with_shell(commands.git_repo_info(repo_info.path),
          function(out)
            create_repo_card(out, repo_info)
          end)

      end
    end)

    return base_widget

  end
}
