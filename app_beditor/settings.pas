unit SETTINGS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Utils, ComCtrls, ShellAPI;

type
  TSettingsForm = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    FontDialog: TFontDialog;
    OpenDialog: TOpenDialog;
    MainPage: TPageControl;
    GlobalTab: TTabSheet;
    SignatureGroup: TGroupBox;
    SignatureCaption: TLabel;
    SignatureEdit: TEdit;
    SignatureBox: TCheckBox;
    SignatureButton: TButton;
    ViewTab: TTabSheet;
    FontGroup: TGroupBox;
    FontCaption: TLabel;
    FontNameCaption: TLabel;
    FontSizeCaption: TLabel;
    FontName: TLabel;
    FontSize: TLabel;
    FontButton: TButton;
    EditButton: TButton;
    IntergrationTab: TTabSheet;
    IntegrationGroup: TGroupBox;
    IntegrationBox: TCheckBox;
    InegrationCaption: TLabel;
    DefaultButton: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    procedure SignatureButtonClick(Sender: TObject);
    procedure SignatureBoxClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FontButtonClick(Sender: TObject);
    procedure SignatureEditChange(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure DefaultButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;
  strona_kodowa: integer;
  
implementation

uses MAIN;

{$R *.DFM}

procedure TSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TSettingsForm.CancelButtonClick(Sender: TObject);
begin
 Close;
end;

procedure TSettingsForm.SignatureButtonClick(Sender: TObject);
begin
 OpenDialog.InitialDir:= ExtractFileDir(SignatureEdit.Text);
 If OpenDialog.Execute Then
  Begin
   SignatureEdit.Text:= LowerCase(OpenDialog.FileName);
  End;
end;

procedure TSettingsForm.SignatureBoxClick(Sender: TObject);
begin
 If SignatureBox.Checked Then
  Begin
   SignatureEdit.Enabled:= True;
   SignatureButton.Enabled:= True;
  End
 Else
  Begin
   SignatureEdit.Enabled:= False;
   SignatureButton.Enabled:= False;
  End;
end;

procedure TSettingsForm.OKButtonClick(Sender: TObject);
begin
 If Not IntegrationBox.Checked Then
  Begin
   SetRegSubKey(hkey_classes_root, 'batfile\Shell\Edit\Command', '', 'NOTEPAD.EXE "%1"');
   SetRegSubKey(hkey_classes_root, 'cmdfile\Shell\Edit\Command', '', 'NOTEPAD.EXE "%1"');
  End
 Else
  Begin
   SetRegSubKey(hkey_classes_root, 'batfile\Shell\Edit\Command', '', PChar(ParamStr(0)+' "%1"'));
   SetRegSubKey(hkey_classes_root, 'cmdfile\Shell\Edit\Command', '', PChar(ParamStr(0)+' "%1"'));
  End;
 If SignatureBox.Checked Then
  Begin
   SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'UseSignature', '1');
   SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'SignatureFile', PChar(SignatureEdit.Text));
  End
 Else
  Begin
   SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'UseSignature', '0');
  End;
 MainForm.Editor.Font.Name:= FontName.Caption;
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontName', PChar(FontName.Caption));
 MainForm.Editor.Font.Size:= StrToInt(FontSize.Caption);
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontSize', PChar(FontSize.Caption));
 MainForm.Editor.Font.CharSet:= strona_kodowa;
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'FontCharSet', PChar(inttostr(strona_kodowa)));
 Close;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
 If (GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'UseSignature') = '1') Then
  Begin
   SignatureBox.Checked:= True;
   SignatureEdit.Enabled:= True;
   SignatureButton.Enabled:= True;
  End;
 SignatureEdit.Text:= GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'SignatureFile');
 FontName.Caption:= MainForm.Editor.Font.Name;
 FontSize.Caption:= IntToStr(MainForm.Editor.Font.Size);

 If (LowerCase(ExtractFileName(GetRegSubKey(hkey_classes_root, 'batfile\Shell\Edit\Command', ''))) = LowerCase(ExtractFileName(ParamStr(0))+' "%1"'))
  and
 (LowerCase(ExtractFileName(GetRegSubKey(hkey_classes_root, 'cmdfile\Shell\Edit\Command', ''))) = LowerCase(ExtractFileName(ParamStr(0))+' "%1"'))
 Then IntegrationBox.Checked:= True;

 SignatureEdit.OnChange(self);
end;

procedure TSettingsForm.FontButtonClick(Sender: TObject);
begin
 FontDialog.Font.Name:= FontName.Caption;
 FontDialog.Font.Size:= StrToInt(FontSize.Caption);
 FontDialog.Font.Charset:= strona_kodowa;
 If FontDialog.Execute Then
  Begin
   FontName.Caption:= FontDialog.Font.Name;
   FontSize.Caption:= IntToStr(FontDialog.Font.Size);
   strona_kodowa:= FontDialog.Font.Charset;
  End;
end;

procedure TSettingsForm.SignatureEditChange(Sender: TObject);
begin
 If SignatureEdit.Text = '' Then EditButton.Enabled:= False Else EditButton.Enabled:= True;
end;

procedure TSettingsForm.EditButtonClick(Sender: TObject);
begin
 If FileExists(SignatureEdit.Text) Then ShellExecute(SettingsForm.Handle, Nil, 'NOTEPAD.EXE', PChar(SignatureEdit.Text), Nil, Sw_ShowNormal);
end;

procedure TSettingsForm.DefaultButtonClick(Sender: TObject);
begin
   FontName.Caption:= 'Terminal';
   FontSize.Caption:= '9';
   strona_kodowa:= 255;
end;

end.
