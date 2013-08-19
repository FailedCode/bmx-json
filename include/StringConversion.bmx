
'Converts a BlitzMax string to utf8
'
Function bmxStrToUtf8:String(s:String)
	Local r:String
	For Local i:Int = 0 Until s.length
		Local char:Int = s[i]
		If char < 128
			r:+Chr(char)
		Else If char < 2048
			r:+Chr(char / 64 | 192)
			r:+Chr(char Mod 64 | 128)
		Else
			r:+Chr(char / 4096 | 224)
			r:+Chr(char / 64 Mod 64 | 128)
			r:+Chr(char Mod 64 | 128)
		EndIf
	Next
	Return r
End Function

'Converts a utf8 string to a blitzmax string
'
Function Utf8ToBmxString:String(s:String)
		Local buf:Short[s.length]
		Local sPos:Int
		Local bPos:Int = -1
		
		While sPos < s.Length
			bPos:+1
			
			Local c:Int = s[sPos]
			sPos:+1
			If c < 128
				buf[bPos] = c
				Continue
			EndIf

			Local d:Int = s[sPos]
			sPos:+1
			If c < 224
				buf[bPos] = (c - 192) * 64 + (d - 128)
				Continue
			EndIf
			
			Local e:Int = s[sPos]
			sPos:+1
			If c < 240
				buf[bPos] = (c - 224) * 4096 + (d - 128) * 64 + (e - 128)
				Continue
			EndIf
			
			buf[bPos] = 0 '?
		EndWhile
		Return String.FromShorts(buf, bPos + 1)
End Function
