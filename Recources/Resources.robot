*** Settings ***
Library   SeleniumLibrary
Library   Collections
Library   String


*** Variables ***
#ENVIRONMENT
${browser}  Chrome
${url}    https://www.aktia.fi/fi/yritysasiakkaat/viitenumerolaskuri
${time_out}     10

#UI ELEMENTS
${accept_cookies}  //*[contains(text(),'Hyväksy kaikki evästeet')]
${close_chatbox}    //*[@title='Sulje']
${reference_number_base}    //*[@name='referenceNumberBase']
${reference_number_dropdown}    (//*[@class='input-group']/*)[2]
${kansainvalinen_viitenumero}    //*[contains(text(),'Kansainvälinen viitenumero')]/..
${laske}    //*[contains(text(),'Laske')]
${get_all_reference_number}     //*[@class='table--vertical']/*
${error_message}     //*[@class='error-text']
@{reference_number_list}

*** Keywords ***
#UNIVERSAL KEYWORDS
Click Element When Visible
    [Arguments]    ${argument_locater}
    Wait Until Element Is Visible    ${argument_locater}    ${time_out}
    Run Keyword and Ignore Error    scroll element into view    ${argument_locater}
    mouse over    ${argument_locater}
    Set Focus To Element  ${argument_locater}
    click element  ${argument_locater}

Click Element If Visible
    [Arguments]     ${argument_element}
    set selenium implicit wait    1
     ${count}    get element count    ${argument_element}
    IF    ${count} > 0
        Click Element    ${argument_element}
    END
    set selenium implicit wait    ${time_out}

#PROJECT KEYWORDS
Open Browser and Setup
    open browser   ${url}   ${browser}
    maximize browser window
    #set window size    ${1400}    ${600}
    set selenium implicit wait    ${time_out}
    Click Element When Visible    ${accept_cookies}
    Click Element If Visible     ${close_chatbox}

Teardown
    Sleep     5
   Close All Browsers

#FUNCTIONAL KEYWORDS
Provide Reference Number
    [Arguments]    ${base_number}
    input text    ${reference_number_base}    ${base_number}
    #Select Random Reference Number From Dropdown     # This keyword can be use for select random of reference options
    Select From List By Index    ${reference_number_dropdown}    2
    Sleep    2
    Click Element If Visible     ${close_chatbox}
    Click Element When Visible     ${kansainvalinen_viitenumero}
    Sleep    2
    Click Element If Visible     ${close_chatbox}
    Sleep    1
    Click Element When Visible    ${laske}


Get Provided Reference Number as List
    ${get_count}    get element count    ${get_all_reference_number}
    # CLEAR LIST #
    FOR     ${element}    IN    @{reference_number_list}
    Remove values from list    ${reference_number_list}   ${element}
    END
    #APPEND NEW ITEMS#
    FOR    ${i}    IN RANGE   1    (${get_count})+1
    ${reference_number}    get text    (//*[@class='table--vertical']/*)[${i}]
    append to list    ${reference_number_list}    ${reference_number}
    END

Configure Reference Number Format as Described
    ${get_lenght}    get length    ${reference_number_list}
    FOR     ${i}    IN RANGE   0    ${get_lenght}
        ${reference_number}    get from list    ${reference_number_list}    ${i}
        ${updated_reference_number}    Replace String     ${reference_number}    RF    2715
        ${pre}	fetch from left    ${updated_reference_number}    ${SPACE}
        #LOG TO CONSOLE    pre ${pre}
        ${updated_reference_number}    remove string   ${updated_reference_number}    ${SPACE}
        #LOG TO CONSOLE    ${all_reference_number}
        ${post}    get substring     ${updated_reference_number}    6
        #LOG TO CONSOLE     post ${post}
        ${final_reference_number}     Catenate   SEPARATOR=  ${post}    ${pre}
        set list value    ${reference_number_list}    ${i}    ${final_reference_number}
        LOG TO CONSOLE    final number ${reference_number_list}[${i}]
    END


Verify Reference Number from List
    ${get_lenght}    get length    ${reference_number_list}
    FOR     ${i}    IN RANGE   0    ${get_lenght}
        ${reference_number}    get from list    ${reference_number_list}    ${i}
        ${mod}    evaluate    ${reference_number}%97
        ${mod}    Convert to string    ${mod}
        Should Be Equal    ${mod}    1
    END


Select Random Reference Number From Dropdown
    ${get_count_options}    get element count    (//*[@class='input-group']/*)[2]/*[not(@value='undefined')]
    ${random}    evaluate    random.randint(1,${get_count_options})
    Select From List By Index    ${reference_number_dropdown}    ${random}
