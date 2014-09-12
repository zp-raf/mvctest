unit frmprincipaldatamodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, frmquerydatamodule, mvc;

type

  { TPrincipalDataModule }

  // Esta es solo una clase wrapper. No me gusta hacer esto pero es para evitar
  // mayores complicaciones
  TPrincipalDataModule = class(TQueryDataModule, IModel)
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PrincipalDataModule: TPrincipalDataModule;

implementation

{$R *.lfm}

{ TPrincipalDataModule }

end.

