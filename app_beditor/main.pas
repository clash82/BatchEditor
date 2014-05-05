unit MAIN;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, Menus, Utils, StdCtrls, ExtCtrls, ShellAPI, ImgList;

type
  TMainForm = class(TForm)
    ToolBar: TToolBar;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;
    StatusBar: TStatusBar;
    NewButton: TToolButton;
    OpenButton: TToolButton;
    SaveButton: TToolButton;
    ExecuteButton: TToolButton;
    CommandsButton: TToolButton;
    SettingsButton: TToolButton;
    HelpButton: TToolButton;
    ExitButton: TToolButton;
    ActiveButtonsList: TImageList;
    ExitSubMenu: TMenuItem;
    Editor: TRichEdit;
    SeparatorPanel: TPanel;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ExecuteMenu: TPopupMenu;
    ExecuteRunMenu: TMenuItem;
    ExecuteParamRunMenu: TMenuItem;
    NewSubMenu: TMenuItem;
    OpenSubMenu: TMenuItem;
    SaveSubMenu: TMenuItem;
    SaveAsSubMenu: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    CharmapRunMenu: TMenuItem;
    CalcRunMenu: TMenuItem;
    NoteRunMenu: TMenuItem;
    ClipRunMenu: TMenuItem;
    Separator3: TMenuItem;
    ToolsSubMenu: TMenuItem;
    CharmapToolsMenu: TMenuItem;
    CalcToolsMenu: TMenuItem;
    NoteToolsMenu: TMenuItem;
    Separator4: TMenuItem;
    ExecuteSubMenu: TMenuItem;
    ExecuteParamSubMenu: TMenuItem;
    Spliter: TSplitter;
    CommandsPanel: TPanel;
    Separator5: TMenuItem;
    CommandsSubMenu: TMenuItem;
    CommandsTree: TTreeView;
    AddButton: TButton;
    CommandsMemo: TMemo;
    EditMenu: TMenuItem;
    CutSubMenu: TMenuItem;
    CopySubMenu: TMenuItem;
    PasteSubMenu: TMenuItem;
    DelSubMenu: TMenuItem;
    Separator6: TMenuItem;
    SelAllSubMenu: TMenuItem;
    Separator7: TMenuItem;
    WrapSubMenu: TMenuItem;
    FindDialog: TFindDialog;
    FindSubMenu: TMenuItem;
    Separator8: TMenuItem;
    Separator9: TMenuItem;
    SettingsSubMenu: TMenuItem;
    ContextMenu: TPopupMenu;
    FindContextMenu: TMenuItem;
    Separator10: TMenuItem;
    CutContextMenu: TMenuItem;
    CopyContextMenu: TMenuItem;
    PasteContextMenu: TMenuItem;
    DelContextMenu: TMenuItem;
    Separator11: TMenuItem;
    SelAllContextMenu: TMenuItem;
    Separator12: TMenuItem;
    WrapContextMenu: TMenuItem;
    AboutSubMenu: TMenuItem;
    Separator14: TMenuItem;
    UrlSubMenu: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditorChange(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure ExecuteRunMenuClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ExecuteParamRunMenuClick(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure SaveAsSubMenuClick(Sender: TObject);
    procedure CharmapRunMenuClick(Sender: TObject);
    procedure CalcRunMenuClick(Sender: TObject);
    procedure NoteRunMenuClick(Sender: TObject);
    procedure CommandsButtonClick(Sender: TObject);
    procedure SpliterMoved(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure CommandsTreeClick(Sender: TObject);
    procedure CommandsTreeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CutSubMenuClick(Sender: TObject);
    procedure CopySubMenuClick(Sender: TObject);
    procedure PasteSubMenuClick(Sender: TObject);
    procedure DelSubMenuClick(Sender: TObject);
    procedure SelAllSubMenuClick(Sender: TObject);
    procedure WrapSubMenuClick(Sender: TObject);
    procedure FindSubMenuClick(Sender: TObject);
    procedure FindDialogFind(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure CommandsTreeKeyPress(Sender: TObject; var Key: Char);
    procedure EditorKeyPress(Sender: TObject; var Key: Char);
    procedure AboutSubMenuClick(Sender: TObject);
    procedure UrlSubMenuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  TextChange: Boolean;
  TextFileName: String;
  TS, LabelS, CountS, CommandS, QuestionS, CaptionS: TStringList;

implementation

uses EXECUTE, PARAM, SETTINGS, ABOUT;

{$R *.DFM}

procedure MakeNew;
begin
 MainForm.Editor.Clear;
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'UseSignature') = '1' Then
  Begin
   If FileExists(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'SignatureFile')) Then MainForm.Editor.Lines.LoadFromFile(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'SignatureFile'));
  End;
 TextFileName:= LoadStr(12);
 MainForm.Caption:= Application.Title+' — '+LoadStr(12);
 TextChange:= False;
 MainForm.StatusBar.SimpleText:= LoadStr(14);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var LF: TextFile;
    LT: String;
    ME: Integer;

begin
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontName') <> '' Then Editor.Font.Name:= GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontName');
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontSize') <> '' Then Editor.Font.Size:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontSize'));
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontCharSet') <> '' Then Editor.Font.CharSet:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontCharSet'));

 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'WrapText') = '1' Then
  Begin
   WrapSubMenu.Click;
  End;
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Width') <> '' Then MainForm.Width:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Width'));
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Height') <> '' Then MainForm.Height:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Height'));
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Left') <> '' Then
  Begin
   MainForm.Position:= poDesigned;
   MainForm.Left:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Left'));
  End;
 If GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Top') <> '' Then MainForm.Top:= StrToInt(GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Top'));

 AddImage(ActiveButtonsList, 'B_NEW');
 AddImage(ActiveButtonsList, 'B_OPEN');
 AddImage(ActiveButtonsList, 'B_SAVE');
 AddImage(ActiveButtonsList, 'B_EXECUTE');
 AddImage(ActiveButtonsList, 'B_COMMANDS');
 AddImage(ActiveButtonsList, 'B_SETTINGS');
 AddImage(ActiveButtonsList, 'B_HELP');
 AddImage(ActiveButtonsList, 'B_EXIT');
 If ParamStr(1) = '' Then MakeNew Else
  Begin
   If Not FileExists(ParamStr(1)) Then
    Begin
     MessageBox(MainForm.Handle, PChar(Replace(LoadStr(13), '%1', ExtractFileName(ParamStr(1)), False)), PChar(Application.Title), MB_OK or MB_ICONERROR);
     MakeNew;
    End
   Else
    Begin
     Editor.Lines.LoadFromFile(ParamStr(1));
     TextChange:= False;
     StatusBar.SimpleText:= LoadStr(14);
     MainForm.Caption:= Application.Title+' — '+ExtractFileName(ParamStr(1));
     TextFileName:= ParamStr(1);
    End;
  End;

 // wczytanie pliku komend
 AssignFile(LF, ChangeFileExt(ParamStr(0), '.KMD'));
 Reset(LF);
 LabelS:= TStringList.Create;
 CountS:= TStringList.Create;
 CommandS:= TStringList.Create;
 QuestionS:= TStringList.Create;
 CaptionS:= TStringList.Create;
 TS := TStringList.create;

        Repeat
         Repeat
          ReadLn(LF, LT);
          If LT[1] = '[' Then
           Begin
            CommandsTree.Items.Add(nil, CopyFromChar(LT, LT[AnsiPos('[', LT)+1], Length(LT)-2));
            Me:= CommandsTree.Items.Count-1;
            TS.Insert(CommandsTree.Items.Count-1, '-');

            LabelS.Insert(CommandsTree.Items.Count-1, '-');
            CountS.Insert(CommandsTree.Items.Count-1, '-');
            CommandS.Insert(CommandsTree.Items.Count-1, '-');
            QuestionS.Insert(CommandsTree.Items.Count-1, '-');
            CaptionS.Insert(CommandsTree.Items.Count-1, '-');
           End;
          Until LT[1] = '[';
         Repeat
          ReadLn(LF, LT);
          If LT <> '' Then
           Begin
            CommandsTree.Items.AddChild(CommandsTree.Items.Item[me], CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1 ));
            TS.Insert(CommandsTree.Items.Count-1, CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1));

            LabelS.Insert(CommandsTree.Items.Count-1, CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1 ));
            
            LT:= Copy(LT, AnsiPos('^', LT)+1, Length(LT));
            CountS.Insert(CommandsTree.Items.Count-1, CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1));
            LT:= Copy(LT, AnsiPos('^', LT)+1, Length(LT));
            CommandS.Insert(CommandsTree.Items.Count-1, CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1));
            LT:= Copy(LT, AnsiPos('^', LT)+1, Length(LT));
            QuestionS.Insert(CommandsTree.Items.Count-1, CopyFromChar(LT, LT[1], AnsiPos('^', LT)-1));
            LT:= Copy(LT, AnsiPos('^', LT)+1, Length(LT));
            CaptionS.Insert(CommandsTree.Items.Count-1, LT);

           End;
          Until LT = '';
         Until Eof(LF);
       CloseFile(LF);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 If TextChange Then
  Begin
   Case MessageBox(MainForm.Handle, PChar(Replace(LoadStr(11), '%1', ExtractFileName(TextFileName), False)), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION) Of
    IDCANCEL: CanClose:= False;
    IDNO: CanClose:= True;
    IDYES:
     Begin
      If TextFileName <> LoadStr(12) Then Editor.Lines.SaveToFile(TextFileName) Else
       Begin
        If SaveDialog.Execute Then
         Begin
          Editor.Lines.SaveToFile(SaveDialog.FileName);
          CanClose:= True;
         End
        Else
         Begin
          CanClose:= False;
         End;
       End;
     End;
   End;
  End;
