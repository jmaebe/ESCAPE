{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit escapecomponents; 

interface

uses
  Compos, NewStr, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('Compos', @Compos.Register); 
end; 

initialization
  RegisterPackage('EscapeComponents', @Register); 
end.
