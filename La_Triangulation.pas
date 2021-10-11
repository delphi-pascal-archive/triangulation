//***********************************************************************//
// --------Les principales étapes de l'algorithme-----------------------
// -Les points sont triés selon leurs distances à un point origine fixe.
// -On construit le premier triangle sur les trois premier points.
// -On itère le processus de construction des triangles jusqu'au dernier
//  point.
// -Chaque fois qu'un nauveau triangle est ajouté à la triangulation une
//  critère d'optimation est appliqué "critère Min-Max".

unit La_Triangulation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,Math, Buttons, ExtCtrls, XPMan;
type
TAide =(Cas1,Cas2,Cas3,Cas4,Cas5,Cas6);
TDiagonal=(Diag12,Diag13,Diag23);
TFace =Set of (Face12,Face13,Face23);
TEnsPoint=Set of (P1,P2,P3);

P_Point = ^TPoint3D;
P_NoeudPoint = ^TNoeudPoint;
P_NoeudTriang = ^TNoeudTriang;
P_ListeTriang = ^TListeTriang;
P_NoeudOptime = ^TNoeudOptime;
P_ListeOptime = ^TListeOptime;
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Label6: TLabel;
    Label7: TLabel;
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Button3: TButton;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Déclarations privées}
  public
    { Déclarations publiques}
    Drawing : Boolean;
    Origin : Tpoint;
  end;
 {****** Declaration de Tpoint ******}
TPoint3D = object
 private
 Abs : Real;
 Ord : Real;
 Alt : Real;
 public
 function  Lirepoint:Tpoint3D;
 function  LireAbs:Real;
 function  LireOrd:Real;
 function  LireAlt:Real;
 procedure Defpoint(Ax,Ay,Az:Real);
 procedure DefAbs(Ax:Real);
 procedure DefOrd(AY:Real);
 procedure DefAlt(Az:Real);
 end;
   {Declaration de TDoite}
TDroite = object
  private
   Point1,Point2:^TPoint3D;
   A,B :Real;
  public
    constructor Cdroite(APoint1,APoint2:P_Point);
    destructor Ddroite;
    procedure CalculeAB;
    function  LireP1:P_Point;
    function  LireP2:P_Point;
    function  LireA:Real;
    function  LireB:Real;
 end;
{****** Declaration de TNoeudpoint ******}
 TNoeudPoint=object
 private
 PPoint : ^Tpoint3D;
 NSuivant : P_NoeudPoint;
 public
 constructor CNoeudPoint(APoint:P_Point);
 destructor DNoeudPoint;
 procedure DefSuivant(Anoeud:P_NoeudPoint);
 function  LireSuivant:P_NoeudPoint;
 function  NLirePoint:P_Point;
 procedure Afficher(Color:TColor);
 end;
 {****** Declaration de TListe point ******}
 TListepoint=object
 private
 TeteListe : ^TnoeudPoint;
 public
 constructor CListePoint;
 destructor DListePoint;
 procedure SupprimeListe;
 procedure Insere(PPoint:P_Point);
 function  LireTete:P_NoeudPoint;
 procedure DefTete(PNoeud:P_NoeudPoint);
 end;
   {****** Declaration de TNoeud_Triangle ******}
TNoeudTriang=object
 private
 P1 : ^Tpoint3D;
 P2 : ^Tpoint3D;
 P3 : ^Tpoint3D;
 T12: P_NoeudTriang;
 T13: P_NoeudTriang;
 T23: P_NoeudTriang;
 NSuivant   : P_NoeudTriang;
 NPrecedant : P_NoeudTriang;
 public
 constructor CNoeudTriang(AP1,AP2,AP3:P_Point);
 destructor  DNoeudTriang;
 function  LireP1:P_Point;
 function  LireP2:P_Point;
 function  LireP3:P_Point;
 function  LireT12:P_NoeudTriang;
 function  LireT13:P_NoeudTriang;
 function  LireT23:P_NoeudTriang;
 procedure DefP1(PPoint:P_Point);
 procedure DefP2(PPoint:P_Point);
 procedure DefP3(PPoint:P_Point);
 procedure DefT12(PNoeud:P_NoeudTriang);
 procedure DefT13(PNoeud:P_NoeudTriang);
 procedure DefT23(PNoeud:P_NoeudTriang);
 procedure DefSuivant(ANoeud:P_NoeudTriang);
 function  LireSuivant:P_NoeudTriang;
 procedure Afficher(Color:TColor);
end;

 {****** Declaration de TListe_Triangle ******}
 TListeTriang=object
 private
 TeteListe : P_NoeudTriang;
 public
 constructor CListeTriang;
 destructor DListeTriang;
 procedure SupprimeListe;
 procedure Inserer(PNoeud:P_NoeudTriang);
 function  LireTete:P_NoeudTriang;
end;
 {****** Declaration de TNoeud_Optime ******}
TNoeudOptime=object
 private
 PTriangle : P_NoeudTriang;
 NSuivant : P_NoeudOptime;
 public
 constructor CNoeudOptime(ATriangle:P_NoeudTriang);
 procedure DefSuivant(ANoeud:P_NoeudOptime);
 function  LireSuivant:P_NoeudOptime;
 function  LireTriangle:P_NoeudTriang;
 end;
 {****** Declaration de TListe_Optime ******}
TListeOptime=object
 private
 TeteListe : P_NoeudOptime;
 public
 constructor CListeOptime;
 destructor DListeOptime;
 procedure Inserer(ANoeud:P_NoeudTriang);
 procedure Supprime(ANoeud:P_NoeudOptime);
 function  LireTete:P_NoeudOptime;
end;