end;

procedure TMainForm.EditorChange(Sender: TObject);
begin
 TextChange:= True;
 StatusBar.SimpleText:= LoadStr(15);
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
begin
 If TextFileName <> LoadStr(12) Then
  Begin
   Editor.Lines.SaveToFile(TextFileName);
   TextChange:= False;
   StatusBar.SimpleText:= LoadStr(14);
  End
 Else
  Begin
   If SaveDialog.Execute Then
    Begin
     Editor.Lines.SaveToFile(SaveDialog.FileName);
     TextFileName:= SaveDialog.FileName;
     MainForm.Caption:= Application.Title+' — '+ExtractFileName(TextFileName);
     TextChange:= False;
     StatusBar.SimpleText:= LoadStr(14);
    End;
  End;
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
 If TextChange Then
  Begin
   Case MessageBox(MainForm.Handle, PChar(Replace(LoadStr(11), '%1', ExtractFileName(TextFileName), False)), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION) Of
    IDCANCEL: Exit;
    IDNO:
     Begin
      If OpenDialog.Execute Then
       Begin
        Editor.Lines.LoadFromFile(OpenDialog.FileName);
        TextFileName:= OpenDialog.FileName;
        TextChange:= False;
        StatusBar.SimpleText:= LoadStr(14);
        MainForm.Caption:= Application.Title+' — '+ExtractFileName(OpenDialog.FileName);
       End;
      Exit;
      End;
    IDYES:
     Begin
      If TextFileName <> LoadStr(12) Then Editor.Lines.SaveToFile(TextFileName) Else
       Begin
        If SaveDialog.Execute Then
         Begin
          Editor.Lines.SaveToFile(SaveDialog.FileName);
          MainForm.Caption:= Application.Title+' — '+ExtractFileName(SaveDialog.FileName);
          TextChange:= False;
          StatusBar.SimpleText:= LoadStr(14);
          TextFileName:= SaveDialog.FileName;
         End;
       End;
      If OpenDialog.Execute Then
       Begin
        Editor.Lines.LoadFromFile(OpenDialog.FileName);
        TextFileName:= OpenDialog.FileName;
        TextChange:= False;
        StatusBar.SimpleText:= LoadStr(14);
        MainForm.Caption:= Application.Title+' — '+ExtractFileName(OpenDialog.FileName);
       End Else Exit;
     End;
   End;
  End
  Else
   Begin
    If OpenDialog.Execute Then
     Begin
      Editor.Lines.LoadFromFile(OpenDialog.FileName);
      TextFileName:= OpenDialog.FileName;
      TextChange:= False;
      StatusBar.SimpleText:= LoadStr(14);
      MainForm.Caption:= Application.Title+' — '+ExtractFileName(OpenDialog.FileName);
     End Else Exit;
   End;
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.ExecuteRunMenuClick(Sender: TObject);
begin
 Editor.Lines.SaveToFile(GetTempDir+'BE_TEMP.BAT');
 WinExec(PChar(GetTempDir+'BE_TEMP.BAT'), Sw_ShowNormal);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 If WrapSubMenu.Checked Then SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'WrapText', '1') Else SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'WrapText', '0');
 If MainForm.WindowState = wsMaximized Then MainForm.WindowState:= wsNormal;
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Width', PChar(IntToStr(MainForm.Width)));
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Height', PChar(IntToStr(MainForm.Height)));
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Left', PChar(IntToStr(MainForm.Left)));
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'Top', PChar(IntToStr(MainForm.Top)));
 DelFile(GetTempDir+'BE_TEMP.BAT');

 TS.Free;
 LabelS.Free;
 CountS.Free;
 CommandS.Free;
 QuestionS.Free;
 CaptionS.Free;

 Action:= CaFree;
