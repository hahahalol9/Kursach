unit MainUnit;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,System.Generics.Collections,QueueUnit,TypeInfo,StatisticViewUnit,
  Vcl.ExtCtrls,TypeControllerUnit,FileOperationsUnit,PathsUnit,MusicPlayerUnit,bass,OverallStatisticUnit,
  Vcl.Menus,FontSettingsUnit,AudioSettingsUnit,AddMusicUnit,TypeUnit,AddTextUnit,AdditionalFormUnit,
  Vcl.Touch.Keyboard,SettingsUnit, Vcl.Imaging.pngimage;

type
    TAppState = (NotTyping,Typing,Paused,TypingFinished);
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    exts1: TMenuItem;
    EnglishMenu: TMenuItem;
    RussianMenu: TMenuItem;
    OtherMenu: TMenuItem;
    AddTextItem: TMenuItem;
    Statistic1: TMenuItem;
    MainPanel: TPanel;
    Music1: TMenuItem;
    Next: TMenuItem;
    Stop: TMenuItem;
    Continue: TMenuItem;
    AddVolume: TMenuItem;
    LowerVolume: TMenuItem;
    S1: TMenuItem;
    Instruction1: TMenuItem;
    procedure OnNotTyping();
    procedure OnFinish();
    procedure OnPause();
    procedure OnTyping();
    procedure OnUnpause();
    procedure LoadFileNamesToMenuItem(MenuItem : TMenuItem;Paths : TList<String>);
    procedure FormCreate(Sender: TObject);
    procedure LoadFileNamesToMenu();
    procedure ShowPauseForm();
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure LoadTypeFormToPanel();
    procedure AddTextItemClick(Sender: TObject);
    procedure OnAddTextClose();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NextClick(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure ContinueClick(Sender: TObject);
    procedure AddVolumeClick(Sender: TObject);
    procedure LowerVolumeClick(Sender: TObject);
    procedure OnOverallStatisticClose();
    procedure Statistic1Click(Sender: TObject);
    procedure ShowSettings();
    procedure OnCloseSettings();
    procedure S1Click(Sender: TObject);
    procedure UpdateSettings();
    procedure ShowTextError();
    class procedure CentralizeControl(Control : TControl);
    procedure Instruction1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

Const
    ENTER = 13;
    ESCAPE = 27;
    INSTRUCTION_TEXT = 'Press Esc to pause'+#13#10+'You can choose lessong from texts menu'+
    #13#10+'If your session is longer than 25 seconds'+#13#10+'it will be save into statistic';

implementation

Var
    StatisticForm : TTypeStatisticForm;
    AppState : TAppState;
    MusicPlayer : TMusicPlayer;
    Settings : TSettings;

{$R *.dfm}



class procedure TMainForm.CentralizeControl(Control : TControl);
Begin
      Control.Left := (Screen.Width - Control.Width) div 2;
      Control.Top := (Screen.Height - Control.Height) div 2;
End;

procedure TMainForm.UpdateSettings();
Var
    Volume : Single;
Begin
    TypeForm.SetSettings(Settings);
    Volume := Settings.MusicVolume;
    Volume := Volume/100;
    MusicPlayer.SetVolume(Volume);
End;

procedure TMainForm.S1Click(Sender: TObject);
begin
    ShowSettings();
end;

procedure TMainForm.ShowSettings();
Begin
    if (AppState = NotTyping) then
    Begin
        self.Enabled:=False;
        SettingsForm := TSettingsForm.Create(nil,OnCloseSettings,Settings);
        CentralizeControl(SettingsForm);
        SettingsForm.Show();
    End;
End;

procedure TMainForm.OnCloseSettings();
Begin
    self.Enabled := True;
    Settings := SettingsForm.Settings;
    UpdateSettings();
End;

procedure TMainForm.OnNotTyping();
Begin
    AppState := NotTyping;
    TypeForm.OnNotTyping();
    self.Enabled:=True;
End;

procedure TMainForm.OnPause();
Begin
    AppState := Paused;
    self.Enabled:=False;
    ShowPauseForm();
    TypeForm.OnPause();
End;

procedure TMainForm.ShowTextError();
Begin
    MessageDlg('This lessong  is empty!'+#13#10+'You can choose lesson in texts menu'+
    #13#10+'Choose another lesson!',mtConfirmation, mbOKCancel, 0);
    AppState:=NotTyping;
    self.Enabled:=True;
    LoadFileNamesToMenu;
End;

procedure TMainForm.OnTyping();
Begin
    if  TypeForm.OnStart() then
    Begin
        AppState := Typing;
    End
    Else
    Begin
        AppState := Paused;
        Self.Enabled := False;
        ShowTextError();
    End;
End;

procedure TMainForm.OnUnpause();
Begin
    AppState := Typing;
    TypeForm.OnUnpause();
    self.Enabled:=True;
End;

procedure TMainForm.LoadTypeFormToPanel();
Begin
    TypeForm := TTypeForm.Create(nil,OnFinish);
    TypeForm.Parent := MainPanel;
    TypeForm.Show();
End;


procedure TMainForm.LowerVolumeClick(Sender: TObject);
begin
    MusicPlayer.LowerVolume(Settings);
end;

procedure TMainForm.NextClick(Sender: TObject);
begin
    MusicPlayer.PlayNext();
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (AppState = NotTyping) then
    Begin
        If (Ord(Key)=Enter) then
            OnTyping();
    End
    Else if AppState=Typing then
    Begin
        if Ord(Key) = ESCAPE then
            OnPause()
        Else
            TypeForm.OnTryType(Key);
    End;
end;


procedure TMainForm.Instruction1Click(Sender: TObject);
Var
    Dlg: TForm;
begin
    Dlg:= CreateMessageDialog(Instruction_Text, mtInformation, [mbOk], mbOK);
    Dlg.Caption := 'Instruction';
    Dlg.ShowModal;
    Dlg.Free;
end;

procedure TMainForm.LoadFileNamesToMenu();
Begin
    LoadFileNamesToMenuItem(EnglishMenu,TFileOperations.ReadFilePathsFromDirectory(TPaths.GetEnglishTextsDirectory()));
    LoadFileNamesToMenuItem(OtherMenu,TFileOperations.ReadFilePathsFromDirectory(TPaths.GetOtherTextsDirectory()));
    LoadFileNamesToMenuItem(RussianMenu,TFileOperations.ReadFilePathsFromDirectory(TPaths.GetRussianTextsDirectory()));
End;


procedure TMainForm.AddTextItemClick(Sender: TObject);
begin
    if (AppState = NotTyping) then
    Begin
        self.Enabled:=False;
        AddTextForm := TAddTextForm.Create(nil,OnAddTextClose);
        CentralizeControl(AddTextForm);
        AddTextForm.Show();
    End;
end;

procedure TMainForm.OnAddTextClose();
Begin
    self.Enabled:=True;
    LoadFileNamesToMenu();
End;

procedure TMainForm.OnOverallStatisticClose();
Begin
    self.Enabled := True;
End;

procedure TMainForm.AddVolumeClick(Sender: TObject);
begin
    MusicPlayer.AddVolume(Settings);
end;

procedure TMainForm.ContinueClick(Sender: TObject);
begin
    MusicPlayer.Continute();
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    BASS_Free();
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    CentralizeControl(self);
    MusicPlayer := TMusicPlayer.Create(Handle);
    LoadTypeFormToPanel();
    LoadFileNamesToMenu();
    OnNotTyping();
    If not TFileOperations.TryReadSettings(Settings) then
    Begin
        Settings.Size := 35;
        Settings.MusicVolume := 50;
        Settings.TextColor := clBlack;
        Settings.PrintedTextColor := clSkyBlue;
    End;
    UpdateSettings();
end;

procedure TMainForm.OnFinish();
Begin
    AppState := TypingFinished;
    ShowPauseForm();
    TypeForm.OnFinish();
    self.Enabled:=False;
End;


procedure TMainForm.LoadFileNamesToMenuItem(MenuItem : TMenuItem;Paths : TList<String>);
Var
    NewItem : TMenuItem;
    Path : String;
    Name :String;
Begin
    MenuItem.Clear();
    for Path in Paths do
    Begin
        NewItem := TMenuItem.Create(MenuItem);
        Name := extractfilename(Path);
        SetLength(Name,Length(Name)-4);
        NewItem.Caption := Name;
        NewItem.ImageName:=Path;
        NewItem.OnClick := TypeForm.SetCurrentText;
        MenuItem.Add(NewItem);
    End;
End;

procedure TMainForm.ShowPauseForm();
Var
    OnOkPr : TOnCloseProcedure;
Begin
    if AppState = TypingFinished then
        OnOkPr := nil
    Else
        OnOkPr := OnUnpause;
    StatisticForm := TTypeStatisticForm.Create(self,TypeForm.TypeController.CurrentStatistic,OnOkPr,OnNotTyping);
    CentralizeControl(StatisticForm);
    StatisticForm.Show();
End;

procedure TMainForm.Statistic1Click(Sender: TObject);
Var
    StatisticArr : TStatisticArr;
begin
    if (AppState = NotTyping) then
    Begin
        Self.Enabled := False;
        TFileOperations.TryReadStatisticArr(StatisticArr);
        OverAllStatisticForm := TOverAllStatisticForm.Create(self,OnOverallStatisticClose,StatisticArr);
        CentralizeControl(OverAllStatisticForm);
        OverAllStatisticForm.Show();
    End;
end;

procedure TMainForm.StopClick(Sender: TObject);
begin
    MusicPlayer.Pause();
end;

end.
