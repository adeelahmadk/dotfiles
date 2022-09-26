--[[
Series Name:    Star Warp
Code Name:      A new hope
Author:         Codegenki
Description:    Supporting script for OS mudule
Usage:          Add to your conkyrc config block:
                lua_load = '~/.conky/scripts/script.lua',
                lua_draw_hook_post = 'main',
                lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Vars
first_run = 1
nic_update_interval = 5
net_update_interval = 2
ncpus = 0
active_nics = ''
active_ifaces = {}
netconf = ''

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
        local output = io.popen('ip link | grep -Po --regexp "(?<=[0-9]: ).*"')

        local nic_str = ''
        active_ifaces = {}
        for l in output:lines() do
            local line = io.popen('echo "' .. l .. '" | cut -d">" -f1'):read("*a")
            --print('\nLine: ' .. line .. '\n')
            if string.find(line, "<BROADCAST") or string.find(line, "<POINTOPOINT") then
                local iface = string.gsub(string.match(line, "^.*:"), ":", "")
                table.insert(active_ifaces, iface)
                nic_str = nic_str .. iface .. '  '
                --print('Interface: ' .. iface)
            end
        end
        output:close()
        
        if active_ifaces == nil then
            active_nics = ''
        else
            active_nics = nic_str
        end
    end
    --print('Interface: ' .. active_nics)
    return active_nics
end

-- Print traffic stats for active network interfaces
function conky_draw_nics()
    if netconf == '' or tonumber(conky_parse("$updates")) % net_update_interval == 0 then
        if table.maxn(active_ifaces) >= 1 then
            local iface_stats = ''
            for _,v in pairs(active_ifaces) do
                if string.find(v, "wlp") or string.find(v, "enp") then
                    if iface_stats ~= '' then
                        iface_stats = iface_stats .. '\n'
                    end
                    iface_stats = iface_stats
                                  .. '${goto 5}${color6}'.. v .. '${goto 70}${color5}'
                                  .. '${font Neuropol X:size=6}Up: ${color #FFFFFF}'
                                  .. '${upspeed ' .. v .. '}${color5}'
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
                end
            end
            netconf = iface_stats
        else
            netconf = netconf
                      .. '${goto 5}${color6}Net${color}${goto 70}${color9}'
                      .. '${font Neuropol X:size=7}disconnected${font}'
        end
    end
    return netconf
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

