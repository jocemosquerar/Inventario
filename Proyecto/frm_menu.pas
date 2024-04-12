unit frm_menu;

{
GRANT USAGE ON GENERATOR GEN_MARCA TO JORGE
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, FileUtil, Forms, Controls, Graphics, Dialogs,
  Menus, ActnList, StdActns, ExtCtrls, StdCtrls, frm_accesoria,
  frm_Reginventario, frm_funcionario, frm_reportes, frm_salida, frm_acerca;

type

  { Tfrmmenu }

  Tfrmmenu = class(TForm)
    admUbicacion: TAction;
    admResponsable: TAction;
    admSalida: TAction;
    admAseguradora: TAction;
    Image1: TImage;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    sisAcerca: TAction;
    MenuItem16: TMenuItem;
    sisReportes: TAction;
    admFuncionario: TAction;
    admMarca: TAction;
    admInventario: TAction;
    MainMenu2: TMainMenu;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    sisSalir: TAction;
    admProveedor: TAction;
    admEstado: TAction;
    admDependencia: TAction;
    admCategoria: TAction;
    ActionList1: TActionList;
    IBConnection1: TIBConnection;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    procedure admAseguradoraExecute(Sender: TObject);
    procedure admCategoriaExecute(Sender: TObject);
    procedure admDependenciaExecute(Sender: TObject);
    procedure admEstadoExecute(Sender: TObject);
    procedure admFuncionarioExecute(Sender: TObject);
    procedure admInventarioExecute(Sender: TObject);
    procedure admMarcaExecute(Sender: TObject);
    procedure admProveedorExecute(Sender: TObject);
    procedure admResponsableExecute(Sender: TObject);
    procedure admSalidaExecute(Sender: TObject);
    procedure admUbicacionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure sisAcercaExecute(Sender: TObject);
    procedure sisReportesExecute(Sender: TObject);
    procedure sisSalirExecute(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmmenu: Tfrmmenu;

implementation

{$R *.lfm}

{ Tfrmmenu }

procedure Tfrmmenu.sisSalirExecute(Sender: TObject);
begin
  Close;
end;

procedure Tfrmmenu.FormDestroy(Sender: TObject);
begin
 FrmMenu := nil;
end;

procedure Tfrmmenu.MenuItem14Click(Sender: TObject);
var
  per, cla : string;
begin
 per := EmptyStr;
 cla := EmptyStr;

 if InputQuery('Acceso', 'Nombre de usuario', per) then begin

   if trim(per) = EmptyStr then
    raise exception.create('Nombre de usuario incompleto');

   if InputQuery('Acceso', 'Clave de acceso', True, cla) then begin
     if trim(cla) = EmptyStr then
      raise exception.create('Clave de acceso incompleto');

     IBConnection1.UserName := per;
     IBConnection1.Password := cla;

     try
      IBConnection1.Connected :=true;
      frmmenu.Menu            := MainMenu1;
     except
      MessageDlg('Nombre de usuario ó clave de acceso incorrectos', mtError, [mbOk], 0);
     end;

    end;
  end;
end;

procedure Tfrmmenu.sisAcercaExecute(Sender: TObject);
begin
  acerca_de;
end;

procedure Tfrmmenu.sisReportesExecute(Sender: TObject);
begin
  reportes(IBConnection1);
end;

procedure Tfrmmenu.admCategoriaExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'CATEGORIA');
end;

procedure Tfrmmenu.admAseguradoraExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'ASEGURADORA');
end;

procedure Tfrmmenu.admDependenciaExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'DEPENDENCIA');
end;

procedure Tfrmmenu.admEstadoExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'ESTADO');
end;

procedure Tfrmmenu.admFuncionarioExecute(Sender: TObject);
begin
  persona(IBConnection1);
end;

procedure Tfrmmenu.admInventarioExecute(Sender: TObject);
begin
 RegInventario(IBConnection1);
end;

procedure Tfrmmenu.admMarcaExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'MARCA');
end;

procedure Tfrmmenu.admProveedorExecute(Sender: TObject);
begin
 Accesoria(IBConnection1, 'PROVEEDOR');
end;

procedure Tfrmmenu.admResponsableExecute(Sender: TObject);
begin
  Accesoria(IBConnection1, 'RESPONSABLEM');
end;

procedure Tfrmmenu.admSalidaExecute(Sender: TObject);
begin
  salida(IBConnection1);
end;

procedure Tfrmmenu.admUbicacionExecute(Sender: TObject);
begin
  Accesoria(IBConnection1, 'UBICACION');
end;

procedure Tfrmmenu.FormCreate(Sender: TObject);
var
 Archivo : TextFile;
 rutabase : string;
begin
  if not FileExists('inventario.txt') then begin
    MessageDlg('No se encuentra el archivo "inventario.txt"', mtError, [mbOk], 0);
    Application.terminate;
   end;
  AssignFile(Archivo,'inventario.txt');
  reset(Archivo);
  readln(Archivo, rutabase);
  closefile(Archivo);
  IBConnection1.DatabaseName := rutabase;
end;

end.
