import sys, os, json
if sys.version_info[0] == 2:
    reload(sys)
    sys.setdefaultencoding('utf-8')
os.chdir('/www/server/panel')
sys.path.append("class/")
import public, db

sql = db.Sql()
sites = public.M('sites').field('name,id').select()
print(sites)
for site in sites:
    backups = sql.table('backup').where('id=?', (site['id'])).field(
            'id,name,filename').select()
    for backup in backups:
        print(site['name'],'\t',backup['name'])
   
    
    

