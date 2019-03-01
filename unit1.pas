unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls;

type

  { TGomb }

  TGomb = class(TBitBtn)
    private
    public
      x,y:integer;
  end;
  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    TrackBar1: TTrackBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure jobbklikk(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Megnyom(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


var gombok:array[1..400,1..400] of TGomb;
    akna:array[1..400,1..400] of boolean;
    meret:integer;
    bombaszam,zaszloszam,bombanzaszlo:integer;


procedure ment;
var f:text;
    s:string;
    i,j:integer;
begin
  s:=getenvironmentvariable('Localappdata');
  s:=s+'\Akna';
  createdir(s);
  assignfile(f,s+utf8toansi('\mentés.dat'));
  rewrite(f);
  writeln(f,meret,' ',bombaszam,' ',zaszloszam,' ',bombanzaszlo);
  for i:=1 to meret do
    for j:=1 to meret do
      if not akna[i,j] and
        (gombok[i,j].caption='') then
        writeln(f,1) else
      if (gombok[i,j].caption='') then
        writeln(f,2) else
      if (gombok[i,j].caption='Z') and
        not akna[i,j] then
        writeln(f,4) else
      if (gombok[i,j].caption='Z') then
        writeln(f,5) else begin
          writeln(f,3);
          writeln(f,gombok[i,j].caption);
        end;
  closefile(f);
end;

procedure tolt;
var f:text;
    s:string;
    i,j,c:integer;
begin
  s:=getenvironmentvariable('Localappdata');
  s:=s+'\Akna';
  assignfile(f,s+utf8toansi('\mentés.dat'));
  reset(f);
  readln(f,meret,bombaszam,zaszloszam,bombanzaszlo);
  for i:=1 to 20 do for j:=1 to 20 do begin
    gombok[i,j].Visible:=false;
    gombok[i,j].caption:='';
    akna[i,j]:=false;
    gombok[i,j].Font.size:=0;
  end;
  for i:=1 to meret do for j:=1 to meret do begin
    gombok[i,j].visible:=true;
  end;
  for i:=1 to meret do
    for j:=1 to meret do begin
      readln(f,c);
      case c of
        1: begin
          gombok[i,j].caption:='';
          akna[i,j]:=false;
        end;
        2: begin
          gombok[i,j].Caption:='';
          akna[i,j]:=true;
        end;
        3: begin
          akna[i,j]:=false;
          readln(f,c);
          gombok[i,j].caption:=inttostr(c);
        end;
        4: begin
          akna[i,j]:=false;
          gombok[i,j].Caption:='Z';
          gombok[i,j].Font.color:=clGreen;
        end;
        5: begin
          akna[i,j]:=true;
          gombok[i,j].Caption:='Z';
          gombok[i,j].Font.color:=clGreen;
        end;
      end;
    end;
  closefile(f);
end;

procedure feltar(x,y:integer); //kiírja az aknaszámokat
var dx,dy,ux,uy,s:integer;
begin
  if (x>0) and (y>0) and (x<=meret) and (y<=meret) and (gombok[x,y].caption='') then begin

    s:=0;
    for dx:=-1 to 1 do
      for dy:=-1 to 1 do begin
        ux:=x+dx;
        uy:=y+dy;
        if (ux>0) and (uy>0) and (uy<=meret) and (ux<=meret)
        then
          if akna[ux,uy] then s:=s+1;
      end;
    gombok[x,y].font.color:=clBlack;
    Gombok[x,y].caption:=inttostr(s);
    if s=0 then
      for dx:=-1 to 1 do
        for dy:=-1 to 1 do
          feltar(x+dx,y+dy);
  end;
end;

{ TForm1 }

procedure indit;
var x,y,i,j:integer;
begin

  meret:=Form1.TrackBar1.position;
  for x:=1 to 20 do for y:=1 to 20 do begin
    gombok[x,y].Visible:=false;
    gombok[x,y].caption:='';
    akna[x,y]:=false;
    gombok[x,y].Font.size:=0;
  end;
  randomize;
  for i:=1 to meret do begin
    repeat
      x:=random(meret)+1;
      y:=random(meret)+1;
    until not akna[x,y];
    akna[x,y]:=true;
  end;

  for x:=1 to meret do for y:=1 to meret do begin
    gombok[x,y].visible:=true;
  end;

  bombaszam:=meret;
  zaszloszam:=0;
  bombanzaszlo:=0;

  form1.caption:='Aknakereső';
end;

procedure TForm1.jobbklikk(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,j:integer;
begin
  if Button=mbRight then begin
    i:=TGomb(sender).x;
    j:=TGomb(Sender).y;
    if (gombok[i,j].Caption='') and (zaszloszam<bombaszam) then begin
      gombok[i,j].caption:='Z';
      gombok[i,j].Font.Color:=clGreen;
      gombok[i,j].Font.Size:=0;
      zaszloszam:=zaszloszam+1;
      if akna[i,j] then bombanzaszlo:=bombanzaszlo+1;
      if bombanzaszlo=bombaszam then ShowMessage('Nyertél!');
    end else if gombok[i,j].caption='Z' then begin
      gombok[i,j].font.color:=clBlack;
      gombok[i,j].caption:='';
      gombok[x,y].Font.Size:=0;
      zaszloszam:=zaszloszam-1;
      if akna[i,j] then bombanzaszlo:=bombanzaszlo-1;
    end;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  indit;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  ment;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  tolt;
end;

procedure TForm1.Megnyom(Sender: TObject);
var x,y,i,j:integer;
begin
  if caption<>'Vesztettél!' then begin
    x:=TGomb(Sender).X;
    y:=TGomb(Sender).Y;
    if akna[x,y] then begin
      Caption:='Vesztettél!';
      for i:=1 to meret do
        for j:=1 to meret do
          if akna[i,j] then begin
            gombok[i,j].font.color:=clRed;
            gombok[i,j].caption:='X';
            gombok[i,j].Font.Size:=35;
          end;
    end
    else feltar(x,y);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var x,y,i:integer;
begin
  for x:=1 to 20 do
    for y:=1 to 20 do begin
      gombok[x,y]:=TGomb.Create(Form1);
      gombok[x,y].Parent:=Form1;
      gombok[x,y].Width:=20;
      gombok[x,y].Height:=20;
      gombok[x,y].Left:=(x-1)*20;
      gombok[x,y].Top:=(y-1)*20;
      gombok[x,y].caption:='';
      gombok[x,y].onclick:=@megnyom;
      gombok[x,y].OnMouseDown:=@jobbklikk;
      gombok[x,y].x:=x;
      gombok[x,y].y:=y;
      gombok[x,y].visible:=false;
      akna[x,y]:=false;
    end;
  bombaszam:=meret;
  trackbar1.position:=5;
  indit;
end;



procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  indit;
end;

end.

