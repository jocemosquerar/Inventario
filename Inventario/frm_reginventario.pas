unit frm_reginventario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, Buttons, ComCtrls,
  ActnList, StdCtrls, DbCtrls, DBExtCtrls, DBGrids, Dm_Reginventario,
  IBConnection, db, lcltype, rxdbcurredit, frm_buscadorelemento,
  frm_observacion;

type

  { Tfrmreginventario }

  Tfrmreginventario = class(TForm)
    D_Ubicacion: TDataSource;
    DBLookupComboBox8: TDBLookupComboBox;
    DBMemo4: TDBMemo;
    D_Mantenimiento: TDataSource;
    DBGrid3: TDBGrid;
    D_Salidas: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBMemo2: TDBMemo;
    DBMemo3: TDBMemo;
    D_Poliza: TDataSource;
    DBLookupComboBox7: TDBLookupComboBox;
    D_Movimiento: TDataSource;
    D_funcionario: TDataSource;
    D_Dependencia: TDataSource;
    DBLookupComboBox6: TDBLookupComboBox;
    D_Proveedor: TDataSource;
    D_Estado: TDataSource;
    D_Marca: TDataSource;
    D_Categoria: TDataSource;
    D_Elemento: TDataSource;
    DBDateEdit1: TDBDateEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    DBLookupComboBox4: TDBLookupComboBox;
    DBLookupComboBox5: TDBLookupComboBox;
    DBMemo1: TDBMemo;
    Buscar: TAction;
    Cancelar: TAction;
    Grabar: TAction;
    Editar: TAction;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Nuevo: TAction;
    ActionList1: TActionList;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    Panel1: TPanel;
    RxDBCurrEdit1: TRxDBCurrEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure BuscarExecute(Sender: TObject);
    procedure CancelarExecute(Sender: TObject);
    procedure DBDateEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBEdit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DBEdit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure DBLookupComboBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBox4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBox7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBLookupComboBox8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBMemo4Exit(Sender: TObject);
    procedure D_ElementoStateChange(Sender: TObject);
    procedure EditarExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GrabarExecute(Sender: TObject);
    procedure NuevoExecute(Sender: TObject);
  private
    { private declarations }
    Dm : TDmRegInventario;
    procedure Set_Origenes;
  public
    { public declarations }
  end;

var
  frmreginventario: Tfrmreginventario;

 procedure RegInventario(const base : TIBConnection);

implementation

{$R *.lfm}

{ Tfrmreginventario }

procedure RegInventario(const base: TIBConnection);
begin
  Application.CreateForm(TFrmRegInventario, FrmRegInventario);
  FrmRegInventario.Dm      := TDmRegInventario.Create(nil);
  FrmRegInventario.Dm.base := Base;

  frmreginventario.D_elemento.DataSet    :=  FrmRegInventario.Dm.Elemento;
  frmreginventario.D_Categoria.DataSet   :=  FrmRegInventario.Dm.Categoria;
  frmreginventario.D_marca.DataSet       :=  FrmRegInventario.Dm.marca;
  frmreginventario.D_estado.DataSet      :=  FrmRegInventario.Dm.estado;
  frmreginventario.D_proveedor.DataSet   :=  FrmRegInventario.Dm.proveedor;
  frmreginventario.D_dependencia.DataSet :=  FrmRegInventario.Dm.dependencia;
  frmreginventario.D_funcionario.DataSet :=  FrmRegInventario.Dm.Funcionario;
  frmreginventario.D_movimiento.DataSet  :=  FrmRegInventario.Dm.Movimiento;
  frmreginventario.D_poliza.DataSet      :=  FrmRegInventario.Dm.Aseguradora;
  frmreginventario.D_Salidas.DataSet     :=  FrmRegInventario.Dm.SqlSalidas;
  frmreginventario.D_Mantenimiento.DataSet :=  FrmRegInventario.Dm.Mantenimiento;
  frmreginventario.D_Ubicacion.DataSet   :=  FrmRegInventario.Dm.Ubicacion;

  FrmRegInventario.ShowModal;
  FrmRegInventario.Free;
end;

procedure Tfrmreginventario.DBEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) then
   SelectNext(ActiveControl,true, true);
end;

