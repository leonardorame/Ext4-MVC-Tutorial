unit customer_handler;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, fpjson, jsonparser;

type

  { TCustomerHandler }

  TCustomerHandler = class(TFPWebModule)
    procedure DataModuleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure delete(Sender: TObject; ARequest: TRequest; AResponse: TResponse;
      var Handled: Boolean);
    procedure insert(Sender: TObject; ARequest: TRequest; AResponse: TResponse;
      var Handled: Boolean);
    procedure read(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: Boolean);
    procedure update(Sender: TObject; ARequest: TRequest; AResponse: TResponse;
      var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  CustomerHandler: TCustomerHandler;

implementation

{$R *.lfm}

{ TCustomerHandler }

procedure TCustomerHandler.DataModuleRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
begin
  AResponse.Content := 'Hello World!';
  Handled := False;
end;

procedure TCustomerHandler.delete(Sender: TObject; ARequest: TRequest;
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
  lFile := 'data.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
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
      lResponse.Add('root', lResult);
      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
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

procedure TCustomerHandler.insert(Sender: TObject; ARequest: TRequest;
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
  lFile := 'data.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try

      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;

      lResult.Integers['id'] := Random(1000);

      //if lResult.indexofname('active') > -1 then
      //  raise exception.create('aaa');
      if lResult.Nulls['active'] then
        lResult.Booleans['active'] := false;

      lArray.Add(lResult);
      (* Save the file *)
      lStr.Text:= lJSON.AsJSON;
      lStr.SaveToFile(lFile);

      lResponse.Add('success', true);
      lResponse.Add('root', lResult);

      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
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

procedure TCustomerHandler.read(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: Boolean);
var
  lJSonParser: TJSONParser;
  lStr: TFileStream;
  lFile: string;
  lJSON: TJSONObject;

begin
  lFile := 'data.json';
  lStr := TFileStream.Create(lFile, fmOpenRead);
  lJSonParser := TJSONParser.Create(lStr);
  try
    lJSON := lJSonParser.Parse as TJSonObject;
    AResponse.ContentType := 'application/json; charset=utf-8';
    AResponse.Content := AnsiToUtf8(lJSON.AsJSON);
  finally
    lJSonParser.Free;
    lStr.Free;
  end;
  Handled := True;
end;

procedure TCustomerHandler.update(Sender: TObject; ARequest: TRequest;
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
  lFile := 'data.json';
  lStr := TStringList.Create;
  lStr.LoadFromFile(lFile);
  lJSonParser := TJSONParser.Create(lStr.Text);
  lResponse :=TJSONObject.Create;
  try
    try
      (* Assign values to local variables *)
      lResult := TJSONParser.Create(ARequest.Content).Parse as TJSONObject;

      (* Traverse data finding by Id *)
      lJSON := lJSonParser.Parse as TJSonObject;
      lArray := lJSON.Arrays['root'];
      for I := 0 to lArray.Count - 1 do
      begin
        if lResult.Integers['id'] = (lArray.Objects[I] as TJsonObject).Integers['id'] then
        begin
          (* Assign field values *)
          (lArray.Objects[I] as TJsonObject).Strings['name'] := lResult.Strings['name'];
          (lArray.Objects[I] as TJsonObject).Strings['email'] := lResult.Strings['email'];
          (lArray.Objects[I] as TJsonObject).Integers['age'] := lResult.Integers['age'];
          (lArray.Objects[I] as TJsonObject).Integers['gender'] := lResult.Integers['gender'];
          (lArray.Objects[I] as TJsonObject).Booleans['active'] := lResult.Booleans['active'];
          lStr.Text := lJSon.AsJSON;
          lStr.SaveToFile(lFile);
          Break;
        end;
      end;
      lResponse.Add('success', true);
      lResponse.Add('root', lResult);

      AResponse.ContentType := 'application/json; charset=utf-8';
      AResponse.Content := AnsiToUtf8(lResponse.AsJSON);
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
  RegisterHTTPModule('customers', TCustomerHandler);
end.

