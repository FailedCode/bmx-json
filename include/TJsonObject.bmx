
Type TJsonObject Extends TJsonNode

	Method _parse(tok:TStringTokenStreamer)
		While Not tok.Eof()
			Select tok.nextNonWsChar()
				Case "~q"
					_parsePair(tok)
					tok.swallowIfChar(",")
				Case "}"
					Return
				Default
					_parseError "<Json> expects '~q' (key/value pair) or '}'", tok
			End Select
		EndWhile
	EndMethod
	
EndType
