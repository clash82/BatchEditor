unit ABOUT;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ShellAPI, ExtCtrls;

type
  TAboutForm = class(TForm)
    NameCaption: TLabel;
    CloseButton: TButton;
    CopyrightCaption: TLabel;
    Url: TLabel;
    Logo: TImage;
    Url3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure UrlClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:= CaFree;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  Logo.Picture.Icon.Handle:= Application.Icon.Handle;
end;

procedure TAboutForm.UrlClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', PChar('http://'+TLabel(Sender).Caption), nil, nil, Sw_ShowNormal);
end;

end.
