unit MusicPlayerUnit;

interface

Uses
    SysUtils, Windows,
  extctrls,bass,Classes,FileOperationsUnit,PathsUnit,System.Generics.Collections,SettingsUnit;
Type
    TMusicPlayer = class
        procedure PlayNext();
        procedure SetSongPaths();
        procedure Pause();
        procedure Continute();
        procedure OnTimerTick(Sender : TObject);
        procedure AddVolume(Var Settings : TSettings);
        procedure LowerVolume(Var Settings : TSettings);
        procedure SetVolume(Volume : Single);
        constructor Create(Handle:HWND);
        public
            Channel : Hstream;
            Paths : TStringList;
            CurrentIndex : Integer;
            IsPaused : Boolean;
            Timer : TTimer;
            Volume : Single;
    end;

implementation
Const
    VOLUME_CHANGE = 0.1;
    INTERVAL = 100;

constructor TMusicPlayer.Create(Handle:HWND);
Begin
    Timer := TTimer.Create(nil);
    Timer.Enabled := True;
    Timer.Interval := INTERVAL;
    Timer.OnTimer := OnTimerTick;
    BASS_INIT(-1,44100,0,Handle,nil);
    Paths := TStringList.Create();
    CurrentIndex := 0;
    IsPaused := True;
    Volume := 0.5;
    Bass_SetVolume(Volume);
    SetSongPaths();
End;

procedure TMusicPlayer.OnTimerTick(Sender : TObject);
Begin
    if (not IsPaused) And (Bass_ChannelIsActive(channel)=0) Or (Bass_ChannelIsActive(channel)=-1)  then
    Begin
        PlayNext();
    End;
End;

procedure TMusicPlayer.PlayNext();
Begin
    if Paths.Count>0 then
    Begin
        if self.Channel>0 then
        Begin
            Bass_StreamFree(Channel);
        End;
        if CurrentIndex >= Paths.Count then
        Begin
            CurrentIndex := 0;
        End;
        Channel := Bass_StreamCreateFile(False,PChar(Paths[CurrentIndex]),0,0,BASS_UNICODE);
        BASS_ChannelPlay(Channel,False);
        Inc(CurrentIndex);
        IsPaused := False;
        Timer.Enabled:=True;
    End;
End;

procedure TMusicPlayer.SetSongPaths();
Var
    List : TList<String>;
    Path : String;
Begin
    List := TFileOperations.ReadFilePathsFromDirectory(TPaths.GetMusicFolder());
    Paths.Clear();
    for Path in List do
    Begin
        Paths.Add(Path);
    End;
End;



procedure TMusicPlayer.Pause();
Begin
    if Channel>0 then
    Begin
        Bass_ChannelPause(channel);
        IsPaused := True;
        Timer.Enabled := False;
    End;
End;

procedure TMusicPlayer.Continute();
Begin
    if IsPaused then
    Begin
        IsPaused := False;
        Bass_ChannelPlay(channel,False);
        Timer.Enabled:=True;
    End;
End;

procedure TMusicPlayer.SetVolume(Volume : Single);
Begin
    self.Volume := Volume;
    Bass_SetVolume(Volume);
End;


procedure TMusicPlayer.AddVolume(Var Settings : TSettings);
Begin
    if Volume <1 then
    Begin
        Volume := Volume + VOLUME_CHANGE;
        Bass_SetVolume(Volume);
        Settings.MusicVolume := Trunc(Volume);
    End;
End;

procedure TMusicPlayer.LowerVolume(Var Settings : TSettings);
Begin
    if Volume > 0 then
    Begin
        Volume := Volume -VOLUME_CHANGE;
        Bass_SetVolume(Volume);
        Settings.MusicVolume := Trunc(Volume);
    End;
End;

end.
