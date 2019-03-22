
var eCustomer = {
xhr_GetData: null,
xhr_GetData_Edit: null,

ActiveEvent: function() {
},

	BindGrid: function () {
var FormData = eCustomer.GetDataGrid();
if (eCustomer.ValidateDataGrid(FormData)) {
LoadGrid(eCustomer.xhr_GetData, 'tblGrid', '/eCustomer/GetData', FormData, function () { /*eCustomer.ScreenAccessPermission();*/ });
}
},

 GetDataGrid: function() {
	var eCustomer = {
	CustomerID: $('#hf_SearchCustomerID').val().trim(),
CustomerName: $('#txtSearchCustomerName').val().trim(),
CustomerAddress: $('#txtSearchCustomerAddress').val().trim(),
ContactNumber: $('#txtSearchContactNumber').val().trim(),
DOB: $('#txtSearchDOB').val().trim(),
AnniversaryDate: $('#txtSearchAnniversaryDate').val().trim(),
};
 return eCustomer;
},

 ValidateDataGrid: function(FormData){
var valid = true;
	valid = Validate_Control_NullBlank('#hf_SearchCustomerID', FormData.CustomerID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtSearchCustomerName', FormData.CustomerName, Resource.Required, valid);
valid = Validate_Control_DDMMYYYY('#txtSearchDOB', FormData.DOB, Resource.InvalidFormat, valid);
valid = Validate_Control_DDMMYYYY('#txtSearchAnniversaryDate', FormData.AnniversaryDate, Resource.InvalidFormat, valid);

FocusOnError('#frm_eCustomerGrid', valid);
 return valid;
},

ResetDataGrid: function() {
var ID = $('#hf_eCustomerID').val();
$('#frm_eCustomerGrid .has-error p').html('');
$('#frm_eCustomerGrid .has-error').removeClass('has-error');
if (ID == '' || ID == null || ID == 0 || ID == undefined)
eCustomer.ClearData();
else
eCustomer.GetDataByID(eCustomer.xhr_getData_For_Edit, ID);
},

ScreenAccessPermission:function () {
		var getAccess = GetScreenAccessPermissions(scrnID);
if (getAccess[0].HasInsert)
GetAddButton('#divAdd', 'eCustomer.SetForAdd()');
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
eCustomer.ClearData();
$('#divGridUser').hide();
});
},

AddUpdate: function () {
		Reset_Form_Errors();
var FormData = eCustomer.GetData();
if (eCustomer.ValidateData(FormData)) {
AddEdit('/eCustomer/AddUpdateData',{ Model: FormData }, function (responce) {
eCustomer.SetForClose();
eCustomer.BindGrid();
});
}
},

GetDataByID:function (_Id) {
		Reset_Form_Errors();
eCustomer.ClearData();

if (eCustomer.xhr_GetData_Edit && eCustomer.xhr_GetData_Edit.readystate != 4) 
eCustomer.xhr_GetData_Edit.abort();

eCustomer.xhr_GetData_Edit = GetAjaxData('/eCustomer/GetData',{CustomerID:_Id, },function(responce){
if (responce !== null && responce.Status === 'Success'){
var json_data = eval(responce);
if (json_data.length == 1){
var Modal = json_data[0];
LoadAddUpdateView(eCustomer.divAddUpdateID,'/eCustomer/_partialAddUpdate', Resource.Edit, function () {
$('#divGridUser').hide();
$('#hf_CustomerID').value(Modal.CustomerID);

$('#txtCustomerName').value(Modal.CustomerName);
$('#txtCustomerAddress').value(Modal.CustomerAddress);
$('#txtContactNumber').value(Modal.ContactNumber);
$('#txtDOBCustom').value(Modal.DOBCustom);
$('#txtAnniversaryDateCustom').value(Modal.AnniversaryDateCustom);
},function(ex){});
} else /*end json_data.length == 1 */ { alert(responce.Message);
}
} else/*end responce.Status === 'Success' */ { alert(responce.Message); }
});/*end GetAjaxData */
},/*end GetDataByID */

 GetData: function() {
	var eCustomer = {
	CustomerID: $('#hf_CustomerID').val().trim(),
CustomerName: $('#txtCustomerName').val().trim(),
CustomerAddress: $('#txtCustomerAddress').val().trim(),
ContactNumber: $('#txtContactNumber').val().trim(),
DOB: $('#txtDOB').val().trim(),
AnniversaryDate: $('#txtAnniversaryDate').val().trim(),
};
 return eCustomer;
},

 ValidateData: function(FormData){
var valid = true;
	valid = Validate_Control_NullBlank('#hf_CustomerID', FormData.CustomerID, Resource.Required, valid);
valid = Validate_Control_NullBlank('#txtCustomerName', FormData.CustomerName, Resource.Required, valid);
valid = Validate_Control_DDMMYYYY('#txtDOB', FormData.DOB, Resource.InvalidFormat, valid);
valid = Validate_Control_DDMMYYYY('#txtAnniversaryDate', FormData.AnniversaryDate, Resource.InvalidFormat, valid);

FocusOnError('#frm_eCustomerAddUpdate', valid);
 return valid;
},

Delete: function (_id, ItemInfo) {
DeleteData(eCustomer.xhr_getData_For_Delete, '/eCustomer/Delete', {CustomerID : _id
, CurrentScreenID: scrnID}
, ItemInfo, function() { eCustomer.BindGrid(); eCustomer.ClearData(); eCustomer.SetForClose(); })
},

ResetDataAddUpdate: function() {
var ID = $('#hf_eCustomerID').val();
$('#frm_eCustomerAddUpdate .has-error p').html('');
$('#frm_eCustomerAddUpdate .has-error').removeClass('has-error');
if (ID == '' || ID == null || ID == 0 || ID == undefined)
eCustomer.ClearData();
else
eCustomer.GetDataByID(eCustomer.xhr_getData_For_Edit, ID);
},

ClearData: function() {
Reset_Form_Errors('#frm_eCustomerAddUpdate');ResetFormErrors('#frm_eCustomerAddUpdate');/*Clear_Form_Fields('#frm_eCustomerAddUpdate');*/$('#frm_eCustomerAddUpdate .has-error p').html('').hide();$('#frm_eCustomerAddUpdate .has-error').removeClass('has-error');$('#frm_eCustomerAddUpdate .form-control:first').focus();},

SetForClose: function() {
},


};
