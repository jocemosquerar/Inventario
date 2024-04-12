unit frm_buscarsalida;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, DateTimePicker, lcltype, Buttons, IbConnection;

type

  { Tfrmbuscarsalida }

  Tfrmbuscarsalida = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    DataSource1: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    SQLQuery1: TSQLQuery;
    procedure Button1Click(Sender: TObject);
    procedure DateTimePicker1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SQLQuery1AfterOpen(DataSet: TDataSet);
  private

  public

  end;

var
  frmbuscarsalida: Tfrmbuscarsalida;

function buscar_salida(const base : TIBConnection) : integer;

implementation

{$R *.lfm}

{ Tfrmbuscarsalida }

function buscar_salida(const base : TIBConnection) : integer;
begin
 Application.CreateForm(TfrmBuscarSalida, FrmBuscarSalida);
 FrmBuscarSalida.SQLQuery1.DataBase := base;
 frmbuscarsalida.ShowModal;
 if frmbuscarsalida.ModalResult = mrOk then
  Result := FrmBuscarSalida.SqlQuery1.FieldByName('Id').AsInteger
 else
  Result := -1;
end;

procedure Tfrmbuscarsalida.FormCreate(Sender: TObject);
begin
  DateTimePicker1.Date := Date;
  DateTimePicker2.Date := Date;
end;

procedure Tfrmbuscarsalida.FormDestroy(Sender: TObject);
begin
  FrmBuscarSalida := nil;
end;

procedure Tfrmbuscarsalida.SQLQuery1AfterOpen(DataSet: TDataSet);
begin
  BitBtn1.Enabled := not SqlQuery1.IsEmpty;
end;

procedure Tfrmbuscarsalida.DateTimePicker1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_RETURN) then
   SelectNext(ActiveControl,true, true);
end;

procedure Tfrmbuscarsalida.Button1Click(Sender: TObject);
begin
 SqlQuery1.Close;
 SqlQuery1.ParamByName('Ini').AsDateTime := DateTimePicker1.Date;
 SqlQuery1.ParamByName('Fin').AsDateTime := DateTimePicker2.Date;
 SqlQuery1.Open;
end;

end.