procedure Tfrmreginventario.BuscarExecute(Sender: TObject);
var
  id : integer;
begin
 id := buscar_elemento(Dm.Elemento.DataBase As TIBConnection);
 if id = -1 then
  MessageDlg('Producto NO existente', mtWarning, [mbOk], 0)
 else begin
   Dm.abrir_elemento(id);
   PageControl1.ActivePageIndex:=0;
  end;
end;

procedure Tfrmreginventario.CancelarExecute(Sender: TObject);
begin
 Dm.Elemento.Cancel;
 Dm.Movimiento.Cancel;
 Dm.Accion := EmptyStr;
end;

procedure Tfrmreginventario.DBDateEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);

 if (Dm.Elemento.State in [dsInsert, dsEdit]) And (Key=VK_ESCAPE) then
  Dm.Elemento.FieldByName('fecha_Compra').Clear;
end;

procedure Tfrmreginventario.DBEdit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);
end;

procedure Tfrmreginventario.DBGrid1EditButtonClick(Sender: TObject);
var
  texto : string;
begin
   with Tfrmobservacion.create(nil) do
    try
     texto := Dm.Movimiento.FieldByName('observacion').AsString;
     Memo1.Text := texto;
     ShowModal;
     if texto <> Memo1.text then begin
       if dm.movimiento.state in [dsBrowse] then
        dm.Movimiento.Edit;
       dm.Movimiento.FieldByName('observacion').AsString := Memo1.Text;
       Dm.Movimiento.Post;
      end;
    finally
      free;
    end;
end;

procedure Tfrmreginventario.DBLookupComboBox2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
 Cad : string;
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);

 if (Dm.Elemento.State in [dsInsert, dsEdit]) then begin

   if (Key=VK_ESCAPE) then
    Dm.Elemento.FieldByName('Id_Marca').Clear;

   if (Key=VK_INSERT) then begin
     Cad := InputBox('Creación de marca', 'Nombre de la marca', '');

     if Trim(Cad) = EmptyStr then begin
       MessageDlg('Descripción incompleta', mtwarning, [mbOk], 0);
       exit;
      end;

     if not Dm.Insertar_Accesoria('Marca', Trim(AnsiUpperCase(Cad)), 'Gen_Marca', Dm.Marca) then
      MessageDlg('No fue posible insertar el registro', mtwarning, [mbOk], 0);
    end;
  end;
end;

procedure Tfrmreginventario.DBLookupComboBox4KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
 cad : string;
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);

 if (Dm.Elemento.State in [dsInsert, dsEdit]) then begin

   if (Key=VK_ESCAPE) then
    Dm.Elemento.FieldByName('Id_Proveedor').Clear;

   if (Key=VK_INSERT) then begin
     Cad := InputBox('Creación de proveedor', 'Nombre del proveedor', '');

     if Trim(Cad) = EmptyStr then begin
       MessageDlg('Descripción incompleta', mtwarning, [mbOk], 0);
       exit;
      end;

     if not Dm.Insertar_Accesoria('Proveedor', Trim(AnsiUpperCase(Cad)), 'Gen_Proveedor', Dm.Proveedor) then
      MessageDlg('No fue posible insertar el registro', mtwarning, [mbOk], 0);
    end;
  end;
end;

procedure Tfrmreginventario.DBLookupComboBox7KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
 cad : string;
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);

 if (Dm.Elemento.State in [dsInsert, dsEdit]) then begin

   if (Key=VK_ESCAPE) then
    Dm.Elemento.FieldByName('Id_Aseguradora').Clear;

   if (Key=VK_INSERT) then begin
     Cad := InputBox('Creación de Aseguradora', 'Póliza y Nombre de aseguradora', '');

     if Trim(Cad) = EmptyStr then begin
       MessageDlg('Descripción incompleta', mtwarning, [mbOk], 0);
       exit;
      end;

     if not Dm.Insertar_Accesoria('Aseguradora', Trim(AnsiUpperCase(Cad)), 'Gen_Aseguradora', Dm.Aseguradora) then
      MessageDlg('No fue posible insertar el registro', mtwarning, [mbOk], 0);
    end;
  end;
end;

procedure Tfrmreginventario.DBLookupComboBox8KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
 cad : string;
