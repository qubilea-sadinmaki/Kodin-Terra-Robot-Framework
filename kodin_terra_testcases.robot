*** Settings ***
Documentation   Tests for Kodinterra.fi. Tests various features
...             :store,storeinfo,search, shoppingcart, buying 
Metadata         Version    0.1

Library      SeleniumLibrary
Resource     ${CURDIR}/resources/resources.robot

Test Teardown   Close All Browsers
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
        BuiltIn.Log To Console  step1
        Verify Shoppingcart Contents Count  ${TRUE}
        BuiltIn.Log To Console  step2
        Search And Add Product  ${example_product4}
        BuiltIn.Log To Console  step3
        Search And Add Product  ${example_product2}     2  
        Search And Add Product  ${example_product3}  
        Search And Add Product  ${example_product}
        Verify Shoppingcart Contents Count  ${TRUE}

Verify Product Categories
        [Tags]  TestCase6
        Navigate To Store And Verify  ${hameenlinna.linkElement}  ${hameenlinna.locator}
        Navigate Categories  Työkalut ja -koneet   Vasarat ja lekat     empty
        # Add Product  Ellix kirvesmiehen vasara 450g  #Oli tilapäisesti loppu
        Add Products To Shoppingcart  Lux kirvesmiehen vasara 225g Classic
        Verify Shoppingcart Saldo Is Updated
        Navigate Categories     Rakentaminen    Naulat, naulauslevyt ja palkkikengät    Naulat
        Add Products To Shoppingcart   Sinkilä 25x2,0 kuumasinkitty 1,0 kg
        
        Goto Shoppingcart
        Goto Shoppingdesk
        Verify Shoppingdesk
        Goto Billing

# Test Case 7
#         [Tags]  QuickTest
#         # MyFirstCustomClass.SINGLETON
#         # ${kind}=  BuiltIn.Set Variable  DOG
#         # MyFirstCustomClass.HOW MANY ${kind} ARE HERE
#         # SHOW LIST  dog  cat  ape
#         # SHOW LIST OF KEYVARS  kvar1=value1  kvar2=value2  kvar3=value3
#         # TITLE SHOULD START WITH  Kodin Terra - Pieniin suuriin muutoksiin
#         # ${rand}=  RANDOM NUM
#         # BuiltIn.Log To Console  RANDOM NUM:${rand}
#         # ${seed}=  BuiltIn.Set Variable  1
#         # ${rand}=  RANDOM NUM WITH SEED  ${seed}
#         # BuiltIn.Log To Console  \nRANDOM NUMBER WITH SEED ${seed} is ${rand}
#         # ${seed}=  BuiltIn.Set Variable  2
#         # ${rand}=  RANDOM NUM WITH SEED  ${seed}
#         # BuiltIn.Log To Console  \nRANDOM NUMBER WITH SEED ${seed} is ${rand}
#         ${msg}=        CalendarHelper.Test
#         BuiltIn.Log To Console  \n${msg}

        

        


        
        

