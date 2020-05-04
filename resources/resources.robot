*** Settings ***
Library	 OperatingSystem
Library	 String
Library  Collections
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
    SeleniumLibrary.Set Selenium Timeout  25 seconds
    Goto Main Site
    BuiltIn.Set Suite Variable  ${SHOPPINGCART_SALDO}  0
    BuiltIn.Set Suite Variable  ${DELIVERY_COST}  0
    @{SHOPPINGCART_PRODUCTS}=   BuiltIn.Create List
    BuiltIn.Set Suite Variable  @{SHOPPINGCART_PRODUCTS}

Add Product To List
    [Arguments]   ${name}=No name  ${price}=0  ${count}=0  ${log}=${FALSE}
     Set Current Product  ${name}  ${price}  ${count}  ${log}
     Collections.Append To List  ${SHOPPINGCART_PRODUCTS}  ${CURRENT_PRODUCT}
     ${item}=   Collections.Get From List  ${SHOPPINGCART_PRODUCTS}  -1
     ${updated_saldo}=   BuiltIn.Evaluate  ${SHOPPINGCART_SALDO}+${item}[total]   
     BuiltIn.Set Suite Variable   ${SHOPPINGCART_SALDO}   ${updated_saldo}     
         
    # BuiltIn.Log To Console  \nSaldo updated to:${SHOPPINGCART_SALDO}

Remove Product From List    
    [Arguments]   ${index}=-1
    Collections.Remove From List  ${SHOPPINGCART_PRODUCTS}  ${index}

Set Current Product
    [Arguments]   ${name}=No name  ${price}=0  ${count}=0  ${log}=${FALSE}
    # ${name}     Remove String   ${name}   ${SPACE}
    ${total}=   StringToFloat   ${price}    ${count}    
    ${price}=   StringToFloatToString   ${price}    1
    BuiltIn.Set Suite Variable  &{CURRENT_PRODUCT}    name=${name}   price=${price}  count=${count}  total=${total} 
    BuiltIn.Run Keyword If  ${log}  BuiltIn.Log To Console  \nCurrent product:&{CURRENT_PRODUCT}[name]:&{CURRENT_PRODUCT}[price]:&{CURRENT_PRODUCT}[count]:&{CURRENT_PRODUCT}[total]
    
Goto Main Site
    Open Browser   ${mainsite.homeURL}   ${BROWSER} 
    Maximize Browser Window  
    Wait Until Page Contains Element   ${mainsite.homeLocator}  
    Hide Cookie button

Goto Billing
    Choose And Verify Delivery
    SeleniumLibrary.Input Text  firstNameBilling  Matti
    SeleniumLibrary.Input Text  lastNameBilling  Meikäläinen
    SeleniumLibrary.Input Text  phone1Billing  0452345666
    SeleniumLibrary.Input Text  email1Billing  matti.meikalainen@gmail.com
    SeleniumLibrary.Input Text  address1Billing  Coronatie 20 C 20
    SeleniumLibrary.Input Text  zipCodeBilling  00500
    SeleniumLibrary.Input Text  cityBilling  Helsinki
    ${radio_btn}=   Execute Javascript   return document.querySelector('[value="VISA,ELECTRON,MASTERCARD"]').parentElement.querySelector('[class="checkmark checkmark-radiobutton"]')
    ScrollTo And Click  ${radio_btn}
    ScrollTo And Click  goToBuy
    SeleniumLibrary.Wait Until Page Contains Element    form_CREDITCARD
    SeleniumLibrary.Set Focus To Element  form_CREDITCARD
    SeleniumLibrary.Element Should Be Visible  form_CREDITCARD:creditCardNumber0
    SeleniumLibrary.Element Should Be Visible  form_CREDITCARD:expirationDate0
    SeleniumLibrary.Element Should Be Visible  form_CREDITCARD:cardVerificationCode00

