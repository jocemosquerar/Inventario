unit dm_reginventario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, IBConnection, Dialogs;

type

  { Tdmreginventario }

  Tdmreginventario = class(TDataModule)
    Categoria: TSQLQuery;
    Elemento: TSQLQuery;
    Estado: TSQLQuery;
    Dependencia: TSQLQuery;
    Aseguradora: TSQLQuery;
    MantenimientoFECHA: TDateField;
    MantenimientoID: TLongintField;
    MantenimientoID_ELEMENTO: TLongintField;
    MantenimientoID_RESPONSABLE: TLongintField;
    MantenimientoOBSERVACIONES: TMemoField;
    Responsable: TSQLQuery;
    MovimientoFECHA: TDateField;
    MovimientoID: TLongintField;
    MovimientoID_ELEMENTO: TLongintField;
    MovimientoID_ESTADO: TLongintField;
    MovimientoID_FUNCIONARIO: TSmallintField;
    MovimientoOBSERVACION: TStringField;
    SqlEstado: TSQLQuery;
    Funcionario: TSQLQuery;
    SqlFuncionario: TSQLQuery;
    Marca: TSQLQuery;
    Movimiento: TSQLQuery;
    Proveedor: TSQLQuery;
    SQLQuery1: TSQLQuery;
    Mantenimiento: TSQLQuery;
    Ubicacion: TSQLQuery;
    SqlSalidas: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure ElementoAfterClose(DataSet: TDataSet);
    procedure ElementoAfterInsert(DataSet: TDataSet);
    procedure ElementoAfterOpen(DataSet: TDataSet);
    procedure MantenimientoBeforeInsert(DataSet: TDataSet);
    procedure MantenimientoBeforePost(DataSet: TDataSet);
    procedure MovimientoAfterInsert(DataSet: TDataSet);
    procedure MovimientoBeforeInsert(DataSet: TDataSet);
    procedure MovimientoBeforePost(DataSet: TDataSet);
    procedure MantenimientoAfterInsert(DataSet: TDataSet);
  private
    Fbase: TIBConnection;
    procedure Setbase(AValue: TIBConnection);
    { private declarations }
  public
    { public declarations }
    Accion : string;

    property base : TIBConnection read Fbase write Setbase;
    function abrir_elemento(const id : integer) : boolean;
    function validar_datos : string;
    function Insertar_Accesoria(const tabla, valor, generador : string; const cuery : TSQLQuery) : boolean;
  end;

var
  dmreginventario: Tdmreginventario;

implementation

{$R *.lfm}

{ Tdmreginventario }

procedure Tdmreginventario.MovimientoAfterInsert(DataSet: TDataSet);
begin
 Movimiento.FieldByName('Id').AsInteger             := -1;
 Movimiento.FieldByName('Id_Elemento').AsInteger    := Elemento.FieldByName('Id').AsInteger;
 Movimiento.FieldByName('Id_Funcionario').AsInteger := Elemento.FieldByName('Id_Funcionario').AsInteger;
 Movimiento.FieldByName('Id_Estado').AsInteger      := Elemento.FieldByName('Id_Estado').AsInteger;
 Movimiento.FieldByName('fecha').Value              := Date;
end;

procedure Tdmreginventario.MovimientoBeforeInsert(DataSet: TDataSet);
begin
  if Accion = EmptyStr then
   Abort;
end;

procedure Tdmreginventario.MovimientoBeforePost(DataSet: TDataSet);
begin
 if (Movimiento.FieldByName('Fecha').AsDateTime > Date) then begin
   MessageDlg('Fecha de novedad incorrecta', mtWarning, [mbOk], 0);
   Abort;
  end;

  if (Movimiento.FieldByName('Id_Funcionario').AsInteger = Elemento.FieldByName('Id_Funcionario').AsInteger) And
     (Movimiento.FieldByName('Id_Estado').AsInteger = Elemento.FieldByName('Id_Estado').AsInteger) then begin
    MessageDlg('No ha cambiado nada del elemento', mtWarning, [mbOk], 0);
    Abort;
   end;
