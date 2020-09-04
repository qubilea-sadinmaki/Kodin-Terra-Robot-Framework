*** Settings ***
Documentation  Tests for Kodinterra.fi, using Android. Tests just site opening.
Metadata         Version    0.1  
Library  AppiumLibrary
Resource     ${CURDIR}/resources/mobile_resources.robot

*** Variables ***
${BROWSER}  chrome 

*** Test Cases ***

Verify Homepage
        [Tags]  verify-homepage
        Init Test  ${BROWSER}
        Goto Main Site
        # Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}

# Verify Store Change
#         [Tags]  verify-store-change    
#         Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
#         Verify Info Section when Store Changed

# Verify Search
#         [Tags]  verify-search
#         Verify Search


# Verify Shoppingcart
#         [Tags]  verify-shoppingcart
#         Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
#         Verify Shopping Cart Example
        

# Verify Shoppingcart Contents
#         [Tags]  verify-choppingcart-contents
#         ${example_product}=     BuiltIn.Set Variable  Weber Genesis II E-410 GBS kaasugrilli
#         ${example_product2}=     BuiltIn.Set Variable  Weber suojapeite Premium Gen II 3 P.
#         ${example_product3}=     BuiltIn.Set Variable  Weber Original vihannespannu, iso
#         ${example_product4}=     BuiltIn.Set Variable  Weber savustulastut siipikarjalle
#         ${example_product5}=     BuiltIn.Set Variable  Weber Pulse 1000 jalustalla sähkögrilli
        
#         Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
#         Verify Shoppingcart Contents Count  ${TRUE}
#         Search And Add Product  ${example_product4}
#         Search And Add Product  ${example_product2}     2  
#         Search And Add Product  ${example_product3}  
#         Search And Add Product  ${example_product}
#         Verify Shoppingcart Contents Count  ${TRUE}

# Verify Product Categories
#         [Tags]  verify-product-categories
#         Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
#         Navigate Categories  Työkalut ja -koneet   Vasarat ja lekat     empty
#         # Add Product  Ellix kirvesmiehen vasara 450g  #Oli tilapäisesti loppu
#         Add Products To Shoppingcart  Lux kirvesmiehen vasara 225g Classic
#         Verify Shoppingcart Saldo Is Updated
#         Navigate Categories     Rakentaminen    Naulat, naulauslevyt ja palkkikengät    Naulat
#         Add Products To Shoppingcart   Sinkilä 25x2,0 kuumasinkitty 1,0 kg
        
#         Goto Shoppingcart
#         Goto Shoppingdesk
#         Verify Shoppingdesk
#         Goto Billing

# Development Test
#         [Tags]  development-test
#         ${msg}=  BuiltIn.Set Variable  opening
#         BuiltIn.Log To Console  \n${msg}
