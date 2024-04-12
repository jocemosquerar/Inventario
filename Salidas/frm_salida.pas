unit frm_salida;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, Forms, Controls, Graphics, Dialogs, DBCtrls,
  ExtCtrls, ComCtrls, ActnList, StdCtrls, DBDateTimePicker, LR_Class, LR_DBSet,
  ibconnection, LclType, frm_buscarsalida;

type

  { Tfrmsalida }

  Tfrmsalida = class(TForm)
    Button1: TButton;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    D_SqlQuery1: TDataSource;
    D_SqlElemento: TDataSource;
    D_SqlSalida: TDataSource;
    DBDateTimePicker2: TDBDateTimePicker;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    Imprimir: TAction;
    ActionList1: TActionList;
    Buscar: TAction;
    Cancelar: TAction;
    DBDateTimePicker1: TDBDateTimePicker;
    Editar: TAction;
    Grabar: TAction;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Nuevo: TAction;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SqlSalida: TSQLQuery;
    SqlElemento: TSQLQuery;
    SqlSalidaFECHA_REGRESO: TDateField;
    SqlSalidaFECHA_SALIDA: TDateField;
    SqlSalidaID: TLongintField;
    SqlSalidaID_ELEMENTO: TLongintField;
    SqlSalidaOBSERVACIONES_REGRESO: TMemoField;
    SqlSalidaOBSERVACIONES_SALIDA: TMemoField;
    SQLTransaction1: TSQLTransaction;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure BuscarExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CancelarExecute(Sender: TObject);
    procedure DBDateTimePicker1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure D_SqlSalidaStateChange(Sender: TObject);
    procedure EditarExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GrabarExecute(Sender: TObject);
    procedure ImprimirExecute(Sender: TObject);
    procedure NuevoExecute(Sender: TObject);
    procedure SqlSalidaAfterInsert(DataSet: TDataSet);
    procedure SqlSalidaAfterOpen(DataSet: TDataSet);
    procedure SqlSalidaAfterPost(DataSet: TDataSet);
    procedure SqlSalidaBeforePost(DataSet: TDataSet);
  private
    procedure abrir_elemento(const id : integer);
    procedure abrir_salida(const id : integer);
  public

  end;

var
  frmsalida: Tfrmsalida;

 procedure salida(const Base : TIBConnection);

implementation

{$R *.lfm}

procedure salida(const Base : TIBConnection);
begin
 Application.CreateForm(TfrmSalida, Frmsalida);
 FrmSalida.SQLTransaction1.DataBase := base;
 FrmSalida.SQLTransaction1.Active   := True;
 FrmSalida.SqlSalida.DataBase       := base;
 FrmSalida.SqlElemento.DataBase     := base;
 FrmSalida.SqlQuery1.DataBase       := base;
 FrmSalida.SqlQuery2.DataBase       := base;
 FrmSalida.ShowModal;
end;

{ Tfrmsalida }

procedure Tfrmsalida.FormDestroy(Sender: TObject);
begin
  frmsalida := nil;
end;

procedure Tfrmsalida.GrabarExecute(Sender: TObject);
begin
  SqlSalida.Post;
end;

procedure Tfrmsalida.ImprimirExecute(Sender: TObject);
begin
 if SqlSalida.IsEmpty then
  exit;

 if (SqlSalida.state in [dsInsert, dsEdit]) then
  exit;

 SqlQuery1.Close;
 SqlQuery1.ParamByName('Id').AsInteger := SqlSalida.FieldByName('Id').AsInteger;
 SQLQuery1.Open;
 frReport1.ShowReport;
 SQLQuery1.Close;
end;

procedure Tfrmsalida.NuevoExecute(Sender: TObject);
begin
  Abrir_Salida(-1);
  SqlSalida.Insert;
  DBDateTimePicker1.SetFocus;
end;

procedure Tfrmsalida.abrir_salida(const id: integer);
begin
  SqlSalida.Close;
  SqlSalida.ParamByName('Id').AsInteger := id;
  SqlSalida.Open;
end;

procedure Tfrmsalida.Button1Click(Sender: TObject);
var
  cod : string;
