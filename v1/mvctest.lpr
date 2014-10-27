program mvctest;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  frmsgcddatamodule, // database connection
  ctrl, observerSubject, mvc,
  // home
  Principal, frmabmpersonas, frmabmcuentas,
  frmbuscarpersonas, frmgeneradeuda, frmpago,
  frmprocesoasientos, frmprocesocomprobante, frmprocesodocumentos,
  frmprocesofacturacion, frmprocesorecibo, frmprocnotacredito,
  principalctrl, personactrl, asientosctrl,
  buscarpersctrl, comprobantectrl, cuentactrl, documentosctrl, facturactrl2,
  generardeudactrl, movimientoctrl, notacreditoctrl, pagoctrl, procesoctrl,
  reciboctrl, frmprincipaldatamodule, frmquerydatamodule,
  frmpersonasdatamodule, frmaranceldatamodule, frmasientosdatamodule,
  frmcodigosdatamodule, frmcomprobantedatamodule, frmcuentadatamodule,
  frmcuotaxarancel, frmdocumentosdatamodule, frmfacturadatamodule2,
  frmgeneradeudadatamodule, frmpagodatamodule,
  manejoerrores, frmrecibodatamodule, frmNotaCreditoDataModule;


{$R *.res}

begin

  RequireDerivedFormResource := True;
  Application.Initialize;

  // el datamodule donde esta la conexion
  SgcdDataModule := TSgcdDataModule.Create(nil);

  Principal1 := TPrincipal1.Create(nil, TPrincipalController.Create(
    TPrincipalDataModule.Create(nil, SgcdDataModule)));

  Application.OnException:=@(Principal1.AppPropsException);

  // Hay que castear el objeto para poder añadirle los observadores
  Principal1.Show;
  (SgcdDataModule as ISubject).Attach(Principal1 as IObserver);

  Application.Run;
end.


