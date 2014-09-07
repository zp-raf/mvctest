program mvctest;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  ctrl,
  frmsgcddatamodule,
  frmacademiadatamodule,
  frmabmacademias,
  //frmabmpersonas,
  //frmpersonadatamodule,
  //personactrl,
  principalctrl,
  observerSubject,
  Principal;

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
  Application.CreateForm(TSgcdDataModule, SgcdDataModule);
  //Application.CreateForm(TAcademiaDataModule, AcademiaDataModule);
  //Application.CreateForm(TPersonasDataModule, PersonasDataModule);

  // Controlador
  PrincipalController := TPrincipalController.Create(SgcdDataModule);
  //ABMController := TController.Create(AcademiaDataModule);
  //PersonaController := TPersonaController.Create(PersonasDataModule);

  // Vista
  Principal1 := TPrincipal1.Create(nil, PrincipalController);
  //AbmAcademias := TAbmAcademias.Create(nil, ABMController);
  //AbmPersonas := TAbmPersonas.Create(nil, PersonaController);

  // Hay que castear el objeto para poder añadirle los observadores
  (SgcdDataModule as ISubject).Attach(Principal1 as IObserver);
  Principal1.Show;
  //(SgcdDataModule as ISubject).Attach(AbmAcademias as IObserver);
  //AbmAcademias.Show;
  //(SgcdDataModule as ISubject).Attach(AbmPersonas as IObserver);
  //AbmPersonas.Show;

  Application.Run;
end.