{......................FIN DE DECLATION D'OBJETs........................}
{*************************************************************************}
{...................DEBUT DE DECLATION DES PROCEDUREs...................}

procedure Drawshap(Apoint:Tpoint;Amode:Tpenmode;Acolor:Tcolor);
function Taille(P1,P2:P_Point):Real;
procedure Trianguler;
procedure Bon_Triang(PPoint:P_Point);
function GetFace(PTriangle:P_NoeudTriang;PPoint:P_Point):TFace;
function GetTest(P1,P2,P3,PPoint:P_Point):Boolean;
function Parallele(P1,P2,PPoint:P_Point):boolean;
function CalculAngle(P1,P2,P3:P_Point):Real;
function InterLine(Line1,Line2:TDroite):Boolean;
function Optimeser(var Triangle1,Triangle2:P_NoeudTriang;Diagonal:TDiagonal):Boolean;
procedure Optimeser_Liste(PTriang:P_NoeudTriang);
procedure Coller(var Triangle:P_NoeudTriang);
function Si_inclu(P1,P2,P3:P_Point;P:TPoint3D):boolean;
function Trouve_Triangle(Triangle:P_NoeudTriang;PPoint:TPoint3D):boolean;
procedure ChercheAltitude(PPoint:TPoint3D);
function CalcAltitude(P1,P2,P3,PPoint:TPoint3D):Real;
FUNCTION f_nul(l_reel:REAL):BOOLEAN;
var
  Form1: TForm1;
  ListePoint :TListePoint;
  ListeTriang:TListeTriang;
  ListeOptime:TListeOptime;
  Naviguer,TriangAlt : P_NoeudTriang;
  ClPoint,clLine,clCherche,clPlan:Tcolor;
  NbTriangle,NbPoint:Integer;
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

implementation

{$R *.DFM}
 (**********  Implimentation de Tpoint3D  *************)
function Tpoint3D.Lirepoint:Tpoint3D;
var A:Tpoint3D;
begin
 A.abs := Abs;
 A.Ord := Ord;
 A.Alt := Alt;
 Result := A;
end;
function Tpoint3D.LireAbs:Real;
begin
 Result := Abs;
end;
function Tpoint3D.LireOrd:Real;
begin
 Result := Ord;
end;
function Tpoint3D.LireAlt:Real;
begin
 Result := Alt;
end;
procedure Tpoint3D.Defpoint(Ax,Ay,Az:Real);
begin
 Abs := Ax;
 Ord := Ay;
 Alt := Az;
end;
procedure Tpoint3D.DefAbs(Ax:Real);
begin
 Abs := Ax;
end;
procedure Tpoint3D.DefOrd(Ay:Real);
begin
 Ord := Ay;
end;
procedure Tpoint3D.DefAlt(Az:Real);
begin
 Alt := Az;
end;
        {***********  Implimentation de TDroite **********}
constructor Tdroite.Cdroite(APoint1,APoint2:P_Point);
begin
 Point1:=APoint1;
 Point2:=APoint2;
 CalculeAB;
end;

destructor Tdroite.Ddroite;
begin
  Dispose(Point1);
  Dispose(Point2);
end;

procedure TDroite.CalculeAB;
begin
 if(Point1.LireAbs<>Point2.LireAbs)and(Point1.LireOrd<>Point2.LireOrd)then
  begin
    A:=(Point2.LireOrd-Point1.LireOrd)/(Point2.LireAbs-Point1.LireAbs);
    B:=Point1.LireOrd-(A*Point1.LireAbs);
  end
 else if f_nul(Point1.LireAbs-Point2.LireAbs)and (Point1.LireOrd<>Point2.LireOrd)then
  begin
    A:=0;
    B:=Point1.LireAbs
  end
 else if(Point1.LireAbs<>Point2.LireAbs)and f_nul(Point1.LireOrd-Point2.LireOrd)then
  begin
    A:=0;
    B:=Point1.LireOrd
  end
 else if f_nul(Point1.LireAbs-Point2.LireAbs)and f_nul(Point1.LireOrd-Point2.LireOrd)then
  begin
    A:=0;B:=0;
  end ;

end;

function TDroite.LireA:Real;
begin
  Result:=A;
end;

function TDroite.LireB:Real;
begin
  Result:=B;
end;

function TDroite.LireP1:P_Point;
begin
  Result:=Point1;
end;

function TDroite.LireP2:P_Point;
begin
  Result:=Point2;
end;

{***********  Implimentation de TnoeudPoint **********}
constructor TNoeudPoint.CNoeudPoint(APoint:P_Point);
begin
 PPoint := APoint;
 NSuivant :=NIL;
end;
destructor TNoeudPoint.DNoeudPoint;
begin
 dispose(PPoint);
 PPoint:=NIL;
 Nsuivant:=NIL;
end;
procedure TNoeudPoint.DefSuivant(Anoeud:P_NoeudPoint);
begin
 Nsuivant := Anoeud;
end;
function TNoeudPoint.LireSuivant:P_NoeudPoint;
begin
 Result := Nsuivant;
end;
function TNoeudPoint.NLirepoint:P_Point;
begin
 if(PPoint<>NIL)then            
   Result := PPoint
 else
   Result := NIL;{Erreur}
end;

procedure TNoeudPoint.Afficher(Color:TColor);
begin
  with Form1.canvas do
  begin
    Brush.Style:=bsclear;
    Pen.Mode:=PmCopy;
    Pen.Color :=Color;
    Ellipse(Trunc(PPoint.Abs),Trunc(PPoint.Ord),
            Trunc(PPoint.Abs+1),Trunc(PPoint.Ord+1));
  end;
end;

{********* Implimentation de TlistePoint *********}
constructor TlistePoint.CListePoint;
begin
 TeteListe := NIL;
end;
destructor TListePoint.DListePoint;
begin

end;
procedure TListePoint.SupprimeListe;
var Point ,Point1: P_NoeudPoint;
begin
  Point := LireTete;
  Point1 := Point;
  while Point <> NIL do
  begin
    Point := Point.LireSuivant;
    Dispose(Point1);
    Point1 := Point;
  end;
  TeteListe := NIL;
end;
procedure TListePoint.Insere(PPoint:P_Point);
var PNoeud,PEncours : P_NoeudPoint;
begin
  New(PNoeud);
  PNoeud.CNoeudPoint(PPoint);
  PEncours := TeteListe;
  if (TeteListe = NIL)then
  begin
    TeteListe := PNoeud;
  end
 else
  begin
    while PEncours.LireSuivant<>NIL do PEncours:=PEncours.LireSuivant;
    PEncours.DefSuivant(PNoeud);
  end;
end;
function Tlistepoint.LireTete:P_NoeudPoint;
begin
 Result:=TeteListe
end;
procedure TListePoint.DefTete(PNoeud:P_NoeudPoint);
begin
  TeteListe:=PNoeud
end;
{***********  Implimentation de TnoeudTriang **********}
constructor TNoeudTriang.CNoeudTriang(AP1,AP2,AP3:P_Point);
begin
 P1 := AP1;
 P2 := AP2;
 P3 := AP3;
 T12:=NIL;
 T13:=NIL;
 T23:=NIL;
 NSuivant :=NIL;
 NPrecedant :=NIL;
 NbTriangle:=NbTriangle+1;
end;

destructor TNoeudTriang.DNoeudTriang;
begin
 P1:=NIL;
 P2:=NIL;
 P3:=NIL;
 T12:=NIL;
 T13:=NIL;
 T23:=NIL;
 Nsuivant:=NIL;
 NPrecedant :=NIL;
end;

procedure TNoeudTriang.DefSuivant(ANoeud:P_NoeudTriang);
begin
 NSuivant := ANoeud
end;

function TNoeudTriang.LireSuivant:P_NoeudTriang;
begin
 Result := NSuivant
end;
  
function TNoeudTriang.LireP1:P_Point;
begin
   Result := P1
end;

function TNoeudTriang.LireP2:P_Point;
begin
   Result := P2
end;

function TNoeudTriang.LireP3:P_Point;
begin
   Result := P3
end;

function  TNoeudTriang.LireT12:P_NoeudTriang;
begin
   Result := T12
end;

function  TNoeudTriang.LireT13:P_NoeudTriang;
begin
   Result := T13
end;

function  TNoeudTriang.LireT23:P_NoeudTriang;
begin
   Result := T23
end;

procedure TNoeudTriang.DefP1(PPoint:P_Point);
begin
  P1:=PPoint
end;

procedure TNoeudTriang.DefP2(PPoint:P_Point);
begin
  P2:=PPoint
end;

procedure TNoeudTriang.DefP3(PPoint:P_Point);
begin
  P3:=PPoint
end;

procedure TNoeudTriang.DefT12(PNoeud:P_NoeudTriang);
begin
  T12:=PNoeud
end;

procedure TNoeudTriang.DefT13(PNoeud:P_NoeudTriang);
begin
  T13:=PNoeud
end;

procedure TNoeudTriang.DefT23(PNoeud:P_NoeudTriang);
begin
  T23:=PNoeud
end;

procedure TNoeudTriang.Afficher(Color:TColor);
begin
  with Form1.canvas do
   begin
    Pen.Mode:=PmCopy;
    Pen.Color :=Color;
    MoveTo(Trunc(P1.LireAbs),Trunc(P1.LireOrd));
    LineTo(Trunc(P2.LireAbs),Trunc(P2.LireOrd));
    MoveTo(Trunc(P2.LireAbs),Trunc(P2.LireOrd));
    LineTo(Trunc(P3.LireAbs),Trunc(P3.LireOrd));
    MoveTo(Trunc(P3.LireAbs),Trunc(P3.LireOrd));
    LineTo(Trunc(P1.LireAbs),Trunc(P1.LireOrd));
   end;
end;

{********* Implimentation de TlisteTringle *********}
constructor TListeTriang.CListeTriang;
begin
 TeteListe := NIL;
end;

destructor TListeTriang.DListeTriang;
begin

end;
procedure TListeTriang.SupprimeListe;
var Triangle,Triangle1 : P_NoeudTriang;
begin
 Triangle := TeteListe;
 Triangle1 := Triangle;
  while Triangle<>NIL do
  begin
    Triangle := Triangle.LireSuivant;
    Dispose(Triangle1);
    Triangle1 := Triangle;
  end;
  TeteListe:=NIL;
end;

procedure TListeTriang.Inserer(PNoeud:P_NoeudTriang);
begin
 if (TeteListe = NIL)then
  begin
    TeteListe := PNoeud;
  end
 else
  begin
    PNoeud.DefSuivant(TeteListe);
    TeteListe:=PNoeud;
  end;
end;

function TListeTriang.LireTete:P_NoeudTriang;
begin
 Result:=TeteListe;
end;
{********* Implimentation de TNoeud_Optime *********}
constructor TNoeudOptime.CNoeudOptime(ATriangle:P_NoeudTriang);
begin
  PTriangle := ATriangle;
  NSuivant :=NIL;
end;

procedure TNoeudOptime.DefSuivant(ANoeud:P_NoeudOptime);
begin
  NSuivant:=ANoeud;
end;

function  TNoeudOptime.LireSuivant:P_NoeudOptime;
begin
  Result:=NSuivant;
end;

function  TNoeudOptime.LireTriangle:P_NoeudTriang;
begin
  Result:=PTriangle;
end;
{********* Implimentation de TlisteOptime *********}
constructor TListeOptime.CListeOptime;
begin
  TeteListe:=NIL;
end;

destructor TListeOptime.DListeOptime;
begin
  dispose(TeteListe);
end;

procedure TListeOptime.Inserer(ANoeud:P_NoeudTriang);
var PEncours,PNoeud:P_NoeudOptime;
    Existe:Boolean;
begin
  if (TeteListe = NIL)then
  begin
    New(PNoeud);
    PNoeud.CNoeudOptime(ANoeud);
    TeteListe := PNoeud;
  end
 else
  begin
    Existe:=False;
    PEncours:=TeteListe;
    while (PEncours<>NIL)and(Existe=False) do
     begin
       if (PEncours.LireTriangle=ANoeud) then Existe:=True;
       PEncours:=PEncours.LireSuivant;
     end;
    if Existe=False then
     begin
       New(PNoeud);
       PNoeud.CNoeudOptime(ANoeud);
       PNoeud.DefSuivant(TeteListe);
       TeteListe:=PNoeud;
     end;
  end;
end;

procedure TListeOptime.Supprime(ANoeud:P_NoeudOptime);
var PEncours:P_NoeudOptime;
begin
  if ANoeud=TeteListe then
   begin
     TeteListe:=ANoeud.LireSuivant;
     dispose(ANoeud);
   end
  else
   begin
     PEncours:=TeteListe;
     while PEncours.LireSuivant<>ANoeud do
       PEncours:=PEncours.LireSuivant;
     PEncours.DefSuivant(ANoeud.LireSuivant);
     dispose(ANoeud);
   end;
end;

function  TListeOptime.LireTete:P_NoeudOptime;
begin
  Result:=TeteListe;
end;

{.....................IMPLIMENTATIONS DES PROCEDURES.......................}

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if(x>5)and(x<Form1.Width-150)and(y>30)and(y<Form1.Height-70)then
  begin
    drawing := true;
    Drawshap(point(x,y),pmNotXor,clPoint);
    origin := point(x,y);
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var PPoint : TPoint3D;
    Ax,Ay : Real;
begin
  
  if drawing and(x>5)and(x<Form1.Width-150)and(y>30)and(y<Form1.Height-70)then
   begin
     Drawshap(origin,pmNotXor,clPoint);
     origin := point(x,y);
     Drawshap(origin,pmNotXor,clPoint);
   end;

     Ax := x;
     Ay := y;
     PPoint.Defpoint(Ax,Ay,0);
     ChercheAltitude(PPoint);

  StatusBar1.Panels[0].Text := format('Fenêtre: ( %d  _  %d )',[x,y]);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Point3D:^TPoint3D;
    X1,Y1,Z1:Real;
begin
  if Drawing and(x>5)and(x<Form1.Width-150)and(y>30)and(y<Form1.Height-70)and(ListeTriang.LireTete= Nil)then
  begin
    X1:=X;
    Y1:=Y;
    Randomize;
    Z1:=Random(1000);
    Drawshap(point(x,y),pmCopy,clPoint);
    New(Point3D);
    Point3D.Defpoint(X1,Y1,Z1);
    ListePoint.Insere(Point3D);
    NbPoint:=NbPoint+1;
    Form1.Edit2.Text:=IntToStr(NbPoint);
  end;
 Drawing := False;
end;
procedure Drawshap(Apoint:Tpoint;Amode:Tpenmode;Acolor:Tcolor);
begin
  with Form1.canvas do
  begin
    Brush.Style:=bsclear;
    Pen.mode := Amode;
    Pen.color:=AColor;
    Ellipse(Apoint.x-1,Apoint.y-1,Apoint.x+1,Apoint.y+1);
  end;
end;
function Taille(P1,P2:P_Point):Real;
var P_1:TPoint3D;
begin
  P_1.DefAbs(P1.LireAbs-P2.LireAbs);
  P_1.DefOrd(P1.LireOrd-P2.LireOrd);

  Result:=sqrt(sqr(P_1.LireAbs)+sqr(P_1.LireOrd));
end;

procedure TrieListe;
var PEncours,PSuiv,PPrec:P_NoeudPoint;
    PMin : P_Point;
    Trie:Boolean;
begin
  PEncours:=ListePoint.LireTete;
  PMin :=PEncours.NLirePoint;
  while PEncours<>NIl do
  begin
    if PEncours.NLirePoint.LireAbs<PMin.LireAbs then
      begin
        PMin :=PEncours.NLirePoint;
      end;
    PEncours:=PEncours.LireSuivant;
  end;

  Trie:=False;
  while Trie<>True do
  begin
  Trie:=True;
  PEncours:=ListePoint.LireTete;
  PSuiv := PEncours.LireSuivant;
  PPrec := ListePoint.LireTete;
  while PSuiv<>NIL do
    begin
      if (PEncours=ListePoint.LireTete) and
         (Taille(PEncours.NLirePoint,PMin)>Taille(PSuiv.NLirePoint,PMin)) then
        begin
          ListePoint.DefTete(PSuiv);
          PEncours.DefSuivant(PSuiv.LireSuivant);
          PSuiv.DefSuivant(PEncours);
          Trie:=False;
        end
      else
          if (Taille(PEncours.NLirePoint,PMin)>Taille(PSuiv.NLirePoint,PMin)) then
            begin
              PPrec.DefSuivant(PSuiv);
              PEncours.DefSuivant(PSuiv.LireSuivant);
              PSuiv.DefSuivant(PEncours);
              Trie:=False;
            end;
      PPrec:=PEncours;
      PEncours:=PSuiv;
      PSuiv:=PEncours.LireSuivant;
    end;
  end;
  PEncours:=ListePoint.LireTete;
  PSuiv := PEncours.LireSuivant;
  while PSuiv<>NIL do
   begin
     if (PEncours.NLirePoint.LireAbs=PSuiv.NLirePoint.LireAbs)and
       (PEncours.NLirePoint.LireOrd=PSuiv.NLirePoint.LireOrd)then
      begin
        PEncours.DefSuivant(PSuiv.LireSuivant);
        dispose(PSuiv);
        PSuiv := PEncours.LireSuivant;
      end
     else
      begin
        PEncours:=PEncours.LireSuivant;
        PSuiv := PEncours.LireSuivant
      end;
   end;
end;

procedure Trianguler;
var P_Encours,P:P_NoeudPoint;
    PNoeud : P_NoeudTriang;
    i : integer;
    label FIN  ;
begin
  i :=0;
  P:=ListePoint.LireTete;
  while (i<3) and (P<>NIL) do
  begin
    i:=i+1;
    P:=P.LireSuivant;
  end;
  if i<3 then goto FIN;
  P_Encours:=ListePoint.LireTete;
  if Parallele(P_Encours.NLirePoint,P_Encours.LireSuivant.NLirePoint,
                P_Encours.LireSuivant.LireSuivant.NLirePoint)then
     begin
      P_Encours.NLirePoint.DefOrd(P_Encours.NLirePoint.LireOrd+0.1);
      P_Encours.LireSuivant.NLirePoint.DefAbs(P_Encours.LireSuivant.NLirePoint.LireAbs+0.1);
     end;
  New(PNoeud);
  PNoeud.CNoeudTriang(P_Encours.NLirePoint,P_Encours.LireSuivant.NLirePoint,
                      P_Encours.LireSuivant.LireSuivant.NLirePoint);
  ListeTriang.Inserer(PNoeud);
  PNoeud.Afficher(clLine);
  P_Encours:=P_Encours.LireSuivant;
  NbPoint:=3;
  while P_Encours<>NIl do
  begin
    Bon_Triang(P_Encours.NLirePoint);
    P_Encours:=P_Encours.LireSuivant;
    NbPoint:=NbPoint+1;
  end;
  Form1.Edit1.Text:=IntToStr(NbTriangle);
  Form1.Edit2.Text:=IntToStr(NbPoint);
  FIN:
end;

procedure Bon_Triang(PPoint:P_Point);
var PEncours,PNoeud : P_NoeudTriang;
    Face : TFace;
    Encors:Boolean;
begin
  PEncours:=ListeTriang.LireTete;
  while PEncours<>NIL do
   begin
     Encors:=True;
   while Encors=True do
    begin
      Encors:=False;
      Face:=[];
      PNoeud:=NIL;
      Face:=GetFace(PEncours,PPoint);
                  if Face12 in Face then
                   begin
                     New(PNoeud);
                     PNoeud.CNoeudTriang(PEncours.LireP1,PEncours.LireP2,PPoint);
                     PEncours.DefT12(PNoeud);
                     PNoeud.DefT12(PEncours);
                     if (Face13 in Face)or(Face23 in Face) then
                       Encors:=True;
                     Coller(PNoeud);
                     PNoeud.Afficher(clLine);
                     ListeTriang.Inserer(PNoeud);
                     Optimeser_Liste(PNoeud);
                   end
                  else if Face13 in Face then
                   begin
                     New(PNoeud);
                     PNoeud.CNoeudTriang(PEncours.LireP1,PEncours.LireP3,PPoint);
                     PEncours.DefT13(PNoeud);
                     PNoeud.DefT12(PEncours);
                     if (Face12 in Face)or(Face23 in Face) then
                       Encors:=True;
                     Coller(PNoeud);
                     PNoeud.Afficher(clLine);
                     ListeTriang.Inserer(PNoeud);
                     Optimeser_Liste(PNoeud);
                   end
                  else if Face23 in Face then
                   begin
                     New(PNoeud);
                     PNoeud.CNoeudTriang(PEncours.LireP2,PEncours.LireP3,PPoint);
                     PEncours.DefT23(PNoeud);
                     PNoeud.DefT12(PEncours);
                     if (Face12 in Face)or(Face13 in Face) then
                       Encors:=True;
                     Coller(PNoeud);
                     PNoeud.Afficher(clLine);
                     ListeTriang.Inserer(PNoeud);
                     Optimeser_Liste(PNoeud);
                   end;
         end;
         PEncours:=PEncours.LireSuivant;
      end;         

end;

procedure Coller(var Triangle:P_NoeudTriang);
var PEncours:P_NoeudTriang;
    PP : TEnsPoint;
begin
  PEncours:=ListeTriang.LireTete;
  while PEncours<>NIL do
   begin
     PP:=[];
     if (PEncours.LireP1=Triangle.LireP1)or(PEncours.LireP1=Triangle.LireP3)then
       PP:=[P1];
     if (PEncours.LireP2=Triangle.LireP1)or(PEncours.LireP2=Triangle.LireP3)then
       PP:=PP+[P2];
     if (PEncours.LireP3=Triangle.LireP1)or(PEncours.LireP3=Triangle.LireP3)then
       PP:=PP+[P3];
     if (P1 in PP)and(P2 in PP)then
      begin
        PEncours.DefT12(Triangle);
        Triangle.DefT13(PEncours);
      end
     else if (P1 in PP)and(P3 in PP)then
      begin
        PEncours.DefT13(Triangle);
        Triangle.DefT13(PEncours);
      end
     else if (P2 in PP)and(P3 in PP)then
      begin
        PEncours.DefT23(Triangle);
        Triangle.DefT13(PEncours);
      end;
     PP:=[];
     if (PEncours.LireP1=Triangle.LireP2)or(PEncours.LireP1=Triangle.LireP3)then
       PP:=[P1];
     if (PEncours.LireP2=Triangle.LireP2)or(PEncours.LireP2=Triangle.LireP3)then
       PP:=PP+[P2];
     if (PEncours.LireP3=Triangle.LireP2)or(PEncours.LireP3=Triangle.LireP3)then
       PP:=PP+[P3];
     if (P1 in PP)and(P2 in PP)then
      begin
        PEncours.DefT12(Triangle);
        Triangle.DefT23(PEncours);
      end
     else if (P1 in PP)and(P3 in PP)then
      begin
        PEncours.DefT13(Triangle);
        Triangle.DefT23(PEncours);
      end
     else if (P2 in PP)and(P3 in PP)then
      begin
        PEncours.DefT23(Triangle);
        Triangle.DefT23(PEncours);
      end;
     PEncours:=PEncours.LireSuivant;
   end;
end;

function Parallele(P1,P2,PPoint:P_Point):boolean;
var  Parall : boolean;
Determinant : Real;
begin
  Determinant :=  ((P1.LireAbs-P2.LireAbs)*(P1.LireOrd-PPoint.LireOrd))
                 -((P1.LireOrd-P2.LireOrd)*(P1.LireAbs-PPoint.LireAbs));
  if (Determinant=0) then
    Parall := True
  else
    Parall := False;
  Result := Parall;
end;

function GetTest(P1,P2,P3,PPoint:P_Point):Boolean;
var Line,Line1 : TDroite;
    Test : Boolean;
begin
  Line.Cdroite(P1,P2);
  Line1.Cdroite(P1,PPoint);
  Test:=False;
  if (P1=PPoint)or(P2=PPoint)or(P3=PPoint)or Parallele(P1,P2,PPoint)then
    Test:=False
  else if (Line.LireP1.LireAbs<>Line.LireP2.LireAbs) then
    begin
      if((PPoint.LireOrd<Line.LireA*PPoint.LireAbs+Line.LireB)and(P3.LireOrd>Line.LireA*P3.LireAbs+Line.LireB))
       or((PPoint.LireOrd>Line.LireA*PPoint.LireAbs+Line.LireB)and(P3.LireOrd<Line.LireA*P3.LireAbs+Line.LireB))then
        Test:=True
      else
       Test:=False;
    end
  else if f_nul(Line.LireP1.LireAbs-Line.LireP2.LireAbs) then
    begin
      if((PPoint.LireAbs<Line.LireB)and(P3.LireAbs>Line.LireB))
       or((PPoint.LireAbs>Line.LireB)and(P3.LireAbs<Line.LireB))then
       Test:=True
      else
       Test:=False;
    end;
  Result:=Test;
end;

function GetFace(PTriangle:P_NoeudTriang;PPoint:P_Point):TFace;
var Face : TFace;
    Test : Boolean;
begin
  Face:=[];
  if (PTriangle.T12 = NIL)then
  begin
    Test:=GetTest(PTriangle.P1,PTriangle.P2,PTriangle.P3,PPoint);
    if Test=True then
      Face:=[Face12];
  end;
  if (PTriangle.T13 = NIL)then
  begin
    Test:=GetTest(PTriangle.P1,PTriangle.P3,PTriangle.P2,PPoint);
    if Test=True then
      Face:=Face+[Face13];
  end;
  if (PTriangle.T23 = NIL)then
  begin
    Test:=GetTest(PTriangle.P2,PTriangle.P3,PTriangle.P1,PPoint);
    if Test=True then
      Face:=Face+[Face23];
  end;

  Result:=Face;
end;

function CalculAngle(P1,P2,P3:P_Point):Real;
var Pc_T1,Pc_T2:Real;
    PcT1,PcT2:TPoint3D;
    CosC:Real;
begin
  PcT1.DefAbs(P2.LireAbs-P1.LireAbs);
  PcT1.DefOrd(P2.LireOrd-P1.LireOrd);
  PcT2.DefAbs(P3.LireAbs-P1.LireAbs);
  PcT2.DefOrd(P3.LireOrd-P1.LireOrd);

  Pc_T1:=sqrt(sqr(PcT1.LireAbs)+sqr(PcT1.LireOrd));
  Pc_T2:=sqrt(sqr(PcT2.LireAbs)+sqr(PcT2.LireOrd));
  CosC:=((PcT1.LireAbs*PcT2.LireAbs)+(PcT1.LireOrd*PcT2.LireOrd))/(Pc_T1*Pc_T2);
  if ((CosC <= -1) or (CosC >= 1)) then
   Result:=3.15
  else
   Result:=ArcCos(CosC);
end;

function InterLine(Line1,Line2:TDroite):Boolean;
var Point:TPoint3D;
    Aide : TAide;
begin
  Aide:=Cas1;
  if (Line1.LireA<>0)and(Line2.LireA<>0) then
    Aide:=Cas1
  else if (Line1.LireA=0)and(Line2.LireA<>0) then
    Aide:=Cas2
  else if (Line1.LireA<>0)and(Line2.LireA=0) then
    Aide:=Cas3
  else if (Line1.LireA=0)and(Line2.LireA=0) then
    Aide:=Cas4;

  Result:=False;
  case Aide of
  Cas1 : begin
           Point.DefAbs((Line2.LireB-Line1.LireB)/(Line1.LireA-Line2.LireA));
           Point.DefOrd(Line1.LireA*Point.LireAbs+Line1.LireB);
           if Line1.LireP1.LireAbs<Line1.LireP2.LireAbs then
            begin
              if (Point.LireAbs>Line1.LireP1.LireAbs)and
                  (Point.LireAbs<Line1.LireP2.LireAbs)then
                Result:=True
              else
                Result:=False;
            end
           else
            begin
              if (Point.LireAbs<Line1.LireP1.LireAbs)and
                  (Point.LireAbs>Line1.LireP2.LireAbs)then
                Result:=True
              else
                Result:=False;
            end
         end;
  Cas2 : if f_nul(Line1.LireP1.LireAbs-Line1.LireP2.LireAbs)then
          begin
            Point.DefAbs(Line1.LireB);
            Point.DefOrd(Line2.LireA*Point.LireAbs+Line2.LireB);
            if Line1.LireP1.LireOrd<Line1.LireP2.LireOrd then
             begin
               if (Point.LireOrd>Line1.LireP1.LireOrd)and
                   (Point.LireOrd<Line1.LireP2.LireOrd)then
                 Result:=True
               else
                 Result:=False;
             end
            else
             begin
               if (Point.LireOrd<Line1.LireP1.LireOrd)and
                   (Point.LireOrd>Line1.LireP2.LireOrd)then
                 Result:=True
               else
                 Result:=False;
             end
           end
        else
          begin
            Point.DefOrd(Line1.LireB);
            Point.DefAbs((Point.LireOrd-Line2.LireB)/Line2.LireA);
            if Line1.LireP1.LireAbs<Line1.LireP2.LireAbs then
             begin
               if (Point.LireAbs>Line1.LireP1.LireAbs)and
                   (Point.LireAbs<Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
            else
             begin
               if (Point.LireAbs<Line1.LireP1.LireAbs)and
                   (Point.LireAbs>Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
          end;
  Cas3 : if(Line2.LireP1.LireAbs=Line2.LireP2.LireAbs)then
          begin
            Point.DefAbs(Line2.LireB);
            Point.DefOrd(Line1.LireA*Point.LireAbs+Line1.LireB);
            if Line1.LireP1.LireAbs<Line1.LireP2.LireAbs then
             begin
               if (Point.LireAbs>Line1.LireP1.LireAbs)and
                   (Point.LireAbs<Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
            else
             begin
               if (Point.LireAbs<Line1.LireP1.LireAbs)and
                   (Point.LireAbs>Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
          end
         else
          begin
            Point.DefOrd(Line2.LireB);
            Point.DefAbs((Point.LireOrd-Line1.LireB)/Line1.LireA);
            if Line1.LireP1.LireAbs<Line1.LireP2.LireAbs then
             begin
               if (Point.LireAbs>Line1.LireP1.LireAbs)and
                   (Point.LireAbs<Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
            else
             begin
               if (Point.LireAbs<Line1.LireP1.LireAbs)and
                   (Point.LireAbs>Line1.LireP2.LireAbs)then
                 Result:=True
               else
                 Result:=False;
             end
          end;
  Cas4 : if f_nul(Line1.LireP1.LireAbs-Line1.LireP2.LireAbs)and
           f_nul(Line2.LireP1.LireOrd-Line2.LireP2.LireOrd)then
          begin
            if Line1.LireP1.LireOrd<Line1.LireP2.LireOrd then
             begin
               if (Line2.LireB>Line1.LireP1.LireOrd)and
                   (Line2.LireB<Line1.LireP2.LireOrd)then
                 Result:=True
               else
                 Result:=False;
             end
            else
             begin
               if (Line2.LireB<Line1.LireP1.LireOrd)and
                   (Line2.LireB>Line1.LireP2.LireOrd)then
                 Result:=True
               else
                 Result:=False;
             end
           end
         else
          begin
            if f_nul(Line1.LireP1.LireOrd-Line1.LireP2.LireOrd)and
               f_nul(Line2.LireP1.LireAbs-Line2.LireP2.LireAbs)then
               begin
              if Line1.LireP1.LireAbs<Line1.LireP2.LireAbs then
               begin
                 if (Line2.LireB>Line1.LireP1.LireAbs)and
                     (Line2.LireB<Line1.LireP2.LireAbs)then
                   Result:=True
                 else
                   Result:=False;
               end
              else
               begin
                 if (Line2.LireB<Line1.LireP1.LireAbs)and
                     (Line2.LireB>Line1.LireP2.LireAbs)then
                   Result:=True
                 else
                   Result:=False;
               end
             end
          end;
  end;
end;

function Optimeser(var Triangle1,Triangle2:P_NoeudTriang;Diagonal:TDiagonal):Boolean;
var T1_P1,T1_P2,T1_P3,T2_P1,T2_P2,T2_P3:P_Point;
    T1_12,T1_13,T1_23,T2_12,T2_13,T2_23,T1,T2:P_NoeudTriang;
    Angle1,Angle2,Angle3,Angle4,Angle5,Angle6,Min1,Min2 :Real;
    Line1,Line2 :TDroite;
    Yes:Boolean;
begin
   T1_P1:=Triangle1.LireP1;T2_P1:=Triangle2.LireP1;
   T1_P2:=Triangle1.LireP2;T2_P2:=Triangle2.LireP2;
   T1_P3:=Triangle1.LireP3;T2_P3:=Triangle2.LireP3;

   T1_12:=Triangle1.LireT12;T2_12:=Triangle2.LireT12;
   T1_13:=Triangle1.LireT13;T2_13:=Triangle2.LireT13;
   T1_23:=Triangle1.LireT23;T2_23:=Triangle2.LireT23;
  if Diagonal=Diag12 then
   begin
     if (T2_P1<>T1_P1) and (T2_P1<>T1_P2) then
      begin
       if T1_P1=T2_P2 then
        begin
          Triangle2.DefP1(T1_P1);
          Triangle2.DefP2(T1_P2);
          Triangle2.DefP3(T2_P1);

          Triangle2.DefT12(T2_23);
          Triangle2.DefT13(T2_12);
          Triangle2.DefT23(T2_13);
        end
       else
        begin
          Triangle2.DefP1(T1_P1);
          Triangle2.DefP2(T1_P2);
          Triangle2.DefP3(T2_P1);

          Triangle2.DefT12(T2_23);
          Triangle2.DefT23(T2_12);
        end;
      end
     else if (T2_P2<>T1_P1) and (T2_P2<>T1_P2) then
      begin
        if T1_P1=T2_P1 then
         begin
           Triangle2.DefP2(T1_P2);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_12);
         end
        else
         begin
           Triangle2.DefP1(T1_P1);
           Triangle2.DefP2(T1_P2);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_12);
         end;
      end
     else if (T2_P3<>T1_P1) and (T2_P3<>T1_P2) then
      begin
        if T1_P1=T2_P2 then
         begin
           Triangle2.DefP1(T1_P1);
           Triangle2.DefP2(T1_P2);

           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_13);
         end
      end
   end
  else if Diagonal=Diag13 then
   begin
     Triangle1.DefP2(T1_P3);
     Triangle1.DefP3(T1_P2);

     Triangle1.DefT12(T1_13);
     Triangle1.DefT13(T1_12);
     if (T2_P1<>T1_P1) and (T2_P1<>T1_P3) then
      begin
        if T1_P1=T2_P2 then
         begin
           Triangle2.DefP1(T2_P2);
           Triangle2.DefP2(T2_P3);
           Triangle2.DefP3(T2_P1);

           Triangle2.DefT12(T2_23);
           Triangle2.DefT13(T2_12);
           Triangle2.DefT23(T2_13);
         end
        else
         begin
           Triangle2.DefP1(T2_P3);
           Triangle2.DefP3(T2_P1);

           Triangle2.DefT12(T2_23);
           Triangle2.DefT23(T2_12);
         end;
       end
     else if (T2_P2<>T1_P1) and (T2_P2<>T1_P3) then
      begin
        if T1_P1=T2_P1 then
         begin
           Triangle2.DefP2(T2_P3);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_12);
         end
        else
         begin
           Triangle2.DefP1(T2_P3);
           Triangle2.DefP2(T2_P1);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_12);
         end;
      end
     else if (T2_P3<>T1_P1) and (T2_P3<>T1_P3) then
      begin
        if T1_P1=T2_P2 then
         begin
           Triangle2.DefP1(T2_P2);
           Triangle2.DefP2(T2_P1);

           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_13);
         end;
      end;
   end
  else if Diagonal=Diag23 then
   begin
     Triangle1.DefP1(T1_P2);
     Triangle1.DefP2(T1_P3);
     Triangle1.DefP3(T1_P1);

     Triangle1.DefT12(T1_23);
     Triangle1.DefT13(T1_12);
     Triangle1.DefT23(T1_13);
     if (T2_P1<>T1_P2) and (T2_P1<>T1_P3) then
      begin
        if T1_P2=T2_P2 then
         begin
           Triangle2.DefP1(T2_P2);
           Triangle2.DefP2(T2_P3);
           Triangle2.DefP3(T2_P1);

           Triangle2.DefT12(T2_23);
           Triangle2.DefT13(T2_12);
           Triangle2.DefT23(T2_13);
         end
        else
         begin
           Triangle2.DefP1(T2_P3);
           Triangle2.DefP3(T2_P1);

           Triangle2.DefT12(T2_23);
           Triangle2.DefT23(T2_12);
         end;
      end
     else if (T2_P2<>T1_P2) and (T2_P2<>T1_P3) then
      begin
        if T1_P2=T2_P1 then
         begin
           Triangle2.DefP2(T2_P3);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_12);
         end
        else
         begin
           Triangle2.DefP1(T2_P3);
           Triangle2.DefP2(T2_P1);
           Triangle2.DefP3(T2_P2);

           Triangle2.DefT12(T2_13);
           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_12);
         end;
      end
     else if (T2_P3<>T1_P2) and (T2_P3<>T1_P3) then
      begin
      if T1_P2=T2_P2 then
         begin
           Triangle2.DefP1(T2_P2);
           Triangle2.DefP2(T2_P1);

           Triangle2.DefT13(T2_23);
           Triangle2.DefT23(T2_13);
         end;
      end;
   end;
   Line1.Cdroite(Triangle1.LireP1,Triangle1.LireP2);
   Line2.Cdroite(Triangle1.LireP3,Triangle2.LireP3);
   Yes:=InterLine(Line1,Line2);
   if Yes=True then
   begin
   T1_P1:=Triangle1.LireP1;T2_P1:=Triangle2.LireP1;
   T1_P2:=Triangle1.LireP2;T2_P2:=Triangle2.LireP2;
   T1_P3:=Triangle1.LireP3;T2_P3:=Triangle2.LireP3;

   T2_13:=Triangle2.LireT13;
   T1_23:=Triangle1.LireT23;
   {optimeser}
   {1er Cas}
   Angle1:=CalculAngle(T1_P1,T1_P2,T1_P3);
   Angle2:=CalculAngle(T1_P2,T1_P1,T1_P3);
   Angle3:=CalculAngle(T1_P3,T1_P1,T1_P2);
   Angle4:=CalculAngle(T2_P1,T2_P2,T2_P3);
   Angle5:=CalculAngle(T2_P2,T2_P1,T2_P3);
   Angle6:=CalculAngle(T2_P3,T2_P1,T2_P2);
   Min1:=Angle1;
   if Angle2<Min1 then
     Min1:=Angle2;
   if Angle3<Min1 then
     Min1:=Angle3;
   if Angle4<Min1 then
     Min1:=Angle4;
   if Angle5<Min1 then
     Min1:=Angle5;
   if Angle6<Min1 then
     Min1:=Angle6;
   {2eme Cas}
   Angle1:=CalculAngle(T1_P1,T1_P3,T2_P3);
   Angle2:=CalculAngle(T1_P3,T1_P1,T2_P3);
   Angle3:=CalculAngle(T2_P3,T1_P1,T1_P3);
   Angle4:=CalculAngle(T1_P2,T1_P3,T2_P3);
   Angle5:=CalculAngle(T1_P3,T1_P2,T2_P3);
   Angle6:=CalculAngle(T2_P3,T1_P2,T1_P3);
   Min2:=Angle1;
   if Angle2<Min2 then
     Min2:=Angle2;
   if Angle3<Min2 then
     Min2:=Angle3;
   if Angle4<Min2 then
     Min2:=Angle4;
   if Angle5<Min2 then
     Min2:=Angle5;
   if Angle6<Min2 then
     Min2:=Angle6;

   {chercher Le Max_Min}
  //Critère de Min-Max :
  //Une triangulation satisfait le critère de Min-Max, si pour tout quarrilatère
  //convexe de la tiangulation, si on remplace la diagonale par sonopposée,
  //la valeur du plus petit angle n'augmente pas.
  //une triangulation qui satisfait ce critère est dite triangulation de delaunay.
   Result:=False;
   if (Min2>Min1)
      and(NOT Parallele(Triangle1.LireP1,Triangle1.LireP3,Triangle2.LireP3))
      and(NOT Parallele(Triangle1.LireP2,Triangle1.LireP3,Triangle2.LireP3)) then
    begin
      Triangle1.Afficher(clPlan);
      Triangle2.Afficher(clPlan);

      T1:=Triangle1.LireT23;
      T2:=Triangle2.LireT13;
        if T1<>NIL then
       begin
         if T1.LireT12=Triangle1 then
          T1.DefT12(Triangle2)
        else if T1.LireT13=Triangle1 then
          T1.DefT13(Triangle2)
        else if T1.LireT23=Triangle1 then
          T1.DefT23(Triangle2);
       end;

       if T2<>NIL then
       begin
         if T2.LireT12=Triangle2 then
          T2.DefT12(Triangle1)
        else if T2.LireT13=Triangle2 then
          T2.DefT13(Triangle1)
        else if T2.LireT23=Triangle2 then
          T2.DefT23(Triangle1);
       end;

      Triangle1.DefP1(T1_P3);
      Triangle1.DefP2(T2_P3);
      Triangle1.DefP3(T1_P1);

      Triangle2.DefP1(T1_P3);
      Triangle2.DefP2(T2_P3);
      Triangle2.DefP3(T1_P2);

      Triangle1.DefT12(Triangle2);
      Triangle1.DefT23(T2_13);

      Triangle2.DefT12(Triangle1);
      Triangle2.DefT13(T1_23);

      Triangle1.Afficher(clLine);
      Triangle2.Afficher(clLine);

      Drawshap(point(Trunc(Triangle1.LireP1.LireAbs),Trunc(Triangle1.LireP1.LireOrd)),pmCopy,clPoint);
      Drawshap(point(Trunc(Triangle1.LireP2.LireAbs),Trunc(Triangle1.LireP2.LireOrd)),pmCopy,clPoint);
      Drawshap(point(Trunc(Triangle1.LireP3.LireAbs),Trunc(Triangle1.LireP3.LireOrd)),pmCopy,clPoint);
      Drawshap(point(Trunc(Triangle2.LireP3.LireAbs),Trunc(Triangle2.LireP3.LireOrd)),pmCopy,clPoint);
      Result:=True;
    end;
    end
   else
    Result:=False;
