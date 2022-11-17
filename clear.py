import sys,os
panelPath = '/www/server/panel/'
os.chdir(panelPath)
sys.path.insert(0,panelPath + "class/")
import public,time,json
import files

if __name__ == "__main__":
    
    site = files.files()
    get = ''
    site.Close_Recycle_bin(get);