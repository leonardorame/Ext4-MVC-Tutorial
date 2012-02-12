unit customerdatamodule;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpJson, jsonparser;

type

  { TCustomerData }

  TCustomerData = class(TFPWebModule)
    procedure deleteRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure insertRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure readRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure updateRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;



var
  CustomerData: TCustomerData;

implementation

{$R *.lfm}

{ TCustomerData }

procedure TCustomerData.deleteRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
begin
  (* Load "database" *)
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;
      lResult := lResult.Objects['items'];

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['items'];
      for I := 0 to lArray.Count - 1 do
      begin
        if lResult.Integers['id'] = (lArray.Objects[I] as TJsonObject).Integers['id'] then
        begin
          lArray.Delete(I);
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('items', lResult);
      AResponse.Content := lResponse.AsJSON;
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

procedure TCustomerData.insertRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;

begin
  Randomize;
  (* Load "database" *)
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['items'];
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;
      lResult := lResult.Objects['items'];
      lResult.Integers['id'] := Random(1000);
      lArray.Add(lResult);
      (* Save the file *)
      lStr.Text:= lJSON.AsJSON;
      lStr.SaveToFile(lFile);

      lResponse.Add('success', true);
      lResponse.Add('items', lResult);

      AResponse.Content := lResponse.AsJSON;
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;
end;

procedure TCustomerData.readRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lJSonParser: TJSONParser;
  lStr: TFileStream;
  lFile: string;
  lJSON: TJSONObject;

begin
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TFileStream.Create(lFile, fmOpenRead);
  lJSonParser := TJSONParser.Create(lStr);
  try
    lJSON := lJSonParser.Parse as TJSonObject;
    AResponse.Content := lJSON.AsJSON;
  finally
    lJSonParser.Free;
    lStr.Free;
  end;
  Handled := True;
end;

procedure TCustomerData.updateRequest(Sender: TObject; ARequest: TRequest;
  AResponse: TResponse; var Handled: Boolean);
var
  lResponse: TJSONObject;
  lJSON: TJSONObject;
  lResult: TJSONObject;
  lArray: TJSONArray;
  lJSonParser: TJSONParser;
  lStr: TStringList;
  lFile: string;
  I: Integer;
begin
  (* Load "database" *)
  lFile := ExtractFilePath(ParamStr(0)) + 'users.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;
      lResult := lResult.Objects['items'];

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['items'];
      for I := 0 to lArray.Count - 1 do
      begin
        if lResult.Integers['id'] = (lArray.Objects[I] as TJsonObject).Integers['id'] then
        begin
          (lArray.Objects[I] as TJsonObject).Strings['Name'] := lResult.Strings['Name'];
          (lArray.Objects[I] as TJsonObject).Floats['Sales'] := lResult.Floats['Sales'];
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('items', lResult);
      AResponse.Content := lResponse.AsJSON;
    except
      on E: Exception do
      begin
        lResponse.Add('success', false);
        lResponse.Add('msg', E.Message);
        AResponse.Content := lResponse.AsJSON;
      end;
    end;
  finally
    lResponse.Free;
    lJSonParser.Free;
    lStr.Free;
  end;

  Handled := True;

end;

initialization
  RegisterHTTPModule('CustomerData', TCustomerData);
end.