end;

procedure TMainForm.ExecuteParamRunMenuClick(Sender: TObject);
Var Param: String;
begin
 Param:= ExecuteForm.GetParam;
 If Param <> '' Then
  Begin
   Editor.Lines.SaveToFile(GetTempDir+'BE_TEMP.BAT');
   ShellExecute(MainForm.Handle, Nil, PChar(GetTempDir+'BE_TEMP.BAT'), PChar(Param), Nil, Sw_ShowNormal);
  End
 Else Exit;
end;

procedure TMainForm.NewButtonClick(Sender: TObject);
begin
 If TextChange Then
  Begin
   Case MessageBox(MainForm.Handle, PChar(Replace(LoadStr(11), '%1', ExtractFileName(TextFileName), False)), PChar(Application.Title), MB_YESNOCANCEL or MB_ICONQUESTION) Of
    IDCANCEL: Exit;
    IDNO: MakeNew;
    IDYES:
     Begin
      If TextFileName <> LoadStr(12) Then
       Begin
        Editor.Lines.SaveToFile(TextFileName)
       End
      Else
       Begin
        If SaveDialog.Execute Then Editor.Lines.SaveToFile(SaveDialog.FileName) Else Exit;
       End;
      MakeNew;
     End;
   End;
  End
 Else
  Begin
   MakeNew;
  End;
