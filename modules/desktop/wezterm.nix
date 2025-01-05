{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      programs.wezterm.enable = true;
      programs.wezterm.extraConfig =
        #lua
        ''
          local act = wezterm.action
          local io = require 'io'
          local os = require 'os'
          local config = {}
          local mux = wezterm.mux
          config.set_environment_variables = {
            SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh"
          }
          config.tiling_desktop_environments = {
            'Wayland'
          }
          config.enable_wayland = true
          config.front_end = "WebGpu"
          config.tab_bar_at_bottom = true
          config.hide_tab_bar_if_only_one_tab = true
          config.font = wezterm.font {
            family = 'JetBrains Mono Nerd Font',
            weight = 'DemiBold',
          }
          config.font_size = 13
          config.window_decorations = "RESIZE"
          config.window_padding = {
              left = 0,
              right = 0,
              top = 0,
              bottom = 0,
          }

          config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }
          config.keys = {
            {
              key = 'Return',
              mods = 'ALT',
              action = wezterm.action.ShowLauncher
            },
            {
              key = 'h',
              mods = 'ALT',
              action = act.ActivatePaneDirection 'Left',
            },
            {
              key = 'l',
              mods = 'ALT',
              action = act.ActivatePaneDirection 'Right',
            },
            {
              key = 'k',
              mods = 'ALT',
              action = act.ActivatePaneDirection 'Up',
            },
            {
              key = 'j',
              mods = 'ALT',
              action = act.ActivatePaneDirection 'Down',
            },
            {
              key = 'e',
              mods = 'CTRL',
              action = act.EmitEvent 'hx-scrollback',
            },
            {
              key = 'v',
              mods = 'ALT',
              action = act.SplitHorizontal
            },
            {
              key = 'v',
              mods = 'ALT|SHIFT',
              action = act.SplitVertical
            },
            {
              key = 'g',
              mods = 'ALT|SHIFT',
              action = act.EmitEvent 'test',
            },
            {
              key = 'q',
              mods = 'ALT',
              action = wezterm.action.CloseCurrentPane { confirm = false },
            },
            {
              key = "s",
              mods = 'ALT',
              action = act.EmitEvent 'sesh',
            }
          }

          for i = 1, 8 do
            -- CTRL+ALT + number to activate that tab
            table.insert(config.keys, {
              key = tostring(i),
              mods = 'ALT',
              action = act.ActivateTab(i - 1),
            })
          end





          wezterm.on('test', function(window, pane)


            local dimensions = pane:get_dimensions()
            local row = dimensions.physical_top + dimensions.viewport_rows - 2
            local col_start = 7
            local col_end = dimensions.cols
            local status_text = pane:get_text_from_region(col_start,row,col_end,row + 1)
            -- local text = 'cols: '..dimensions.cols.." ".. 'viewport_rows: '..dimensions.viewport_rows.." ".. 'scrollback_rows: '..dimensions.scrollback_rows.." ".. 'physical_top: '..dimensions.physical_top.." "..'scrollback_top: '.. dimensions.scrollback_top
            local text = ""


            for i in string.gmatch(status_text, "%S+") do
               text = i
               break
            end

            for i in string.gmatch(text,"[^%.]+") do
               text = i
               break
            end


            local proc = pane:get_foreground_process_info()
            if pid then
            local pid = proc.pid

            local env_f = io.open('/proc/'..pid..'/environ', 'r+')
            local env_vars = env_f:read("*a")
            text = env_vars
            end

            local name = os.tmpname()
            local f = io.open(name, 'w')
            f:write(text)
            f:flush()
            f:close()

            window:perform_action(
              act.SplitPane {
                command = {
                  -- set_environment_variables = { PATH = ""},
                  -- args = {'/nix/store/k65yq9109hqbjlg7sfhcnadga9avqvpm-openjdk-22+36/bin/java', '-ea', '-cp', 'res/', text} },
                  args = { 'hx', name }
                },
                direction = "Right",
              },
              pane
            )

            wezterm.sleep_ms(1000)
            os.remove(name)
            end
          )

          wezterm.on('hx-scrollback', function(window, pane)
            -- Retrieve the text from the pane
            local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

            -- Create a temporary file to pass to vim
            local name = os.tmpname()
            local f = io.open(name, 'w+')
            f:write(env_vars)
            f:flush()
            f:close()

            -- Open a new window running vim and tell it to open the file
            window:perform_action(
              act.SplitPane {
                command = { args = { 'hx', name } },
                direction = "Down",
              },
              pane
            )

            -- Wait "enough" time for vim to read the file before we remove it.
            -- The window creation and process spawn are asynchronous wrt. running
            -- this script and are not awaitable, so we just pick a number.
            --
            -- Note: We don't strictly need to remove this file, but it is nice
            -- to avoid cluttering up the temporary directory.
            wezterm.sleep_ms(1000)
            os.remove(name)
          end
          )


          config.unix_domains = {
            {
              name = 'unix',
            },
          }

          config.default_gui_startup_args = { 'connect', 'unix' }



          -- From https://github.com/wez/wezterm/discussions/4796#discussioncomment-8354795
          local fd = "${pkgs.fd}/bin/fd"
          local rootPath = "/home/sargo/"

          local toggle = function(window, pane)
            local projects = {}

            local success, stdout, stderr = wezterm.run_child_process({
              fd,
              "-HI",
              "-td",
              "^.git$",
              "--max-depth=4",
              rootPath,
              -- add more paths here
            })

            if not success then
              wezterm.log_error("Failed to run fd: " .. stderr)
              return
            end

            for line in stdout:gmatch("([^\n]*)\n?") do
              local project = line:gsub("/.git/$", "")
              local label = project
              local id = project:gsub(".*/", "")
              table.insert(projects, { label = tostring(label), id = tostring(id) })
            end

            window:perform_action(
              act.InputSelector({
                action = wezterm.action_callback(function(win, _, id, label)
                  if not id and not label then
                    wezterm.log_info("Cancelled")
                  else
                    wezterm.log_info("Selected " .. label)
                    win:perform_action(
                      act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }),
                      pane
                    )
                  end
                end),
                fuzzy = true,
                title = "Select project",
                choices = projects,
              }),
              pane
            )
          end
          -- End

          wezterm.on("sesh", toggle)

          return config
        '';
    })
  ];
}
