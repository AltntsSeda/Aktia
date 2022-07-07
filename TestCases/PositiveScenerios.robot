*** Settings ***
Library     SeleniumLibrary
Resource    ../Recources/Resources.robot
Library   DataDriver    ../TestData/PositiveSenarious.xlsx    sheet_name:Positive

Test Setup    Open Browser and Setup
Test Teardown    Teardown
Test Template    Verify Reference Number

*** Test Cases ***
Implement Positive Scenerios    ${base_number}

*** Keywords ***
Verify Reference Number
    [Arguments]    ${base_number}
    Provide Reference Number    ${base_number}
    Get Provided Reference Number as List
    Configure Reference Number Format as Described
    Verify Reference Number from List

