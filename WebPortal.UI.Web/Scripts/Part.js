
var Part = {
    xhr_GetData: null,
    xhr_EditData: null,
    xhr_DeleteData: null,

    divAddUpdateID: '#MasterForm',

    ActiveEvent: function () { },

    BindGrid: function () {
        var FormData = Part.GetDataGrid();
        if (Part.ValidateDataGrid(FormData)) {
            //$('#tblGrid').on('draw.dt', function () { Part.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
            LoadGrid(Part.xhr_GetData, 'tblGrid', '/Part/GetData', FormData, function () { Part.ScreenAccessPermission(); });
        }
    },

    GetDataGrid: function () {
        var Part = {
            //PartID: $('#hf_PartIDSearch').val().trim(),
            //PartName: $('#txtPartNameSearch').val().trim(),
            //PartDescription: $('#txtPartDescriptionSearch').val().trim(),
            //PartVendor: $('#txtPartVendorSearch').val().trim(),
            //PartCost: $('#txtPartCostSearch').val().trim(),
            //PartQuantity: $('#txtPartQuantitySearch').val().trim(),
        };
        return Part;
    },

    ValidateDataGrid: function (FormData) {
        var valid = true;
        //valid = Validate_Control_NullBlank('#hf_SearchPartID', FormData.PartID, Resource.Required, valid);

        FocusOnError('#frm_PartGrid', valid);
        return valid;
    },

    ResetDataGrid: function () {
        var ID = $('#hf_PartID').val();
        $('#frm_PartGrid .has-error p').html('');
        $('#frm_PartGrid .has-error').removeClass('has-error');
        if (ID == '' || ID == null || ID == 0 || ID == undefined)
            Part.ClearData();
        else
            Part.BindGrid();
    },

    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);
        if (getAccess[0].HasInsert)
            GetAddButton('#divAdd', 'Part.SetForAdd()');
        if (!getAccess[0].HasUpdate)
            $('#tblGrid .HasUpdatetds a').removeAttr('href').removeAttr('title').removeAttr('style');
        if (!getAccess[0].HasDelete)
            $('#tblGrid .DeleteColumn').html('').addclass('hide');
        if (getAccess[0].HasExport)
            $('#divExport').removeAttr('style');
    },

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(Part.divAddUpdateID, '/Part/_partialAddUpdate', Resource.Add, function () {
            Part.ClearData();
            //$('#divGridPart').hide();
            AllowOnlyNumberOrDecimalValue(".Alphabet");
            AllowOnlyNumberOrDecimalValue(".Amount");
            AllowOnlyNumberValue(".Number");
        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = Part.GetData();
        if (Part.ValidateData(FormData)) {
            AddUpdateData('/Part/AddUpdateData', { Model: FormData }, function (responce) {

                if (FormData.PartID > 0) {
                    Part.SetForClose();
                } else
                    Part.ClearData();

                Part.BindGrid();
            });
        }
    },

    GetDataByID: function (_Id) {
        Reset_Form_Errors();
        Part.ClearData();

        if (Part.xhr_EditData && Part.xhr_EditData.readystate != 4)
            Part.xhr_EditData.abort();

        Part.xhr_EditData = GetAjaxData('/Part/GetData', { PartID: _Id, }, function (responce) {
            if (responce !== null && responce.Status === 'Success') {
                var json_data = eval(responce).Data;
                if (json_data.length == 1) {
                    var Modal = json_data[0];
                    LoadAddUpdateView(Part.divAddUpdateID, '/Part/_partialAddUpdate', Resource.Edit, function () {
                        AllowOnlyNumberOrDecimalValue(".Alphabet");
                        AllowOnlyNumberOrDecimalValue(".Amount");
                        AllowOnlyNumberValue(".Number");

                        //$('#divGridPart').hide();
                        $('#hf_PartID').val(Modal.PartID);

                        $('#txtPartName').val(Modal.PartName);
                        $('#txtPartDescription').val(Modal.PartDescription);
                        $('#txtPartVendor').val(Modal.PartVendor);
                        $('#txtPartCost').val(Modal.PartCost);
                        $('#txtPartQuantity').val(Modal.PartQuantity);
                    }, function (ex) { });
                } else /*end json_data.length == 1 */ {
                    alert(responce.Message);
                }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },/*end GetDataByID */

    GetData: function () {
        var Part = {
            PartID: $('#hf_PartID').val().trim(),
            PartName: $('#txtPartName').val().trim(),
            PartDescription: $('#txtPartDescription').val().trim(),
            PartVendor: $('#txtPartVendor').val().trim(),
            PartCost: $('#txtPartCost').val().trim(),
            PartQuantity: $('#txtPartQuantity').val().trim(),
        };
        return Part;
    },

    ValidateData: function (FormData) {
        var valid = true;
        //valid = Validate_Control_NullBlank('#hf_PartID', FormData.PartID, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtPartName', FormData.PartName, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtPartVendor', FormData.PartVendor, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtPartCost', FormData.PartCost, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtPartQuantity', FormData.PartQuantity, Resource.Required, valid);

        FocusOnError('#frm_PartAddUpdate', valid);
        return valid;
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(Part.xhr_DeleteData, '/Part/Delete', { PartID: _id, CurrentScreenID: scrnID }, ItemInfo, function () {
            Part.BindGrid();

            //https://datatables.net/reference/api/rows().remove()
        });
    },

    ResetDataAddUpdate: function () {
        var ID = $('#hf_PartID').val();
        $('#frm_PartAddUpdate .has-error p').html('');
        $('#frm_PartAddUpdate .has-error').removeClass('has-error');
        if (ID == '' || ID == null || ID == 0 || ID == undefined)
            Part.ClearData();
        else
            Part.GetDataByID(Part.xhr_EditData, ID);
    },

    ClearData: function () {
        //Reset_Form_Errors('#frm_PartAddUpdate');
        //ResetFormErrors('#frm_PartAddUpdate');
        Clear_Form_Fields('#frm_PartAddUpdate');
        $('#frm_PartAddUpdate .has-error p').html('').hide();
        $('#frm_PartAddUpdate .has-error').removeClass('has-error');
        $('#frm_PartAddUpdate .form-control:first').focus();
    },

    SetForClose: function () {
        $(Part.divAddUpdateID).html('').hide();
        $('#hf_PartID').val('');
        $('#divGridPart,#divExport,#divAdd').show();
    }
};