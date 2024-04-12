program Inventario;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, rxnew, runtimetypeinfocontrols, datetimectrls, frm_menu, frm_accesoria,
  frm_observacion, frm_funcionario, frm_reportes, frm_reginventario, 
dm_reginventario, frm_buscadorelemento, frm_salida, frm_buscarsalida;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmmenu, frmmenu);
  Application.Run;
end.