Choose And Verify Delivery

    ScrollTo And Click  //*[contains(text(), "Toimitus kotiin")]
    ${delivery_cost}=   SeleniumLibrary.Execute Javascript  return document.querySelector('[data-shipping-mode="KEKU 21S"]').querySelector('div > header > div > div > h3').innerText  
    Log To Console  \ndelivery:${delivery_cost}
    BuiltIn.Sleep  4
    ${delivery_cost_on_bill}=   SeleniumLibrary.Execute Javascript  return document.querySelector('div[id="cart-shipping-charge-container"]').querySelector('div[class="price-container"]').innerText 
    BuiltIn.Should Be Equal  ${delivery_cost}  ${delivery_cost_on_bill}
    ${delivery_cost}=   StringToFloat  ${delivery_cost}
    BuiltIn.Set Suite Variable  ${DELIVERY_COST}  ${delivery_cost}
    

Verify Info Section when Store Changed
    To Store Info Section   ${hameenlinna.id}
    Verify Info Section  ${hameenlinna.locationName}
    Navigate To Store And Verify  ${pori.linkElement}  ${pori.locator}
    Verify Info Section  ${pori.locationName}  
    
Navigate To Store And Verify
    [Arguments]   ${selector}  ${locator}
        Wait Until Element Is Visible  ${changeStoreBtnLocator}
        Execute Javascript    document.querySelector('[class="select-store-link text-small"]').click()
        Choose Store  ${selector}  ${locator}

Choose Store
    [Arguments]   ${selector}  ${locator}
    # Log To Console  \nChoose Store ${locator} 
    Wait Until Element Is Visible   //*[@id="changeCustomerStore"]
    Execute Javascript    document.querySelector('${selector}').click()
    Wait Until Page Contains  ${locator}

Verify Search
    SeleniumLibrary.Input Text  ${searchFormLocator}  Weber
    SeleniumLibrary.Wait Until Element Is Visible  AutoSuggestSuggestions
    Verify List Has Right Elements At Beginning  [class="autosuggestHeader"]  Osasto
    Sleep   1
    SeleniumLibrary.Input Text  ${searchFormLocator}  Fiskars
    SeleniumLibrary.Wait Until Element Is Visible  AutoSuggestSuggestions
    Verify List Has Right Elements At Beginning   [class="autosuggestHeader"]  Brändi

Verify Shopping Cart Example
    SeleniumLibrary.Input Text  ${searchFormLocator}  Weber
    SeleniumLibrary.Wait Until Element Is Visible  AutoSuggestSuggestions
    ${list_element}=     ListElement That Contains Text  [class="category_list"]  PuutarhaGrillausWeber grillit  ${TRUE}
    SeleniumLibrary.Click Element  ${list_element}
    SeleniumLibrary.Wait Until Element Is Visible   //div[@id="PageHeading_1_-2001_1989"]//h1
    SeleniumLibrary.Element Text Should Be  //div[@id="PageHeading_1_-2001_1989"]//h1  Weber grillit
    ${product_name}=    Set Variable    Weber Genesis II E-410 GBS kaasugrilli
    Add Products  ${product_name}   1
    Verify Shoppingcart Saldo Is Updated

Verify Shoppingcart Saldo Is Updated
    SeleniumLibrary.Wait Until Element Is Visible   ${ShopcartAddedNotification}  
    ${saldo_addition}=  BuiltIn.Set Variable  &{CURRENT_PRODUCT}[total]
    ${saldo_addition}=  Convert Float To Comparable  ${saldo_addition}
    ${saldo_added}    Get Text   widget_minishopcart 
    ${saldo_added}  Remove String   ${saldo_added}   ${SPACE}
    BuiltIn.Should Contain  ${saldo_added}    ${saldo_addition} 

