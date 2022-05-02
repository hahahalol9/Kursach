unit FileOperationsUnit;

interface
Uses
    TypeInfo,IOUtils,System.Generics.Collections,System.SysUtils,Classes,PathsUnit,SettingsUnit;
Type
    TStatisticFile = File of TTypeStatistic;
    TSettingsFile = File of TSettings;
    TFileOperations = class
            class function TrySaveStatisticArr(StatisticArr:TStatisticArr): Boolean;static;
            class function TryReadStatisticArr(Var StatisticArr:TStatisticArr):Boolean;static;
            class function ReadFilePathsFromDirectory(DirectoryPath : String):TList<String>;static;
            class function TryReadFile(Path : String;Var Text : String):Boolean;static;
            class function TryCopyText(OldFilePath : String;NewFilePath : String):Boolean;static;
            class function TrySaveStatistic(Statistic:TTypeStatistic): Boolean;static;
            class function StrippedOfNonAscii(const s: string): string;static;
            class function TrySaveSettings(Settings : TSettings): Boolean;
            class function TryReadSettings(Var Settings : TSettings): Boolean;
    end;

implementation


class function TFileOperations.TrySaveStatistic(Statistic:TTypeStatistic): Boolean;
Var
    CurrentFile : TStatisticFile;
    IsCorrect : Boolean;
    Path : String;
Begin
    Path := TPaths.GetSavePath();
    Assign(CurrentFile,Path);
    IsCorrect := True;
    Try
        Reset(CurrentFile);
        Seek(CurrentFile,FileSize(CurrentFile));
        Write(CurrentFile,Statistic);
    Except
        IsCorrect :=False;
    End;
    Close(CurrentFile);
    TrySaveStatistic := IsCorrect;
End;

class function TFileOperations.TrySaveStatisticArr(StatisticArr:TStatisticArr): Boolean;
Var
    CurrentFile : TStatisticFile;
    IsCorrect : Boolean;
    I  :Integer;
Begin
    Assign(CurrentFile,TPaths.GetSavePath());
    IsCorrect := True;
    Try
        Reset(CurrentFile);
        Seek(CurrentFile,FileSize(CurrentFile));
    Except
        IsCorrect :=False;
    End;
    Close(CurrentFile);
    if IsCorrect then
    Begin
        for I := 0 to High(StatisticArr) do
            write(CurrentFile,StatisticArr[I]);
        Close(CurrentFile);
    End;
    TrySaveStatisticArr := IsCorrect;
End;

class function TFileOperations.TryReadStatisticArr(Var StatisticArr:TStatisticArr):Boolean;
Var
    Size : Integer;
    IsCorrect : Boolean;
    CurrentFile : TStatisticFile;
    I  :Integer;
Begin
    AssignFile(CurrentFile,TPaths.GetSavePath());
    IsCorrect := True;
    Try
        Reset(CurrentFile);
    Except
        IsCorrect := False;
    End;
    Size := 0;
    while IsCorrect And (not Eof(CurrentFile)) do
    Begin
        Inc(Size);
        SetLength(StatisticArr,Size);
        Read(CurrentFile,StatisticArr[Size-1]);
    End;
    Close(CurrentFile);
    TryReadStatisticArr := IsCorrect And (Size>0);
End;

class function TFileOperations.ReadFilePathsFromDirectory(DirectoryPath : String):TList<String>;
Var
    List : TList<String>;
    SR: TSearchRec;
Begin
    List := TList<String>.Create();
    Try
      if FindFirst(DirectoryPath + '*.*', faAnyFile, SR) = 0 then
      begin
        repeat
          if (SR.Attr <> faDirectory) then
          begin
            List.Add(DirectoryPath+SR.Name);
          end;
        until FindNext(SR) <> 0;
        FindClose(SR);
      end;
    Except

    End;
    ReadFilePathsFromDirectory := List;
End;


class function TFileOperations.TryReadFile(Path : String;Var Text : String):Boolean;
Var
    IsCorrect : Boolean;
Begin
    IsCorrect := True;
    Try
        Text:=TFile.ReadAllText(Path);
        Text := Utf8ToString(Text);
        Text := Trim(Text);
        Text := StringReplace(Text, #13#10, #32, [rfReplaceAll]);
    Except
        IsCorrect := False;
    End;
    TryReadFile := IsCorrect;
End;


class function TFileOperations.TryCopyText(OldFilePath : String;NewFilePath : String):Boolean;
Var
    IsCorrect : Boolean;
    Text : String;
    MyText: TStringlist;
Begin
    IsCorrect := TFileOperations.TryReadFile(OldFilePath,Text);
    if IsCorrect then
    Begin
        MyText:=TStringList.Create();
        Try
            IsCorrect := Length(Text)>0;
            if IsCorrect then
            Begin
                MyText.Add(Text);
                MyText.SaveToFile(NewFilePath);
            End;
        Except
            IsCorrect := False;
        End;
    End;
    TryCopyText := IsCorrect;
End;


class function TFileOperations.StrippedOfNonAscii(const s: string): string;
var
  i, Count: Integer;
begin
  SetLength(Result, Length(s));
  Count := 0;
  for i := 1 to Length(s) do begin
    if ((s[i] >= #32) and (s[i] <= #127)) or (s[i] in [#10, #13]) then begin
      inc(Count);
      Result[Count] := s[i];
    end;
  end;
  SetLength(Result, Count);
end;



class function TFileOperations.TrySaveSettings(Settings : TSettings): Boolean;
Var
    CurrentFile :    TSettingsFile ;
    IsCorrect : Boolean;
Begin
     Assign(CurrentFile,TPaths.GetSettingsPath());
     IsCorrect := True;
     Try
        ReWrite(CurrentFile);
        Write(CurrentFile,Settings);
     Except
        IsCorrect :=False;
     End;
     Close(CurrentFile);
     TrySaveSettings := IsCorrect;
End;

class function TFileOperations.TryReadSettings(Var Settings : TSettings): Boolean;
Var
    CurrentFile :    TSettingsFile ;
    IsCorrect : Boolean;
Begin
    IsCorrect := True;
     Assign(CurrentFile,TPaths.GetSettingsPath());
     Try
        Reset(CurrentFile);
        Read(CurrentFile,Settings);
     Except
        IsCorrect := False;
     End;
     Close(CurrentFile);
     TryReadSettings := IsCorrect;
End;


end.
