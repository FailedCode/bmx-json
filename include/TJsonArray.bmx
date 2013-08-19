
Type TJsonArray Extends TJsonNode
	Field arrayCount:Int

	Method _parse(tok:TStringTokenStreamer)
		While Not tok.Eof()
			Select tok.lookAheadChar()
				Case "]"
					tok.nextChar() 'swallow the end char
					Return
				Default
					_parseValue(tok, String.FromInt(arrayCount))
					arrayCount:+1
					Insert("length", String.FromInt(arrayCount))
					tok.swallowIfChar(",")
			End Select
		WEnd

	EndMethod
	
EndType
