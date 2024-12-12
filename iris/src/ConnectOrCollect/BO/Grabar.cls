Class ConnectOrCollect.BO.Grabar Extends Ens.BusinessOperation
{

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    
    //Quick Save of the Message in a Table
    Lock +^SingleThread:10
    if '$test quit $$$ERROR($$$GeneralError,"Failed to lock Single Thread Block")
    do ..CreateTable(pRequest)  //Only One at a time
    Lock -^SingleThread

}

/// Create the Persistent Table if it does not yet exist
Method CreateTable(pRequest As %Persistent) As %Status
{
    //If Table already created we are done here
    if $data(^Tables(pRequest.%ClassName(1))) quit $$$OK
    //
    #DIM tCDefNew as %Dictionary.ClassDefinition
    set tCDef=##class(%Dictionary.ClassDefinition).%OpenId(pRequest.%ClassName(1))
    set tCDefNew=tCDef.%ConstructClone(1)
    do tCDefNew.Storages.Clear()
    set tCDefNew.Name="Stored."_tCDef.Name
    $$$TRACE(tCDefNew.Name)
    set tSC=tCDef.%Save(1)
    do $SYSTEM.OBJ.Compile(tCDefNew.Name)
    set ^Tables(pRequest.%ClassName(1))=tCDefNew.Name
    quit $$$OK
}

}
