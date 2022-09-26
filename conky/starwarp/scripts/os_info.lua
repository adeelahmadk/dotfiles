--[[
Series Name:    Star Warp
Code Name:      A new hope
Author:         Codegenki
Description:    Supporting script for OS mudule
Usage:          Add to your conkyrc config block:
                lua_load = '~/.config/conky/scripts/script.lua',
                lua_draw_hook_post = 'main',
                lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Vars
first_run = 1
nic_update_interval = 5
net_update_interval = 1
access_update_interval = 15
ncpus = 0
active_nics = ''
active_ifaces = {}
netconf = ''
access_status = ''

-- Function Definitions

-- Trims given string and returns
function trim(s)
   return s:gsub("^%s+", ""):gsub("%s+$", "")
end

-- Main function
function conky_main ()
  if conky_window == nil then
    return
  end
  local cs = cairo_xlib_surface_create (conky_window.display,
                                       conky_window.drawable,
                                       conky_window.visual,
                                       conky_window.width,
                                       conky_window.height)
  cr = cairo_create (cs)
  if first_run == 1 then
    local file = io.popen("lscpu -a -p='cpu' | grep '[0-9]' | wc -l")
    ncpu = trim(file:read("*a"))
    file:close()
    first_run = nil
  end

  cairo_destroy (cr)
  cairo_surface_destroy (cs)
  cr = nil
end

-- Print a list of active network interfaces
function conky_active_nics()
  if active_nics == '' or tonumber(conky_parse("$updates")) % nic_update_interval == 0 then
    -- Use regex on the result of `ip link` command to find the interfaces that are up
    -- and connected. First, remove iface number from output using positive lookbehind (?<=).
    --  sh> ip link | grep -Po --regexp "(?<=[0-9]: ).*"
    -- Then only match those lines with `state UP`.
    -- use assert() to avoid empty output file.
    local output = assert(io.popen('ip link | grep -Po --regexp "(?<=[0-9]: ).*"'))
    local result = output:read("*a")
    local nic_str = ''
    output:close()
    active_ifaces = {}
    for line in iter_lines(result) do
      if line ~= "" then
        if string.find(line, " UP ") then
          local iface = string.match(line, "(.*):")
          -- print('iface:' .. iface .. '\n')
          table.insert(active_ifaces, iface)
          nic_str = nic_str .. iface .. '  '
        end
      end
    end

    if active_ifaces == nil then
      active_nics = ''
    else
      active_nics = nic_str
    end
  end
  -- print('Interfaces: ' .. active_nics)
  return active_nics
end

-- Print traffic stats for active network interfaces
function conky_draw_access()
  if access_status == '' or tonumber(conky_parse("$updates")) % access_update_interval == 0 then
    -- curl -o /dev/null --max-time 10 --silent --head --write-out "%{http_code}" https://www.google.com
    local output = io.popen('curl -o /dev/null --max-time 10 --silent --head --write-out "%{http_code}" https://www.google.com')
    local code = tonumber(output:read("*a"))
    local status = ''
    output:close()
    if code == 200 then
        status = '${color3}accessible'
    elseif code == 0 then
        status = '${color9}unreachable'
    else
        status = '${color9}firewalled'
    end
    access_status = status
  end

  --print('status: ' .. access_status)
  return access_status
end

-- Print traffic stats for active network interfaces
function conky_draw_nics()
    if netconf == '' or tonumber(conky_parse("$updates")) % net_update_interval == 0 then
      local iface_stats = ''
      local wlan_stats = '' 
      if table.maxn(active_ifaces) >= 1 then 
        for _,v in pairs(active_ifaces) do
          if string.find(v, "^wlp") or string.find(v, "^enp") then
            -- print('iface: ' .. v)
            if iface_stats ~= '' then
              iface_stats = iface_stats .. '\n${voffset 5}'
            end
            if string.find(v, "wlp") then
              wlan_stats = wlan_stats
                           .. '${goto 70}${color #FFFFFF}'
                           .. 'ESSID${goto 125}${wireless_essid ' .. v .. '}'
                           .. '\n${goto 70}'
                           .. 'Signal${goto 125}${wireless_link_qual_perc ' .. v .. '}%'
                           .. '${goto 170}'
                           .. '${if_match ${wireless_link_qual_perc ' .. v .. '}<=50}'
                           ..     '${color2}${wireless_link_bar 5,80 ' .. v .. '}'
                           .. '${else}'
                           .. '${if_match ${wireless_link_qual_perc ' .. v .. '}<=70}'
                           ..     '${color4}${wireless_link_bar 5,80 ' .. v .. '}'
                           .. '${else}'
                           .. '${if_match ${wireless_link_qual_perc ' .. v .. '}<=85}'
                           ..     '${color6}${wireless_link_bar 5,80 ' .. v .. '}'
                           .. '${else}'
                           ..     '${color3}${wireless_link_bar 5,80 ' .. v .. '}'
                           .. '${endif}${endif}${endif}'
                           .. '\n'
            end
            iface_stats = iface_stats
                          .. '${goto 5}${font}${color6}'.. v .. '${font Neuropol X:size=6}'
                          .. wlan_stats
                          .. '${voffset 5}${goto 70}'
                          .. '${color5}Up: ${color #FFFFFF}${upspeed ' .. v .. '}${color5}'
                          .. '${goto 170}Down: ${color #FFFFFF}'
                          .. '${downspeed ' .. v .. '}'
                          .. '\n'
                          .. '${voffset -2}'
                          .. '${goto 70}${upspeedgraph '.. v .. ' 20,80 FFFFFF 3EB489}'
                          .. '${goto 170}${downspeedgraph ' .. v .. ' 20,80 FFFFFF 3EB489}'
                          .. '\n'
                          .. '${voffset -2}'
                          .. '${goto 70}${color5}Sent ${color #FFFFFF}'
                          .. '${totalup ' .. v .. '}${color5}'
                          .. '${goto 170}Rec. ${color #FFFFFF}'
                          .. '${totaldown ' .. v .. '}'
            wlan_stats = ''
          end  -- end if interface in wlp* or enp*
        end  -- end of for loop
        netconf = iface_stats
      else
          iface_stats = iface_stats
                        .. '${goto 5}${color6}Net${color}${goto 70}${color9}'
                        .. '${font Neuropol X:size=7}disconnected${font}\n'
          netconf = iface_stats
      end  -- end if active interfaces present
    end  -- end if update interval
    return netconf
end

-- Utility function for strings

-- iterate a multiline string.
function iter_lines(s)
    if s:sub(-1)~="\n" then s=s.."\n" end
    return s:gmatch("(.-)\n")
end

-- Utility functions for table data structure

function flush_table(table)
    for _,v in pairs(table) do
        table.remove(table, v)
    end
end

function has_key(table, key)
    return table[key]~=nil
end

function has_value(table, value)
    for k, v in pairs(table) do
        if table[k] == value then
            return true
        end
    end
    return false
end

