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
