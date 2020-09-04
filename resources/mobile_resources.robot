*** Settings ***
Library	 OperatingSystem
Library	 String
Library  Collections
Library  AppiumLibrary
# Library   ${CURDIR}/shoppingcart/ShoppingCart.py
Resource   ${CURDIR}/common_keywords.robot

*** Variables ***
${cookieBtnLocator}  //*[@class="light-button accept"]

*** Keywords *** 
Init Test
    [Arguments]   ${browser_to_use}
    Open Application  http://localhost:4723/wd/hub  
    ...  platformName=Android  
    ...  platformVersion=9
    ...  fullReset=false  
    ...  noReset=true  
    ...  deviceName=emulator-5554 
    ...  browserName=${browser_to_use}
    
Goto Main Site
    Go To Url  https://www.kodinterra.fi/fi/terra  
    Hide Cookie button

Hide Cookie button
    Click Element When Visible  ${cookieBtnLocator}
    Wait Until Element Is Visible  //*[contains(text(), "Haluatko valita automaattisesti lähimmän myymälän?")]
    Click Element When Visible  //*[contains(text(), "Ei, älä valitse lähintä myymälää")]