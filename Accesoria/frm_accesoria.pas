unit frm_accesoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics, Dialogs,
  DbCtrls, DBGrids, IbConnection;

type

  { Tfrmaccesoria }

  Tfrmaccesoria = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure FormDestroy(Sender: TObject);
    procedure SQLQuery1AfterInsert(DataSet: TDataSet);
    procedure SQLQuery1AfterPost(DataSet: TDataSet);
    procedure SQLQuery1BeforePost(DataSet: TDataSet);
  private
    { private declarations }
    objeto : string;
    procedure Armar_Sql;
  public
    { public declarations }
  end;

var
  frmaccesoria: Tfrmaccesoria;

 procedure accesoria(const Base : TIBConnection; const tabla : string);

implementation

{$R *.lfm}

procedure accesoria(const Base : TIBConnection; const tabla : string);
begin
 Application.CreateForm(TFrmAccesoria, FrmAccesoria);
 FrmAccesoria.Caption:= FrmAccesoria.Caption + tabla;
 FrmAccesoria.objeto := tabla;
 FrmAccesoria.SQLTransaction1.DataBase := Base;
 FrmAccesoria.Armar_Sql;
 FrmAccesoria.ShowModal;
end;

{ Tfrmaccesoria }

procedure Tfrmaccesoria.SQLQuery1AfterPost(DataSet: TDataSet);
begin
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.CommitRetaining;
  SQLQuery1.Close;
  SQLQuery1.Open;
end;

procedure Tfrmaccesoria.SQLQuery1BeforePost(DataSet: TDataSet);
begin
 if SQLQuery1.Fieldbyname('descripcion').isnull then
  Raise Exception.Create('Descripción incompleta')
 else begin

   SQLQuery1.Fieldbyname('descripcion').AsString := Trim(UpCase(SQLQuery1.Fieldbyname('descripcion').AsString));

   SQLQuery2.Close;
   SqlQuery2.SQL.Text := Format('Select Count(*) From %s Where Descripcion = %s', [objeto, quotedstr(SQLQuery1.Fieldbyname('descripcion').AsString)]);
   if SQLQuery1.State in [dsEdit] then
    SqlQuery2.SQL.Text := SqlQuery2.SQL.Text + ' And Id <> ' + SqlQuery1.FieldByName('Id').AsString;
   SQLQuery2.Open;
   if SQLQuery2.Fields[0].AsInteger > 0 then begin
     MessageDlg('Descripción ya registrada', mtError, [mbOk], 0);
     Abort;
    end;
 end;
end;

procedure Tfrmaccesoria.FormDestroy(Sender: TObject);
begin
 FrmAccesoria := nil;
end;

procedure Tfrmaccesoria.SQLQuery1AfterInsert(DataSet: TDataSet);
begin
  SqlQuery1.FieldByName('Id').AsInteger := -1;
end;

procedure Tfrmaccesoria.Armar_Sql;
begin
// SQLQuery1.Sequence.SequenceName:= 'Gen_' + objeto;
 SQLQuery1.SQL.Text        := Format('Select * From %s order by descripcion', [objeto]);
 SQLQuery1.InsertSQL.Text  := Format('Insert Into %s (Id, Descripcion) Values (:Id, :Descripcion)', [objeto]);
 SQLQuery1.UpdateSQL.Text  := Format('Update %s Set Descripcion = :Descripcion Where Id = :Old_Id', [objeto]);
 SqlQuery1.RefreshSQL.Text := Format('Select * From %s Where Id = gen_id(gen_%s, 0)', [objeto, objeto]);
// SqlQuery1.RefreshSQL.Text := Format('Select * From %s Where Id = :Id', [objeto]);
 SqlQuery1.DeleteSQL.Text  := Format('Delete From %s Where Id = :Id', [objeto]);

 SQLQuery1.DataBase := SQLTransaction1.DataBase;
 SQLQuery2.DataBase := SQLTransaction1.DataBase;

 SQLQuery1.Open;
end;

end.

