/// this is to create the CRM data that corresponds to th Order data
Class ConnectOrCollect.Setup.crm Extends (%Persistent, %JSON.Adaptor)
{

/*
    ///Documentation of Foreign Server  used for this
    create foreign server ext.onlinestore foreign data wrapper jdbc connection 'onlinestore'
    
    ///Documentation of Foreign table used for this
    create foreign table onlinestore.orders(Id INTEGER,
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(100),
    Quantity INTEGER,
    InvoiceDate Date,
    Price NUMERIC,
    CustomerId VARCHAR(10),
    -- Country VARCHAR(50)) 
    server ext.onlinestor
    */

// IDCliente,Nombre,Apellidos,Genero,FechaNacimiento,DireccionPais,DireccionCiudad,DireccionRegion,DireccionCodigoPostal    

Property IdCliente As %Integer;

Property Nombre As %String(MAXLEN = 30);

Property Apellidos As %String(MAXLEN = 30);

Property Genero As %String(MAXLEN = 1);

Property FechaNacimiento As %Date;

Property DireccionPais As %String(MAXLEN = 20);

Property DireccionCiudad As %String(MAXLEN = 20);

Property DireccionRegion As %String(MAXLEN = 20);

Property DireccionCodigoPostal As %String(MAXLEN = 12);

/// Resets an Creates the CRM Table with Random Data from the Source Orders in onlineorders
ClassMethod Create(pVerbose As %Boolean = 1) As %Status
{
    #DIM tSC as %Status=$$$OK
    #DIM errObj as %Exception.AbstractException
    try {
        ///Cleanup the existing CRM entries
        do ..%KillExtent()

        //Scan the OnlineStore Foreign Table to Get CustomerIDs
        Set tSql="Select distinct CustomerId from onlinestore.orders"
        set tStmt=##class(%SQL.Statement).%New()
        $$$THROWONERROR(tSC,tStmt.%Prepare(tSql))
        #DIM tRS as %SQL.StatementResult
        set tRS=tStmt.%Execute()
        while tRS.%Next() {
            Write:pVerbose "CustomerId:",tRS.%Get("CustomerId"),!
            $$$THROWONERROR(tSC,..AddCRMEntry(tRS.%Get("CustomerId")))
        }

    }catch (errObj) {
        set tSC=errObj.AsStatus()
        write:pVerbose !,"Error in Create:",errObj.DisplayString(),!
    }
    quit tSC
}

ClassMethod Export2CSV(pFileName As %String = "/data/crm/clientes.csv") As %Status
{
    #DIM tSC as %Status=$$$OK
    #DIM errObj as %Exception.AbstractException
    try {
        set tStream=##class(%Stream.FileCharacter).%New()
        set tStream.TranslateTable="UTF8"
        do tStream.LinkToFile(pFileName)
        set tSql="Select * from ConnectOrCollect_Setup.crm"
        set tStmt=##class(%SQL.Statement).%New()
        $$$THROWONERROR(tSC,tStmt.%Prepare(tSql))
        set tRS=tStmt.%Execute()
        //do tRS.%Display()
        //do tRS.%DisplayFormatted("CSV",pFileName)  //100:CSV
        set tLine="",tSep=""
        for i=1:1:tRS.%ResultColumnCount {
            set tLine=tLine_tSep_tRS.%GetMetadata().columns.GetAt(i).colName
            set tSep=","
        }
        Write "tline:",tLine,!
        $$$THROWONERROR(tSC,tStream.WriteLine(tLine))
        
        while (tRS.%Next()) {
            set tLine="",tSep=""
            for i=1:1:tRS.%ResultColumnCount {
                set tLine=tLine_tSep_tRS.%GetData(i)
                set tSep=","
            }
            w "tLine:",tLine,!
            $$$THROWONERROR(tSC,tStream.WriteLine(tLine))   
        }
        
        $$$THROWONERROR(tSC,tStream.%Save())

    } catch(errObj) {
        set tSC=errObj.AsStatus()
        Write "Caught Error: ",errObj.DisplayString(),!
    }
    quit tSC
}

/// Throws Exception on Error
ClassMethod AddCRMEntry(pCustomerID As %String) As %Status
{
    set tNombreM=$lb("Antonio","Manuel","José","Francisco","David","Juan","Joan","Javier","Daniel")
    set tNombreF=$lb("María","Carmen","Ana","Laura","Pilar","Isabel","Celestina")
    set tApp=$lb("García","Rodriguez","González","Fernández","López","Martinez","Sánchez","Pérez","Ferrer","Jordana")
    set tPais=$lb("España","Francia","United Kingdom","USA")
    
    //set tRegionUSA=$LB("Massachusetts","New-York")
    set tCiudadES=$LB("Barcelona","Girona","Madrid","Granada","Sevilla","Valencia")
    set tCPES=$lb("08001","17004","28014","18010","41001","46002")
    #DIM cust as ConnectOrCollect.Setup.crm
    set cust=..%New()  
    ///
    set cust.IdCliente=pCustomerID
    set cust.Genero=$Li($lb("M","F"),$random(2)+1)
    set cust.FechaNacimiento=$p($H,",",1)-(20*365)-$random(40*365)
    set tNombre=$select(cust.Genero="M":tNombreM,1:tNombreF)
    set cust.Nombre=$li(tNombre,$random($ListLength(tNombre))+1)
    set cust.Apellidos=$li(tApp,$random($ll(tApp))+1)_" "_$li(tApp,$random($ll(tApp))+1)
    set cust.DireccionPais=$li(tPais,$random($ll(tPais))+1)
    set cust.DireccionRegion=""
    set IxCuidad=$select(cust.DireccionPais="España":$random($ll(tCiudadES))+1,1:"")
    set cust.DireccionCiudad=$SELECT(cust.DireccionPais="España":$li(tCiudadES,IxCuidad),1:"")
    set cust.DireccionCodigoPostal=$select(cust.DireccionPais="España":$li(tCPES,IxCuidad),1:"")
    set tSC=cust.%Save(1)
    quit tSC
}

Storage Default
{
<Data name="crmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IdCliente</Value>
</Value>
<Value name="3">
<Value>Nombre</Value>
</Value>
<Value name="4">
<Value>Apellidos</Value>
</Value>
<Value name="5">
<Value>Genero</Value>
</Value>
<Value name="6">
<Value>FechaNacimiento</Value>
</Value>
<Value name="7">
<Value>DireccionPais</Value>
</Value>
<Value name="8">
<Value>DireccionCiudad</Value>
</Value>
<Value name="9">
<Value>DireccionRegion</Value>
</Value>
<Value name="10">
<Value>DireccionCodigoPostal</Value>
</Value>
</Data>
<DataLocation>^ConnectOrCollect.Setup.crmD</DataLocation>
<DefaultData>crmDefaultData</DefaultData>
<IdLocation>^ConnectOrCollect.Setup.crmD</IdLocation>
<IndexLocation>^ConnectOrCollect.Setup.crmI</IndexLocation>
<StreamLocation>^ConnectOrCollect.Setup.crmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
