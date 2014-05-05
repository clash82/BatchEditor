unit UTILS;

interface

Uses Windows, Controls, Graphics, SysUtils, Registry;

Procedure AddImage(Target: TImageList; ResName: String);
function replace(str,s1,s2:string;casesensitive:boolean):string;
Function GetTempDir: String;
Function Slash(Value: String): String;
Function GetWinDir: String;
Procedure DelFile(FileName: String);
Procedure SetRegSubKey(Local: HKey; Root, KeyName, KeyData: PChar);
Procedure SetRegKey(Local: HKey; Root: PChar);
Function GetRegSubKey(Local: HKey; Root, KeyName: PChar): String;
Procedure DeleteRegKey(Local: HKey; Root: PChar);
function CopyFromChar(s:string;c:char;l:integer):string;

implementation

function CopyFromChar(s:string;c:char;l:integer):string;
var i:integer;
begin
i:=pos(c,s);
result:=copy(s,i,l);
end;

Procedure SetRegSubKey(Local: HKey; Root, KeyName, KeyData: PChar);
Var Reg: TRegistry;
 Begin
 Reg := TRegistry.Create;
  Try
   Reg.RootKey:= Local;
   Reg.OpenKey(Root, True);
   Reg.WriteString(KeyName, KeyData);
  Finally;
  Reg.Free;
 End;
 End;

Procedure SetRegKey(Local: HKey; Root: PChar);
Var Reg: TRegistry;
 Begin
  Reg := TRegistry.Create;
   Try
    Reg.RootKey:= Local;
    Reg.CreateKey(Root);
   Finally;
  Reg.Free;
  End;
 End;

Function GetRegSubKey(Local: HKey; Root, KeyName: PChar): String;
Var Reg: TRegistry;
 Begin
  Reg := TRegistry.Create;
   Try
    Reg.RootKey:= Local;
    Reg.OpenKey(Root, True);
    Result:= Reg.ReadString(KeyName);
   Finally;
  Reg.Free;
  End;
 End;

Procedure DeleteRegKey(Local: HKey; Root: PChar);
Var Reg: TRegistry;
 Begin
  Reg := TRegistry.Create;
   Try
    Reg.RootKey:= Local;
    Reg.DeleteKey(Root);
   Finally;
  Reg.Free;
  End;
 End;

Procedure DelFile(FileName: String);
Var TmpFile: TextFile;
 begin
  If FileExists(FileName) Then
   Begin
    AssignFile(TmpFile, FileName);
    {$I-}
    Erase(TmpFile);
    {$I+}
   End;
 end;

Function Slash(Value: String): String;
 begin
  if (value='') then result:='' else
   begin
    if (value[length(value)]<>'\') then result:=value+'\' else result:=value;
   end;
  end;

Function GetWinDir: String;
var PCharBuffer: PChar;
    DWordBuffer: DWord;
begin
  DWordBuffer:=255;
  PCharBuffer:=StrAlloc(255);
  GetWindowsDirectory(PCharBuffer, DWordBuffer);
  GetWinDir:=String(PCharBuffer);
  StrDispose(PCharBuffer);
end;

Function GetTempDir: String;
 Var
  Dir: Array[0..255] Of Char;
  Size: Integer;
 Begin
  Size:= SizeOf(Dir) - 1;
  GetTempPath(Size, Dir);
  If Dir = '' Then GetTempDir:= Slash(Slash(GetWinDir)) Else GetTempDir:= Slash(Dir);
 End;

function replace(str,s1,s2:string;casesensitive:boolean):string;
var
  i:integer;
  s,t:string;
begin
  s:='';
  t:=str;
  repeat
    if casesensitive then i:=pos(s1,t) else i:=pos(lowercase(s1),lowercase(t));
      if i>0 then
      begin
        s:=s+Copy(t,1,i-1)+s2;
        t:=Copy(t,i+Length(s1),MaxInt);
      end
      else
        s:=s+t;
  until i<=0;
  result:=s;
end;

Procedure AddImage(Target: TImageList; ResName: String);
Var Bitmap: TBitmap;
Begin
  Bitmap := TBitmap.Create;
  bitmap.Handle:= loadbitmap(hinstance, pchar(resname));
  target.AddMasked(bitmap, BitMap.Canvas.Pixels[0,0]);
  bitmap.free;
end;

end.
