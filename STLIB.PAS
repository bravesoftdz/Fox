{$Q-}{$R-}{$S-}{$N+}
unit StLib;

InterFace
Uses Crt,dos,graph;
const F1   =#59;
const F2   =#60;
const F3   =#61;
const F4   =#62;
const F5   =#63;
const F6   =#64;
const F7   =#65;
const F8   =#66;
const F9   =#67;
const f10  =#68;
const f11  =#133;
const f12  =#134;

const Esc  =#27;
const enter=#13;

const UpL  =#71;
const Up   =#72;
const UpR  =#73;
const Left =#75;
const Right=#77;
const DownL=#79;
const Down =#80;
const DownR=#81;

const Ins  =#82;
const del  =#83;

var reg:registers;

{Function sgn(base:integer):shortint;}
Function Rnd:real;
{procedure maketables;far;}
Procedure Rkey;
Procedure SetGraficMode(gm:byte);far;
Procedure SetTextMode;far;
Procedure Curs(Visible:boolean);far;
Procedure MouseCover;far;
Procedure MouseInit;far;
Procedure MouseLocate(Row,Column:integer);
Procedure MousePoll(var Row,Column,LeftButton,RightButton:integer);
Procedure MouseShow;far;

Var J,I,K,L : integer;
    key,key1: char;
    Flg   : Boolean;
    RandomBase:real;

{ sint,cost: array [0..359] of double;}

implementation

{function sgn(base:integer):shortint;
begin
  if base < 0 then Sgn:=-1;
  if base > 0 then Sgn:=+1;
  if base = 0 then Sgn:=0
end;}
{---------------------------------}
Procedure Rkey;
begin
 key:=readKey;
 if key=#0 then key1:=readKey;
end;
{---------------------------------}
procedure Curs(Visible:boolean);
Const SizeCursor:word=0;
begin
  with Reg do begin
    if Visible=True then CX:=SizeCursor;
    if Visible=False then begin
      BH:=0;
      AH:=03;
      INTR($10,reg);
      SizeCursor:=Cx;
      CH:=$20
    end;
    AH:=01;
    Intr($10,Reg)
  end
end; {Cursor}
{------------------------------------------}
{--------}

procedure SetTextMode;
begin
TextMode(co80+font8x8);
mouseInit;
ClrScr;
randomize;
curs(false)
end;
{----------------------}
Procedure SetGraficMode(gm:byte);
var GraphDriver : integer;
    GraphMode   : integer;
    ErrorCode   : integer;
begin
  MouseInit;

  Graphdriver :=installUserDriver('svga256',nil);
  Graphdriver :=16;
  GraphMode:=gm;
  InitGraph(GraphDriver,GraphMode,'c:\tp7\bgi\');
  ErrorCode := GraphResult;
  if ErrorCode <> grOk then
    begin
      Writeln ('Graph error: ', GraphErrorMsg(ErrorCode));
      Writeln ('Program halted');
      Halt(1)
    end;
end;
{-------------------------}
function Rnd:real;
begin
 randomBase:=frac(sqr(sqr(sqr(randomBase+pi))));
 rnd:=RandomBase
end;
{-------------------------}
{Procedure MakeTables;
Begin
  for i:=0 to 359 do
  begin
    sint[i]:=sin(abs(i)*pi/180.0);
    cost[i]:=cos(abs(i)*pi/180.0)
  end;
end;}
Procedure MouseCover;
begin
  Reg.AX:=2;
  intr($33,Reg)
end;
{------------------------------------------}
Procedure MouseInit;
begin
  Reg.AX:=0;
  intr($33,Reg);
  if Reg.AX=0 then begin
   halt;
  end
end;
{--------------------------------------------}
Procedure MouseLocate(Row,Column:integer);
begin
  Reg.AX:=4;
  Reg.CX:=Row;
  Reg.DX:=Column;
  intr($33,Reg)
end;
{--------------------------------------------------}
Procedure MousePoll(var Row,Column,LeftButton,RightButton:integer);
begin
  Reg.AX:=3;
  intr($33,Reg);
  Row:=Reg.CX;
  Column:=reg.DX;
  LeftButton:=(reg.BX and 1);
  RightButton:=(Reg.BX and 2);
end;
{------------------------------------------}
Procedure MouseShow;
begin
  Reg.AX:=1;
  intr($33,Reg)
end;

BEGIN
END.