*** Settings ***
Library	 OperatingSystem
Library	 String
Library  Collections
Library  AppiumLibrary
# Library   ${CURDIR}/shoppingcart/ShoppingCart.py
Resource   ${CURDIR}/common_keywords.robot

*** Variables ***
${INVALID USERNAME}  XXXXXX
${INVALID PASSWORD}  XXXXXX
${EMPTY}  ''

${changeStoreBtnLocator}  //*[@class="own-store-container"]
${cookieBtnLocator}  //*[@class="light-button accept"]
${shopcartLocator}  widget_minishopcart
${searchFormLocator}  SimpleSearchForm_SearchTerm
${searchResultListItemLocator}  [class="category_list"]
${storeBtn}  //li[@class="nav-item"]
${storeNameLocator}  //*[@class="col-sm-8"]/h1/strong
${addToCartBtn}  add2CartBtn
${quantityToAddInput}  quantityProductPage
${product_title}    //*[@id="productTitle"]
${ShopcartAddedNotification}  MiniShopCartProductAddedWrapper
${empty_cart_element}   WC_EmptyShopCartDisplayf_div_1

&{hameenlinna}  linkElement=[data-segmentid="Hameenlinna"]  locator=Kodin Terra Hämeenlinna  locationName=Hämeenlinna  id=hameenlinna
&{jyvaskyla}  linkElement=[data-segmentid="Jyvaskyla"]  locator=Kodin Terra Jyväskylä  locationName=Jyväskylä  id=jyvaskyla
&{kokkola}  linkElement=[data-segmentid="Kokkola"]  locator=Kodin Terra Kokkola  locationName=Kokkola  id=kokkola
&{kuopio}  linkElement=[data-segmentid="Kuopio"]  locator=Kodin Terra Kuopio  locationName=Kuopio  id=kuopio
&{pori}  linkElement=[data-segmentid="Pori"]  locator=Kodin Terra Pori  locationName=Pori  id=pori
&{rovaniemi}  linkElement=[data-segmentid="Rovaniemi"]  locator=Kodin Terra Rovaniemi  locationName=Rovaniemi  id=rovanniemi
&{tuusula}  linkElement=[data-segmentid="Tuusula"]  locator=Kodin Terra Tuusula  locationName=Tuusula  id=tuusula
@{stores}   &{hameenlinna}   &{jyvaskyla}   &{kokkola}   &{kuopio}   &{pori}   &{rovaniemi}   &{tuusula}

&{mainsite}   homeURL=https://www.kodinterra.fi/fi/terra   homeLocator=//*[@alt="Kodin Terra verkkokauppa - Etusivu"]
...     login=/kirjaudu/Lw  username=JohnQaDoe  password=penkkipunnerrus

*** Keywords *** 
Init Test
    [Arguments]   ${browser}
    Open Application  http://localhost:4723/wd/hub  
    ...  platformName=Android  
    ...  platformVersion=11
    ...  fullReset=false  
    ...  noReset=true  
    ...  deviceName=emulator-5554 
    ...  browserName=${browser}
    
Goto Main Site
    Go To Url  https://www.kodinterra.fi/fi/terra 
    # Wait Until Page Contains Element  alt=Kodin Terra verkkokauppa - Etusivu  
    # Open Browser   ${mainsite.homeURL}   ${BROWSER} 
    # Maximize Browser Window  
    # Wait Until Page Contains Element   ${mainsite.homeLocator}  
    Hide Cookie button

# Navigate To Store And Verify
#     [Arguments]   ${selector}  ${locator}

Hide Cookie button
    Click Element When Visible  ${cookieBtnLocator}
    Wait Until Element Is Visible  //*[contains(text(), "Haluatko valita automaattisesti lähimmän myymälän?")]
    Click Element When Visible  //*[contains(text(), "Ei, älä valitse lähintä myymälää")]