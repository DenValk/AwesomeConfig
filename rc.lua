--[[

    Steamburn Awesome WM config 3.0
    github.com/copycat-killer

--]]

--{{Required custom modules
--require("volume")
--}}}


-- {{{ Required libraries
local posix     = require("posix")
local gears     = require("gears")
local awful     = require("awful")
awful.rules     = require("awful.rules")
                  require("awful.autofocus")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local lain      = require("lain")
-- }}}


-- {{{ Error handling
if awesome.startup_errors then
      naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Oops, there were errors during startup!",
                       text = awesome.startup_errors })
end

do
      local in_error = false
      awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                          title = "Oops, an error happened!",
                          text = err })
        in_error = false
     end)
end
-- }}}


-- {{{ Autostart applications
function run_once(dly,prg,arg_string,pname,screen)
  if not prg then
    do return nil end
  end

  if not pname then
    pname = prg
  end
  if not arg_string then 
    if dly>0 then
      posix.sleep(dly)
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
--    awful.util.spawn_with_shell("pgrep -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
  else
    if dly>0 then
      posix.sleep(dly)
    end
    awful.util.spawn_with_shell("pgrep -f -u $USER -x \"" .. pname .. " ".. arg_string .."\" || (" .. prg .. " " .. arg_string .. ")",screen)
--    awful.util.spawn_with_shell("pgrep -u $USER -x '" .. pname .. " ".. arg_string .."' || (" .. prg .. " " .. arg_string .. ")",screen)
  end
end

---}}}


--{{ PreDesktop Application Initializations
run_once(0,"nvidia-settings","-l")
run_once(0,"urxvtd")
run_once(0,"unclutter")
  --compmgr for window effects (tansparent conky)
run_once(0,"xcompmgr -cF &")
	--Moved to a later spot for Tags initialization
	--run_once(0,"conky", "-c /home/$USER/.config/conky/conkyrc", "conky")
-- }}

--{{{ ADDITIONAL FUNCTIONS

--Table Functions
function joinTables(t1, t2)
        t3={}
        for k,v in ipairs(t1) do table.insert(t3, v) end 
        for k,v in ipairs(t2) do table.insert(t3, v) end 
        return t3
end

--Conky Related Functions
function get_conky()
    local clients = client.get()
    local conky = {}
    local i = 1
    for k,v in ipairs(clients) 
      do
         if v.class == "Conky" then
            table.insert(conky, v)
         end
      end
--[[    while clients[i]
    do
        if clients[i].class == "Conky"
        then
            table.insert(conky, clients[i])
        end
        i = i + 1
    end--]]
    return conky
end
function raise_conky()
    local conky = get_conky()
    local i=1
    while conky[i]
    do
      conky[i].ontop = true
      i = i + 1
    end
end
function lower_conky()
    local conky = get_conky()
    local i=1
    while conky[i]
    do
      conky[i].ontop = false
      i = i + 1
    end
end
function toggle_conky()
    local conky = get_conky()
    local i=1
    while conky[i]
    do
      if conky[i].ontop
      then
          conky[i].ontop = false
      else
          conky[i].ontop = true
      end
      i = i + 1
    end 
end



--}}}






-- {{{ Variable definitions
-- localization
os.setlocale(os.getenv("LANG"))

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/stock/theme.lua")

--common
modkey     = "Mod4"
mod3key    = "Mod3"
altkey     = "Mod1"
terminal   = "sakura"
-- terminal   = "terminator"
--[editor     = os.getenv("EDITOR") or "nano" or "vi"
editor     = "vim"

-- user defined
browser    = "epiphany"
browser2   = "nautilus"
--gui_editor = "gvim"
graphics   = "gimp"

-- lain
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol    = 1

local layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.float,
    awful.layout.suit.spiral
}
-- }}}

-- {{{ Tags
basetags = {
   names   = {"Gen", "Term"},
   layout = { layouts[1], layouts[3]}
   }
specialtags = {
   names = {{"Graphic", "media"}, {"Doc"}, {"Resource", "Services", "Skype"}, {"Doc"}},
   layout = {{layouts[3], layouts[1]}, {layouts[1]}, {layouts[3], layouts[4], layouts[3]}}
   }

--[[tags = {
   names1 = { "web", "term", "docs", "media", "Stuff", "Services", "Skype"},
   layout1 = { layouts[1], layouts[3], layouts[1], layouts[1], layouts[5], layouts[3], layouts[4]},
   names = { "web", "term", "docs", "media", "Stuff"},
   layout = { layouts[1], layouts[3], layouts[1], layouts[1], layouts[5]}
}--]]
tags = {}
for s = 1, screen.count() do
   tags[s] = awful.tag(joinTables(basetags.names, specialtags.names[s]), s, joinTables(basetags.layout, specialtags.layout[s]))
--[[   if s==1 then
     tags[s] = awful.tag(tags.names1, s, tags.layout1)
   else
     tags[s] = awful.tag(tags.names, s, tags.layout)
   end--]]
end
-- }}}

-- {{{ Wallpaper
if (beautiful.wallpaper1 and beautiful.wallpaper2 and beautiful.wallpaper3) then
  for s = 1, screen.count() do
--      gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      if s==1 then
         gears.wallpaper.maximized(beautiful.wallpaper1, s,true)
      elseif s==2 then
         gears.wallpaper.maximized(beautiful.wallpaper2, s, true)
      else
         gears.wallpaper.maximized(beautiful.wallpaper3, s, true)
      end
  end
elseif beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end


--if beautiful.wallpaper then
--    for s = 1, screen.count() do
--        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
--end
-- }}}

-- {{{ Menu
mysystemmenu = {
     { "Nautilus", "nautilus"},
     { "Awesome Manual", terminal .. " -e 'man awesome'" },
     { "Awesine Config", terminal .. " -e '" .. editor .. " " .. awesome.conffile .."'" },
     { "restart AWM", awesome.restart },
     { "quit", awesome.quit }
}

myappmenu = {
     { "Internet", "epiphany"},
     { "KeePass", "keepassx"},
     { "WinPrint", 'virtualbox --startvm Win8.1\\ Print\\ Clone'},
     { "...", "exit"}

}

myPubmenu = {
     { "TexMaker", "texmaker"},
     {"InkScape", "inkscape"},
     {"Mathematica", "mathematica"},
     { "...", "exit"}
}
     
mymainmenu = awful.menu(
     { 
          items = { 
               { "Sys", mysystemmenu, beautiful.awesome_icon },
               { "Tool", myappmenu},
               { "Publication", myPubmenu},
               { "open terminal", terminal }
          }
     })


-- }}}

-- {{{ Wibox
markup = lain.util.markup
gray   = "#94928F"

-- Textclock
mytextclock = awful.widget.textclock(" %H:%M ", 30)

-- Command Launcher
myCommandLauncher = awful.widget.prompt()

-- Calendar
lain.widgets.calendar:attach(mytextclock)

-- Mail IMAP check
--mailwidget = lain.widgets.imap({
--    timeout  = 180,
--    server   = "server",
--    mail     = "mail",
--    password = "keyring get mail",
--    settings = function()
--        mail  = ""
--        count = ""
--
--        if mailcount > 0 then
--            mail = "Mail "
--            count = mailcount .. " "
--        end
--
--        widget:set_markup(markup(gray, mail) .. count)
--    end
--})

-- MPD
--[[Commented out. I don't like this.
mpdwidget = lain.widgets.mpd({
    settings = function()
        artist = mpd_now.artist .. " "
       title  = mpd_now.title  .. " "

        if mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        elseif mpd_now.state == "stop" then
            artist = ""
            title  = ""
        end

        widget:set_markup(markup(gray, artist) .. title)
    end
})
--]]

-- CPU
cpuwidget = lain.widgets.sysload({
    settings = function()
        widget:set_markup(markup(gray, " Cpu ") .. load_1 .. " ")
    end
})

-- MEM
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup(gray, " Mem ") .. mem_now.used .. " ")
    end
})

-- /home fs
fshomeupd = lain.widgets.fs({
    partition = "/home"
})

-- Battery
batwidget = lain.widgets.bat({
    settings = function()
        bat_perc = bat_now.perc
        if bat_perc == "N/A" then bat_perc = "Plug" end
        widget:set_markup(markup(gray, " Bat ") .. bat_perc .. " ")
    end
})

-- Net checker
netwidget = lain.widgets.net({
    settings = function()
        if net_now.state == "up" then net_state = "On"
        else net_state = "Off" end
        widget:set_markup(markup(gray, " Net ") .. net_state .. " ")
    end
})

-- ALSA volume
volumewidget = lain.widgets.alsa({
    settings = function()
        header = " Vol "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M "
        else
            vlevel = vlevel .. " "
        end

        widget:set_markup(markup(gray, header) .. vlevel)
    end
})

-- Weather
yawn = lain.widgets.yawn(2478734)

-- Separators
first = wibox.widget.textbox(markup.font("Tamsyn 4", " "))
spr = wibox.widget.textbox(' ')

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
--mylayoutbox = {}
txtlayoutbox = {}
mytaglist = {}
mytasklist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end))
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

