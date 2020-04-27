*** Settings ***

*** Keywords ***  
Click Element When Visible
    [Arguments]   ${locator}   
    Wait Until Element Is Visible   ${locator} 
    Click Element   ${locator}

ScrollTo And Click
    [Arguments]   ${locator}
    Wait Until Page Contains Element    ${locator}
    SeleniumLibrary.Scroll Element Into View  ${locator}  
    Click Element   ${locator}

Hide Blocking Element
    [Arguments]   ${locator}
    ${isVisible}=  Run Keyword And Return Status    Wait Until Element Is Visible   ${locator}   1
    Run Keyword IF  ${isVisible}  Click Element  ${locator}

Open Page And Verify Element Is Visible
        [Arguments]  ${url}  ${locator}
        Open Browser   ${url}   ${BROWSER} 
        Wait Until Page Contains Element   ${locator} 

Open Page And Verify It Contains Text
        [Arguments]  ${url}  ${text}
        Open Browser   ${url}   ${BROWSER} 
        Wait Until Page Contains  ${text}

Click Element And Verify Page Loaded
    [Arguments]  ${click_locator}   ${element_locator} 
    Click Element  ${click_locator}
    Wait Until Page Contains Element   ${element_locator}

Login
        [Arguments]  ${username_locator}   ${username}  ${password_locator}   ${password}  ${login_button} 
        Wait Until Element Is Visible   ${login_button}
        Input Text    ${username_locator}    ${username}
        Input Password    ${password_locator}    ${password}
        Click Button   ${login_button} 

Do Search
        [Arguments]  ${locator}   ${search_for}
        Input Text    ${locator}    ${search_for}
        Press Keys  ${locator}   RETURN 

StringToFloatToString
    [Arguments]  ${str}  ${modifier}=1
        ${f}=   StringToFloat  ${str}  ${modifier}
        ${f}=   BuiltIn.Convert To String  ${f}
        ${f}=   String.Replace String  ${f}  .  ,
        # BuiltIn.Log To Console  \nStringToFloatToString:${f}
        [Return]    ${f} 

StringToFloat
    [Arguments]  ${str}  ${modifier}=1
        ${f}=   BuiltIn.Set Variable  ${str} 
        ${f}=   String.Remove String Using Regexp  ${f}  [^0-9.,]
        ${f}=   String.Replace String  ${f}  ,  .
        # Remove possible extra dots and everything after that (fe. 4.950.01, removes .01)
        # ${f}=    Only Two Digits  ${f}
        ${f}=   SeleniumLibrary.Execute Javascript  return /^[0-9]+\.?.{0,2}/.exec("${f}")[0];  #/^([^.]*.[^.]*),*/.exec("${f}")[0];  
        ${f}=   BuiltIn.Convert To Number  ${f}
        # BuiltIn.Log To Console  \nStringToFloat:${f}
        ${f}=   BuiltIn.Evaluate  ${f}*${modifier}
        ${f}=   SeleniumLibrary.Execute Javascript  return /^[0-9]+\.?.{0,2}/.exec("${f}")[0];
        # BuiltIn.Log To Console  \nStringToFloat2:${f}
        [Return]    ${f} 

Convert Float To Comparable
        [Arguments]  ${f}
        ${f}=  Evaluate  "%.2f" % ${f}
        ${f}=   BuiltIn.Convert To String  ${f}
        ${f}=   String.Replace String  ${f}  .  ,
        [Return]    ${f}   

Only Two Digits
    [Arguments]  ${f}
    SeleniumLibrary.Execute Javascript  return /^[0-9]+\.?.{0,2}/.exec("${f}")[0];