{$R+}{$Q+}
program FoxHunt;
Uses Crt,Graph,StLib;
const MaxX=13;
      MaxY=13;
const empty=9;
const MaxFox=8;
const Xs=36;
      Ys=36;

type FoxData=object
  x,y:byte;
  cond:boolean;
end;

type scoreData=object
 Names:string[10];
 mov  :byte;
end;

type HiScores=array[1..21] of scoreData;

var map,r:array[1..MaxX,1..MaxY] of byte;
    mx,my:byte;
    str1,str2:string;
    dx,dy:shortInt;
    fox:array[1..MaxFox] of FoxData;
   { caught,}saw:byte;

    timer,tt:byte;

    lastHi:byte;
    last:byte;
    ch:array[1..10] of char;
    LastN:byte;
    show:boolean;
    victory:byte;
    tempS:ScoreData;
    Hi:HiScores;
    File1:file of HiScores;

    x1,x2,y1,y2:integer;

    mx1,my1:integer;
    mx2,my2:integer;
    mb1,mb2:integer;
    mmouse:boolean;
    Marray:array[1..1000] of byte;

{0-5+ NUMBERs}
{.- empty}
{10-1.-marked empty}

procedure showScores;
begin
  show:=false;
  setFillStyle(1,10);
  bar(480,50,635,300);
  setColor(63);
  rectangle(479,49,636,301);
  for i:=1 to 20 do with hi[i] do begin
    str(mov:2,str1);
    str(i  :2,str2);
    if mov>99 then str1:='±±';
    setColor(183);
    if (mov=timer) or ((i=1) and (mov>timer)) then line(481,74+i*10,634,74+i*10);
    if (mov<timer) and (hi[i+1].mov>timer)    then line(481,78+i*10,634,78+i*10);

    if i<>lastHI then setColor(63) else setColor(123);
    outTextXY(485,70+i*10,str2+')'+names);
    outTextXY(618,70+i*10,str1);
    line(614,50,614,300);
  end;
end;

procedure sortScores;
begin
for j:=1 to 21 do begin
  for i:=1 to 20 do begin
    if hi[i].mov>hi[i+1].mov then begin
      TempS:=hi[i];
      hi[i]:=hi[i+1];
      hi[i+1]:=TempS;
      if i+1=lastHi then dec(lastHi);
    end
  end;
end;
{showScores;}
rewrite(file1);
  write(file1,hi);
  close(file1);
end;

procedure eraseScores;
begin
for i:=1 to 21 do with hi[i] do begin
  str(22-i,str1);
  names:='manúú'+str1;
  mov:=99-i*2;
end;
sortScores;
rewrite(file1);
  write(file1,hi);
  close(file1);
end;

procedure NewGame;
begin
reset(file1);
 read(file1,hi);
close(file1);
last:=1;
show:=true;
setFillStyle(1,0);
bar(0,0,640,480);
victory:=0;
timer:=0;
mx:=(maxX+1) div 2;
my:=(maxY+1) div 2;
hi[21].mov:=82;
for i:=1 to maxY do
  for j:=1 to MaxX do begin
    r[j,i]:=1;
    map[j,i]:=empty;
  end;
for i:=1 to MaxFox do with fox[i] do begin
  x:=round(random*(maxX-1)+1);
  y:=round(random*(MaxY-1)+1);
  cond:=false;
end;
if mmouse=true then mouseLocate((mx-1)*Xs+3*xs div 4,(my-1)*Ys+3*ys div 4);
mousePoll(mx1,my1,mb1,mb2);
mx2:=mx1;
my2:=my1;
{getimage(mx1,my1,mx1+10,my1+10,MArray);}
end;

