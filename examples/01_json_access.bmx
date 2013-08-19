
SuperStrict

Include "../json.bmx"

Local s:String = LoadString("test.json")
	
Local json:TJsonNode = TJsonNode.Create(s)

Print json.xPath("layers/0/data/length")

Print json.xPath("layers/0/data/0")

Print json.xPath("layers/0/height")

Local sum:Int
For Local i:Int = 0 Until json.xPath("layers/0/data/length").ToInt()
	sum:+json.xPath("layers/0/data/" + i).ToInt()
Next

Print "sum: " + sum
end
