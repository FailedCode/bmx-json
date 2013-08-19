
SuperStrict

Include "../json.bmx"

Local s:String = LoadString("test.txt")

Print "s: " + s
Print "utf8 converted: " + Utf8ToBmxString(s)
Print "There and back again: " + bmxStrToUtf8(Utf8ToBmxString(s))

Print "Empty string to utf8: '" + bmxStrToUtf8("") + "'"
Print "Empty string from utf8: '" + Utf8ToBmxString("") + "'"
end