end;

procedure Tdmreginventario.MantenimientoAfterInsert(DataSet: TDataSet);
begin
 Mantenimiento.FieldByName('Id_Elemento').AsInteger    := Elemento.FieldByName('Id').AsInteger;
 Mantenimiento.FieldByName('Fecha').Value              := Date;
 Mantenimiento.FieldByName('Id_responsable').AsInteger := Responsable.FieldByName('Id').AsInteger;
end;

procedure Tdmreginventario.ElementoAfterInsert(DataSet: TDataSet);
begin
  Elemento.FieldByName('Id').AsInteger           := -1;
  Elemento.FieldByName('Id_Estado').AsInteger    := 1;
  Elemento.FieldByName('Id_Ubicacion').AsInteger := 1;
end;

procedure Tdmreginventario.ElementoAfterClose(DataSet: TDataSet);
begin
  Movimiento.Close;
end;

procedure Tdmreginventario.DataModuleCreate(Sender: TObject);
begin
  Accion := EmptyStr;
end;

procedure Tdmreginventario.ElementoAfterOpen(DataSet: TDataSet);
begin
 Movimiento.Close;
 Movimiento.ParamByName('Id').AsInteger := Elemento.FieldByName('Id').AsInteger;
 Movimiento.Open;

 SqlSalidas.Close;
 SqlSalidas.ParamByName('Id').AsInteger := Elemento.FieldByName('Id').AsInteger;
 SqlSalidas.Open;

 Mantenimiento.Close;
 Mantenimiento.ParamByName('Id').AsInteger := Elemento.FieldByName('Id').AsInteger;
 Mantenimiento.Open;
end;

procedure Tdmreginventario.MantenimientoBeforeInsert(DataSet: TDataSet);
begin
  if Accion = EmptyStr then
   Abort;
end;

procedure Tdmreginventario.MantenimientoBeforePost(DataSet: TDataSet);
begin
  if (Mantenimiento.FieldByName('Fecha').AsDateTime > Date) then begin
    MessageDlg('Fecha de mantenimiento incorrecta', mtWarning, [mbOk], 0);
    Abort;
   end;
end;

procedure Tdmreginventario.Setbase(AValue: TIBConnection);
begin
  if Fbase=AValue then Exit;
   Fbase:=AValue;

  SQLTransaction1.DataBase := Fbase;
  Elemento.DataBase    := FBase;
  Categoria.DataBase   := FBase;
  Marca.DataBase       := FBase;
  Proveedor.DataBase   := FBase;
  Movimiento.DataBase  := FBase;
  Funcionario.DataBase := FBase;
  Estado.DataBase      := FBase;
  Dependencia.DataBase := FBase;
  SQLQuery1.DataBase   := FBase;
  SqlFuncionario.DataBase := FBase;
  SqlEstado.DataBase   := Fbase;
  Aseguradora.DataBase := Fbase;
  SqlSalidas.DataBase  := Fbase;
  Mantenimiento.DataBase:= Fbase;
  Responsable.DataBase := Fbase;
  Ubicacion.DataBase   := Fbase;

  Categoria.Open;
  Marca.Open;
  Proveedor.Open;
  Movimiento.Open;
  Funcionario.Open;
  Estado.Open;
  Dependencia.Open;
  SqlFuncionario.Open;
  SqlEstado.Open;
  Aseguradora.Open;
  Responsable.Open;
  Ubicacion.Open;
end;

function Tdmreginventario.abrir_elemento(const id: integer): boolean;
begin
  Elemento.Close;
  Elemento.ParamByName('Id').AsInteger := Id;
  Elemento.Open;
  Result := not Elemento.IsEmpty;
end;

function Tdmreginventario.validar_datos: string;
var
  mensaje : string;
///
   function validar_descripcion : string;
   begin
    if Elemento.FieldByName('Descripcion').IsNull then
     Result := 'Descripción incompleta' + #13 + #10
    else
     Result := EmptyStr;
    end;