procedure ShowMap;
begin
for i:=1 to maxY do
  for j:=1 to MaxX do if r[j,i]>0 then begin
    r[j,i]:=0;
    case map[j,i] of
      0     :l:=25;
      1..MaxFox  :l:=75+((map[j,i])*2);
    empty   :l:=5;
      10    :l:=7;
      11..(10+MaxFox):l:=150+((map[j,i]-10)*2);
    empty+10:l:=167;
      20    :l:=17;
      21..(20+MaxFox):l:=140+((map[j,i]-20)*2);

    end;
    dx:=0;
    for k:=1 to MaxFox do if (fox[k].x=j) and (fox[k].y=i) and (fox[k].cond=true) then inc(dx);
    if dx>0 then l:=115;

    x1:=(j-1)*Xs+5;
    y1:=(i-1)*Ys+5;
    x2:=(j)*Xs+1;
    y2:=(i)*Ys+1;

    setColor(23);
    recTangle(x1-1,y1-1,x2+1,y2+1);
    setColor(63);
    setFillStyle(1,l);
    bar(x1,y1,x2,y2);
    if (map[j,i]<>empty) and (map[j,i]<>10+empty) and (dx=0) then begin
      if map[j,i]<empty then str(map[j,i],str1) else str(map[j,i]-10,str1);
      if map[j,i]>=20 then str(map[j,i]-20,str1);
      outTextXY((x1+x2) div 2-4,
                (y1+y2) div 2-4,str1);
    end;
    if map[j,i]>=20 then begin
      ellipse((x1+x2) div 2,
              (y1+y2) div 2,0,360,xs div 2-4,ys div 3);
    end;
    setColor(252);
    if dx>0 then for k:=1 to dx do begin
       outTextXY((x1+x2) div 2-4-(dx+1)*4+k*8,
                 (y1+y2) div 2-4,'o');
       outTextXY((x1+x2) div 2-4-(dx+1)*4+k*8,
                 (y1+y2) div 2-4,'Y');
    end;
  end
end;

procedure adv(ax,ay:shortInt);
begin
if (ax>0) and (ay>0) and (ax<=MaxX) and (ay<=MaxY) then begin
  if map[ax,ay]<10 then inc(map[ax,ay],10);
  r[ax,ay]:=1;
end;
end;

BEGIN
randomize;
MouseInit;
SetGraficMode(2);
{  1- 63 white}
{ 64-126 green}
{127-189 blue }
{190-252 red  }
for i:=1 to 63 do SetRGBPalette(i    ,i,i,i);
for i:=1 to 63 do SetRGBPalette(i +63,0,i,0);
for i:=1 to 63 do SetRGBPalette(i+126,0,0,i);
for i:=1 to 63 do SetRGBPalette(i+189,i,0,0);
SetRGBPalette(253,63,0,60);
assign(file1,'Scores.fox');

{$I-}
reset(file1);
{$I+}
if ioresult<>0 then eraseScores else close(file1);

