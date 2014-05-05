unit PARAM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Utils;

type
  TParamForm = class(TForm)
    ParamEdit: TEdit;
    QuestionCaption: TLabel;
    OKButton: TButton;
    CancelButton: TButton;
    ParamCount: TLabel;
    function GetParam(Question, Title: String; Count: Byte): String;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKButtonClick(Sender: TObject);
    procedure ParamEditChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ParamForm: TParamForm;
  UserParam: String;

implementation

{$R *.DFM}

function TParamForm.GetParam(Question, Title: String; Count: Byte): String;
 Begin
 Application.CreateForm(TParamForm, ParamForm);
 ParamForm.Caption:= Title;
 ParamForm.QuestionCaption.Caption:= Question;
 ParamForm.ParamCount.Caption:= Replace(LoadStr(19), '%1', IntToStr(Count), False);
 ParamForm.ShowModal;
 Result:= UserParam;
 End;

procedure TParamForm.CancelButtonClick(Sender: TObject);
begin
 UserParam:= '';
 Close;
end;

procedure TParamForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= caFree;
end;

procedure TParamForm.OKButtonClick(Sender: TObject);
begin
 UserParam:= ParamEdit.Text;
 Close;
end;

procedure TParamForm.ParamEditChange(Sender: TObject);
begin
 If ParamEdit.Text = '' Then OKButton.Enabled:= False Else OKButton.Enabled:= True;
end;

end.