end;

procedure Optimeser_Liste(PTriang:P_NoeudTriang);
var P_Encours,POptime:P_NoeudOptime;
    Temp1,Temp2:P_NoeudTriang;
    Optime,OK:Boolean;
    Diagonal :TDiagonal;
begin
  ListeOptime.Inserer(PTriang);
  while ListeOptime.LireTete<>NIL do
  begin
    P_Encours:=ListeOptime.LireTete;
    while P_Encours<>NIL do
     begin
       Optime:=True;
       if P_Encours.LireTriangle.LireT12<>NIL then
        begin
          Diagonal:=Diag12;
          Temp1:=P_Encours.LireTriangle;
          Temp2:=Temp1.LireT12;
          OK:=Optimeser(Temp1,Temp2,Diagonal);
          if OK=True then
           begin
             Optime:=False;
             ListeOptime.Inserer(Temp2);
           end;
        end;
       if P_Encours.LireTriangle.LireT13<>NIL then
        begin
          Diagonal:=Diag13;
          Temp1:=P_Encours.LireTriangle;
          Temp2:=Temp1.LireT13;
          OK:=Optimeser(Temp1,Temp2,Diagonal);
          if OK=True then
           begin
             Optime:=False;
             ListeOptime.Inserer(Temp2);
           end;
        end;
       if P_Encours.LireTriangle.LireT23<>NIL then
        begin
          Diagonal:=Diag23;
          Temp1:=P_Encours.LireTriangle;
          Temp2:=Temp1.LireT23;
          OK:=Optimeser(Temp1,Temp2,Diagonal);
          if OK=True then
           begin
             Optime:=False;
             ListeOptime.Inserer(Temp2);
           end;
        end;
      POptime:=P_Encours;
      P_Encours:=P_Encours.LireSuivant;
      if Optime=True then
       begin
        ListeOptime.Supprime(POptime);
       end;
     end;
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if NbPoint<3 then
   ShowMessage('Saisi les points')
  else
  if Listetriang.LireTete<>nil then
   ShowMessage('Il faut initialisé pour recommencer')
   else
  begin
   TrieListe;
   Trianguler;
  end;
