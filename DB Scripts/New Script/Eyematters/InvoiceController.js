
var Invoice = {
xhr_GetData: null,
xhr_GetData_Edit: null,

ActiveEvent: function() {
},

	BindGrid: function () {
var FormData = Invoice.GetDataGrid();
if (Invoice.ValidateDataGrid(FormData)) {
LoadGrid(Invoice.xhr_GetData, 'tblGrid', '/Invoice/GetData', FormData, function () { /*Invoice.ScreenAccessPermission();*/ });
}
},

 GetDataGrid: function() {
	var Invoice = {
	InvoiceID: $('#hf_SearchInvoiceID').val().trim(),
CustomerID: $('#ddlSearchCustomerID').val(),
OrderDate: $('#txtSearchOrderDate').val().trim(),
ExpectedDeliveryDate: $('#txtSearchExpectedDeliveryDate').val().trim(),
InvoiceName: $('#txtSearchInvoiceName').val().trim(),
Frame: $('#txtSearchFrame').val().trim(),
Lens: $('#txtSearchLens').val().trim(),
FrameAmount: $('#txtSearchFrameAmount').val().trim(),
LensAmount: $('#txtSearchLensAmount').val().trim(),
RefractionBy: $('#txtSearchRefractionBy').val().trim(),
Remarks: $('#txtSearchRemarks').val().trim(),
RESPH: $('#txtSearchRESPH').val().trim(),
RECYL: $('#txtSearchRECYL').val().trim(),
REAXIS: $('#txtSearchREAXIS').val().trim(),
REVA: $('#txtSearchREVA').val().trim(),
READD: $('#txtSearchREADD').val().trim(),
LESPH: $('#txtSearchLESPH').val().trim(),
LECYL: $('#txtSearchLECYL').val().trim(),
LEAXIS: $('#txtSearchLEAXIS').val().trim(),
LEVA: $('#txtSearchLEVA').val().trim(),
LEADD: $('#txtSearchLEADD').val().trim(),
};
 return Invoice;
},

 ValidateDataGrid: function(FormData){
var valid = true;
	valid = Validate_Control_NullBlank('#hf_SearchInvoiceID', FormData.InvoiceID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#ddlSearchCustomerID', FormData.CustomerID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtSearchOrderDate', FormData.OrderDate, Resource.Required, valid);
valid = Validate_Control_DDMMYYYY('#txtSearchExpectedDeliveryDate', FormData.ExpectedDeliveryDate, Resource.InvalidFormat, valid);
valid = Validate_Control_NullBlank('#txtSearchInvoiceName', FormData.InvoiceName, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtSearchFrameAmount', FormData.FrameAmount, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtSearchLensAmount', FormData.LensAmount, Resource.Required, valid);

FocusOnError('#frm_InvoiceGrid', valid);
 return valid;
},

ResetDataGrid: function() {
var ID = $('#hf_InvoiceID').val();
$('#frm_InvoiceGrid .has-error p').html('');
$('#frm_InvoiceGrid .has-error').removeClass('has-error');
if (ID == '' || ID == null || ID == 0 || ID == undefined)
Invoice.ClearData();
else
Invoice.GetDataByID(Invoice.xhr_getData_For_Edit, ID);
},

ScreenAccessPermission:function () {
		var getAccess = GetScreenAccessPermissions(scrnID);
if (getAccess[0].HasInsert)
GetAddButton('#divAdd', 'Invoice.SetForAdd()');
if (getAccess[0].HasUpdate)
$('#tblGrid .HasUpdatetds a').removeAttr('href').removeAttr('title').removeAttr('style');
if (getAccess[0].HasDelete)
$('#tblGrid .DeleteColumn').html('').addclass('hide');
if (getAccess[0].HasExport)
$('#divExport').removeAttr('style');
},

SetForAdd:function () {
		Reset_Form_Errors();
LoadAddUpdateView(clients.divAddUpdateID, '/Client/_partialAddUpdate', Resource.Add, function () {
Invoice.ClearData();
$('#divGridUser').hide();
});
},

AddUpdate: function () {
		Reset_Form_Errors();
var FormData = Invoice.GetData();
if (Invoice.ValidateData(FormData)) {
AddEdit('/Invoice/AddUpdateData',{ Model: FormData }, function (responce) {
Invoice.SetForClose();
Invoice.BindGrid();
});
}
},

GetDataByID:function (_Id) {
		Reset_Form_Errors();
Invoice.ClearData();

if (Invoice.xhr_GetData_Edit && Invoice.xhr_GetData_Edit.readystate != 4) 
Invoice.xhr_GetData_Edit.abort();

Invoice.xhr_GetData_Edit = GetAjaxData('/Invoice/GetData',{InvoiceID:_Id, },function(responce){
if (responce !== null && responce.Status === 'Success'){
var json_data = eval(responce);
if (json_data.length == 1){
var Modal = json_data[0];
LoadAddUpdateView(Invoice.divAddUpdateID,'/Invoice/_partialAddUpdate', Resource.Edit, function () {
$('#divGridUser').hide();
$('#hf_InvoiceID').value(Modal.InvoiceID);

Reload_ddl_Global(Invoice.xhr_GetData_User, '#ddlCustomerID', '/AjaxCommonData/GetInvoice', {}, 'Resource.Select', function () { $('#ddlCustomerID').val(Modal.CustomerID); });
$('#txtOrderDate').value(Modal.OrderDate);
$('#txtExpectedDeliveryDateCustom').value(Modal.ExpectedDeliveryDateCustom);
$('#txtInvoiceName').value(Modal.InvoiceName);
$('#txtFrame').value(Modal.Frame);
$('#txtLens').value(Modal.Lens);
$('#txtFrameAmount').value(Modal.FrameAmount);
$('#txtLensAmount').value(Modal.LensAmount);
$('#txtRefractionBy').value(Modal.RefractionBy);
$('#txtRemarks').value(Modal.Remarks);
$('#txtRESPH').value(Modal.RESPH);
$('#txtRECYL').value(Modal.RECYL);
$('#txtREAXIS').value(Modal.REAXIS);
$('#txtREVA').value(Modal.REVA);
$('#txtREADD').value(Modal.READD);
$('#txtLESPH').value(Modal.LESPH);
$('#txtLECYL').value(Modal.LECYL);
$('#txtLEAXIS').value(Modal.LEAXIS);
$('#txtLEVA').value(Modal.LEVA);
$('#txtLEADD').value(Modal.LEADD);
},function(ex){});
} else /*end json_data.length == 1 */ { alert(responce.Message);
}
} else/*end responce.Status === 'Success' */ { alert(responce.Message); }
});/*end GetAjaxData */
},/*end GetDataByID */

 GetData: function() {
	var Invoice = {
	InvoiceID: $('#hf_InvoiceID').val().trim(),
CustomerID: $('#ddlCustomerID').val(),
OrderDate: $('#txtOrderDate').val().trim(),
ExpectedDeliveryDate: $('#txtExpectedDeliveryDate').val().trim(),
InvoiceName: $('#txtInvoiceName').val().trim(),
Frame: $('#txtFrame').val().trim(),
Lens: $('#txtLens').val().trim(),
FrameAmount: $('#txtFrameAmount').val().trim(),
LensAmount: $('#txtLensAmount').val().trim(),
RefractionBy: $('#txtRefractionBy').val().trim(),
Remarks: $('#txtRemarks').val().trim(),
RESPH: $('#txtRESPH').val().trim(),
RECYL: $('#txtRECYL').val().trim(),
REAXIS: $('#txtREAXIS').val().trim(),
REVA: $('#txtREVA').val().trim(),
READD: $('#txtREADD').val().trim(),
LESPH: $('#txtLESPH').val().trim(),
LECYL: $('#txtLECYL').val().trim(),
LEAXIS: $('#txtLEAXIS').val().trim(),
LEVA: $('#txtLEVA').val().trim(),
LEADD: $('#txtLEADD').val().trim(),
};
 return Invoice;
},

 ValidateData: function(FormData){
var valid = true;
	valid = Validate_Control_NullBlank('#hf_InvoiceID', FormData.InvoiceID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#ddlCustomerID', FormData.CustomerID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtOrderDate', FormData.OrderDate, Resource.Required, valid);
valid = Validate_Control_DDMMYYYY('#txtExpectedDeliveryDate', FormData.ExpectedDeliveryDate, Resource.InvalidFormat, valid);
valid = Validate_Control_NullBlank('#txtInvoiceName', FormData.InvoiceName, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtFrameAmount', FormData.FrameAmount, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtLensAmount', FormData.LensAmount, Resource.Required, valid);

FocusOnError('#frm_InvoiceAddUpdate', valid);
 return valid;
},

Delete: function (_id, ItemInfo) {
DeleteData(Invoice.xhr_getData_For_Delete, '/Invoice/Delete', {InvoiceID : _id
, CurrentScreenID: scrnID}
, ItemInfo, function() { Invoice.BindGrid(); Invoice.ClearData(); Invoice.SetForClose(); })
},

ResetDataAddUpdate: function() {
var ID = $('#hf_InvoiceID').val();
$('#frm_InvoiceAddUpdate .has-error p').html('');
$('#frm_InvoiceAddUpdate .has-error').removeClass('has-error');
if (ID == '' || ID == null || ID == 0 || ID == undefined)
Invoice.ClearData();
else
Invoice.GetDataByID(Invoice.xhr_getData_For_Edit, ID);
},

ClearData: function() {
Reset_Form_Errors('#frm_InvoiceAddUpdate');ResetFormErrors('#frm_InvoiceAddUpdate');/*Clear_Form_Fields('#frm_InvoiceAddUpdate');*/$('#frm_InvoiceAddUpdate .has-error p').html('').hide();$('#frm_InvoiceAddUpdate .has-error').removeClass('has-error');$('#frm_InvoiceAddUpdate .form-control:first').focus();},

SetForClose: function() {
},


};
