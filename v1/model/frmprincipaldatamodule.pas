unit frmprincipaldatamodule;

{$mode objfpc}{$H+}

interface

uses
  frmquerydatamodule, mvc;

type

  { TPrincipalDataModule }

  // ???: This class adds nothing for the moment. Maybe in the future will do
  // something useful ;)
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

