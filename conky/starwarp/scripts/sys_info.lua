--[[
Series Name:    Star Warp
Code Name:      A new hope
Author:         Codegenki
Description:    Supporting script for SYS mudule
Usage:          Add to your conkyrc config block:
                lua_load = '~/.config/conky/scripts/script.lua',
                lua_draw_hook_post = 'main',
                lua_draw_hook_pre = 'some_function'
]]

require 'cairo'

-- Global Vars
first_run = 1
cpu_update_interval = 1800
cputemp_update_interval = 6
ncpus = 0
cpu_hwmon = ''
ctemp = 0


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
  local updates = tonumber (conky_parse ('${updates}'))
  if first_run == 1 then
      local file = io.popen("lscpu -a -p='cpu' | grep '[0-9]' | wc -l")
      ncpu = trim(file:read("*a"))
      --print('No. of CPUs: ' .. ncpu)
      file:close()
      first_run = nil
  end

  local hwmon = ''
  timer = (updates % cpu_update_interval)
  if timer == 0 or cpu_hwmon == '' then
    local all_hwmon_temp_names = io.popen('ls /sys/class/hwmon/*/temp* | grep -Po --regexp ".*(label)$"')
    for l in all_hwmon_temp_names:lines() do
      local name = io.popen('cat ' .. l):read("*a")
      if name:match("^Package*") then
        start, finish, hwmon = string.find(l,"[%a%p]+/([%a]+%d)%p[%a%d]+")
        cpu_hwmon = hwmon
        --print(l .. 'found under: ' .. hwmon)
        break
      end
    end
    all_hwmon_temp_names:close()
  end

  cairo_destroy (cr)
  cairo_surface_destroy (cs)
  cr = nil
end

-- Print a temperature of the CPU Package
function conky_cpu_temp()
  if tonumber (conky_parse ('${updates}')) % cputemp_update_interval == 0 or ctemp == 0 then
    cpu_temp_file = '/sys/class/hwmon/' .. cpu_hwmon .. '/temp1_input'
    local cpu_temp_fh = io.open(cpu_temp_file, "r")
    ctemp = tonumber(cpu_temp_fh:read("*a"))  / 1000
    --print('CPU temp: ' .. ctemp)
    cpu_temp_fh:close()
  end

  if ctemp > 75 then
    cputemp_update_interval = 2
    return "${color red}${blink " .. ctemp .. "}${color}"
  elseif ctemp > 50 then
    cputemp_update_interval = 4
  else
    cputemp_update_interval = 6
  end
  return ctemp
end

