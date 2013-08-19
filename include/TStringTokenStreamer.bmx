'
' This class allows for reading a string a char at a time and other nifty things that go well in parsing text.
'
Type TStringTokenStreamer

	Const WHITESPACE:String = Chr($20) + Chr($09) + Chr($0a) + Chr($0d) 'Space + Horizontal tab + Line feed Or New line + Carriage Return
	
	Field str:String
	Field pos:Int

	Function Create:TStringTokenStreamer(s:String)
		Local r:TStringTokenStreamer = New TStringTokenStreamer
		r.str = s
		r.pos = 0
		Return r
	End Function

	Method nextChar:String()
		If Eof() Return ""
		Local c:String = Chr(str[pos])
		pos:+1
		Return c
	End Method

	Method nextNonWsChar:String()
		Local c:String
		Repeat
			c = nextChar()
		Until Not WHITESPACE.Contains(c)
		Return c
	End Method
	
	Method previousChar:String()
		If pos - 1 > 0 Then Return Chr(str[pos - 1])
		Return ""
	End Method
	
	Method swallowIfChar(char:String)
		If char <> nextNonWsChar() Then pos:-1
		If pos < 0 Then pos = 0
	EndMethod
	
	Method lookAheadChar:String()
		If Not Eof() Then Return Chr(str[pos])
		Return ""
	End Method
	
	Method Eof:Int()
		Return (pos >= str.Length)
	End Method
EndType
