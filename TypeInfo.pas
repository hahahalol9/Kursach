unit TypeInfo;

interface

uses
    SysUtils;

Type
    TTypeStatistic = Record
        SymbolsTyped : Integer;
        MistakesCount : Integer;
        TypeSpeed : Integer;
        MistakesRate : Single;
        TypingTimeInSeconds : Integer;
        Date : TDateTime;
        public
            function CalculateMistakesRate() : Single;
            procedure CalculateTypeSpeed();
            procedure SetCurrentDate();
            procedure Clear();
            function GetMistakesRateString():String;
    End;
    TStatisticArr = Array of TTypeStatistic;


implementation

Const
    MISTAKE_RATE_AFTER_DOT_SYMBOLS_COUNT = 1;
    MISTAKE_RATE_SYMBOLS_COUNT = 4;

function TTypeStatistic.CalculateMistakesRate() : Single;
Begin
    if SymbolsTyped = 0 then
        MistakesRate := 0
    Else
    Begin
        MistakesRate := Single(MistakesCount)/(SymbolsTyped+MistakesCount)*100;
        if MistakesRate>100 then
            MistakesRate:=100;
    End;
    CalculateMistakesRate:=MistakesRate;
End;

procedure TTypeStatistic.CalculateTypeSpeed();
Begin
    if TypingTimeInSeconds > 0 then
        TypeSpeed := SymbolsTyped*60 div TypingTimeInSeconds
    Else
        TypeSpeed := SymbolsTyped * 60;
End;


procedure TTypeStatistic.SetCurrentDate();
Begin
    Date := Now;
End;

procedure TTypeStatistic.Clear();
Begin
     SymbolsTyped :=0;
     MistakesCount :=0;
     TypeSpeed :=0;
     MistakesRate :=0;
     TypingTimeInSeconds := 0;
End;

function TTypeStatistic.GetMistakesRateString():String;
Var
    Str : String;
Begin
    Str := floattostrf(MistakesRate, ffFixed, MISTAKE_RATE_SYMBOLS_COUNT, MISTAKE_RATE_AFTER_DOT_SYMBOLS_COUNT );
    GetMistakesRateString := Str;
End;

end.
