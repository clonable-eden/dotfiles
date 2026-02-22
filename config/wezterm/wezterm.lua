-- ~/.config/wezterm/wezterm.lua
-- Cool WezTerm config with Japanese font, transparency, and git worktree status

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ============================================================
-- Font
-- ============================================================
-- Moralerspace Argon HW v2.0.0: Monaspace + IBM Plex Sans JP + Nerd Fonts
-- Install: https://github.com/yuru7/moralerspace/releases
config.font = wezterm.font('Moralerspace Argon HW', { weight = 'Regular' })
config.font_size = 14.0
config.line_height = 1.15

-- ============================================================
-- Window / Transparency
-- ============================================================
config.macos_window_background_blur = 20
config.window_decorations = 'RESIZE'
config.window_padding = { left = 12, right = 12, top = 8, bottom = 4 }
config.initial_cols = 140
config.initial_rows = 40

-- ============================================================
-- Color Schemes (custom: soft/muted tones, avoids primary colors)
-- ============================================================
config.color_schemes = {
  ['Soft Dark'] = {
    foreground = '#c6d0f5', background = '#000000',
    cursor_bg = '#a6d189', cursor_fg = '#1a1b26', cursor_border = '#a6d189',
    selection_fg = '#c6d0f5', selection_bg = '#414559', split = '#414559',
    ansi    = { '#45475a','#eba0ac','#a6d189','#e5c890','#8caaee','#c6a0f6','#81c8be','#bac2de' },
    brights = { '#585b70','#f2b8c6','#b5e0a0','#f0d8a8','#a4bef7','#d4b4fa','#99dbd1','#cdd6f4' },
    tab_bar = {
      background = 'rgba(0, 0, 0, 0.6)',
      active_tab   = { bg_color = '#414559', fg_color = '#c6d0f5', intensity = 'Bold' },
      inactive_tab = { bg_color = 'rgba(0, 0, 0, 0.4)', fg_color = '#737994' },
      inactive_tab_hover = { bg_color = '#303446', fg_color = '#c6d0f5', italic = true },
    },
  },
}

-- Theme: fixed dark
config.color_scheme = 'Soft Dark'
config.window_background_opacity = 0.6

-- ============================================================
-- Tab Bar
-- ============================================================
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.show_new_tab_button_in_tab_bar = false

-- ============================================================
-- Pane: dim inactive panes
-- ============================================================
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.4 }

-- ============================================================
-- Cursor
-- ============================================================
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 600

-- ============================================================
-- Misc
-- ============================================================
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.status_update_interval = 3000

-- ============================================================
-- External commands (full path: WezTerm Lua bypasses shell PATH)
-- ============================================================
local GIT = '/opt/homebrew/bin/git'
local ZOXIDE = '/opt/homebrew/bin/zoxide'

-- ============================================================
-- Helper: get git info in a single child process
-- ============================================================
local function get_git_info(cwd)
  if not cwd or cwd == '' then return nil end

  -- Get branch, toplevel, and git-dir in one call
  local cmd = GIT .. ' -C "' .. cwd .. '" rev-parse --abbrev-ref HEAD --show-toplevel --git-dir 2>/dev/null'
  local success, stdout, _ = wezterm.run_child_process { '/bin/sh', '-c', cmd }
  if not success or not stdout or stdout == '' then return nil end

  local lines = {}
  for line in stdout:gmatch('[^\r\n]+') do
    table.insert(lines, line)
  end
  if #lines < 3 then return nil end

  local branch = lines[1]
  if branch == 'HEAD' then
    local ok, hash, _ = wezterm.run_child_process { GIT, '-C', cwd, 'rev-parse', '--short', 'HEAD' }
    branch = ok and hash and '(' .. hash:gsub('%s+$', '') .. ')' or 'detached'
  end

  return {
    branch = branch,
    is_worktree = lines[3]:find('/worktrees/') ~= nil,
    worktree_name = lines[2]:match('[^/]+$') or lines[2],
  }
end

-- ============================================================
-- Status Bar: git branch / worktree + cwd + time
-- ============================================================
local STATUS_COLORS = {
  dim = '#737994', text = '#c6d0f5', green = '#a6d189', blue = '#8caaee', purple = '#c6a0f6', yellow = '#e5c890',
}

