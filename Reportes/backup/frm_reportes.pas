unit frm_reportes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, LR_Class, LR_DBSet, LR_E_CSV,
  lr_e_pdf, Forms, Controls, Graphics, Dialogs, ExtCtrls, DbCtrls, Buttons,
  StdCtrls, DBGrids, IbConnection;

type

  { Tfrmreportes }

  Tfrmreportes = class(TForm)
    BitBtn1: TBitBtn;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    frCSVExport1: TfrCSVExport;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    frTNPDFExport1: TfrTNPDFExport;
    GroupBox1: TGroupBox;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    SQLQuery1: TSQLQuery;
    SQLReport2: TSQLQuery;
    SQLReport: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { private declarations }
    NumInve : string;
  public
    { public declarations }
  end;

const
  SqlGeneral = 'select elemento.inventario, elemento.descripcion elemento, elemento.serie,' +
               'marca.descripcion marca, elemento.modelo, funcionario.apellidos || '' '' || funcionario.nombres funcionario,' +
               'dependencia.descripcion dependencia, estado.descripcion estado, elemento.id, ' +
               'iif(elemento.id_aseguradora is null, ''No'', ''Si'') Asegurado ' +
               'from elemento ' +
               'left join funcionario on (elemento.id_funcionario = funcionario.id) ' +
               'left join estado on (elemento.id_estado = estado.id) ' +
               'left join dependencia on (elemento.id_dependencia = dependencia.id) ' +
               'left outer join marca on (elemento.id_marca = marca.id) ';

  SqlFic1 = 'Select elemento.id, categoria.descripcion categoria,' +
            'elemento.descripcion elemento, marca.descripcion marca, elemento.modelo, elemento.serie,' +
            'proveedor.descripcion proveedor, elemento.fecha_compra, elemento.numero_factura, elemento.valor_compra,'+
            'elemento.inventario, elemento.caracteristicas, Dependencia.Descripcion Dependencia,' +
            'funcionario.apellidos || '' '' || funcionario.nombres funcionario, estado.descripcion estado, aseguradora.descripcion aseguradora ' +
            'From ELEMENTO ' +
            'left join funcionario on (elemento.id_funcionario = funcionario.id) ' +
            'left join estado on (elemento.id_estado = estado.id) ' +
            'left join categoria on (elemento.id_categoria = categoria.id) ' +
            'left join Dependencia on (elemento.id_dependencia = Dependencia.id) ' +
            'left outer  join marca on (elemento.id_marca = marca.id) ' +
            'left outer join proveedor on (elemento.id_proveedor = proveedor.id) ' +
            'left outer join aseguradora on (elemento.id_aseguradora = aseguradora.id) ' +
            'Where Elemento.inventario = %s';

  SqlFic2 = 'Select fecha, observacion from MOVIMIENTO where id_elemento = %d order by fecha desc';

var
  frmreportes: Tfrmreportes;

  procedure reportes(const base : TIBConnection);

implementation

{$R *.lfm}

{ Tfrmreportes }

procedure reportes(const base : TIBConnection);
begin
 Application.CreateForm(TFrmreportes, frmreportes);
 FrmReportes.SQLTransaction1.DataBase := base;
 FrmReportes.SQLTransaction1.Active   := true;
 frmreportes.SQLQuery1.DataBase       := base;
 frmreportes.SQLReport2.DataBase      := base;
 frmreportes.SQLReport.DataBase       := base;
 FrmReportes.ShowModal;
end;

procedure Tfrmreportes.FormDestroy(Sender: TObject);
begin
  frmreportes := nil;
end;

procedure Tfrmreportes.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 1 then begin
    GroupBox1.Caption := 'Funcionario';
    SqlQuery1.Close;
    SqlQuery1.Sql.Text := 'Select id, apellidos || '' '' || nombres descripcion from funcionario ' +
                          'Where id in (select distinct id_funcionario from elemento) order by 2';
    SqlQuery1.Open;
   end
  else
   if RadioGroup1.ItemIndex = 2 then begin
     GroupBox1.Caption := 'Dependencia';
     SqlQuery1.Close;
     SqlQuery1.Sql.Text := 'Select id, descripcion from dependencia order by 2';
     SQLQuery1.Open;
    end

end;

procedure Tfrmreportes.BitBtn1Click(Sender: TObject);
var
 rpt : string;
//
 procedure orden_reporte;
 begin
    Case RadioGroup2.ItemIndex of
    0 : SQLReport.SQL.Text := SQLReport.SQL.Text + ' Order By Elemento.Descripcion';
    1 : SQLReport.SQL.Text := SQLReport.SQL.Text + ' Order By Dependencia.Descripcion';
    2 : SQLReport.SQL.Text := SQLReport.SQL.Text + ' Order By Marca.Descripcion';
    3 : SQLReport.SQL.Text := SQLReport.SQL.Text + ' Order By Funcionario.Apellidos, Funcionario.Nombres';
    4 : SQLReport.SQL.Text := SQLReport.SQL.Text + ' Order By Elemento.Inventario';
   end;
   rpt := 'reportes/rptInventario.lrf';
 end;
//
begin
 SQLReport.Close;
 case RadioGroup1.ItemIndex of
   0: begin
       SQLReport.SQL.Text := SqlGeneral;
       orden_reporte;
      end;
   1 : begin
        SQLReport.SQL.Text := SqlGeneral +
                              ' Where Elemento.Id_Funcionario = ' +  SqlQuery1.FieldByName('Id').AsString;
//                              ' Order By Elemento.Descripcion';
        orden_reporte;
        rpt := 'reportes/rptInventario.lrf';
       end;
   2 : begin
        SQLReport.SQL.Text := SqlGeneral +
                              ' Where Elemento.Id_Dependencia = ' +  SqlQuery1.FieldByName('Id').AsString;
        orden_reporte;
//                              ' Order By Elemento.Descripcion';
        rpt := 'reportes/rptInventario.lrf';
       end;
   3 : begin
        NumInve := InputBox('Ficha de producto', 'Número de inventario', '');
        if (Trim(NumInve) = EmptyStr) then begin
           MessageDlg('Especifique un número de inventario', mtWarning, [mbOk], 0);
           Exit;
          end;
        SQLReport.SQL.Text := Format(sqlFic1, [NumInve]);
        rpt := 'reportes/rptficha.lrf';
       end;
   4 : begin
        SQLReport.SQL.Text := 'Select coalesce(aseguradora.descripcion, ''NO ASEGURADO'') aseguradora,, elemento.inventario, elemento.descripcion elemento, elemento.serie, ' +
                              'marca.descripcion marca, elemento.valor_compra, estado.descripcion estado ' +
                              'from elemento ' +
                              'left join estado on (elemento.id_estado = estado.id) ' +
                              'left join dependencia on (elemento.id_dependencia = dependencia.id) ' +
                              'left outer join marca on (elemento.id_marca = marca.id) ' +
                              'left outer join aseguradora on (elemento.id_aseguradora = aseguradora.id) ' +
                              'order by aseguradora.descripcion, elemento.descripcion';

        rpt := 'reportes/rptAseguradora.lrf';
       end;
  end;

 SqlReport.Open;
 if RadioGroup1.ItemIndex = 3 then begin
   SQLReport2.Sql.Text := Format(SqlFic2, [Sqlreport.FieldByName('Id').AsInteger]);
   SqlReport2.Open;
  end;
 frReport1.LoadFromFile(rpt);
 frReport1.ShowReport;
end;

end.

