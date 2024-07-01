
import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,db,time
import system
import monitor



if __name__ == "__main__":
    
    site = system.system()
    numsite = monitor.Monitor()
    
    #print(site.GetDiskInfo2())
    #print(numsite._get_site_list())
    
    disk = site.GetDiskInfo2()
    bnumsite = numsite._get_site_list()
    n = disk[0]['size'][1]
    n = n.replace('G','')
    
    
    
    print(n)
    
    if not bnumsite:
        print(0)
    else:
        print(len(bnumsite))
