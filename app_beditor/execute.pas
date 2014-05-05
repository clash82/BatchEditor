unit EXECUTE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Utils;

type
  TExecuteForm = class(TForm)
    ParameterEdit: TComboBox;
    ParameterCaption: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelButtonClick(Sender: TObject);
    function GetParam: String;
    procedure OKButtonClick(Sender: TObject);
    procedure ParameterEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExecuteForm: TExecuteForm;
  Param: String;

implementation

{$R *.DFM}

function TExecuteForm.GetParam: String;
begin
 Application.CreateForm(TExecuteForm, ExecuteForm);
 ExecuteForm.ShowModal;
 Result:= Param;
end;

procedure TExecuteForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:= CaFree;
end;

procedure TExecuteForm.CancelButtonClick(Sender: TObject);
begin
 Param:= '';
 Close;
end;

procedure TExecuteForm.OKButtonClick(Sender: TObject);
Var TextCount: Integer;
begin
 Param:= ParameterEdit.Text;
 SetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'LastParam', PChar(ParameterEdit.Text));
 If ParameterEdit.Items.IndexOf(ParameterEdit.text) = -1 Then
  begin
   if ParameterEdit.Items.Count > 199 then
    begin
     ParameterEdit.Items.Delete(0);
    end;
   ParameterEdit.Items.Add(ParameterEdit.Text);
  end;
 For TextCount:= 0 To ParameterEdit.Items.Count-1 Do
  Begin
   SetRegSubKey(hkey_current_user, PChar('Software\Batch Editor'), PChar('ParamWord'+IntToStr(TextCount)), PChar(ParameterEdit.Items.Strings[TextCount]));
  End;
 Close;
end;

procedure TExecuteForm.ParameterEditChange(Sender: TObject);
begin
 If ParameterEdit.Text = '' Then OKButton.Enabled:= False Else OKButton.Enabled:= True;
end;

procedure TExecuteForm.FormCreate(Sender: TObject);
Var SearchCount: Integer;
begin
 SearchCount:= 0;
 Repeat
  If GetRegSubKey(hkey_current_user, PChar('Software\Batch Editor'), PChar('ParamWord'+IntToStr(SearchCount))) <> '' Then
   Begin
    ParameterEdit.Items.Add(GetRegSubKey(hkey_current_user, PChar('Software\Batch Editor'), PChar('ParamWord'+IntToStr(SearchCount))));
   End;
  SearchCount:= SearchCount+1;
 Until GetRegSubKey(hkey_current_user, 'Software\Batch Editor', PChar('ParamWord'+IntToStr(SearchCount))) = '';
 ParameterEdit.Text:= GetRegSubKey(hkey_current_user, 'Software\Batch Editor', 'LastParam');
 ParameterEdit.OnChange(Self);
end;

end.
