
import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,db,time
import panelSite



if __name__ == "__main__":
    
    sql = db.Sql()
    
    
    site = panelSite.panelSite()
    get = public.dict_obj()
    site_name = sys.argv[1]
    get.id = sql.table('sites').where('name=?', (site_name,)).getField('id')
    
    id = get.id
    
    get.path = sql.table('sites').where("id=?", (id,)).getField('path')
    
    
   
    get.webname = site_name
    s = site.DeleteSite(get)
    print(site_name," deteled")
    
    if os.path.exists(get.path+'/.user.ini'):
        public.ExecShell("chattr -i "+get.path+"/.user.ini")
    
    if os.path.exists(get.path):
        public.ExecShell("rm -rf "+get.path)
        print(get.path," deteled")
