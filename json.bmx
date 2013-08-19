' ****************************************************************************
'  Copyright (c) 2013 Mattias Hansson 
'  GNU GPL v2
'
' This file implements a self-contained JSON parser/"xpath"/encoder(not yet!)
'
' Usage:
'   'Parse the JSON data (utf8 string)
'	Local json:TJsonNode = TJsonNode.Create(s)
'   'next extract and use the data in a XPATH fashion
'   Print json.getValueFromPath("layers/0/data/length")
'
' Notes(0):
'   JSON arrays are parsed so that values are given the names 0..n
'   An additional property in arrays is the 'length'-property that contains
'   the current number of elements in the array (just as in JavaScript)
'
' Notes(1):
'   In some situations the parser might be more lenient than the spec, but 
'   it should always accept correct JSON.
'
' ****************************************************************************

Include "include/StringConversion.bmx"
Include "include/TJsonNode.bmx"
Include "include/TJsonObject.bmx"
Include "include/TJsonArray.bmx"
Include "include/TStringTokenStreamer.bmx"