Verify Shoppingdesk
      ${count}=  Execute Javascript   return document.querySelectorAll('[class="d-flex align-items-center product"]').length
        FOR    ${INDEX}    IN RANGE  0  ${count}
        ${name}=   Execute Javascript   return document.querySelectorAll('[class="d-flex align-items-center product"]')[${INDEX}].querySelector('[class="title"]').innerText
        ${Count}=   Execute Javascript   return document.querySelectorAll('[class="d-flex align-items-center product"]')[${INDEX}].querySelector('[class="col-2 col-sm-1 col-md-2 col-lg-1 text-right"]').innerText
        ${price}=   Execute Javascript   return document.querySelectorAll('[class="d-flex align-items-center product"]')[${INDEX}].querySelector('[class="d-flex justify-content-end"]').innerText
        ${ref_item}=   Collections.Get From List  ${SHOPPINGCART_PRODUCTS}  ${INDEX}
        BuiltIn.Log To Console  \nName:${name}, pcs:${count}, price:${price}
        BuiltIn.Should Contain  ${name}  ${ref_item}[name]
        BuiltIn.Should Contain  ${count}  ${ref_item}[count]
        BuiltIn.Should Contain  ${price}  ${ref_item}[price]
        END

        ${total_sum}=   Execute Javascript   return document.querySelector('[class="total-sum"]').querySelector('[class="price-container"]').innerText
        ${saldo}=   Convert Float To Comparable  ${SHOPPINGCART_SALDO}  
        # BuiltIn.Log To Console  \nTotal sum: ${total_sum} vs ${saldo}  
        BuiltIn.Should Contain  ${total_sum}  ${saldo}        

Verify Shoppingcart Product Is Added
    [Arguments]  ${product}
    SeleniumLibrary.Wait Until Element Is Visible   ${ShopcartAddedNotification}
    SeleniumLibrary.Element Should Contain  ${ShopcartAddedNotification}     ${product} 

Navigate Categories
    [Arguments]   ${main_category}   ${sub_category}   ${subsub_category}
    ${main}=  Get Element With InnerText    [class="nav-item h-100 text-nowrap dropdown"]    ${main_category} 
    SeleniumLibrary.Wait Until Element Is Visible  ${main}
    SeleniumLibrary.Mouse Over  ${main}
    BuiltIn.Run Keyword If  '${sub_category}'=='empty'  SeleniumLibrary.Click Element  ${main} 
    ...  ELSE    Click Element With InnerText   [role="menuitem"]    ${sub_category}

    BuiltIn.Run Keyword If  '${subsub_category}'!='empty'  Click SidenavigationElement   [class="category-name font-size-lg"]    ${subsub_category}

Click SidenavigationElement
    [Arguments]   ${selector}   ${text}
    ${element}=   Get Element With InnerText  ${selector}   ${text}
    # SeleniumLibrary.Set Focus To Element  ${element}
    Scroll Element Into View  ${element}
    # Navigationbar was blocking sidebar element, so had to use ARROW_UP to get it visible (Selenium does not handle layer Z)
    SeleniumLibrary.Press Keys  None   ARROW_UP
    Sleep  0.5  reason=None
    SeleniumLibrary.Press Keys  None   ARROW_UP
    Sleep  0.5  reason=None
    SeleniumLibrary.Press Keys  None   ARROW_UP
    SeleniumLibrary.Mouse Over  ${element}
    SeleniumLibrary.Click Element   ${element}
    SeleniumLibrary.Wait Until Page Contains  ${text}

Click Element With InnerText
    [Arguments]   ${selector}   ${text}
    ${element}=   Get Element With InnerText  ${selector}   ${text}
    SeleniumLibrary.Set Focus To Element  ${element}
    SeleniumLibrary.Click Element   ${element}
    SeleniumLibrary.Wait Until Page Contains  ${text}

Get Element With InnerText 
    [Arguments]   ${selector}   ${text}
    BuiltIn.Run Keyword And Return  Execute Javascript  for (const a of document.querySelectorAll('${selector}')) { if (a.innerText.match(/^\s*${text}\s*$/gm)) { return a }}

Verify Shoppingcart Contents Count
    [Arguments]   ${remove_items_from_cart}=${FALSE}    ${fail_if_not_empty}=${FALSE} 
    Goto Shoppingcart 
    ${isShoppingcartEmpty}=   BuiltIn.Run Keyword  Is Shippingcart Empty
    BuiltIn.Run Keyword If  not ${isShoppingcartEmpty} and ${fail_if_not_empty}  BuiltIn.Fail   Shopping cart was supposed to be empty!
    BuiltIn.Run Keyword If  not ${isShoppingcartEmpty} and ${remove_items_from_cart}    Remove Products From Shoppingcart 

Goto Shoppingcart
    SeleniumLibrary.Wait Until Page Contains Element  main-menu
    SeleniumLibrary.Click Element  widget_minishopcart
    SeleniumLibrary.Wait Until Page Contains Element  goToBuy 
    Wait Until Page Contains Element    //body[@class="shopping-cart"]  

