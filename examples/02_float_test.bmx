
SuperStrict

Include "../json.bmx"

Local s:String = LoadString("test2.json")
Local json:TJsonNode = TJsonNode.Create(s)

Print "float_test: " + json.xPath("float_test")
Print "float_test2: " + json.xPath("float_test2")
	
Print "finished"
end
