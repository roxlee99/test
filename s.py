import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,db,time
import panelSite
import json


if __name__ == "__main__":
    sql = db.Sql()
    sites = panelSite.panelSite()
    get = public.dict_obj()
    
    site_name = sys.argv[1]
    get.id = sql.table('sites').where('name=?', (site_name,)).getField('id')
    get.pid = get.id
    
    
    data1 = {}
    data1['website'] = site_name+',www.'+site_name
    domains = data1['website'].split(',')
    print(domains)
    
    website_name = domains[0].split(':')[0]
    get.webname = json.dumps({"domain": website_name, "domainlist": domains[1:], "count": 0})
    
    siteMenu = json.loads(get.webname)
    data = {}
    data['siteStatus'] = True
    data['siteId'] = get.pid
    
    get.set_ssl = '1'

    sites.siteName = site_name
    data = sites._set_ssl(get, data, siteMenu)
    
    print(data)