///
   function validar_inventario : string;
   begin
   if Elemento.FieldByName('Inventario').IsNull then
     Result := 'Número de inventario incompleto' + #13 + #10
     else begin
       SQLQuery1.Close;
       SqlQuery1.Sql.Text := Format('Select count(*) from elemento where inventario = %s ', [QuotedStr(Trim(Elemento.FieldByName('Inventario').AsString))]);

       if Elemento.State in [dsEdit] then
        SqlQuery1.Sql.Text := SqlQuery1.Sql.Text + ' And Id <> ' + Elemento.FieldByName('Id').AsString;

      SqlQuery1.Open;
      if SQLQuery1.Fields[0].AsInteger > 0 then
       Result := 'Número de inventario YA registrado' + #13 + #10
      else
       Result := EmptyStr;
     end;
   end;
///
   function validar_categoria : string;
   begin
    if Elemento.FieldByName('id_categoria').IsNull then
     Result := 'Categoria incompleta' + #13 + #10
    else
     Result := EmptyStr;
   end;
///
   function validar_dependencia : string;
   begin
    if Elemento.FieldByName('id_dependencia').IsNull then
     Result := 'Dependencia incompleta' + #13 + #10
    else
      Result := EmptyStr;
  end;
///
   function validar_marca : string;
   begin
    if Elemento.FieldByName('id_marca').IsNull then
     Result := 'Marca incompleta' + #13 + #10
    else
     Result := EmptyStr;
   end;
///
   function validar_fcompra : string;
   begin
    if (Elemento.FieldByName('Fecha_Compra').IsNull) then
     Result := EmptyStr
    else begin
       if (Elemento.FieldByName('Fecha_Compra').Value < StrToDate('01/01/2008')) or (Elemento.FieldByName('Fecha_Compra').Value > Date)  then
        Result := 'Fecha de compra incorrecta' + #13 + #10
       else
        Result := EmptyStr;
     end;
   end;
///
function validar_vcompra : string;
begin
 if (Elemento.FieldByName('Valor_Compra').AsInteger < 0)   then
   Result := 'Valor de compra incorrecto' + #13 + #10
  else
   Result := EmptyStr;
end;
///
   function validar_funcionario : string;
   begin
    if (Elemento.FieldByName('id_funcionario').IsNull)   then
     Result := 'Responsable incompleto' + #13 + #10
    else
     Result := EmptyStr;
    end;
///
  function validar_estado : string;
  begin
   if (Elemento.FieldByName('id_estado').IsNull)   then
    Result := 'Estado incompleto' + #13 + #10
   else
    Result := EmptyStr;
   end;
///
begin
 mensaje := EmptyStr;
 mensaje := mensaje + validar_inventario;
 mensaje := mensaje + validar_dependencia;
 mensaje := mensaje + validar_descripcion;
 mensaje := mensaje + validar_categoria;
 mensaje := mensaje + validar_estado;
 mensaje := mensaje + validar_funcionario;
 mensaje := mensaje + validar_fcompra;
 mensaje := mensaje + validar_vcompra;

 Result := mensaje;
end;

function Tdmreginventario.Insertar_Accesoria(const tabla, valor, generador : string; const cuery : TSQLQuery) : boolean;
begin
 Result := False;

 SQLQuery1.close;
 SQLQuery1.SQL.Text := Format('Select Count(*) From %s where descripcion = %s',
                              [Tabla, QuotedStr(UpperCase(Trim(Valor)))]);
 SQLQuery1.Open;

 if SQLQuery1.Fields[0].AsInteger > 0 then
  exit;

 SQLQuery1.Close;
 SQLQuery1.SQL.Text := Format('Insert Into %s (id, descripcion) values (gen_id(%s, 1), %s)',
                             [Tabla, Generador, QuotedStr(Valor)]);
 SQLQuery1.ExecSQL;

 SQLTransaction1.CommitRetaining;
 Cuery.Close;
 Cuery.Open;

 Result := True;
end;

end.

