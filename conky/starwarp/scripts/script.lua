--[[
    Add to your conkyrc:
    lua_load = '~/.config/conky/scripts/script.lua',
    lua_draw_hook_post = 'main',
    lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Constants
PATH = '~/.cache/conky'

-- Global Vars
first_run = 1
table_update_interval = 900
print_feed_interval = 900
ncpus = 0
cpu_hwmon = ''
feed_str = ''
feed_files = {}


-- Function Definitions
-- Trims given string and returns
function trim(s)
   return s:gsub("^%s+", ""):gsub("%s+$", "")
end

function isempty(s)
  return s == nil or s == ''
end


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
    
    read_feed_dir()
    
    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end

function read_feed_dir()
    local updates = tonumber (conky_parse ('${updates}'))
	if updates % table_update_interval == 0 or next(feed_files) == nil then
	    feed_files = {}
        local file_names = io.popen('ls -p ' .. PATH .. '/*.feed | grep -v /  | egrep "*.feed"')
        for f in file_names:lines() do
            table.insert(feed_files, trim(f:read("*a")))
        end
        file_names:close()
	end
end

function conky_print_feeds()
    local updates = tonumber (conky_parse ('${updates}'))
    if next(feed_files) ~= nil and updates % print_feed_interval == 0 then
        for _,v in pairs(feed_files) do
            --local result = io.popen('./parse_feeds '  .. PATH .. '/' .. v)
            local f = io.open(PATH .. '/' .. v)
            local output = {}
            for each in f:lines() do
                if ~ isempty(each) then
                    output[#output+1] = each
                end
            end
        end        
    end
    -- under development ...
end


