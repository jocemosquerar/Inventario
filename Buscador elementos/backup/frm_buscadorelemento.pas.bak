unit frm_buscadorelemento;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, ExtCtrls, StdCtrls, Buttons, LclType, IBConnection;

type

  { Tfrmbuscadorelemento }

  Tfrmbuscadorelemento = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    SQLQuery1: TSQLQuery;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    procedure buscar(const opc : integer; const cad : string);
  public
    { public declarations }
  end;

var
  frmbuscadorelemento: Tfrmbuscadorelemento;

  function buscar_elemento(const base : TIBConnection) : integer;

implementation

{$R *.lfm}

{ Tfrmbuscadorelemento }

function buscar_elemento(const base: TIBConnection): integer;
begin
  Application.CreateForm(TFrmBuscadorElemento, FrmBuscadorElemento);
  frmbuscadorelemento.SQLQuery1.DataBase := Base;
  FrmBuscadorElemento.ShowModal;
  if frmbuscadorelemento.SQLQuery1.IsEmpty then
   Result := -1
  else
    Result := frmbuscadorelemento.SQLQuery1.FieldByName('Id').AsInteger;
  frmbuscadorelemento.Free;
end;

procedure Tfrmbuscadorelemento.BitBtn1Click(Sender: TObject);
begin
 if Trim(Edit1.Text) = EmptyStr then
  MessageDlg('No se especificó nada que buscar', mtWarning, [mbOk], 0)
 else begin
   buscar(RadioGroup1.ItemIndex, Edit1.Text);
   DBGrid1.SetFocus;
  end;
end;

procedure Tfrmbuscadorelemento.BitBtn2Click(Sender: TObject);
begin
  SQLQuery1.Close;
  Edit1.Clear;
  RadioGroup1.SetFocus;
end;

procedure Tfrmbuscadorelemento.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key=VK_RETURN) then
  Close;
end;

procedure Tfrmbuscadorelemento.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);
end;

procedure Tfrmbuscadorelemento.FormDestroy(Sender: TObject);
begin
 FrmBuscadorElemento := nil;
end;

procedure Tfrmbuscadorelemento.buscar(const opc: integer; const cad: string);
var
  aux : string;
begin
  case opc of
   0 : aux := ' Inventario = ' + QuotedStr(Trim(Edit1.Text));
   1 : aux := 'Serie = ' + QuotedStr(Trim(Edit1.Text));
   2 : aux := 'Descripcion Like '  + QuotedStr('%' +  Trim(Edit1.Text) + '%');
  end;

 SQLQuery1.Close;
 SQLQuery1.Sql[3] := aux;
 SQLQuery1.Open;
end;

end.

