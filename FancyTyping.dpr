program FancyTyping;

uses
  Vcl.Forms,
  TypeUnit in 'TypeUnit.pas' {TypeForm},
  QueueUnit in 'QueueUnit.pas',
  TypeInfo in 'TypeInfo.pas',
  StatisticViewUnit in 'StatisticViewUnit.pas' {TypeStatisticForm},
  FileOperationsUnit in 'FileOperationsUnit.pas',
  AdditionalFormUnit in 'AdditionalFormUnit.pas',
  MainUnit in 'MainUnit.pas' {MainForm},
  StatisticOperationsUnit in 'StatisticOperationsUnit.pas',
  TypeControllerUnit in 'TypeControllerUnit.pas',
  PathsUnit in 'PathsUnit.pas',
  AddTextUnit in 'AddTextUnit.pas' {AddTextForm},
  MusicPlayerUnit in 'MusicPlayerUnit.pas',
  OverallStatisticUnit in 'OverallStatisticUnit.pas' {OverAllStatisticForm},
  SettingsUnit in 'SettingsUnit.pas' {SettingsForm},
  Vcl.Themes,
  Vcl.Styles,
  bass in 'bass.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOverAllStatisticForm, OverAllStatisticForm);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