end;

procedure TMainForm.SaveAsSubMenuClick(Sender: TObject);
begin
 If SaveDialog.Execute Then
  Begin
   Editor.Lines.SaveToFile(SaveDialog.FileName);
   MainForm.Caption:= Application.Title+' — '+ExtractFileName(SaveDialog.FileName);
   TextFileName:= SaveDialog.FileName;
   TextChange:= False;
   StatusBar.SimpleText:= LoadStr(14);
  End;
end;

procedure TMainForm.CharmapRunMenuClick(Sender: TObject);
begin
 ShellExecute(MainForm.Handle, Nil, 'CHARMAP.EXE', Nil, Nil, Sw_ShowNormal);
end;

procedure TMainForm.CalcRunMenuClick(Sender: TObject);
begin
 ShellExecute(MainForm.Handle, Nil, 'CALC.EXE', Nil, Nil, Sw_ShowNormal);
end;

procedure TMainForm.NoteRunMenuClick(Sender: TObject);
begin
 ShellExecute(MainForm.Handle, Nil, 'NOTEPAD.EXE', Nil, Nil, Sw_ShowNormal);
end;

procedure TMainForm.CommandsButtonClick(Sender: TObject);
begin
 If Not CommandsPanel.Visible Then
  Begin
   CommandsPanel.Visible:= True;
   Spliter.Width:= 3;
   CommandsButton.Down:= True;
   CommandsSubMenu.Checked:= True;
   MainForm.OnResize(Self);
   Spliter.OnMoved(Self);
   CommandsTree.SetFocus;
  End
 Else
  Begin
   Spliter.Width:= 0;
   CommandsPanel.Visible:= False;
   CommandsButton.Down:= False;
   CommandsSubMenu.Checked:= False;
   Editor.SetFocus;
  End;
end;

procedure TMainForm.SpliterMoved(Sender: TObject);
begin
 CommandsTree.Width:= CommandsPanel.Width-15;
 CommandsMemo.Width:= CommandsPanel.Width-15;
 AddButton.Left:= CommandsPanel.Width-82;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
 CommandsTree.Height:= CommandsPanel.Height-145;
 CommandsMemo.Top:= CommandsTree.Height+15;
 AddButton.Top:= CommandsMemo.Top+95;
end;

procedure TMainForm.AddButtonClick(Sender: TObject);
Var Counter: Byte;
    ParamLine, ConfirmLine: String;
