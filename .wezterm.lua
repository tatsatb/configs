local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ── Appearance ──────────────────────────────────────────────────────────────

config.color_scheme = "iTerm2 Smoooooth"

config.colors = {
    --foreground            = "#d3dae3",
    --background            = "#353945",
    --cursor_bg             = "#a3c0de",
    --cursor_border         = "#0275f7",
    --cursor_fg             = "#353945",
    --selection_bg          = "#274a70",
    --selection_fg          = "#d3dae3",
    scrollbar_thumb        = "#b37de6",
    --ansi = {
        --"#3b4048", -- black
        --"#e06c75", -- red
        --"#98c379", -- green
        --"#e5c07b", -- yellow
        --"#5294E2", -- blue
        --"#c678dd", -- magenta
        --"#56b6c2", -- cyan
        --"#d3dae3", -- white
    --},
    --brights = {
        --"#545862", -- bright black
        --"#e06c75", -- bright red
        --"#98c379", -- bright green
        --"#e5c07b", -- bright yellow
        --"#0275f7", -- bright blue
        --"#c678dd", -- bright magenta
        --"#56b6c2", -- bright cyan
        --"#ffffff", -- bright white
    --},
    tab_bar = {
        background        = "#46527f",
        active_tab = {
            bg_color      = "#43adac",
            fg_color      = "#d3dae3",
        },
        inactive_tab = {
            bg_color      = "#2b2e39",
            fg_color      = "#7c818c",
        },
        inactive_tab_hover = {
            bg_color      = "#353945",
            fg_color      = "#d3dae3",
        },
        new_tab = {
            bg_color      = "#23bab8",
            fg_color      = "#ffffff",
        },
        new_tab_hover = {
            bg_color      = "#353945",
            fg_color      = "#0275f7",
        },
    },
}

-- ── Font ────────────────────────────────────────────────────────────────────

config.font = wezterm.font("JetBrains Mono")

config.font_size = 17.0
config.line_height = 1.1
config.cell_width = 1.0

-- ── Window ──────────────────────────────────────────────────────────────────

config.window_background_opacity = 0.69
config.macos_window_background_blur = 25
config.window_padding = { left = 8, right = "1.5cell", top = 8, bottom = 8 }
if wezterm.target_triple:find("darwin") then
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    -- Prevent flicker: opacity+blur forces full compositor repaints on scroll.
    -- WebGpu uses Metal more efficiently; animation_fps suppresses extra frames.
    config.front_end = "WebGpu"
    config.animation_fps = 1
else
    config.window_decorations = "RESIZE"
end
config.initial_cols = 120
config.initial_rows = 25

-- ── Tab bar ─────────────────────────────────────────────────────────────────

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.show_tab_index_in_tab_bar = false
config.window_frame = {
    font_size = 18,
}

-- ── Cursor ──────────────────────────────────────────────────────────────────

config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ── Scrollback ──────────────────────────────────────────────────────────────

config.scrollback_lines = 10000
config.enable_scroll_bar = true


-- ── Bell ────────────────────────────────────────────────────────────────────

config.audible_bell = "Disabled"
config.visual_bell = {
    fade_in_duration_ms  = 75,
    fade_out_duration_ms = 75,
    target               = "CursorColor",
}

-- ── Keys ────────────────────────────────────────────────────────────────────
-- Leader: Ctrl+Q (matches tmux prefix)

config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2500 }