end;

FUNCTION f_nul(l_reel:REAL):BOOLEAN;
BEGIN
  f_nul := ABS(l_reel) < 1E-10;
END;

function Si_inclu(P1,P2,P3:P_Point;P:TPoint3D):boolean;
var Line:TDroite;
begin
Line.Cdroite(P1,P2);
if (P1.LireAbs=P2.LireAbs) then
   begin
     if((P.LireAbs>Line.LireB)and(P3.LireAbs>Line.LireB))or
       ((P.LireAbs<Line.LireB)and(P3.LireAbs<Line.LireB))or
       f_nul(P.LireAbs-Line.LireB)then
       Result := True
     else
       Result := False;
   end
  else
   begin
     if((P.LireOrd>(P.LireAbs*Line.LireA+Line.LireB))and
        (P3.LireOrd>(P3.LireAbs*Line.LireA+Line.LireB)))or
       ((P.LireOrd<(P.LireAbs*Line.LireA+Line.LireB))and
        (P3.LireOrd<(P3.LireAbs*Line.LireA+Line.LireB)))or
        f_nul(P.LireOrd-(P.LireAbs*Line.LireA+Line.LireB))then
       Result := True
     else
       Result := False;
   end;
end;

function Trouve_Triangle(Triangle:P_NoeudTriang;PPoint:TPoint3D):boolean;
begin
      if si_inclu(Triangle.LireP1,Triangle.LireP2,Triangle.LireP3,PPoint)
     and si_inclu(Triangle.LireP1,Triangle.LireP3,Triangle.LireP2,PPoint)
     and si_inclu(Triangle.LireP2,Triangle.LireP3,Triangle.LireP1,PPoint) then
       Result:=True
     else
       Result:=False;