begin
 ParamLine:= '';
 If TS.Strings[CommandsTree.Selected.Absoluteindex] = '-' Then Exit;
 If CountS.Strings[CommandsTree.Selected.Absoluteindex] = '0' Then
  Begin
   If MessageBox(MainForm.Handle, PChar(LoadStr(16)), PCHar(Application.Title), MB_YESNO or MB_ICONQUESTION) = IDYES Then Editor.Lines.Add(CommandS.Strings[CommandsTree.Selected.Absoluteindex]);
  End
 Else
  Begin
   For Counter:= 1 to StrToInt(CountS.Strings[CommandsTree.Selected.Absoluteindex]) Do
    Begin
     ConfirmLine:= ParamForm.GetParam(QuestionS.Strings[CommandsTree.Selected.Absoluteindex], LabelS.Strings[CommandsTree.Selected.Absoluteindex], Counter);
     If ConfirmLine = '' Then Exit;
     If ParamLine = '' Then ParamLine:= Replace(CommandS.Strings[CommandsTree.Selected.Absoluteindex], '%'+IntToStr(Counter), ConfirmLine, False) Else ParamLine:= Replace(ParamLine, '%'+IntToStr(Counter), ConfirmLine, False);
    End;
   If ParamLine <> '' Then Editor.Lines.Add(ParamLine);
   End;
end;

procedure TMainForm.CommandsTreeClick(Sender: TObject);
begin
 If CommandsTree.Items.Count <> 0 Then
  Begin
   If (TS.Strings[CommandsTree.Selected.Absoluteindex] <> '-') Then
    Begin
     CommandsMemo.Enabled:= True;
     AddButton.Enabled:= True;
     CommandsMemo.Text:= CaptionS.Strings[CommandsTree.Selected.Absoluteindex];
    End
   Else
    Begin
     CommandsMemo.Clear;
     AddButton.Enabled:= False;
     CommandsMemo.Enabled:= False;
    End;
  End;
end;

procedure TMainForm.CommandsTreeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 CommandsTree.OnClick(Self);
end;

procedure TMainForm.CutSubMenuClick(Sender: TObject);
begin
 Editor.CutToClipboard;
end;

procedure TMainForm.CopySubMenuClick(Sender: TObject);
begin
 Editor.CopyToClipboard;
end;

procedure TMainForm.PasteSubMenuClick(Sender: TObject);
begin
 Editor.PasteFromClipboard;
end;

procedure TMainForm.DelSubMenuClick(Sender: TObject);
begin
 Editor.ClearSelection;
end;

procedure TMainForm.SelAllSubMenuClick(Sender: TObject);
begin
 Editor.SelectAll;
end;

procedure TMainForm.WrapSubMenuClick(Sender: TObject);
begin
 If WrapSubMenu.Checked Then
  Begin
   WrapSubMenu.Checked:= False;
   WrapContextMenu.Checked:= False;
   Editor.WordWrap:= False;
   Editor.ScrollBars:= ssBoth;
  End
 Else
  Begin
   WrapSubMenu.Checked:= True;
   WrapContextMenu.Checked:= True;
   Editor.WordWrap:= True;
   Editor.ScrollBars:= ssVertical;
  End;
end;

procedure TMainForm.FindSubMenuClick(Sender: TObject);
begin
 FindDialog.Execute;
end;

procedure TMainForm.FindDialogFind(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: integer;
begin
  with Editor do
  begin
    if SelLength <> 0 then StartPos := SelStart + SelLength
    else
     StartPos := 0;
    ToEnd := Length(Text) - StartPos;
     FoundAt := FindText(FindDialog.FindText, StartPos, ToEnd, []);
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog.FindText);
    end
    Else
    begin
     MessageBox(FindDialog.Handle, PChar(LoadStr(18)), PChar(LoadStr(17)), MB_OK or MB_ICONINFORMATION);
    end;
  end;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
 Application.CreateForm(TSettingsForm, SettingsForm);
 SettingsForm.ShowModal;
end;

procedure TMainForm.CommandsTreeKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 Then AddButton.Click;
end;

procedure TMainForm.EditorKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #27 Then Close;
end;

procedure TMainForm.AboutSubMenuClick(Sender: TObject);
begin
 Application.CreateForm(TAboutForm, AboutForm);
 AboutForm.ShowModal;
end;

procedure TMainForm.UrlSubMenuClick(Sender: TObject);
begin
  // prosze pozostawic adres autora dla potomnych :-)
  ShellExecute(MainForm.Handle, Nil, PChar('http://toborek.info'), Nil, Nil, Sw_ShowNormal);
end;

end.