-- Writes a string representation of the current layout in a textbox widget
function updatelayoutbox(layout, s)
    local screen = s or 1
    local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(screen))] or ""
--    local txt_l = awful.layout.getname(awful.layout.get(screen)) or "none"
    layout:set_text(txt_l)
end

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create a textbox widget which will contains a short string representing the
    -- layout we're using.  We need one layoutbox per screen.
    txtlayoutbox[s] = wibox.widget.textbox(beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    awful.tag.attached_connect_signal(s, "property::selected", function ()
        updatelayoutbox(txtlayoutbox[s], s)
    end)
    awful.tag.attached_connect_signal(s, "property::layout", function ()
        updatelayoutbox(txtlayoutbox[s], s)
    end)
    txtlayoutbox[s]:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 2, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 4, function() awful.layout.inc(layouts, -1) end),
            awful.button({}, 5, function() awful.layout.inc(layouts, 1) end),
            awful.button({}, 6, function() awful.layout.inc(layouts, -1) end)))
--This is my layout box. The awesome default.
--    mylayoutbox[s] = awful.widget.layoutbox(s)
--    mylayoutbox[s]:buttons(awful.util.table.join(
--       awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
--       awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
--       awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
--       awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))


    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(first)
    left_layout:add(mytaglist[s])
    left_layout:add(spr)
