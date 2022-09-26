--[[
Series Name:    Star Warp
Code Name:      A new hope
Author:         Codegenki
Description:    Supporting script for meters mudule
Usage:          Add to your conkyrc config block:
                lua_load = '~/.config/conky/scripts/script.lua',
                lua_draw_hook_post = 'main',
                lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Vars
first_run = 1
update_interval = 1
--ncpus = 0
status = ''

-- SETTINGS FOR CPU INDICATOR BAR
bar_bottom_left_x = 50
bar_bottom_left_y = 200
bar_width= 30
bar_height= 100

-- Set bar background colors, 1, 0, 0, 1 = fully opaque red.
bar_bg_red = 1
bar_bg_green = 0
bar_bg_blue = 0
bar_bg_alpha = 1

-- Set indicator colors, 1, 1, 1, 1 = fully opaque white.
bar_in_red = 1
bar_in_green = 1
bar_in_blue = 1
bar_in_alpha = 1

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
    if tonumber(conky_parse('${updates}')) > 5 then
        conky_draw_cpu_bar()
    end
    
    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end

function conky_draw_cpu_bar ()
    cairo_save(cr)

    -- Draw background.
    cairo_set_source_rgba (cr, bar_bg_red, bar_bg_green, bar_bg_blue, bar_bg_alpha)
    cairo_rectangle (cr, bar_bottom_left_x, bar_bottom_left_y, bar_width,-bar_height)
    cairo_fill (cr)
        
    -- Draw indicator. 
    cairo_set_source_rgba (cr, bar_in_red, bar_in_green, bar_in_blue,
	        bar_in_alpha) -- Set indicator color. 
    value = tonumber (conky_parse ("${cpu}"))
    max_value = 100
    scale = bar_height / max_value
    indicator_height = scale * value

    cairo_rectangle (cr, bar_bottom_left_x, bar_bottom_left_y, bar_width,
	        -indicator_height)

    cairo_fill (cr)
        
    --print('status: complete.')
    return status
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