Goto Shoppingdesk 
    Input Text  shoppingCartZipCodeCheckInput  00400
    Click Button   shoppingCartZipCodeCheckButton
    Sleep  4
    Wait Until Element Is Visible  //a[@class="btn btn-primary btn-buy go-to-buy float-right"]
    ${url}=     Execute Javascript   return document.querySelector('.d-none > .btn-primary').getAttribute("href")
    Go To  ${url}
    Wait Until Page Contains  Valitse toimitustapa
    # Wait Until Page Contains Element    //body[@class="ostoskori order-shipping-billing shopping-process-header-hidden"]
    

Is Shippingcart Empty
    ${count_of_products}=   Execute Javascript   return document.querySelectorAll('[class="d-flex align-items-center product mx-1 py-3"]').length
    BuiltIn.Log To Console  \nShoppingcart had ${count_of_products} in it. 
    [Return]    ${count_of_products}==0

Search And Add Product
    [Arguments]   ${product}  ${count}=1
    Search Product and Verify   ${product}
    Add Products To Shoppingcart  ${product}  ${count}  
    
Search Product and Verify
    [Arguments]   ${product}
    BuiltIn.Log To Console  \nSearch Product : ${product}
    Do Search   ${searchFormLocator}  ${product}
    SeleniumLibrary.Wait Until Page Contains    ${product} 

# Shopcart adding / removing ----------------------------
Remove Products From Shoppingcart
     ${count_to_remove}=  Execute Javascript   return document.querySelectorAll('[class="d-none d-lg-inline-block"]').length

        FOR    ${INDEX}    IN RANGE  0  ${count_to_remove}
        ${element}=   Execute Javascript   return document.querySelector('[class="d-none d-lg-inline-block"]')
        ScrollTo And Click  ${element}
        BuiltIn.Sleep  3
        END

     BuiltIn.Log To Console  \nRemoved ${count_to_remove} products from shopingcart!  

Add Products To Shoppingcart
    [Documentation]     Adds one or more pieces of products.   
    [Arguments]   ${product}  ${count}=1
    # BuiltIn.Log To Console  \n${product}:${count}
    BuiltIn.Run Keyword If  ${count} > 1  Add Products  ${product}  ${count}  
    ...  ELSE   Add Product  ${product}

Add Products
    [Documentation]     Adds one or more pieces of products from products own selling page
    [Arguments]   ${product}  ${count}=1
    # BuiltIn.Log To Console  \n${product}:${count}
    Wait Until Loader Is Not Visible
    ScrollTo And Click  //*[@alt='${product}']
    # SeleniumLibrary.Wait Until Element Is Visible  ${product_title} 
    # SeleniumLibrary.Element Text Should Be  ${product_title}    ${product}
    Wait Until Page Contains  ${product}
    Wait Until Element Is Visible  online-store-content
    SeleniumLibrary.Input Text  ${quantityToAddInput}  ${count} 
    ${price}=  SeleniumLibrary.Execute Javascript  return document.querySelector('[id="online-store-content"]').querySelector('strong[class="special-price"]').getAttribute('data-price').toString()
    Add Product To List  ${product}  ${price}  ${count}  ${TRUE}
    ScrollTo And Click  ${addToCartBtn}
    Verify Shoppingcart Product Is Added    ${product}

Add Product
    [Documentation]     Adds product from a list of product thumnails
    [Arguments]   ${product}
    Wait Until Loader Is Not Visible
    Wait Until Element Is Visible  //*[@class="product_listing_container"] 
    ${element}=  SeleniumLibrary.Execute Javascript  return document.querySelector('[alt="${product}"]').parentElement.parentElement.parentElement.parentElement.querySelector('[class="online-availability"]').querySelector('.btn')
    ${price}=  SeleniumLibrary.Execute Javascript  return document.querySelectorAll('[alt="${product}"]')[0].parentElement.parentElement.parentElement.parentElement.querySelector('[class="special-price"]').innerText
    Add Product To List  ${product}  ${price}  1  ${TRUE}
    ScrollTo And Click  ${element} 
    Verify Shoppingcart Product Is Added    ${product} 