--    left_layout:add(txtlayoutbox[s])
    left_layout:add(spr)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
--    if s == 2 then right_layout:add(myCommandLauncher) end
    right_layout:add(spr)
--    right_layout:add(mpdwidget)
    --right_layout:add(mailwidget)
    right_layout:add(cpuwidget)
    right_layout:add(memwidget)
--    right_layout:add(batwidget)
    right_layout:add(netwidget)
    right_layout:add(volumewidget)
    right_layout:add(mytextclock)
    right_layout:add(spr)
    right_layout:add(txtlayoutbox[s])
    right_layout:add(spr)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    -- Take a screenshot
    -- https://github.com/copycat-killer/dots/blob/master/bin/screenshot
--    awful.key({ altkey }, "p", awful.util.spawn_with_shell("sleep 0.5 && shutter -a")),

    -- Security
    awful.key({ modkey }, "F12", function () awful.util.spawn("slock") end),

    -- Tag browsing
    awful.key({ modkey }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    -- COMMENTED OUT DUE TO INKSCAPE CONFLICT!!!!!!!!!!!
--    awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
--    awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

    -- Default client focus
    awful.key({ altkey }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "j",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "i",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end),

    -- Show Menu
    awful.key({ modkey }, "w",
        function ()
            mymainmenu:show({ keygrabber = true })
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
    end),

    -- Layout manipulation
    awful.key({ mod3key,    }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ mod3key,    }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ altkey,    }, "h", function () awful.screen.focus_relative( 1) end),
    awful.key({ altkey,    }, "l", function () awful.screen.focus_relative(-1) end),
    awful.key({ mod3key,    }, "u", awful.client.urgent.jumpto),
--    awful.key({ modkey,           }, "Tab",
--        function ()
--            awful.client.focus.history.previous()
--            if client.focus then
--                client.focus:raise()
--            end
--        end),
    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    -- Dropdown terminal
-- Not Used
--    awful.key({ modkey,	          }, "z",      function () awful.util.spawn_with_shell("terminator") end),

    -- Widgets popups
    awful.key({ mod3key,          }, "c",      function () lain.widgets.calendar:show(7) end),
    awful.key({ mod3key,          }, "d",      function () fshomeupd.show(7) end),
    awful.key({ mod3key,           }, "s",      function () yawn.show(7) end),

    -- ALSA volume control
    awful.key({ altkey, "Control" }, "Up",
        function ()
            awful.util.spawn("amixer -q set Master 1%+")
            volumewidget.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function ()
            awful.util.spawn("amixer -q set Master 1%-")
            volumewidget.update()
        end),
    awful.key({ altkey }, "m",
        function ()
            awful.util.spawn("amixer -q set Master playback toggle")
            volumewidget.update()
        end),
