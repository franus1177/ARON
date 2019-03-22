
var Fixture = {
    xhr_GetData: null,
    xhr_EditData: null,
    xhr_DeleteData: null,

    divAddUpdateID: '#MasterForm',

    ActiveEvent: function () { },

    BindGrid: function () {
        var FormData = Fixture.GetDataGrid();
        if (Fixture.ValidateDataGrid(FormData)) {
            $('#tblGrid').on('draw.dt', function () { Fixture.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
            LoadGrid(Fixture.xhr_GetData, 'tblGrid', '/Fixture/GetData', FormData, function () { Fixture.ScreenAccessPermission(); });
        }
    },

    GetDataGrid: function () {
        var Fixture = {
            //FixtureID: $('#hf_FixtureIDSearch').val().trim(),
            //FixtureName: $('#txtFixtureNameSearch').val().trim(),
            //FixtureCost: $('#txtFixtureCostSearch').val().trim(),
        };
        return Fixture;
    },

    ValidateDataGrid: function (FormData) {
        var valid = true;
        //valid = Validate_Control_NullBlank('#hf_SearchFixtureID', FormData.FixtureID, Resource.Required, valid);
        //valid = Validate_Control_NullBlank('#txtSearchFixtureName', FormData.FixtureName, Resource.Required, valid);

        FocusOnError('#frm_FixtureGrid', valid);
        return valid;
    },

    ResetDataGrid: function () {
        var ID = $('#hf_FixtureID').val();
        $('#frm_FixtureGrid .has-error p').html('');
        $('#frm_FixtureGrid .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            Fixture.ClearData();
        else
            Fixture.BindGrid();
    },

    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);
        if (getAccess[0].HasInsert)
            GetAddButton('#divAdd', 'Fixture.SetForAdd()');

        if (!getAccess[0].HasUpdate)
            $('#tblGrid .HasUpdatetds a').removeAttr('href').removeAttr('title').removeAttr('style');
        if (!getAccess[0].HasDelete)
            $('#tblGrid .DeleteColumn').html('').hide();
        if (getAccess[0].HasExport)
            $('#divExport').removeAttr('style');
    },

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(Fixture.divAddUpdateID, '/Fixture/_partialAddUpdate', Resource.Add, function () {

            GetAjaxData('/Part/GetData', { PartID: null, }, function (responce) {
                if (responce !== null && responce.Status === 'Success') {
                    var Modal = eval(responce).Data;
                    if (Modal.length > 0) {

                        $("#tblFixturePartAddEdit tbody").html("");
                        $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl(Modal).appendTo("#tblFixturePartAddEdit tbody");
                        AllowOnlyNumberValue(".Number");

                    } else /*end json_data.length == 1 */ {
                        alert(responce.Message);
                    }
                } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
            });/*end GetAjaxData */

            Fixture.ClearData();
            //$('#divGridFixture').hide();
        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = Fixture.GetData();
        if (Fixture.ValidateData(FormData)) {
            AddUpdateData('/Fixture/AddUpdateData', { Model: FormData }, function (responce) {
                Fixture.SetForClose();
                Fixture.BindGrid();
            });
        }
    },

    GetDataByID: function (_Id) {
        Reset_Form_Errors();
        Fixture.ClearData();

        if (Fixture.xhr_EditData && Fixture.xhr_EditData.readystate !== 4)
            Fixture.xhr_EditData.abort();

        Fixture.xhr_EditData = GetAjaxData('/Fixture/GetData', { FixtureID: _Id, IsChildResult: true }, function (responce) {
            if (responce !== null && responce.Status === 'Success') {
                var json_data = eval(responce).Data;
                if (json_data.length === 1) {
                    var Modal = json_data[0];

                    LoadAddUpdateView(Fixture.divAddUpdateID, '/Fixture/_partialAddUpdate', Resource.Edit, function () {
                        //$('#divGridFixture').hide();
                        $('#hf_FixtureID').val(Modal.FixtureID);

                        $('#txtFixtureName').val(Modal.FixtureName);
                        $('#txtFixtureCost').val(Modal.FixtureCost);
                        $('#txtFixtureCode').val(Modal.FixtureCode);
                        $("#tblFixturePartAddEdit tbody").html("");
                        $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl(Modal.FixturePartList).appendTo("#tblFixturePartAddEdit tbody");
                        AllowOnlyNumberValue(".Number");

                    }, function (ex) { });
                } else /*end json_data.length == 1 */ {
                    alert(responce.Message);
                }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },/*end GetDataByID */

    GetData: function () {
        var Fixture = {
            FixtureID: $('#hf_FixtureID').val().trim(),
            FixtureName: $('#txtFixtureName').val().trim(),
            FixtureCost: $('#txtFixtureCost').val().trim(),
            FixtureCode: $('#txtFixtureCode').val().trim()
        };

        var PartList = [];
        $('#tblFixturePartAddEdit tbody tr').each(function (i, tr) {

            var Part = {
                FixturePartID: $(this).attr('FixturePartID'),
                FixtureID: Fixture.FixtureID,
                PartID: $(this).attr("data-id"),
                Quantity: null
            };

            Part.Quantity = $('#txtQuantity' + Part.PartID).val().trim();

            if (eval(Part.Quantity) > 0)
                PartList.push(Part);
        });

        Fixture['FixturePart_TableTypeList'] = PartList;
        return Fixture;
    },

    ValidateData: function (FormData) {
        var valid = true;
        /*valid = Validate_Control_NullBlank('#hf_FixtureID', FormData.FixtureID, Resource.Required, valid);*/
        valid = Validate_Control_NullBlank('#txtFixtureName', FormData.FixtureName, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtFixtureCode', FormData.FixtureCode, Resource.Required, valid);
     
        var FixturePartList = FormData.FixturePart_TableTypeList;
        if (FixturePartList.length == 0 && FormData.FixtureName != "") {
            valid = false;
            toastr.error("Part quantity is required");
        }

        FocusOnError('#frm_FixtureAddUpdate', valid);
        return valid;
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(Fixture.xhr_DeleteData, '/Fixture/Delete', { FixtureID: _id, CurrentScreenID: scrnID }, ItemInfo, function () {
            Fixture.BindGrid();
        });
    },

    ResetDataAddUpdate: function () {
        var ID = $('#hf_FixtureID').val();
        $('#frm_FixtureAddUpdate .has-error p').html('');
        $('#frm_FixtureAddUpdate .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            Fixture.ClearData();
        else
            Fixture.GetDataByID(Fixture.xhr_EditData, ID);
    },

    ClearData: function () {
        Reset_Form_Errors('#frm_FixtureAddUpdate');
        ResetFormErrors('#frm_FixtureAddUpdate');
        Clear_Form_Fields('#frm_FixtureAddUpdate');
        $('#frm_FixtureAddUpdate .has-error p').html('').hide();
        $('#frm_FixtureAddUpdate .has-error').removeClass('has-error');
        $('#frm_FixtureAddUpdate .form-control:first').focus();
    },

    SetForClose: function () {
        $(Fixture.divAddUpdateID).html('').hide();

        $('#hf_FixtureID').val('');
        $('#divGridFixture,#divExport,#divAdd').show();
    }
};