begin
 if (Key=VK_RETURN) then
  SelectNext(ActiveControl,true, true);

 if (Dm.Elemento.State in [dsInsert, dsEdit]) then begin

   if (Key=VK_ESCAPE) then
    Dm.Elemento.FieldByName('Id_Ubicacion').Clear;

   if (Key=VK_INSERT) then begin
     Cad := InputBox('Creación de ubicación', 'Nombre de la ubicación', '');

     if Trim(Cad) = EmptyStr then begin
       MessageDlg('Descripción incompleta', mtwarning, [mbOk], 0);
       exit;
      end;

     if not Dm.Insertar_Accesoria('Ubicacion', Trim(AnsiUpperCase(Cad)), 'Gen_Ubicacion', Dm.Ubicacion) then
      MessageDlg('No fue posible insertar el registro', mtwarning, [mbOk], 0);
    end;
  end;
end;

procedure Tfrmreginventario.DBMemo4Exit(Sender: TObject);
begin
  if Dm.Mantenimiento.State in [dsInsert, dsEdit] then
   Dm.Mantenimiento.Post;
end;

procedure Tfrmreginventario.D_ElementoStateChange(Sender: TObject);
begin
//  DBLookupComboBox3.enabled := not (Dm.Elemento.state in [dsEdit]);   // Estado
//  DBLookupComboBox5.enabled := not (Dm.Elemento.state in [dsEdit]);   // Responsable
//  DBLookupComboBox6.enabled := not (Dm.Elemento.state in [dsEdit]);   // Dependencia

  if Dm.Elemento.state in [dsInsert, dsEdit] then begin
    Buscar.Enabled := False;
    ToolButton1.Action := Grabar;
    ToolButton2.Action := Cancelar;
   end
  else begin
    Buscar.Enabled := True;
    ToolButton1.Action := Nuevo;
    ToolButton2.Action := Editar;
   end;
end;

procedure Tfrmreginventario.EditarExecute(Sender: TObject);
begin
  if dm.Movimiento.state in [dsInsert, dsEdit] then begin
    MessageDlg('Actualice o cancele el registro de novedades antes de continuar', mtWarning, [mbOk], 0);
    exit;
   end;

  if Dm.Elemento.IsEmpty then
   MessageDlg('Seleccione primero un elemento', mtWarning, [mbOk], 0)
  else begin
    Dm.Elemento.Edit;
    Dm.Accion := 'E';
    PageControl1.ActivePageIndex:=0;
//    DBEdit1.SetFocus;
  end;
end;

procedure Tfrmreginventario.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
 FrmRegInventario := nil;
end;

procedure Tfrmreginventario.FormCreate(Sender: TObject);
begin
 PageControl1.ActivePageIndex:=0;
end;

procedure Tfrmreginventario.GrabarExecute(Sender: TObject);
var
  msg : string;
begin
  msg := Dm.validar_datos;
  if Msg = EmptyStr then begin

    if Dm.Elemento.state in [dsEdit, dsInsert] then
     Dm.Elemento.Post;
    Dm.Elemento.ApplyUpdates;

    if Dm.Movimiento.state in [dsEdit, dsInsert] then
     Dm.Movimiento.Post;
    Dm.Movimiento.ApplyUpdates;

    if Dm.Mantenimiento.state in [dsEdit, dsInsert] then
     Dm.Mantenimiento.Post;
    Dm.Mantenimiento.ApplyUpdates(-1);

    Dm.SQLTransaction1.CommitRetaining;
    Dm.Accion := EmptyStr;
   end
  else
    MessageDlg('Corrija lo siguiente antes de continuar' + #13+#10 + Msg, mtError, [mbOk], 0);
end;

procedure Tfrmreginventario.NuevoExecute(Sender: TObject);
begin
  if dm.Movimiento.state in [dsInsert, dsEdit] then begin
    MessageDlg('Actualice o cancele el registro de novedades antes de continuar', mtWarning, [mbOk], 0);
    exit;
   end;

  dm.abrir_elemento(-1);
  dm.Elemento.Insert;
  dm.Accion:= 'I';

  PageControl1.ActivePageIndex := 0;
  DBEdit1.SetFocus;
end;

procedure Tfrmreginventario.Set_Origenes;
begin
  D_Elemento.DataSet := Dm.Elemento;
end;

end.

