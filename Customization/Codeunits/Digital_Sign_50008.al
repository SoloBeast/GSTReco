codeunit 50008 "DigiSign"
{

    trigger OnRun()
    begin

    end;

    procedure DigitallySignDocument(DocNo: Code[20]; RecRef: RecordRef; ReportToSend: Integer)
    var
        cuCrypt: Codeunit "Cryptography Management";
        varCheckSum: Text;
        varOption: Option MD5,SHA1,SHA256,SHA384,SHA512;
        varMD5: Text;
        varFinalMD5: Text;
        varcurrTime: Text;
        recGLSetup: Record "General Ledger Setup";
    begin
        recGLSetup.get();
        varcurrTime := Format(CurrentDateTime, 0, '<Day,2><Month,2><Year4><Hours24,2>:<Minutes,2>:<Seconds,2>');
        varCheckSum := recGLSetup."API Key" + varcurrTime;

        //varMD5 := cuCrypt.GenerateHash(varCheckSum, varOption::MD5);
        varMD5 := cuCrypt.GenerateHash(varCheckSum, varOption::SHA256);
        //varFinalMD5 := varMD5.Substring(1, 16);
        varFinalMD5 := varMD5;
        fnDigiSignAPI(varFinalMD5, varcurrTime, DocNo, RecRef, ReportToSend);
    end;

    local procedure fnDigiSignAPI(checksum: Text; TymStamp: Text; DocNo: Code[20]; RecRef: RecordRef; ReportToSend: Integer)
    var

        TempBlob: Codeunit "Temp Blob";
        outStreamReport: OutStream;
        inStreamReport: InStream;
        Parameters: Text;
        txtAuthMsg: Text;
    begin
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);


        //ReportToSend := 50016;
        Report.SaveAs(ReportToSend, Parameters, ReportFormat::Pdf, outStreamReport, RecRef);
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);
        txtAuthMsg := CallServiceWithHeader(inStreamReport, TymStamp, checksum, DocNo);
    end;

    local procedure CallServiceWithHeader(UploadStream: InStream; TymStamp: Text; checksum: Text; DocNo: Text) ServiceResponse: Text
    var
        cubase64: Codeunit "Base64 Convert";
        pdfbase64: Text;
        outstr: OutStream;
        jsonInvoice: JsonObject;
        txtJsonText: Text;
        cuJsonManagement: Codeunit "JSON Management";
        TempBlob: Codeunit "Temp Blob";
        oStream: OutStream;
        filename: Text;
        recGLSetup: Record "General Ledger Setup";
        txtDateTime: Text;
    begin
        txtDateTime := FORMAT(CURRENTDATETIME);
        txtDateTime := DELCHR(txtDateTime, '=', '/');
        txtDateTime := DELCHR(txtDateTime, '=', '\');
        txtDateTime := DELCHR(txtDateTime, '=', '-');
        txtDateTime := DELCHR(txtDateTime, '=', ':');
        txtDateTime := DELCHR(txtDateTime, '=', ' ');

        recGLSetup.Get();
        jsonInvoice.Add('timestamp', TymStamp);
        jsonInvoice.Add('cs', checksum);
        jsonInvoice.Add('uuid', DocNo + txtDateTime);
        jsonInvoice.Add('signer', recGLSetup.Signer);
        jsonInvoice.Add('pfxid', recGLSetup.Pfxid);
        jsonInvoice.Add('pfxpwd', recGLSetup.Pfxpwd);
        jsonInvoice.Add('signloc', recGLSetup.Signloc);
        jsonInvoice.Add('signannotation', recGLSetup.Signannotation);
        txtJsonText := cubase64.ToBase64(UploadStream);
        jsonInvoice.Add('uploadfile', txtJsonText);

        jsonInvoice.WriteTo(txtJsonText);

        //txtJsonText := CallService('', 'https://qatestaccessauth.truecopy.in/ws/v1/signpdfaccessauthjson', txtJsonText, '', '');
        //CallService('', 'https://usgwstage.truecopy.in/api/tse/v3/stampsignpdfv3json', txtJsonText, '', '', DocNo);
        CallService('', recGLSetup."Digital Sign URL", txtJsonText, '', '', DocNo);
    end;

    local procedure CallService(ProjectName: Text; RequestUrl: Text; payload: Text; Username: Text; Password: Text; DocNo: Text)
    var
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        contentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text;
        pdfStram: InStream;
        TempBlob: Codeunit "Temp Blob";
        filename: Text;
    begin
        RequestHeaders := Client.DefaultRequestHeaders();
        RequestContent.WriteFrom(payload);

        RequestContent.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');
        Client.Post(RequestURL, RequestContent, ResponseMessage);
        TempBlob.CREATEINSTREAM(pdfStram);
        //Message(FORMAT(ResponseMessage));
        ResponseMessage.Content().ReadAs(pdfStram);
        filename := DocNo + '.pdf';
        DownloadFromStream(pdfStram, 'Export', '', 'All Files (*.*)|*.*', filename);
    end;
}