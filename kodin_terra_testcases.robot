*** Settings ***
Documentation   Tests for Kodinterra.fi. Tests various features
...             :store,storeinfo,search, shoppingcart, buying 
Metadata         Version    0.1

Library      SeleniumLibrary

Test Teardown   Close All Browsers
Resource  ${CURDIR}/resources/resources.robot
Test Setup      Init Test

*** Variables ***
${BROWSER}  chrome 

*** Test Cases ***

Verify Homepage
        [Tags]  TestCase1
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}

Verify Store Change
        [Tags]  TestCase2     
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
        Verify Info Section when Store Changed

Verify Search
        [Tags]  TestCase3
        Verify Search


Verify Shoppingcart
        [Tags]  TestCase4
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
        Verify Shopping Cart Example
        

Verify Shoppingcart Contents
        [Tags]  TestCase5
        ${example_product}=     BuiltIn.Set Variable  Weber Genesis II E-410 GBS kaasugrilli
        ${example_product2}=     BuiltIn.Set Variable  Weber suojapeite Premium Gen II 3 P.
        ${example_product3}=     BuiltIn.Set Variable  Weber Original vihannespannu, iso
        ${example_product4}=     BuiltIn.Set Variable  Weber savustulastut siipikarjalle
        ${example_product5}=     BuiltIn.Set Variable  Weber Pulse 1000 jalustalla sähkögrilli
        
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
        Verify Shoppingcart Contents Count  ${TRUE}
        Search And Add Product  ${example_product4}     3
        Search And Add Product  ${example_product2}     2  
        Search And Add Product  ${example_product3}  
        Search And Add Product  ${example_product}
        Verify Shoppingcart Contents Count  ${TRUE}

Verify Product Categories
        [Tags]  TestCase6
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
        Navigate Categories  Työkalut ja -koneet   Vasarat ja lekat     empty
        # Add Product  Ellix kirvesmiehen vasara 450g  #Oli tilapäisesti loppu
        Add Product  Lux pajavasara 1000g Classic
        Verify Shoppingcart Saldo Is Updated
        Navigate Categories     Rakentaminen    Naulat, naulauslevyt ja palkkikengät    Naulat
        Add Product   Obi naulalajitelma 550kpl
        
        Goto Shoppingcart
        Goto Shoppingdesk
        Verify Shoppingdesk
        Goto Billing

# Test Case 7
#         [Tags]  QuickTest
#         # SeleniumLibrary.Set Selenium Timeout  25 seconds     
#         # Goto Main Site
#         Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
#         Navigate Categories  Työkalut ja -koneet   Vasarat ja lekat     empty
#         Add Product  Ellix kirvesmiehen vasara 450g
#         Verify Shoppingcart Saldo Is Updated
#         Navigate Categories     Rakentaminen    Naulat, naulauslevyt ja palkkikengät    Naulat
#         Add Product   Fix Master listanaula messinki 1,4X30 40kpl
#         BuiltIn.Sleep  3  reason=None
#         Add Products  Obi naulalajitelma 550kpl  3
#         Goto Shoppingcart
#         Goto Shoppingdesk
#         Verify Shoppingdesk
#         Goto Billing
        

        


        
        

