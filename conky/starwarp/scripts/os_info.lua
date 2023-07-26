--[[
Series Name:    Star Warp
Code Name:      A new hope
Author:         Codegenki
Description:    Supporting script for OS mudule
Usage:          Add to your conkyrc config block:
                lua_load = '~/.config/conky/starwarp/scripts/os_info.lua',
                lua_draw_hook_post = 'main',
                lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Vars
First_Run = 1
NIC_update_interval = 5
NET_update_interval = 2
-- NCPUs = 0
Active_NICs = ''
Active_Interfaces = {}
NETConf = ''

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
    local cs = cairo_xlib_surface_create (
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )
    cr = cairo_create (cs)
    if First_Run == 1 then
        local file = io.popen("lscpu -a -p='cpu' | grep '[0-9]' | wc -l")
        ncpu = trim(file:read("*a"))
        file:close()
        First_Run = nil
    end

    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end

-- Print a list of active network interfaces
function conky_active_nics()
    if Active_NICs == '' or tonumber(conky_parse("${updates}")) % NIC_update_interval == 0 then
        local output, err, code = io.popen('ip link | grep -Po --regexp "(?<=[0-9]: ).*"')
        if not output then
            print("Error opening file", "ip link", err)
            -- Do something to handle the error
        end

        local nic_str = ''
        Active_Interfaces = {}
        for l in output:lines() do
            local line = io.popen('echo "' .. l .. '" | cut -d">" -f1'):read("*a")
            -- print('\nLine: ' .. line .. '\n')
            if string.find(line, "<BROADCAST") or string.find(line, "<POINTOPOINT") then
                local iface = string.gsub(string.match(line, "^.*:"), ":", "")
                table.insert(Active_Interfaces, iface)
                nic_str = nic_str .. iface .. '  '
                -- print('Interface: ' .. iface)
            end
        end
        if output ~= nil then
            output:close()
        end

        if Active_Interfaces == nil then
            Active_NICs = ''
        else
            Active_NICs = nic_str
        end
    end
    --print('Interface: ' .. Active_NICs)
    return Active_NICs
end

-- Print traffic stats for active network interfaces
function conky_draw_nics()
    if NETConf == '' or tonumber(conky_parse("${updates}")) % NET_update_interval == 0 then
        if table.maxn(Active_Interfaces) >= 1 then
            local iface_stats = ''
            for _,v in pairs(Active_Interfaces) do
                if string.find(v, "wlp") or string.find(v, "enp") then
                    if iface_stats ~= '' then
                        iface_stats = iface_stats .. '\n'
                    end
                    iface_stats = iface_stats
                                  .. '${goto 10}${color6}'.. v .. '${goto 70}${color5}'
                                  .. '${voffset -1}'
                                  .. '${font Neuropol X:size=7}Up: ${color #FFFFFF}'
                                  .. '${upspeed ' .. v .. '}${color5}'
                                  .. '${goto 170}Down: ${color #FFFFFF}'
                                  .. '${downspeed ' .. v .. '}'
                                  .. '\n'
                                  .. '${voffset -1}'
                                  .. '${goto 70}${upspeedgraph '.. v .. ' 20,85 FFFFFF 3EB489}'
                                  .. '${goto 170}${downspeedgraph ' .. v .. ' 20,85 FFFFFF 3EB489}'
                                  .. '\n'
                                  .. '${voffset -2}'
                                  .. '${goto 70}${color5}Sent ${color #FFFFFF}'
                                  .. '${totalup ' .. v .. '}${color5}'
                                  .. '${goto 170}Rec. ${color #FFFFFF}'
                                  .. '${totaldown ' .. v .. '}'
                end
            end
            NETConf = iface_stats
        else
            NETConf = NETConf
                      .. '${goto 5}${color6}Net${color}${goto 70}${color9}'
                      .. '${font Neuropol X:size=7}disconnected${font}'
        end
    end
    return NETConf
end

-- Utility functions for table data structure

function flush_table(table)
    for _, v in pairs(table) do
        table.remove(table, v)
    end
end

function has_key(table, key)
    return table[key]~=nil
end

function has_value(table, value)
    for k, _ in pairs(table) do
        if table[k] == value then
            return true
        end
    end
    return false
end

