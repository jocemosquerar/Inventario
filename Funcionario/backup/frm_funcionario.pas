unit frm_funcionario;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, ibconnection;

type

  { Tfrmfuncionario }

  Tfrmfuncionario = class(TForm)
    D_Funcionario: TDataSource;
    DBGrid1: TDBGrid;
    Funcionario: TSQLQuery;
    FuncionarioAPELLIDOS: TStringField;
    FuncionarioID: TLongintField;
    FuncionarioIDENTIFICACION: TStringField;
    FuncionarioNOMBRES: TStringField;
    SQLQuery3: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure FormDestroy(Sender: TObject);
    procedure FuncionarioAfterInsert(DataSet: TDataSet);
    procedure FuncionarioAfterPost(DataSet: TDataSet);
    procedure FuncionarioBeforePost(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmfuncionario: Tfrmfuncionario;

 procedure persona(const Base : TIBConnection);

implementation

{$R *.lfm}

procedure persona(const Base : TIBConnection);
begin
 Application.createform(tfrmfuncionario, frmfuncionario);

 frmfuncionario.SQLTransaction1.DataBase := base;
 frmfuncionario.Funcionario.DataBase     := base;
 frmfuncionario.SQLQuery3.DataBase       := base;

 frmfuncionario.Funcionario.open;

 frmfuncionario.showmodal;
end;

{ Tfrmfuncionario }

procedure Tfrmfuncionario.FormDestroy(Sender: TObject);
begin
 frmfuncionario := nil;
end;

procedure Tfrmfuncionario.FuncionarioAfterInsert(DataSet: TDataSet);
begin
 Funcionario.FieldByName('Id').AsInteger := -1;
end;

procedure Tfrmfuncionario.FuncionarioAfterPost(DataSet: TDataSet);
begin
  Funcionario.ApplyUpdates(-1);
  SQLTransaction1.CommitRetaining;
  Funcionario.Close;
  Funcionario.Open;
end;

procedure Tfrmfuncionario.FuncionarioBeforePost(DataSet: TDataSet);
var
 mensaje : string;
///
   function val_identificacion : string;
   begin
    if Funcionario.fieldbyname('identificacion').IsNull then
     result := 'Identificación incompleta' + #13+#10
    else begin
      SQLQuery3.Close;
      SQLQuery3.Sql.Text := 'Select count(*) from funcionario where identificacion = '  + QuotedStr(Funcionario.fieldbyname('identificacion').AsString);
      if Funcionario.State in [dsEdit] then
        SqlQuery3.Sql.Text := SqlQuery3.Sql.Text + ' And Id <> ' + Funcionario.fieldbyname('id').Asstring;
      SqlQuery3.Open;
      if SQLQuery3.fields[0].AsInteger > 0 then
       result := 'Identificación YA registrada' + #13+#10
      else
       result := Emptystr;
     end;
   end;
///
   function val_nombres : string;
   begin
    if (funcionario.fieldbyname('Apellidos').IsNull) or (funcionario.fieldbyname('Nombres').IsNull) then
     result := 'Apellidos / Nombres incompletos' + #13 + #10
    else
     result := Emptystr;
   end;
///
begin
 mensaje := val_identificacion;
 mensaje := mensaje + val_nombres;

 if mensaje <> emptystr then begin
   MessageDlg('Corrija lo siguiente antes de continuar : ' + #13+#10 + mensaje, mtError, [mbok], 0);
   Abort;
  end
 else begin
   Funcionario.Fieldbyname('Apellidos').AsString := Trim(UpCase(Funcionario.Fieldbyname('Apellidos').AsString));
   Funcionario.Fieldbyname('Nombres').AsString   := Trim(UpCase(Funcionario.Fieldbyname('Nombres').AsString));
 end;
end;


end.

