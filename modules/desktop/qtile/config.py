from libqtile.log_utils import logger
from libqtile.backend.wayland import InputConfig
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen,  ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile import hook, bar, layout, qtile, widget
import asyncio
from asyncio import create_task 
import subprocess
import os
import json
import base64
import wezpy
from qtile_extras.widget.decorations import RectDecoration

wc = wezpy.WeztermClient()

groups = []

def lazy_async(fn):
    return lazy.function( lambda call: create_task(fn()) )

def spawn_os(path, *args):
    os.spawnlp(os.P_NOWAIT, path, path, *args)

@hook.subscribe.startup_once
def launch_startup():
    for bin in ["wezterm-mux-server", "swayosd-server", "swaync" ]:
        spawn_os(bin)   


mod = "mod4"
terminal = "wezterm"

window_open_event = asyncio.Event()
@hook.subscribe.client_managed
def notify_window_open(*args):
    window_open_event.set()
    window_open_event.clear()

next_group_to_open = None
def open_on_group(cmd: str, group: str , switch_group: bool = False, toggle: bool = False):
    global next_group_to_open
    next_group_to_open = group
    qtile.spawn(cmd)

@hook.subscribe.client_new
def move_clients_into_queued_groups(client):
    global next_group_to_open
    if next_group_to_open is None:
        return
    client.togroup(next_group_to_open)
    next_group_to_open = None
    
def lazy_open_current_group(cmd, **kwargs):
    return lazy.function(lambda x: open_on_group(cmd, qtile.current_group.name,**kwargs))


spawning_research = False
research_wids = set()

@hook.subscribe.client_new
def add_research_wm_class(window):
    global spawning_research, research_wids
    if spawning_research:
        info = window.info()
        research_wids.add(info['id'])
        spawning_research = False

@lazy.function
def group_research_browser(*args, **kwargs):
    global spawning_research, research_wids
    for window in qtile.current_group.windows:
        if window.info()['id'] in  research_wids:
            window.minimized = not window.minimized
            if window.minimized and window.has_focus():
                qtile.current_group.focus_back()
            return
    spawning_research = True
    qtile.spawn("firefox")

@lazy.function
def toggle_reasearch_window(*args):
    global research_wids
    id = qtile.current_window.info()['id']
    try:
        research_wids.remove(id)
    except KeyError:
        research_wids.add(id)
    
def window_is_wezterm(window):
    if (info := window.info()) is not None:
        return info['wm_class'] == ['org.wezfurlong.wezterm']
    return False

def focus_wezterm() -> bool:
    for window in qtile.current_group.windows:
        if window_is_wezterm(window):
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
def wezterm_with_group_workspace(*args):
    if not focus_wezterm():
        qtile.spawn(f"wezterm connect --workspace qtile-group-{qtile.current_group.name} unix")


def find_parent_git(path):
    if os.path.isdir(path + "/.git"):
        return path
    if (parent := path.rpartition("/")[0]) == '':
        return None
    return find_parent_git(parent)

def find_hx_pane(panes):
    for pane in panes:
        if pane['workspace'] == 'sys-nix' and pane['title'].endswith('> hx'):
            return pane['pane_id']
    return None

def command_json_output(command):
    return json.loads(subprocess.run(command, capture_output=True).stdout)

async def switch_workspace(workspace,cwd,cmd):
    import random
    with open('/tmp/WEZTERM_CMD', 'w') as file:
        file.write('@'.join([workspace,cwd,cmd,str(random.random())]))
    focus_wezterm()
    blink_focus()
    with open('/tmp/WEZTERM_CMD', 'w') as file:
        file.write('')
    
    # data = base64.encodebytes(f'{workspace}@{cwd}@{cmd}'.encode())[0:-1].decode()
    # os.spawnlp(os.P_NOWAIT,"wezterm", "wezterm", "cli", "spawn", "sh", "-c", f'echo "\033]1337;SetUserVar=WEZTERM_WORKSPACE={data}\007" ;sleep 2')
    

def wezterm_switch_workspace(pane_id: int, workspace: str):
    spawn_os("wezterm", "cli", "spawn", "--pane-id", str(pane_id), "bash", "-c", f'printf \"\033]1337;SetUserVar=%s=%s\007\" WEZTERM_WORKSPACE `echo -n {workspace}| base64`;sleep 1')

async def editor_open(pane_id, abspath):
    logger.warning("Existing hx")
    await wc.focus_pane(pane_id)
    await wc.send_esc(pane_id)
    await wc.write_to_pane(pane_id, ":")
    await wc.send_paste(pane_id, f'open {abspath}')
    await wc.send_enter(pane_id)

async def new_editor(pane_id,target_dir,abspath):
    logger.warning("New hx")
    proc = await asyncio.create_subprocess_exec('wezterm', 'cli', 'spawn', '--pane-id', str(pane_id), '--cwd', target_dir,'hx', abspath, stdout=asyncio.subprocess.PIPE)
    (stdout, stderr) = await proc.communicate()
    return int(stdout.decode().strip())

