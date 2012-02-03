unit providermodule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, HTTPDefs, websession, fpHTTP, fpWeb, fpwebdata,
  extjsjson;

type

  { TProvider1 }

  TProvider1 = class(TFPWebProviderDataModule)
    ExtJSJSONDataFormatter1: TExtJSJSONDataFormatter;
    ExtJSJSonWebdataInputAdaptor1: TExtJSJSonWebdataInputAdaptor;
    FPWebDataProvider1: TFPWebDataProvider;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Provider1: TProvider1;

implementation

{$R *.lfm}

initialization
  RegisterHTTPModule('Provider', TProvider1);
end.

