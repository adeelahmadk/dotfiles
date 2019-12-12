#!/usr/bin/env python3

import subprocess

output = subprocess.getoutput("/usr/lib/update-notifier/apt-check")

# Results are like "10;1" so we split them
updates, security = [ int(s) for s in output.split(';')]

colors = {
    'red': '${color red}',
    'green': '${color green}',
    'grey': '${color grey}',
    'default': '${color}'
}

# Change colours for warnings
if updates > 50:
    ucolor = colors['red']
elif updates > 0:
    ucolor = colors['green']
else:
    ucolor = colors['grey']

if security > 0:
    scolor = colors['red']
else:
    scolor = colors['grey']

endcolor = colors['default']

print('  {0}{1}{2} updates, {3}{4}{5} sec. updates'.format(ucolor, updates, endcolor, scolor, security, endcolor))
