import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,db,time
import panelSite



if __name__ == "__main__":
    sites = panelSite.panelSite()
    get = public.dict_obj()
    
    site = sys.argv[1]
    
    
    get.create_type = 'txt'
    get.websites_content = '{"' + site + ',www.' + site + '|1|0|0|0":""}'
    
    print (get.websites_content)
    #get.websites_content = sys.argv[1]
    # uncuniversity.com
    #print(sys.argv[1])
    #get.websites_content ='{"88581988.com,www.88581988.com,m.88581988.com|1|0|0|0":"","crackpotcomics.com,www.crackpotcomics.com,m.crackpotcomics.com|1|0|0|0":""}'
    #print(type(get.websites_content))
    s = sites.create_website_multiple(get)
    print(s)
