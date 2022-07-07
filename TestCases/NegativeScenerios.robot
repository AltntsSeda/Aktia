*** Settings ***
Library     SeleniumLibrary
Resource    ../Recources/Resources.robot
Library   DataDriver    ../TestData/NegativeSenarious.xlsx   sheet_name:Negative

Test Setup    Open Browser and Setup
Test Teardown    Teardown
Test Template    Verify Error Message

*** Test Cases ***
Implement Negative Scenerios    ${base_number}

*** Keywords ***
Verify Error Message
    [Arguments]    ${base_number}
    Provide Reference Number    ${base_number}
    Click Element If Visible     ${close_chatbox}
    ${lenght_base_number}     get length    ${base_number}
    IF    ${lenght_base_number} < 3
        sleep    1
        element should be visible    ${error_message}
    ELSE IF    ${lenght_base_number} > 19
        sleep    2
        ${lenght_input_base}    get value    //*[@name='referenceNumberBase']
        ${lenght_input_base}     get length     ${lenght_input_base}
        ${lenght_input_base}  Convert to string    ${lenght_input_base}
        should be equal    ${lenght_input_base}     19
    END
