unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses cartman;

{$R *.dfm}





var buf: t128buf = (0, 0, 0, 0);
var cb: t128buf;
var tkey: array [0..15] of longword;
const test_count=10;

procedure TForm1.Button1Click(Sender: TObject);
var i, n: integer; error: boolean;
begin

memo1.Clear;

error:=false;

randomize();

for i:=0 to test_count-1 do begin

buf[0]:=random(maxlong);
buf[1]:=random(maxlong);
buf[2]:=random(maxlong);
buf[3]:=random(maxlong);



for n:=0 to 15 do tkey[n]:=random(maxlong);


cartman_setkey(@tkey);   // Loading then key

memo1.lines.Add(#13#10#13#10+'KEY: ');
memo1.Lines.Add(Format('%8x %8x %8x %8x',[key[0],key[1],key[2],key[3] ]));

memo1.lines.Add('ORIGINAL: ');
memo1.Lines.Add(Format('%8x %8x %8x %8x',[buf[0],buf[1],buf[2],buf[3]]));

move(buf,cb,16);
cartman_crypt(@cb); // Encryption of 4-longwords (128 bit block)

cartman_killkey(); // Burning key

memo1.lines.Add('ENCRYPTED: ');
memo1.Lines.Add(Format('%8x %8x %8x %8x',[cb[0],cb[1],cb[2],cb[3]]));


cartman_setkey(@tkey);   // Loading then key

cartman_decrypt(@cb); // Decryption of 4-longwords (64 bit block)

memo1.lines.Add('DECRYPTED: ');
memo1.Lines.Add(Format('%8x %8x %8x %8x',[cb[0],cb[1],cb[2],cb[3]]));

if (cb[0]<>buf[0]) or (cb[1]<>buf[1]) or (cb[2]<>buf[2]) or (cb[3]<>buf[3]) then error:=true;

if error then memo1.Lines.Add('DECODED TO BAD DATA!!!') else

memo1.Lines.Add('DECODED OK');

end;


memo1.Lines.Add(#13#10#13#10#13#10+' ------------------------------  ');

if error then memo1.Lines.Add('TEST FAILED, DECODED DATA IS BAD.') else
memo1.Lines.Add(FORMAT('ALL %U TESTS FINISHED OK!',[test_count]));


end;

end.