config.keys = {
    -- Pane splitting
    { key = "|", mods = "LEADER",       action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "-", mods = "LEADER",       action = act.SplitVertical   { domain = "CurrentPaneDomain" } },

    -- Pane navigation (vim-style)
    { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection "Left"  },
    { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection "Down"  },
    { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection "Up"    },
    { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection "Right" },

    -- Pane resize (vim-style)
    { key = "H", mods = "LEADER",       action = act.AdjustPaneSize { "Left",  5 } },
    { key = "J", mods = "LEADER",       action = act.AdjustPaneSize { "Down",  5 } },
    { key = "K", mods = "LEADER",       action = act.AdjustPaneSize { "Up",    5 } },
    { key = "L", mods = "LEADER",       action = act.AdjustPaneSize { "Right", 5 } },

    -- Tab management
    { key = "c", mods = "LEADER",       action = act.SpawnTab "CurrentPaneDomain"  },
    { key = "n", mods = "LEADER",       action = act.ActivateTabRelative(1)        },
    { key = "p", mods = "LEADER",       action = act.ActivateTabRelative(-1)       },
    { key = ">", mods = "LEADER",       action = act.MoveTabRelative(1)            },
    { key = "<", mods = "LEADER",       action = act.MoveTabRelative(-1)           },
    -- Move tab to absolute position (1-based input)
    {
        key = "m", mods = "LEADER",
        action = act.PromptInputLine {
            description = "Move tab to position (1-based):",
            action = wezterm.action_callback(function(window, _, line)
                local idx = tonumber(line)
                if idx then window:perform_action(act.MoveTab(idx - 1), window:active_pane()) end
            end),
        },
    },
    { key = "x", mods = "LEADER",       action = act.CloseCurrentPane { confirm = true } },
    { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState           },

    -- Rename tab
    {
        key = ",", mods = "LEADER",
        action = act.PromptInputLine {
            description = "Rename tab:",
            action = wezterm.action_callback(function(window, _, line)
                if line then window:active_tab():set_title(line) end
            end),
        },
    },

    -- Copy mode (vim-style)
    { key = "[", mods = "LEADER",       action = act.ActivateCopyMode            },
    { key = "y", mods = "LEADER",       action = act.CopyTo "ClipboardAndPrimarySelection" },


    -- Clear scrollback
    { key = "k", mods = "CMD",          action = act.ClearScrollback "ScrollbackAndViewport" },

    -- Font size
    { key = "=", mods = "CTRL",         action = act.IncreaseFontSize             },
    { key = "-", mods = "CTRL",         action = act.DecreaseFontSize             },
    { key = "0", mods = "CTRL",         action = act.ResetFontSize                },

    -- Newline in Claude Code (Shift+Enter → raw newline)
    { key = "Enter", mods = "SHIFT",    action = act.SendString "\n"              },
}

-- Direct tab switching (Leader + 1-9)
for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i), mods = "LEADER",
        action = act.ActivateTab(i - 1),
    })
end

-- ── Copy mode (vim bindings) ─────────────────────────────────────────────────

config.key_tables = {
    copy_mode = {
        { key = "h",      mods = "NONE",  action = act.CopyMode "MoveLeft"             },
        { key = "j",      mods = "NONE",  action = act.CopyMode "MoveDown"             },
        { key = "k",      mods = "NONE",  action = act.CopyMode "MoveUp"               },
        { key = "l",      mods = "NONE",  action = act.CopyMode "MoveRight"            },
        { key = "w",      mods = "NONE",  action = act.CopyMode "MoveForwardWord"      },
        { key = "b",      mods = "NONE",  action = act.CopyMode "MoveBackwardWord"     },
        { key = "0",      mods = "NONE",  action = act.CopyMode "MoveToStartOfLine"    },
        { key = "$",      mods = "NONE",  action = act.CopyMode "MoveToEndOfLineContent" },
        { key = "g",      mods = "NONE",  action = act.CopyMode "MoveToScrollbackTop"  },
        { key = "G",      mods = "NONE",  action = act.CopyMode "MoveToScrollbackBottom" },
        { key = "v",      mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Cell" } },
        { key = "V",      mods = "NONE",  action = act.CopyMode { SetSelectionMode = "Line" } },
        { key = "y",      mods = "NONE",  action = act.Multiple {
            act.CopyTo "ClipboardAndPrimarySelection",
            act.CopyMode "Close",
        }},
        { key = "q",      mods = "NONE",  action = act.CopyMode "Close"               },
        { key = "Escape", mods = "NONE",  action = act.CopyMode "Close"               },
    },
}

-- ── Mouse ────────────────────────────────────────────────────────────────────

config.mouse_bindings = {
    -- Right-click paste
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = act.PasteFrom "Clipboard",
    },
}

-- ── Misc ─────────────────────────────────────────────────────────────────────

config.automatically_reload_config = true
config.check_for_updates = false
config.warn_about_missing_glyphs = false
config.bold_brightens_ansi_colors = true
config.native_macos_fullscreen_mode = false

return config