obsidian_group_name = ' '
groups.append(Group(obsidian_group_name, spawn="obsidian"))
@lazy.function
def obsidian(*args):
    g = qtile.groups_map[obsidian_group_name]
    logger.warning( type(g).__name__ )
    g.toscreen()


    
async def into_coro(x):
    return await x


async def open_file(path: str):
    path = os.path.abspath(os.path.expanduser(path))
    if focus_wezterm():
        pass
        # if (id := await )

async def open_workspace(path: str):
    # Conditions
    # workspace exists
    # window exists
    # target is file
    abspath = os.path.expanduser(path)
    is_file = os.path.isfile(abspath)
    target_dir = abspath
    if (git := find_parent_git(abspath)) is not None:
        target_dir = git
    elif is_file :
        target_dir = os.path.dirname(abspath) 

    if is_file:
        target_dir += '/'
  

    workspace_name = target_dir.split("/")[-2]
    (editor_pane, workspace_pane) = await asyncio.gather(
         into_coro(wc.find_pane(workspace_pattern=workspace_name, title_pattern="hx$")),
         into_coro(wc.find_pane(workspace_pattern=workspace_name))
    )

    has_workspace = editor_pane is not None or workspace_pane is not None

    cd_tail = f" nu --execute 'cd {target_dir}'"
    hx_open_tail = f' nu --execute "cd {target_dir} ; hx {abspath}"'

    pane_to_focus = None
    
    if focus_wezterm():
        # Has window
        if is_file:
            # Have a workspace
            if has_workspace:
                # Is file has window has editor
                if editor_pane is not None:
                    logger.warning("Have window, is file, opening in existing editor")
                    await editor_open(editor_pane, abspath)    
                    pane_to_focus = editor_pane
                else:
                    logger.warning("Have window, is file, opening in new editor")
                    pane_to_focus = await new_editor(workspace_pane, target_dir, abspath)
                    
                switch_workspace(workspace_name, target_dir, '')
                
                # Focus the newly created pane
                await wc.focus_pane(pane_to_focus)
            else:
                # Is file has window no workspace
                switch_workspace(workspace_name, target_dir, hx_open_tail)

        else:
            if has_workspace:
                # Not file have window have workspace
                switch_workspace(workspace_name, target_dir, '')
                logger.warning('# Not file have window have workspace')
                logger.warning(f' Switching to ({workspace_name}, {target_dir}, "" )')
            else:
                # Not file have window no workspace
                switch_workspace(workspace_name, target_dir, 'nu')
                logger.warning('# Not file have window no workspace')
                logger.warning(f' Switching to ({workspace_name}, {target_dir}, {"nu"} )')

    else:
        # No window
        # This branch always spawns a command
        command = f'wezterm connect unix --workspace {workspace_name}'
        # It may be appended to in some branches
        if is_file:
            if editor_pane is not None:
                await editor_open(editor_pane, abspath)
                pane_to_focus = editor_pane
                logger.warning("Editor pane aint none")
                # Open gui no command
            else:
                # Open gui with hx command
                command += ' -- ' + hx_open_tail
        
        else:
            if not has_workspace:
                command += ' -- ' + cd_tail

        logger.warning(f' Executing > {command} ')
        qtile.spawn(command)

        # Wait for the window to open then foucs the new pane if needed
        if pane_to_focus is not None:
            logger.warning("Waiting for new window")
            await window_open_event.wait()
            logger.warning("Focus after wait")
            await wc.focus_pane()
   



@lazy.function
def wezterm_in_workspace(*args):
    # if focus_wezterm():
    #     return

    qtile.widgets_map["prompt"].start_input("Working dir", 
                                            lambda name: create_task(open_workspace(name)),
                                            complete="file")
        

def get_focused_wezterm_panes():
    return [output['focused_pane_id'] for output in command_json_output(["wezterm", "cli", "list-clients", "--format", "json"])]



@lazy_async
async def async_firefox():
    id = await wc.find_pane(title_pattern="> hx$")
    await wc.send_esc(id)
    await wc.write_to_pane(id, ":")
    await wc.send_paste(id, "open ~/.bashrc")
    await wc.send_enter(id)


def smart_navigate(direction: str):
    @lazy_async
    async def inner(*args):
        # Try to navigate within wezterm
        navigated = window_is_wezterm(qtile.current_window) and await wc.navigate_direction(direction)
        if not navigated:
            getattr(qtile.current_group.layout, direction)()
    return inner
groups.append(
    ScratchPad("scratchpad", [
        # define a drop down terminal.
        # it is placed in the upper third of screen by default.
        DropDown("term", "kitty", opacity=0.0),

        # # define another terminal exclusively for ``qtile shell` at different position
        # DropDown("qtile shell", "urxvt -hold -e 'qtile shell'",
        #          x=0.05, y=0.4, width=0.9, height=0.6, opacity=0.9,
        #          on_focus_lost_hide=True)
        ]),
)
def blink_focus():
    qtile.groups_map['scratchpad'].dropdown_toggle('term')
    qtile.groups_map['scratchpad'].dropdown_toggle('term')
    

