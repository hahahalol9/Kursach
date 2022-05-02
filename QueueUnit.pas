unit QueueUnit;

interface

Type
    TSymbolPointer = ^TSymbol;
    TSymbol = Record
        Next : TSymbolPointer;
        Value : Char;
    End;
    TTextQueue = class
        Head,Tail : TSymbolPointer;
        procedure SetString(Str : String);
        function ToString(Size : Integer): String;
        function Peek() : Char;
        procedure Enqueue(Ch : Char);
        function Dequeue():Char;
        function IsEmpty():Boolean;
        procedure Clear();
    end;

implementation


procedure TTextQueue.SetString(Str : String);
var
  I: Integer;
Begin
    Clear();
    if Length(Str)>0 then
    Begin
        New(Head);
        Head^.Value := Str[1];
        Tail := Head;
        for I := 2 to Length(Str) do
        Begin
            New(Tail^.Next);
            Tail := Tail^.Next;
            Tail^.Value := Str[I];
        End;
        Tail^.Next := nil;
    End;
End;

function TTextQueue.ToString(Size : Integer): String;
Var
    Str : String;
    CurrPointer : TSymbolPointer;
    I : Integer;
Begin
    Str := '';
    CurrPointer := Head;
    I := 0;
    while (I<Size) And (CurrPointer<>nil) do
    Begin
        Str := Str + CurrPointer.Value;
        CurrPointer := CurrPointer^.Next;
        Inc(I);
    End;
    ToString := Str;
End;

function TTextQueue.Peek() : Char;
Begin
    Peek := Head^.Value;
End;

procedure TTextQueue.Enqueue(Ch : Char);
Begin
    if Head=nil then
    Begin
        New(Head);
        Head^.Next := nil;
        Head^.Value := Ch;
        Tail := Head;
    End
    Else
    Begin
        New(Tail^.Next);
        Tail := Tail^.Next;
        Tail^.Next := nil;
        Tail^.Value := Ch;
    End;
End;

function TTextQueue.Dequeue():Char;
Var
    Temp : TSymbolPointer;
Begin
    Temp := Head;
    if Tail = Head then
    Begin
        Tail := nil;
    End;
    Head := Head^.Next;
    Dispose(Temp);
End;

function TTextQueue.IsEmpty():Boolean;
Begin
    IsEmpty := Head = nil;
End;

procedure TTextQueue.Clear();
Var
    Temp : TSymbolPointer;
Begin
    while Head <> nil do
    Begin
        Temp := Head;
        Head := Head^.Next;
        Dispose(Temp);
    End;
    Tail := nil;
End;

end.