--    awful.key({ altkey, "Control" }, "m",
--        function ()
--            awful.util.spawn("amixer -q set Master playback 100%")
--            volumewidget.update()
--        end),

    --Conky Focus Key Binding
    awful.key({mod3key}, "space", function() raise_conky() end, function() lower_conky() end),


    -- Pithos dbus Controls
    awful.key({mod3key}, "Right", 
       function()
         awful.util.spawn("dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.SkipSong")
       end),
    awful.key({mod3key}, "Left", 
       function()
         awful.util.spawn("dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.PlayPause")
       end),
    awful.key({mod3key}, "slash", 
       function()
         awful.util.spawn("dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.GetCurrentSong")
       end),
    awful.key({mod3key}, "Up", 
       function()
         awful.util.spawn("dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.LoveCurrentSong")
       end),
    awful.key({mod3key}, "Down", 
       function()
         awful.util.spawn("dbus-send --print-reply --dest=net.kevinmehall.Pithos /net/kevinmehall/Pithos net.kevinmehall.Pithos.TiredCurrentSong")
       end),
        



    -- Copy to clipboard
--    awful.key({ modkey }, "c", function () os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ mod3key }, "w", function () awful.util.spawn(browser) end),
    awful.key({ mod3key }, "f", function () awful.util.spawn(browser2) end),
--    awful.key({ modkey }, "s", function () awful.util.spawn(gui_editor) end),
--    awful.key({ modkey }, "g", function () awful.util.spawn(graphics) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
-- modkey f is file browser
--    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "F1",      function(c) awful.client.movetoscreen(c,1)   end),
    awful.key({ modkey,           }, "F2",      function(c) awful.client.movetoscreen(c,2)   end),
    awful.key({ modkey,           }, "F3",      function(c) awful.client.movetoscreen(c,3)   end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons,
	             size_hints_honor = false } },
    { rule = { class = "conky" },
      properties = {
         floating = true,
         sticky = true,
         ontop = false,
         focusable = false,
         size_hints = {"program_position", "program_size"},
         size_hints_honor = true
      } },
    { rule = { class = "URxvt" },
          properties = { opacity = 0.99 } },


--    { rule = { class = "VirtualBox" },
  --        except = { name = "Oracle VM VirtualBox Manager" },
    --      properties = { tag = tags[1][1] } },
 
    { rule = { class = "Dwb" },
          properties = { tag = tags[1][1] } },

    { rule = { class = "Iron" },
          properties = { tag = tags[1][1] } },

    { rule = { instance = "plugin-container" },
          properties = { tag = tags[1][1] } },

    { rule = { class = "Skype" },
          callback = 
            function(c) 
              awful.client.movetoscreen(c, 3)
              awful.client.movetotag(tags[3][5], c) 
            end },

    { rule = { class = "Pithos" },
          callback = 
            function(c) 
              awful.client.movetoscreen(c, 2)
              awful.client.movetotag(tags[2][4], c) 
            end },

-- RULE FOR GOOGLE HANGOUTS!!!!!!!!!!!! --
{ rule = { instance = "crx_knipolnnllmklapflnccelgolnpehhpl" },
  properties = { 
     floating = true,
     type = desktop,
     sticky = true,
     ontop = false,
     focusable = true,
     opacity = 0.9 },
--      width = screen[s].workarea.y/3 },
  callback = function(c)
   --nothing here for now    
  end },

   { rule = { class = "Gimp" },
     	  properties = { tag = tags[2][3] } },

   { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },

   { rule = { class = "Inkscape"},
          properties = { maximized_horizontal = true,
                         maximized_vertical = true},
          callback = 
             function(c)
                  awful.client.movetoscreen(c,2)
                  awful.client.movetotag(tags[2][3])
             end  }
}
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup and not c.size_hints.user_position
       and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=16}):set_widget(layout)
    end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    clients[1].border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
--}}}


--{{{ Programs to run after Desktop Initialization
os.execute("kill -9 `pidof conky`")

run_once(0,"owncloud")
  --screen color adjustment
--run_once(0,"redshift")
run_once(0,"conky", "-c /home/$USER/.config/conky/conkrc-sys", "conky")
run_once(0,"conky", "-c /home/$USER/.config/conky/conkrc-short", "conky")
run_once(0,"skype")
-- }}}