wezterm.on('update-status', function(window, pane)
  local c = STATUS_COLORS
  local elements = {}
  local sep = { { Foreground = { Color = c.dim } }, { Text = '  │  ' } }

  -- CWD
  local cwd_uri = pane:get_current_working_dir()
  local cwd_path = ''
  if cwd_uri and type(cwd_uri) == 'userdata' then
    cwd_path = cwd_uri.file_path or ''
  end
  local home = os.getenv('HOME') or ''
  local cwd_display = cwd_path
  if home ~= '' and cwd_path:sub(1, #home) == home then
    cwd_display = '~' .. cwd_path:sub(#home + 1)
  end

  -- Git
  local git = get_git_info(cwd_path)
  if git then
    table.insert(elements, { Foreground = { Color = c.green } })
    table.insert(elements, { Text = wezterm.nerdfonts.dev_git_branch .. ' ' })
    table.insert(elements, { Foreground = { Color = c.text } })
    table.insert(elements, { Text = git.branch })
    if git.is_worktree then
      table.insert(elements, { Foreground = { Color = c.dim } })
      table.insert(elements, { Text = ' ' })
      table.insert(elements, { Foreground = { Color = c.purple } })
      table.insert(elements, { Text = wezterm.nerdfonts.cod_git_pull_request .. ' ' })
      table.insert(elements, { Foreground = { Color = c.yellow } })
      table.insert(elements, { Text = git.worktree_name or '' })
    end
    for _, e in ipairs(sep) do table.insert(elements, e) end
  end

  -- CWD
  table.insert(elements, { Foreground = { Color = c.blue } })
  table.insert(elements, { Text = wezterm.nerdfonts.md_folder_outline .. ' ' })
  table.insert(elements, { Foreground = { Color = c.dim } })
  table.insert(elements, { Text = cwd_display })

  -- Time
  for _, e in ipairs(sep) do table.insert(elements, e) end
  table.insert(elements, { Foreground = { Color = c.dim } })
  table.insert(elements, { Text = wezterm.strftime '%H:%M  ' })

  window:set_right_status(wezterm.format(elements))

  -- Left: project name (from window title set by project_layout)
  local win_title = window:mux_window():get_title()
  if win_title ~= '' then
    window:set_left_status(wezterm.format {
      { Foreground = { Color = c.purple } },
      { Text = '  ' .. wezterm.nerdfonts.cod_window .. ' ' .. win_title .. '  ' },
    })
  else
    window:set_left_status('')
  end
end)

-- ============================================================
-- Tab Title
-- ============================================================
wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
  local title = tab.active_pane.title or 'shell'
  if #title > max_width - 4 then
    title = title:sub(1, max_width - 6) .. '…'
  end
  return ' ' .. (tab.tab_index + 1) .. ':' .. title .. ' '
end)

-- ============================================================
-- Workspace Switcher (zoxide integration)
-- ============================================================
local function workspace_switcher()
  return wezterm.action_callback(function(window, pane)
    local home = os.getenv('HOME') or ''
    local choices = {}

    -- Existing workspaces
    for _, ws in ipairs(wezterm.mux.get_workspace_names()) do
      table.insert(choices, { id = ws, label = ' ' .. ws })
    end

    -- zoxide
    local success, stdout, _ = wezterm.run_child_process { ZOXIDE, 'query', '-l' }
    if success and stdout then
      for line in stdout:gmatch('[^\r\n]+') do
        local label = line
        if home ~= '' and line:sub(1, #home) == home then
          label = '~' .. line:sub(#home + 1)
        end
        table.insert(choices, { id = line, label = label })
      end
    end

    window:perform_action(
      wezterm.action.InputSelector {
        title = 'Switch Workspace',
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(w, p, id, label)
          if not id then return end
          w:perform_action(
            wezterm.action.SwitchToWorkspace {
              name = label:gsub('^. ', ''),
              spawn = { cwd = id },
            }, p
          )
        end),
      }, pane
    )
  end)
end

-- ============================================================
-- Project Layout: Claude + Terminal + git log
-- ============================================================
-- Ctrl+S p: open a new window with a pre-configured pane layout
--   ┌──────────────┬──────────┐
--   │  Claude Code │ Terminal │
--   │   (60%)      │  (40%)   │
--   ├──────────────┴──────────┤
--   │  git log (25%)          │
--   └─────────────────────────┘
local function project_layout()
  return wezterm.action_callback(function(window, pane)
    local cwd_uri = pane:get_current_working_dir()
    if not cwd_uri then return end
    local cwd = cwd_uri.file_path or ''
    if cwd == '' then return end

    -- Derive project name from directory basename
    local project_name = cwd:match('([^/]+)/?$') or cwd

    -- Create independent OS window
    local _, main_pane, new_window = wezterm.mux.spawn_window {
      cwd = cwd,
    }

    -- Set window title for Cmd+` identification
    new_window:set_title(project_name)

    -- Bottom first: git log with auto-refresh (full width, 25%)
    local git_pane = main_pane:split {
      direction = 'Bottom',
      size = 0.25,
      cwd = cwd,
    }

    -- Then right: general-purpose terminal (40% of top area)
    main_pane:split {
      direction = 'Right',
      size = 0.4,
      cwd = cwd,
    }

    -- Auto-start Claude in main pane
    main_pane:send_text('claude\n')

    -- Auto-refresh git log in bottom pane
    git_pane:send_text(
      'while true; do clear; git --no-pager log --oneline --graph --color -15; sleep 5; done\n'
    )

    -- Focus Claude pane
    main_pane:activate()
  end)
end

-- ============================================================
-- Key Bindings
-- ============================================================
config.leader = { key = 's', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Disable Option+Enter fullscreen toggle
  { key = 'Enter', mods = 'ALT',      action = wezterm.action.DisableDefaultAssignment },
  -- Workspace
  { key = 's', mods = 'LEADER',       action = workspace_switcher() },
  { key = 'S', mods = 'LEADER|SHIFT', action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' } },
  -- Project layout
  { key = 'p', mods = 'LEADER',       action = project_layout() },
  -- Pane split
  { key = '-', mods = 'LEADER',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'LEADER',      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- Pane navigation
  { key = 'h', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Right' },
  -- Pane zoom
  { key = 'z', mods = 'LEADER',       action = wezterm.action.TogglePaneZoomState },
}

return config