end;

function CalcAltitude(P1,P2,P3,PPoint:TPoint3D):Real;
var V1,V2 :TPoint3D;
    A,B,C :Real;
begin
  V1.Abs:=P2.Abs-P1.Abs; V2.Abs:=P3.Abs-P1.Abs;
  V1.Ord:=P2.Ord-P1.Ord; V2.Ord:=P3.Ord-P1.Ord;
  V1.Alt:=P2.Alt-P1.Alt; V2.Alt:=P3.Alt-P1.Alt;

  A:=(V1.Ord*V2.Alt)-(V2.Ord*V1.Alt);
  B:=-((V1.Abs*V2.Alt)-(V2.Abs*V1.Alt));
  C:=(V1.Abs*V2.Ord)-(V2.Abs*V1.Ord);

  Result :=(-1/C)*(A*(PPoint.Abs-P1.Abs)+B*(PPoint.Ord-P1.Ord))+P1.Alt;
end;

procedure ChercheAltitude(PPoint:TPoint3D);
var PEncours:P_NoeudTriang;
    Trouve:Boolean;
    Altitude:Real;
begin
  PEncours:=ListeTriang.LireTete;
  Trouve:=False;
  while(PEncours<>NIL)and(Trouve=False)do
   begin
     Trouve:=Trouve_Triangle(PEncours,PPoint);
     if NOT Trouve then
       PEncours:=PEncours.LireSuivant;
   end;
  if Trouve then
  begin
    Altitude:=CalcAltitude(PEncours.LireP1.Lirepoint,PEncours.LireP2.Lirepoint,
                           PEncours.LireP3.Lirepoint,PPoint);
    Form1.Edit3.Text:=FloatToStr(PEncours.LireP1.LireAbs);
    Form1.Edit4.Text:=FloatToStr(PEncours.LireP1.LireOrd);
    Form1.Edit5.Text:=FloatToStr(PEncours.LireP2.LireAbs);
    Form1.Edit6.Text:=FloatToStr(PEncours.LireP2.LireOrd);
    Form1.Edit7.Text:=FloatToStr(PEncours.LireP3.LireAbs);
    Form1.Edit8.Text:=FloatToStr(PEncours.LireP3.LireOrd);
    Form1.Edit9.Text:=FloatToStr(PEncours.LireP1.LireAlt);
    Form1.Edit10.Text:=FloatToStr(PEncours.LireP2.LireAlt);
    Form1.Edit11.Text:=FloatToStr(PEncours.LireP3.LireAlt);
    Form1.StatusBar1.Panels[1].Text := format('Altitude :( %.2f )',[Altitude]);

    if TriangAlt<>PEncours then
    begin
      if TriangAlt<>NIL then TriangAlt.Afficher(clLine);
      TriangAlt:=PEncours;
      PEncours.Afficher(clCherche);
    end
  end
  else
  begin
    Form1.StatusBar1.Panels[1].Text := '';
    if TriangAlt<>NIL then TriangAlt.Afficher(clLine);
    TriangAlt:=NIL;
    Form1.Edit3.Clear;Form1.Edit4.Clear;Form1.Edit5.Clear;Form1.Edit6.Clear;
    Form1.Edit7.Clear;Form1.Edit8.Clear;Form1.Edit9.Clear;Form1.Edit10.Clear;
    Form1.Edit11.Clear;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form1.Canvas.Brush.Color:=clPlan;
  Form1.Canvas.Pen.Mode:=PmCopy;
  Form1.Canvas.Pen.Color :=clMenuText;
  Form1.Canvas.Rectangle(5,40,Form1.Width-150,Form1.Height-70);
  ListeTriang.SupprimeListe;
  ListePoint.SupprimeListe;
  NbTriangle:=0;
  NbPoint:=0;
  Naviguer:=NIL;
  TriangAlt:=NIL;
  Form1.Edit1.Text:=IntToStr(NbTriangle);
  Form1.Edit2.Text:=IntToStr(NbPoint);
end;


procedure TForm1.FormPaint(Sender: TObject);
begin
Form1.Canvas.Brush.Color:=clPlan;
Form1.Canvas.Pen.Mode:=PmCopy;
Form1.Canvas.Pen.Color :=clMenuText;
Form1.Canvas.Rectangle(5,40,Form1.Width-150,Form1.Height-70);
end;

initialization
clPoint := clWhite;
clLine := clWhite;
clPlan := clBlack;
clCherche := clTeal;
NbTriangle:=0;
NbPoint:=0;
Naviguer:=NIL;
TriangAlt:=NIL;

finalization

end.
//***********************************************************************//
//Bali Samir "Igénieur en informatique"
//Adresse: Cité hachichi Mohamed 140 logs Bt 'A' N° '8' Sétif 19000 Algérie.
//E-mail : balisamir2002@yahoo.fr
//***********************************************************************//