LastN:=0;
lastHi:=0;
MMouse:=true;
NewGame;
repeat
showMap;
  setfillStyle(1,0);
  bar(500,450,640,470);

  j:=0;
  for i:=1 to 20 do begin
    if hi[i].mov=timer then j:=i*2;
    if (hi[i].mov<timer) and (hi[i+1].mov>timer) then j:=i*2+1;
  end;
  if j<>last then begin
    last:=j;
    show:=true;
  end;

  if show=true then showScores;


  setColor(63);
  str(timer,str1);
  outTextXY(500,461,'MOVES:'+str1);
  str1:='';
  for i:=1 to MaxFox do if fox[i].cond=false then str1:=str1+'*';
  outTextXY(500,451,'FOXES:');
  setColor(252);
  outTextXY(548,451,str1);
  if str1='' then begin
    setColor(63);
    if victory<2 then begin
      setTextStyle(0,0,9);
      outTextXY(0,200,'VICTORY!');
      setTextStyle(0,0,0);
    end;
    if Victory=0 then begin
      victory:=1;
      if timer<hi[20].mov then begin
         for i:=1 to 7 do begin
           if i<7 then k:=80+i*7 else k:=63;
           setColor(k);
           setTextStyle(0,0,i);
           outTextXY(i,240+7*i,'High Score');
         end;
        setTextStyle(0,0,0);

         setColor(63);
         rectangle(499,369,631,391);
         setFillStyle(1,10);

         if lastN=0 then for i:=1 to 10 do ch[i]:=chr(0);
         i:=lastN;
         repeat
           bar(500,370,630,390);
           if i>0 then
             for j:=1 to i do outTextXY(520+j*8,375,ch[j]);

           outTextXY(528+i*8,375,'@');
           key:=readKey;
           case key of
            'a'..'z','A'..'Z','1'..'9','0',' ','(',')':
              if i<10 then begin
                inc(i);
                ch[i]:=key;
              end;
            '-','+','*','/':if i>0 then dec(i);
           end;
         until (key=enter);
         lastN:=i;
         str1:='';
         for j:=1 to i do str1:=str1+ch[j];
         if str1='' then str1:='Incognito';
        with hi[21] do begin
          names:=str1;
          mov:=timer;
        end;
        lastHi:=21;
        SortScores;
        ShowScores;
      end;
    end;
  end;

  j:=62;
  k:=-1;
  getimage(mx1,my1,mx1+10,my1+10,MArray);
  repeat
    key:='|';

    inc(j,k);
    if j=32 then k:=1;
    if j=63 then k:=-1;
    setColor(j{+189});
    x1:=(mx-1)*Xs+5;
    y1:=(my-1)*Ys+5;
    x2:=(mx)*Xs+1;
    y2:=(my)*Ys+1;
    recTangle(x1-2,y1-2,x2+2,y2+2);

    if keyPressed then key:=readKey;

    if Mmouse=true then begin
      mousePoll(mx1,my1,mb1,mb2);
      my1:=round(my1/200*480);
      if mx1>MaxX*xs then mx1:=MaxX*xs;
      if my1>MaxY*ys then my1:=MaxY*ys;
      mouseLocate(mx1,round(my1/480*200));

      if (mx2<>mx1) or (my2<>my1) then begin
        Putimage(mx2,my2,MArray,normalPut);
        getimage(mx1,my1,mx1+10,my1+10,MArray);
      end;
      mx2:=mx1;
      my2:=my1;

      setColor(253);
      line(mx1   ,my1   ,mx1+10,my1+10);
      line(mx1+ 1,my1   ,mx1+10,my1+ 9);
      line(mx1   ,my1+ 1,mx1+ 9,my1+10);
      line(mx1   ,my1   ,mx1+ 5,my1   );
      line(mx1   ,my1   ,mx1   ,my1+ 5);
      line(mx1   ,my1   ,mx1+ 6,my1+ 1);
      line(mx1   ,my1   ,mx1+ 1,my1+ 6);
      if mb1=1 then key:=enter;
      if mb2=2 then key:=f1;
      if (mb1=1) or (mb2=2) then begin
        r[mx,my]:=1;
        mx:=round((mx1+xs/2)/xs);
        my:=round((my1+ys/2)/ys);
        if mx>MaxX then mx:=MaxX;
        if my>MaxY then my:=MaxY;
        if mx<1 then mx:=1;
        if my<1 then my:=1;
      end;
    end;
  until key<>'|';
  setColor(0);
  recTangle(x1-2,y1-2,x2+2,y2+2);
  Putimage(mx2,my2,MArray,normalPut);


  r[mx,my]:=1;
  case Key of
      up:if my>1    then dec(my);
    down:if my<MaxY then inc(my);
    left:if mx>1    then dec(mx);
   right:if mx<MaxX then inc(mx);
      f1:if (map[mx,my]<>empty) and (map[mx,my]<>10+empty) then begin
           if map[mx,my]>=20 then dec(map[mx,my],10);
           dx:=-MaxX;
           dy:=-MaxY;
           repeat
             adv(mx+dx,my   );
             adv(mx   ,my+dy);
             adv(mx+dx,my+dy);
             adv(mx-dx,my+dy);
             inc(dx);
             inc(dy)
           until (dx>=MaxX+1) and (dy>=MaxY+1);;
           inc(map[mx,my],10);
         end;
      f2:begin
           if (map[mx,my]>10) and (map[mx,my]<20) then dec(map[mx,my],10);
           if (map[mx,my]>=20) then dec(map[mx,my],20);
         end;
      f3:if (map[mx,my]<10) then inc(map[mx,my],10);
      f5:for i:=1 to maxY do
           for j:=1 to maxX do
             if (map[j,i]>9) and (map[j,i]<20) then begin
               dec(map[j,i],10);
               r[j,i]:=1
             end;
     '{':begin
           for i:=1 to MaxFox do begin
             fox[i].cond:=true;
             r[fox[i].x,fox[i].y]:=1;
           end;
           victory:=2;
         end;
   enter:if map[mx,my]=empty then begin
           if timer<255 then inc(timer,1);
           saw:=0;
           for i:=1 to MaxFox do with fox[i] do begin
             dx:=abs(x-mx);
             dy:=abs(y-my);
             if (dx=dy) and (dx=0) then cond:=true;
{             if (dx=dy) then inc(saw);}
             if ((dx=0) or (dy=0)) or (dx=dy) then inc(saw);
           end;
{           if saw=6 then halt;}
           map[mx,my]:=saw;
         end;
     'q':NewGame;
  end;
  r[mx,my]:=1;
until key=f10;
restoreCRTMode;
CloseGraph;
END.