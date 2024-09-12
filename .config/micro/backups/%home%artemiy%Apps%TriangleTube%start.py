from selenium import webdriver
import time
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options

from pyfzf.pyfzf import FzfPrompt
import os
import sqlite3
from os.path import exists

os.system("killall GeckoMain")

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

up = ".."
srch = "🔎 ПОИСК"
add = "[+add]"
delete = "[-delete]"
menuMain = "Главная"
menuChanels = "Каналы"
player = "mpv"
path = "/home/artemiy/Apps/youtube/"

print(f"{bcolors.WARNING}Загрузка...{bcolors.ENDC}")

options = Options()
options.headless = True

driver = webdriver.Firefox(options=options)

fzf = FzfPrompt()

db = sqlite3.connect(f"{path}Chanelll.db")
cur = db.cursor()

def search():
    sear = input("🔎 Найти: ")
    search_bar = driver.find_element(By.XPATH, """//input[@id="search"]""")
    search_bar.send_keys(sear)
    searchbutton = driver.find_element(By.XPATH, '//*[@id="search-form"]')
    searchbutton.submit()
    print("Ищу " + sear)
    time.sleep(2)

    sear_list = [
        up
    ]
    videos =  driver.find_elements(By.ID, "video-title")
    chanel =  driver.find_elements(By.ID, "tooltip")

    for i in range(len(videos)):
        print(videos[i].text)
        sear_l = videos[i].text
        sear_list.insert(0, sear_l +" | "+ chanel[i].text)
        if i == 20:
            break

    target_half=fzf.prompt(sear_list)
    print(target_half[0])
    vibor2 = target_half[0]
    if vibor2 == up:
        func()
    for i in range(len(videos)):
        name = videos[i].text
        if name == vibor2:
            href = videos[i].get_attribute('href')
            print(href)
            break
    
    # os.system(f"{player} {href}")
    os.system(f"youtube-dl {href} -o - |  mpv -")


def main():
    menu = [
        menuChanels,
        menuMain,
        srch,
    ]
    select = fzf.prompt(menu)[0]
    if select == menuChanels:
        chanels()


def chanels():
    ids = getChanels()
    ids.append(up)
    ids.insert(0, add)
    ids.insert(0, delete)

    target_chanel=fzf.prompt(ids)
    select = target_chanel[0]

    if select == up:
        main()
    if select == add:
        addChanel()
    if select == delete:
        delChanel()
        
    viewChannel(select)

def getChanels():
    db = sqlite3.connect(f'{path}Chanelll.db')
    db.row_factory = lambda cursor, row: row[0]
    c = db.cursor()
    return c.execute('SELECT NAME FROM Chanelll ORDER BY ID DESC').fetchall()


def addChanel():
    url = input("URL: ")
    name = input("NAME: ")
    addChanelInDb(url, name)
    chanels()

def delChanel():
    ids = getChanels()
    ids.append(up)
    target_chanel=fzf.prompt(ids)
    select = target_chanel[0]
    if select == up:
        main()
    delChanelInDb(select)
    chanels()

def viewChannel(chanelName):
    url = ids = c.execute('SELECT URL FROM Chanelll WHERE NAME = "'+chanelName+'"').fetchall()[0]
    driver.get(url)
    time.sleep(1) 
    spisokNAME=[
        up
    ]
    video_name = driver.find_elements(By.ID, "video-title")

    for i in range(len(video_name)):
        ggg = video_name[i].text
        print(ggg)
        spisokNAME.insert(0, ggg)
        if i == 20:
            break
    
    target1=fzf.prompt(spisokNAME)
    
    print(target1[0])

    cccc = target1[0]
    
    if cccc == up:
        main()

    for i in range(len(video_name)):
        ggg = video_name[i].text
        if ggg == cccc:
             href = video_name[i].get_attribute('href')
             print(href)
             break

    # os.system(f"{player} {href}")
    os.system(f"youtube-dl {href} -o - |  mpv -")

def addChanelInDb(url, name):
    if name == "":
        driver.get(url)
        time.sleep(3)
        element2 = driver.find_element(By.XPATH, """//*[@id="channel-name"]""")
        name = element2.text

    cur.execute("""INSERT INTO Chanelll(NAME, URL) VALUES (?,?);""", (name, url))
    db.commit()

def delChanelInDb(name):
    cur.execute(f"DELETE FROM Chanelll WHERE NAME = '{name}';")
    db.commit()

def createDB():
    print("Генерируем базу каналов, это может занять некоторое время...")

    cur.execute("""CREATE TABLE IF NOT EXISTS Chanelll (
        ID INTEGER PRIMARY KEY,
        NAME TEXT,
        URL TEXT
    )""")
    
    db.commit()


    

main()
