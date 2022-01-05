import sys, os, json
if sys.version_info[0] == 2:
    reload(sys)
    sys.setdefaultencoding('utf-8')
os.chdir('/www/server/panel')
sys.path.append("class/")
import public


sites = public.M('sites').field('name').select()
for site in sites:
    print(site["name"])