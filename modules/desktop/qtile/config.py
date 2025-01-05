from libqtile.log_utils import logger
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import extension, hook, bar, layout, qtile, widget
import os

def spawn_os(path):
    os.spawnlp(os.P_NOWAIT, path, path)

@hook.subscribe.startup_once
def launch_startup():
    for bin in ["wezterm-mux-server", "swayosd-server", "swaync" ]:
        spawn_os(bin)
    


mod = "mod4"
terminal = guess_terminal()


spawning_research = False
research_wids = set()

@hook.subscribe.client_new
def add_research_wm_class(window):
    global spawning_research, research_wids
    if spawning_research:
        info = window.info()
        research_wids.add(info['id'])

@lazy.function
def group_research_browser(*args, **kwargs):
    global spawning_research, research_wids
    for window in qtile.current_group.windows:
        if window.info()['id'] in  research_wids:
            window.minimized = not window.minimized
            return
    spawning_research = True
    qtile.spawn("firefox")



def focus_wezterm() -> bool:
    for window in qtile.current_group.windows:
        if window.info()['wm_class'] == ['org.wezfurlong.wezterm']:
            window.focus()
            return True
    return False

def wezterm_tab(tab: int):
    @lazy.function 
    def wezterm_tab_inner(*args):
        if focus_wezterm():
            qtile.simulate_keypress(["mod1"], str(tab))
    return wezterm_tab_inner

@lazy.function 
def laz(*args):
    qtile.simulate_keypress(["alt"], "3")



@lazy.function
def wezterm_with_group_workspace(*args):
    if not focus_wezterm():
        qtile.spawn(f"wezterm connect --workspace qtile-group-{qtile.current_group.name} unix")



def open_workspace(path: str):
    name = path.strip("~/").strip('/')
    cmd = ""
    logger.warning(path)
    abspath = os.path.abspath(os.path.expanduser(path))
    if not os.path.isdir(abspath):
        cmd = f"hx {abspath}"
        path = os.path.dirname(abspath)
    com = f"wezterm connect unix --workspace {name} -- nu --execute 'cd {path}; {cmd}'"
    logger.warning(com)
    qtile.spawn(com)

@lazy.function
def wezterm_in_workspace(*args):
    if focus_wezterm():
        return

    qtile.widgets_map["prompt"].start_input("Working dir", open_workspace, complete="file")
        

keys = [
    Key([mod], "p", group_research_browser, desc="Focus or spawn research browser"),
    # Key([mod, "shift"], "p", lambda: laz, desc="Test"),
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        wezterm_in_workspace,
        desc="Open a workspace in a wezterm session",
    ),
    # Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Return", wezterm_with_group_workspace,desc="Launch wezterm"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Key([], "XF86AudioLowerMute", lazy.spawn("swayosd-client --output-volume mute-toggle")),
    Key([], "f20", lazy.spawn("swayosd-client --brightness lower")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("swayosd-client --output-volume lower")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("swayosd-client --output-volume raise")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("swayosd-client --brightness lower")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("swayosd-client --brightness raise"))
]

def set_volume(volume):
    qtile.spawn("swayosd-client --output-volume -100")
    qtile.spawn(f"swayosd-client --output-volume +{int(volume)}")

@lazy.function
def volume_prompt(*args):
    logger.warning("Prompted")
    qtile.widgets_map["prompt"].start_input("Set volume", set_volume)

for key in [ "XF86AudioLowerVolume", "XF86AudioRaiseVolume" ]:
    keys.append(Key([mod], key,volume_prompt, desc="Set the brightness using a prompted value"))

def set_brightness(brightness):
    qtile.spawn(f"swayosd-cleint --brightness {int(brightness)}")

@lazy.function
def brightness_prompt(*args):
    qtile.widgets_map["prompt"].start_input("Set brightness", set_brightness)

for key in [ "XF86MonBrightnessDown", "XF86MonBrightnessUp" ]:
    keys.append(Key([mod], key, brightness_prompt,desc="Set the brightness using a prompted value"))

for tab in range(1,10):
    keys.append(
        Key(['control', 'shift', 'mod1'], str(tab), wezterm_tab(tab), desc=f"Switch to wezterm tab {tab}")
    )

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            # desc=f"Switch to VT{vt}",
        )
    )


groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            Key(
                [mod], i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            Key(
                [mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
        ]
    )

layouts = [ layout.Tile(add_on_top=False, border_focus="#e79b73", border_width=0, border_on_single=False) ]

widget_defaults = dict(
    font="UbuntuMono",
    fontsize=13,
    padding=3,
)
extension_defaults = widget_defaults.copy()



from libqtile.widget.battery import BatteryStatus, BatteryState
class BatteryWidget(widget.Battery):
    def build_string(self, status: BatteryStatus) -> str:
            """Determine the string to return for the given battery state """
            is_charging = ""
            if status.state == BatteryState.CHARGING:
                is_charging = ""
            charge_icon = [ "", "", "", "", "" ][int(status.percent * 5)] + " " 
            return charge_icon + is_charging
            

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    active="#DE956E",
                    highlight_method='line',
                    this_current_screen_border='#8bcbe7'
                ),
                # widget.TaskList(),
                widget.Prompt(width=bar.STRETCH,bell_style=None,
                              prompt='{prompt} > ',
                          foreground='#8bcbe7'),
                # widget.WindowName(),
                # widget.Spacer(width=bar.STRETCH),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                widget.StatusNotifier(foreground="#b3bbde"),
                # widget.Systray(),
                BatteryWidget(
                    low_foreground="#e07d8e",
                    foreground="#DE956E"
                ),
                widget.Bluetooth(foreground="#b3bbde"),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p",foreground="#b3bbde"),
                widget.QuickExit(foreground="#b3bbde")
                # widget.SwayNC()
            ],
            24,
            background="#13131A",
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = {
    "type:touchpad": InputConfig(tap=True, natural_scroll=True),
    "type:pointer": InputConfig(tap=True),
    "type:keyboard": InputConfig(tap=True),
}

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# Java app compatibility
wmname = "LG3D"

