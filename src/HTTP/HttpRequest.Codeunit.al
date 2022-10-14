codeunit 50100 "Http Request"
{
    Access = Internal;

    var
        HttpMgt: Codeunit "Http Mgt.";

    /// <summary>
    /// Sends the GET request.
    /// </summary>
    /// <returns>True if the connection has been established, error otherwise.</returns>
    [NonDebuggable]
    procedure GetRequest(): Boolean
    var
        ResponseMessage: HttpResponseMessage;
        Client: HttpClient;
        WebServiceUrl: Text;
        PATH, ENDPOINT : Text[50];
    begin
        Initialize();
        WebServiceUrl := HttpMgt.FormatWebServiceAddress(PATH, ENDPOINT);

        HttpMgt.SetDefaultRequestHeaders(Client);
        HttpMgt.SendRequest(Client, WebServiceUrl, ResponseMessage);
        exit(true);
    end;

    /// <summary>
    /// Exports compact store items from Business Central to Compact Store. The name of the request 'import items' reflect the name of the request used by compact store.
    /// </summary>
    /// <param name="ItemNo">Item number which will be exported to compact store.</param>
    /// <returns>True if the item(s) have been exported, error otherwise.</returns>
    //[NonDebuggable]
    procedure ImportItems(ItemNo: Code[20]): Boolean
    var
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Client: HttpClient;
        RequestBody: JsonObject;
        Body, WebServiceUrl : Text;
        PATH, ENDPOINT : Text[50];
    begin
        Initialize();
        WebServiceUrl := HttpMgt.FormatWebServiceAddress(PATH, ENDPOINT);

        HttpMgt.SetDefaultRequestHeaders(Client);
        HttpMgt.AddBodyObject(RequestBody);

        RequestBody.WriteTo(Body);
        Content.WriteFrom(Body);
        HttpMgt.SetContentHeaders(Content, ContentHeaders);

        HttpMgt.SendRequest(Client, WebServiceUrl, Content, ResponseMessage);
        exit(true);
    end;

    [NonDebuggable]
    local procedure Initialize()
    begin
        // Initialize Setup
        // Verify the path/endpoints
    end;
}