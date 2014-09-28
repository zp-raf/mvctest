unit CustomComponents;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, DbCtrls;

type
  TDBLabeledEdit = class(TDBEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  {$I customcomponents_icon.lrs}
  RegisterComponents('Data Controls',[TDBLabeledEdit]);
end;

end.
