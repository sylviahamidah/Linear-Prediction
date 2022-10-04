unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, Grids,
  SDL_matrix;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Button2: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    ListBox1: TListBox;
    StringGrid1: TStringGrid;
    Button3: TButton;
    Matrix1: TMatrix;
    StringGrid2: TStringGrid;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Button4: TButton;
    Button5: TButton;
    Matrix2: TMatrix;
    Button6: TButton;
    Series2: TLineSeries;
    Chart2: TChart;
    Series3: TLineSeries;
    Button7: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  filename: TextFile;
  x, rxx, a, a_inv, e, x_baru: array[-100000..100000] of Extended;
  Ndata, JumlahTimeLag, UkuranMatrik2: integer;


implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 i : integer;
begin
 i:=0;
 assignfile(filename,'dataset.txt');
 reset(filename);
 while not eof(filename) do
 begin
 readln(filename,x[i],x[i]);
 i:=i+1;
 end;
 Ndata:=i-1;
 CloseFile(filename);
 for i := 0 to Ndata-1 do
 begin
 Series1.AddXY(i, x[i]);
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 L,n : integer;
 sum : real;
 s : string;
begin
 JumlahTimeLag := StrToInt(Edit1.Text);
 for L := 0 to JumlahTimeLag do
 begin
 sum:=0.0;
 for n := 0 to Ndata-1 do
 begin
 sum:=sum + X[n]*X[n-L];
 end;
 rxx[L]:=sum ;
 rxx[-L]:=rxx[L];
 Str(rxx[L]:2:5, s);
 Listbox1.Items.Add('rxx['+inttostr(L)+']= '+s );
 end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 UkuranMatrik1,i, k: integer;
 s: string;
begin
 UkuranMatrik1:=JumlahTimeLag;
 Matrix1.Resize(UkuranMatrik1,UkuranMatrik1); // Matrix1.Resize(Col,Row)
 for i := 1 to UkuranMatrik1 do
 begin
 for k := 1 to UkuranMatrik1 do
 begin
 Matrix1.Elem[i,k] := rxx[(i-1)-(k-1)];
 str(Matrix1.Elem[i,k]:5:5, s);
 StringGrid1.Cells[k-1,i-1] := s ; end; end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 UkuranMatrik1,i, k: integer;
 s: string;
begin
 UkuranMatrik1:=JumlahTimeLag;
 Matrix1.Invert;
 for i := 1 to UkuranMatrik1 do
 begin
  for k := 1 to UkuranMatrik1 do
  begin
  str(Matrix1.Elem[i,k]:5:10, s);
  StringGrid2.Cells[i-1, k-1] := s;
  end;
 end;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
 i,k:integer;
 HasilKaliMatrik: real;
 s: string;
begin
 UkuranMatrik2:=JumlahTimeLag;
 Matrix2.Resize(1,UkuranMatrik2);
 for i := 1 to UkuranMatrik2 do
 begin
 HasilKaliMatrik := 0;
 for k := 1 to UkuranMatrik2 do
 begin
 HasilKaliMatrik := HasilKaliMatrik + (Matrix1.Elem[k,i]*rxx[k]);
 end;
 a[i]:=HasilKaliMatrik;
 Str(a[i], s);
 Listbox2.Items.Add('a['+inttostr(i)+']= '+s );
 end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
 i,k:integer;
 x_hat: real;
 s: string;
begin
for i := 1 to UkuranMatrik2 do
 begin
 a_inv[i]:=-a[i];
 end;
 {------Mencari e(m) menggunakan Invers Filtering-------}
 for i:=0 to Ndata-1 do
 begin
 x_hat:=0;
 e[i]:=0;
 for k:=1 to JumlahTimeLag do
 begin
 x_hat:=x_hat+(a_inv[k]*x[i-k]);
 end;
 e[i]:=x[i]+x_hat;
 Series2.AddXY(i, e[i]);
 Str(e[i], s);
 Listbox3.Items.Add('e['+inttostr(i)+']= '+s );
 end;end;


procedure TForm1.Button7Click(Sender: TObject);
var
 i,k : integer;
 Sum2 : real;begin
{------------Membentuk Sinyal Hasil Rekontruksi--------}
 for i:=-JumlahTimeLag to -1 do
 begin
 x_baru[i] := 0;
 end;
 for i := 0 to Ndata-1 do
 begin
  sum2:=0.0;
  for k:=1 to JumlahTimeLag do
  begin
  sum2:=sum2+a[k]*x[i-k];
  end;
 x_baru[i]:=sum2+e[i];
 end;
 for i := 0 to Ndata-1 do
 begin
 Series3.AddXY(i, x_baru[i]);
 end;
end;


end.
