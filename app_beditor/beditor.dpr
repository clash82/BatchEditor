{
  Batch Editor v2.2
  simple batch files editor created in 2001
  prosty edytor plików wsadowych stworzony w 2001 roku

  author: Rafa³ Toborek
  website: http://toborek.info
  sources: http://github.com/clash82/batchEditor/

  projekt stworzony do kompilacji w œrodowisku Delphi 7 SE
}

program BEDITOR;

uses
  Forms, SysUtils, Windows,
  MAIN in 'MAIN.PAS' {MainForm},
  EXECUTE in 'EXECUTE.PAS' {ExecuteForm},
  PARAM in 'PARAM.PAS' {ParamForm},
  SETTINGS in 'SETTINGS.PAS' {SettingsForm},
  ABOUT in 'ABOUT.PAS' {AboutForm},
  UTILS in 'UTILS.PAS';

{$R *.RES}


begin
  If Not FileExists(ChangeFileExt(ParamStr(0), '.KMD')) Then
   Begin
    MessageBox(Application.Handle, PChar(LoadStr(20)), 'Batch Editor - b³¹d', MB_OK or MB_ICONERROR);
    Exit;
   End;
  Application.Initialize;
  Application.Title := 'Batch Editor';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