@lazy_async
async def test(*args):
    switch_workspace("hokey_pokey", '/etc/nixos/', 'htop')

keys = [
    Key([mod], "p", group_research_browser, desc="Focus or spawn research browser"),
    Key([mod, "shift"], "p", toggle_reasearch_window, desc="Toggle research window"),
    Key([mod, "shift"], "t", test, desc="Toggle research window"),
    Key([mod], "h", smart_navigate("left"), desc="Move focus to left"),
    Key([mod], "l", smart_navigate("right"), desc="Move focus to right"),
    Key([mod], "j", smart_navigate("down"), desc="Move focus down"),
    Key([mod], "k", smart_navigate("up"), desc="Move focus up"),
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
    Key([], "XF86AudioLowerVolume", lazy.spawn("swayosd-client --output-volume lower")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("swayosd-client --output-volume raise")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("swayosd-client --brightness lower")),
    Key([], "XF86MonBrightnessUp", lazy.spawn("swayosd-client --brightness raise")),

    # Main leader
    KeyChord([], "Shift_R", [
        KeyChord([], "s",[
           Key([], "b", lazy.spawn("blueberry"),                                                              desc="Bluetooth connections"),
           Key([], "d", lazy.spawn("wdisplays"),                                                              desc="Display settings"     ),
           Key([], "w", lazy.spawn("blueberry"),                                                              desc="Wifi settings"        ),
           Key([], "n", lazy.function(lambda x: create_task( open_workspace("~/sys-nix/"))),                                desc="Nix settings"          ),
           Key([], "q", lazy.function(lambda x: create_task( open_workspace("~/sys-nix/modules/desktop/qtile/config.py"))), desc="Qtile config settings" ),
         ]),
        KeyChord([mod], "d",[
           Key([], "w", lazy.spawn("firefox https://wezfurlong.org/wezterm/config/files.html"), desc="Wezterm docs"           ),
           Key([], "q", lazy.spawn("firefox https://docs.qtile.org/"                         ), desc="Qtile docs"             ),
           Key([], "r", lazy.spawn("firefox https://crates.io/"                              ), desc="Crates.io (rust crates)"),
           Key([], "p", lazy.spaen("firefox https://docs.python.org/3/"                      ), desc="Python docs"            ),
           Key([], "n", lazy.spawn("firefox https://nixos.wiki/wiki/"                        ), desc="Nixos wiki"             )          
        ]),
        KeyChord([mod], "e",[
                Key([], "n", lazy.function(lambda x: create_task( open_workspace("~/sys-nix/"))),                                desc="Nix settings"         ),
                Key([], "q", lazy.function(lambda x: create_task( open_workspace("~/sys-nix/modules/desktop/qtile/config.py"))), desc="Qtile config settings"),
                Key([], "l", lazy.function(lambda x: create_task( open_workspace("~/sys-nix/modules/desktop/qtile/config.py"))), desc="Qtile config settings"),
            ],
            name="Edit", desc="Bindings to edit various things",
        )
    ]),
]

def set_volume(volume):
    qtile.spawn("swayosd-client --output-volume -100")
    qtile.spawn(f"swayosd-client --output-volume +{int(volume)}")

@lazy.function
def volume_prompt(*args):
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



for group in map(lambda g: Group(str(g)), range(1,10)):
    groups.append(group)
    keys.extend(
        [
            Key(
                [mod], group.name,
                lazy.group[group.name].toscreen(),
                desc=f"Switch to group {group.name}",
            ),
            Key(
                [mod, "shift"], group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc=f"Switch to & move focused window to group {group.name}",
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
            

clock_group = {
    "decorations": [
        RectDecoration(colour=["#004040", "#ffffff"], radius=5, filled=True, padding_y=2, group=True)
    ],
    "padding": 10,
}

def mk_bar():
    return bar.Bar(
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
        widget.Clock(format="%Y-%m-%d %a %I:%M %p" ),

        widget.Spacer(width=bar.STRETCH),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        # widget.StatusNotifier(foreground="#b3bbde"),
        # widget.Systray(),
        BatteryWidget(
            low_foreground="#e07d8e",
            foreground="#DE956E"
        ),
        widget.Bluetooth(foreground="#b3bbde"),
        widget.QuickExit(foreground="#b3bbde")
        # widget.SwayNC()
    ],
    24,
    background="#13131A",
)    
screens = [
    Screen(
        bottom=mk_bar(),
        wallpaper="~/Pictures/wallpapers/pink-abstract.jpg"
    ),
    Screen(
        bottom=mk_bar()
    ),
    Screen(
        bottom=mk_bar()
    )
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

