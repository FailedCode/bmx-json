
Type TJsonNode Extends TMap

	Function _parseError(msg:String, tok:TStringTokenStreamer)
		Local excerpt:String = Mid(tok.str, tok.pos - 5, 10)
		Throw msg + ". Pos: " + tok.pos + " (tot)Length: " + tok.str.Length + " excerpt: '" + excerpt + "'"
	End Function

	Method _parse(tok:TStringTokenStreamer) Abstract

	Function Create:TJsonNode(utf8:String)
		Local tok:TStringTokenStreamer = TStringTokenStreamer.Create(Utf8ToBmxString(utf8))
		Local r:TJsonNode
		Select tok.nextNonWsChar()
			Case "{"
				r = New TJsonObject
			Case "["
				r = New TJsonArray
			Default
				_parseError "<Json> expects '{' or '['.", tok
		End Select
		r._parse(tok)
		Return r
	EndFunction

	Method _parseString:String(tok:TStringTokenStreamer)
		'DebugLog "_parseString() ->"
		Local qmode:Int = False
		Local c:String
		Local r:String
		Repeat
			c = tok.nextChar()
			If c = "" Then _parseError "<Json> unterminated string", tok
			If c = "~q" And Not qmode Then Exit
			If Not qmode And c = "\" Then qmode = True
			
			Select qmode
				Case True
					Select tok.nextChar()
						Case "~q", "\", "/"
							r:+tok.previousChar()
						Case "b"
							r:+Chr($08)
						Case "f"
							r:+Chr($0c)
						Case "n"
							r:+Chr($0a)
						Case "r"
							r:+Chr($0d)
						Case "t"
							r:+Chr($09)
						Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f"
							Local _hex:String = tok.previousChar() + tok.nextChar() + tok.nextChar() + tok.nextChar()
							If Len(_hex) < 4 Then _parseError "<Json> expected 4 hexadecimal digits", tok
							r:+Chr(Int("$" + _hex))
						Default
							_parseError "<Json> expected '~q', 'b', 'f', 'n', 'r', 't' or 4 hexadeimal digits", tok
					End Select
					qmode = False
				Case False
					r:+c
			End Select
			
		Forever
		'DebugLog "_parseString() <- :" + r
		Return r
	End Method
	
	'quite naive parser making use of bmx built in capabilities, without checking for syntax correctness.
	Method _parseNumber:String(tok:TStringTokenStreamer)
		'DebugLog "_parseNumber() ->"
		
		'Gold parser regexp base:
		'Number = '-'?('0'|{Digit9}{Digit}*)('.'{Digit}+)?([Ee][+-]?{Digit}+)?
		
		
		'Working but only int parser:
		'---8<------		
		Rem
		
		Const DIGITS:String = "0123456789"
		Local num:String = tok.previousChar()
		While DIGITS.Contains(tok.lookAheadChar())
			num:+tok.nextChar()
		EndWhile
		
		EndRem
		
		'---8<------		

		
		
		Local num:String = tok.previousChar()
		
		While "0123456789.eE+-".Contains(tok.lookAheadChar())
			num:+tok.nextChar()
		WEnd

		Local intVal:Int = num.ToInt()
		Local floatVal:Double = num.ToDouble()
		
		Const EPSILON:Double = 0.1E-6
				
		If Abs(floatVal - intVal) < EPSILON
			num = String.FromInt(intVal)
		Else
			num = String.FromDouble(floatVal)
		EndIf		
		
		'DebugLog "_parseNumber() <- :" + num
		Return num

	EndMethod
	
	Method _parseValue(tok:TStringTokenStreamer, putInKey:String)
		'DebugLog "inserts to " + putInKey
		Select tok.nextNonWsChar()
			Case "~q"
				Insert(putInKey, _parseString(tok))
			Case "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
				Insert(putInKey, _parseNumber(tok))
			Case "{"
				Local o:TJsonObject = New TJsonObject
				o._parse(tok)
				Insert(putInKey, o)
			Case "["
				Local a:TJsonArray = New TJsonArray
				a._parse(tok)
				Insert(putInKey, a)
			Case "t" 'true
				Local t:String = tok.previousChar() + tok.nextChar() + tok.nextChar() + tok.nextChar()
				If Not t = "true" Then _parseError "<Json> Value. Expected 'true'", tok
				Insert(putInKey, "true")
			Case "f" 'false
				Local t:String = tok.previousChar() + tok.nextChar() + tok.nextChar() + tok.nextChar() + tok.nextChar()
				If Not t = "false" Then _parseError "<Json> Value. Expected 'false'", tok
				Insert(putInKey, "false")
			Case "n" 'null
				Local t:String = tok.previousChar() + tok.nextChar() + tok.nextChar() + tok.nextChar()
				If Not t = "null" Then _parseError "<Json> Value. Expected 'null'", tok
				Insert(putInKey, Null)
			Default
				_parseError "<Json> Value. Expected '~q', '-', '0'-'9', '{', '[', 't', 'f', 'n'", tok
		End Select
	EndMethod
	
	Method _parsePair(tok:TStringTokenStreamer)
		Local key:String = _parseString(tok)
		If Not tok.nextNonWsChar() = ":" Then _parseError "<Json> expects ':'", tok
		_parseValue(tok, key)
	EndMethod
	
	'get value from path
	Method xPath:String(path:String)
		'DebugLog "path: " + path
		Local valNames:String[] = path.Split("/")
				
		If valNames[0] = "" Return "<TJsonNode> Object"
		If Contains(valNames[0])
			If String(ValueForKey(valNames[0]))
				Return String(ValueForKey(valNames[0]))
			ElseIf TJsonNode(ValueForKey(valNames[0]))
				Return TJsonNode(ValueForKey(valNames[0])).xPath( "/".join(valNames[1..]) )
			ElseIf Not ValueForKey(valNames[0]) ' Null
				Return "null"
			Else
				Return "Unknown type?" 'should not happen!
			End If
		Else
			Return ""
		EndIf
	End Method
	
EndType
