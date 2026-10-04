*** Settings ***
Library   String
Library   SerialLibrary

*** Variables ***
${com}   	COM3
${baud} 	115200
${board}	nRF5340
${TIME_LEN_ERROR}		-1X
${TIME_ARRAY_ERROR}		-2X
${TIME_VALUE_ERROR}		-3X
${TIME_NULL_ERROR}		-4X
${TIME_ZERO_ERROR}		-5X



*** Test Cases ***
Connect Serial
	Log To Console  Connecting to ${board}
	Add Port  ${com}  baudrate=${baud}  encoding=ascii
	Port Should Be Open  ${com}
	Reset Input Buffer
	Reset Output Buffer

Correct time string
    Reset Input Buffer
    Write Data    000120X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    80X

Correct time string 2
    Reset Input Buffer
    Write Data    235959X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    3599X


Incorrect Time string
	Reset Input Buffer
    Write Data    000161X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_VALUE_ERROR}


Incorrect string length
	Reset Input Buffer
    Write Data    00005X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_LEN_ERROR}

String with letters
	Reset Input Buffer
    Write Data    0000A5X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_ARRAY_ERROR}

String with only zeros
	Reset Input Buffer
    Write Data    000000X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_ZERO_ERROR}


Incorrect seconds
	Reset Input Buffer
    Write Data    000060X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_VALUE_ERROR}

Incorrect minutes
	Reset Input Buffer
    Write Data    006100X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_VALUE_ERROR}

Incorrect hours
	Reset Input Buffer
    Write Data    240000X    encoding=ascii
    ${read} =   Read Until   terminator=58   encoding=ascii 
	Log To Console    Received: ${read}
    Should Be Equal As Strings    ${read}    ${TIME_VALUE_ERROR}


	
Disconnect Serial
	Log To Console  Disconnecting ${board}
	[TearDown]  Delete Port  ${com}


	
	
	
