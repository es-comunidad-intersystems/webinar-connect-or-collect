Class ConnectOrCollect.BO.QuickSave Extends Ens.BusinessOperation
{

/// This is the default message handler.  All request types not declared in the message map are delivered here
Method OnMessage(pRequest As %Library.Persistent, Output pResponse As %Library.Persistent) As %Status
{
    set tC=pRequest.%ConstructClone(1)
    return tC.%Save(1)
}

}