To Store Info Section
    [Arguments]   ${locationID}
    SeleniumLibrary.Wait Until Element Is Visible  main-menu
    Execute Javascript   document.querySelector('[href="/fi/terra/myymalat/${locationID}"]').click()

Verify Info Section
    [Arguments]   ${locator}
    # Log To Console  \nVerify Store Info 
    SeleniumLibrary.Wait Until Element Is Visible  //*[@class="terrafi wcm-content-area myymalat"] 
    ${text_on_location}  Execute Javascript  return document.querySelector('[class="col-sm-8"]').innerText 
    Should Be True  '${text_on_location}' == '${locator}' 

# Support Keywords
ListElement That Contains Text
    [Arguments]   ${elementSelector}  ${textReference}  ${failIfNotFound}=${FALSE}
    ${element}=  Set Variable  ${null} 
    ${l}=   Execute Javascript  return document.querySelectorAll('${elementSelector}').length 

        FOR    ${INDEX}    IN RANGE  0  ${l}
        ${elementText}=  Execute Javascript  return document.querySelectorAll('${elementSelector}')['${INDEX}'].textContent
        Run Keyword And Return If  '${elementText}' == '${textReference}'   Execute Javascript  return document.querySelectorAll('${elementSelector}')['${INDEX}']   
        END
    
    Run Keyword If  ${failIfNotFound} == ${TRUE}  BuiltIn.Fail  List didn't find element with text ${textReference}  
    BuiltIn.Return From Keyword  ${element}  

Get ListElement
    [Documentation]    Return webelement from selected list with index
    [Arguments]   ${elementSelector}  ${INDEX}
    Execute Javascript  return document.querySelectorAll('${elementSelector}')['${INDEX}'] 

Get Elements
    [Documentation]    Return webelements
    [Arguments]   ${elementSelector}
    Execute Javascript  return document.querySelectorAll('${elementSelector}')

Verify List Of Elements 
    [Arguments]   ${elementSelector}  ${textReference}  ${startFrom}  ${endTo}
        FOR    ${INDEX}    IN RANGE  ${startFrom}  ${endTo}
        ${elementText}=  Execute Javascript  return document.querySelectorAll('${elementSelector}')['${INDEX}'].textContent
        Should Be True  '${elementText}' == '${textReference}'
        END

Verify List Has Right Elements At Beginning
    [Arguments]   ${elementSelector}  ${textReference}  ${shouldBeAtleastOne}=${FALSE}
        ${isNotReferenceFound}=  BuiltIn.Set Variable  ${FALSE}
        ${isElementTextReferenceText}=  BuiltIn.Set Variable  ${FALSE}
        ${l}=   Execute Javascript  return document.querySelectorAll('${elementSelector}').length

        FOR    ${INDEX}    IN RANGE  0  ${l}
        ${elementText}=  Execute Javascript  return document.querySelectorAll('${elementSelector}')['${INDEX}'].textContent
        BuiltIn.Run Keyword If  ${INDEX} < 1 and '${elementText}'!='${textReference}' and ${shouldBeAtleastOne}  BuiltIn.Fail  \nNot one ${textReference}:s 
        ${isElementTextReferenceText}=  BuiltIn.Evaluate  '${elementText}' == '${textReference}' 

        # BuiltIn.Log To Console  \n${INDEX} isElementTextReferenceText:${isElementTextReferenceText} isNotReferenceFound:${isNotReferenceFound}
        BuiltIn.Run Keyword If  ${isElementTextReferenceText} and ${isNotReferenceFound}    BuiltIn.Fail    \nList was not unbroken!
        ${isNotReferenceFound}=   BuiltIn.Evaluate  '${elementText}' != '${textReference}'  
        END


Hide Cookie button
    Wait Until Element Is Visible  //*[contains(text(), "Haluatko valita automaattisesti lähimmän myymälän?")]
    Click Element When Visible  //*[contains(text(), "Ei, älä valitse lähintä myymälää")]
    Click Element When Visible  ${cookieBtnLocator}
    Log To Console  \nCookie Button Hided 

Wait Until Loader Is Not Visible
    Wait Until Element Is Not Visible  .spinner
    Wait Until Element Is Not Visible  .preventclicks
    Wait For Condition  return document.readyState=="complete"


# Loop Keywords
    

