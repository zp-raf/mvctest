program mvctest;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  frmsgcddatamodule, // el modelo de conexion de base de datos
  principalctrl, // controlador del home
  observerSubject,
  Principal, // Home form
  frmprincipaldatamodule; //el datamodule del home

{$R *.res}

begin
  { La arquitectura MVC utiliza el patron Observer-Subject. El modelo es un
    Sujeto al cual estan adheridos varios Observadores, en nuestro caso Vistas.
    El sujeto al cambiar de estado deberia llamar a todos los observadores para
    que se actualicen de alguna forma.
    En nuestro caso concreto no es necesario tener un mecanismo para sincronizar
    los datos de los querys con los controles dataaware (TDBGrid, etc) ya que el
    TDataSource tiene su propio mecanismo implementando de Observer-Subject.
    O sea ya hicieron nuestro trabajo :)
    La vista por medio de los  eventos de los controles llama a los metodos
    apropiados en el controlador designado y este realiza las acciones. Asi se
    separa la presentacion de la logica del negocio. }

  { TODO: Pero para otros elementos de la ventana que no son dataaware
    (como algun texto que indique el estado de conexion a la base de  datos)
    se necesita este mecasnismo. }

  RequireDerivedFormResource := True;
  Application.Initialize;

  // Modelo

  // el datamodule donde esta la conexion
  SgcdDataModule := TSgcdDataModule.Create(nil);

  Principal1 := TPrincipal1.Create(nil, TPrincipalController.Create(
    TPrincipalDataModule.Create(nil, SgcdDataModule)));

  // Hay que castear el objeto para poder añadirle los observadores
  Principal1.Show;
  (SgcdDataModule as ISubject).Attach(Principal1 as IObserver);

  Application.Run;
end.
