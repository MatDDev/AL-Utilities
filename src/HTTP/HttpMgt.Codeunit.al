codeunit 50101 "Http Mgt."
{
    Access = Internal;

    var
        FormatUrlTxt: Label '%1/%2', Comment = '%1 - Web Service URL, %2 - Web Service specific endpoint.';
        WebServiceCallFailedErr: Label 'Web service call failed.';
        EmptyValuesErr: Label 'Web Service URL and Endpoint must have values.';
        NotImplementedErr: Label 'The following type is not implemented: %1', Comment = '%1 - not implemented type';

    procedure GetWebServiceCallFailedErr(): Text
    begin
        exit(WebServiceCallFailedErr);
    end;

    procedure GetEmptyValuesErr(): Text
    begin
        exit(EmptyValuesErr);
    end;

    procedure GetNotImplementedErr(): Text
    begin
        exit(NotImplementedErr)
    end;

    [NonDebuggable]
    procedure FormatWebServiceAddress(WebServiceUrl: Text[250]; WebServiceEndpoint: Text[50]): Text
    begin
        if (WebServiceUrl = '') or (WebServiceEndpoint = '') then
            Error(GetEmptyValuesErr());

        WebServiceUrl := DelChr(WebServiceUrl, '>', '/');
        exit(StrSubstNo(FormatUrlTxt, WebServiceUrl, WebServiceEndpoint));
    end;

    [NonDebuggable]
    procedure SetDefaultRequestHeaders(var Client: HttpClient)
    var
        IsolatedStorageManagement: Codeunit "Isolated Storage Management";
        ApiKey: Text;
    begin
        IsolatedStorageManagement.Get(GetHttpKeyLabel(), DataScope::Company, ApiKey);

        Client.Clear();
        Client.DefaultRequestHeaders.Add('Accept', 'application/json');
        //Client.DefaultRequestHeaders.TryAddWithoutValidation('X-API-KEY', ApiKey); // Add API Key if needed
    end;

    [NonDebuggable]
    procedure SetContentHeaders(var Content: HttpContent; var ContentHeaders: HttpHeaders)
    begin
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
    end;

    [NonDebuggable]
    procedure SendRequest(var Client: HttpClient; WebServiceUrl: Text; var ResponseMessage: HttpResponseMessage)
    begin
        if not Client.Get(WebServiceUrl, ResponseMessage) then
            Error(GetWebServiceCallFailedErr());

        if not ResponseMessage.IsSuccessStatusCode then
            Error(Format(ResponseMessage.HttpStatusCode), '-', ResponseMessage.ReasonPhrase);
    end;

    [NonDebuggable]
    procedure SendRequest(var Client: HttpClient; WebServiceUrl: Text; Content: HttpContent; var ResponseMessage: HttpResponseMessage)
    begin
        if not Client.Post(WebServiceUrl, Content, ResponseMessage) then
            Error(GetWebServiceCallFailedErr());

        if not ResponseMessage.IsSuccessStatusCode then
            Error(Format(ResponseMessage.HttpStatusCode), '-', ResponseMessage.ReasonPhrase);
    end;

    [NonDebuggable]
    procedure GetHttpKeyLabel(): Text;
    var
        HttpKeyLbl: Label 'fc31458d-37eb-4f20-ad4f-361755d8b7f8', Locked = true;
    begin
        exit(HttpKeyLbl);
    end;

    [NonDebuggable]
    procedure AddBodyObject(var GenericBody: JsonObject)
    begin
        GenericBody.Add('meta', '1');
    end;
}