begin
  if not (SqlSalida.state in [dsInsert, dsEdit]) then
   exit;

  if InputQuery('Búsqueda', 'Número de inventario', cod) then begin
    SqlQuery2.Close;
    SqlQuery2.SQL.Text := Format('Select Id From ELEMENTO Where inventario = %s', [QuotedStr(Trim(cod))]);
    SqlQuery2.Open;
    if SQLQuery2.IsEmpty then begin
      SqlSalida.FieldByName('Id_Elemento').Clear;
      MessageDlg('Número de inventario NO registrado', mtWarning, [mbOk], 0);
     end
    else begin
      SqlSalida.FieldByName('Id_Elemento').AsInteger := SqlQuery2.FieldByName('Id').AsInteger;
      Abrir_Elemento(SqlQuery2.FieldByName('Id').AsInteger);
     end;
  end;
end;

procedure Tfrmsalida.BuscarExecute(Sender: TObject);
var
  iD : integer;
begin
 if SqlSalida.State in [dsInsert, dsEdit] then
  exit;

 iD := Buscar_Salida(SqlSalida.DataBase as TIBConnection);
 if iD = -1 then begin
   Messagedlg('Salida NO existente', mtWarning, [mbOk], 0);
   exit
  end
 else
  abrir_salida(iD);
end;

procedure Tfrmsalida.CancelarExecute(Sender: TObject);
begin
  SqlSalida.Cancel;
  SQLTransaction1.RollbackRetaining;
  SqlSalida.Close;
end;

procedure Tfrmsalida.DBDateTimePicker1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) then
   SelectNext(ActiveControl,true, true);
end;

procedure Tfrmsalida.D_SqlSalidaStateChange(Sender: TObject);
begin
  if SqlSalida.State in [dsEdit, dsInsert] then begin
    ToolButton1.Action := Grabar;
    ToolButton6.Action := Cancelar;
    Buscar.Enabled     := False;
    Imprimir.Enabled   := False;
   end
  else begin
   ToolButton1.Action := Nuevo;
   ToolButton6.Action := Editar;
   Buscar.Enabled     := True;
   Imprimir.Enabled   := True;
  end;
end;

procedure Tfrmsalida.EditarExecute(Sender: TObject);
begin
  if (not SqlSalida.Active) or (SqlSalida.IsEmpty) then
   exit;

 SqlSalida.Edit;
end;

procedure Tfrmsalida.SqlSalidaAfterInsert(DataSet: TDataSet);
begin
  SqlSalida.FieldByName('Fecha_Salida').AsDateTime := Date;
end;

procedure Tfrmsalida.SqlSalidaAfterOpen(DataSet: TDataSet);
begin
  if not SqlSalida.IsEmpty then
   abrir_elemento(SqlSalida.FieldByName('Id_Elemento').AsInteger);
end;

procedure Tfrmsalida.SqlSalidaAfterPost(DataSet: TDataSet);
begin
  Sqlsalida.ApplyUpdates;
  SqlTransaction1.CommitRetaining;
end;

procedure Tfrmsalida.SqlSalidaBeforePost(DataSet: TDataSet);
var
 msg : string;
begin
  msg := EmptyStr;
  if SqlSalida.FieldByName('Fecha_Salida').IsNull then
   msg := 'Fecha de salida incompleta' + #10+#13;

  if SqlSalida.FieldByName('Observaciones_Salida').IsNull then
   msg := msg + 'Observaciones de salida incompletas' + #10+#13;

  if not SqlSalida.FieldByName('Fecha_Regreso').IsNull then begin
    if SqlSalida.FieldByName('Fecha_Regreso').Value < SqlSalida.FieldByName('Fecha_Salida').Value then
     msg := msg + 'Fecha de regreso incorrecta' + #10+#13;
   end
  else
   if not SqlSalida.FieldByName('Observaciones_Regreso').IsNull then
    msg := msg + 'Fecha de regreso incompleta' + #10+#13;

 if msg <> EmptyStr then begin
  MessageDlg(msg, mtError, [mbOk], 0);
  Abort;
 end;
end;

procedure Tfrmsalida.abrir_elemento(const id: integer);
begin
  SqlElemento.Close;
  SqlElemento.ParamByName('Id').AsInteger := id;
  SqlElemento.Open;
end;

end.

