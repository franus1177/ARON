
var Invoice = {
    xhr_GetData: null,
    xhr_GetData_Edit: null,
    xhr_GetData_User: null,
    divAddUpdateID: "#Master_Form",
    xhr_getData_For_Delete: null,

    ActiveEvent: function () {

        BindAutoCompleteForNewAndOld("#txtCustomerName", "/eCustomer/GetDataDDL", 1, "CustomerName", "CustomerID",
            function (DataJson) { /*serachData Pass*/ return { GlobalID: $("#txtCustomerName").val() } },
            function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
                var CustomerID = $("#txtCustomerName").hasAttr("data-id") === true ? $("#txtCustomerName").attr("data-id") : null;

                Invoice.BindCustomer(CustomerID);
                $('#txtCustomerAddress').focus();

            }, function (event, ui) {

                if ($(event.target).attr('data-label') === "" && $(event.target).attr('data-id') === "") {
                    /*$('#hf_CustomerID').val("");*/
                    $('#txtCustomerAddress').val("");
                    $('#txtContactNumber').val("");
                    $('#txtDOB').val("");
                    $('#txtAnniversaryDate').val("");
                    $('#txtRemarks').val("");
                }
            });

        $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
            .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });

        AllowOnlyNumberValue(".Amount");

        Invoice.ScreenAccessPermission();
    },

    BindCustomer: function (CustomerID) {

        GetAjaxData('/eCustomer/GetData', { CustomerID: CustomerID }, function (responce) {

            if (responce !== null && responce.Status === 'Success') {

                var json_data = (eval(responce)).Data;
                if (json_data.length === 1) {

                    var Modal = json_data[0];

                    $('#txtCustomerName')./*val(Modal.CustomerName).*/attr('data-label', Modal.GlobalID).attr('data-id', Modal.CustomerID);
                    $('#txtCustomerAddress').val(Modal.CustomerAddress);
                    $('#txtContactNumber').val(Modal.ContactNumber);
                    $('#txtDOB').val(Modal.DOBCustom);
                    $('#txtAnniversaryDate').val(Modal.AnniversaryDateCustom);
                    $('#txtRefractionBy').val(Modal.RefractionBy);

                } else /*end json_data.length == 1 */ {
                    alert(responce.Message);
                }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },

    BindGrid: function () {
        //var FormData = Invoice.GetDataGrid();
        //if (Invoice.ValidateDataGrid(FormData)) {
        LoadGrid(Invoice.xhr_GetData, 'tblGrid', '/Invoice/GetData', FormData, function () { Invoice.ScreenAccessPermission(); });
        //}
    },

    GetDataGrid: function () {
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

    ValidateDataGrid: function (FormData) {
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

    ResetDataGrid: function () {
        var ID = $('#hf_InvoiceID').val();
        $('#frm_InvoiceGrid .has-error p').html('');
        $('#frm_InvoiceGrid .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            Invoice.ClearData();
        else
            Invoice.GetDataByID(Invoice.xhr_getData_For_Edit, ID);
    },

    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);
        if (getAccess[0].HasInsert)
            GetAddButton('#divAdd', 'Invoice.SetForAdd()');

        if (getAccess[0].HasUpdate)
            $('#tblGrid .HasUpdatetds a').removeAttr('href').removeAttr('title').removeAttr('style');

        if (!getAccess[0].HasDelete)
            $('#tblGrid .DeleteColumn').html('').addclass('hide');

        if (getAccess[0].HasExport)
            $('#divExport').removeAttr('style');
    },

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(Invoice.divAddUpdateID, '/Invoice/_partialAddUpdate', Resource.Add, function () {
            Invoice.ClearData();
            $('#divGridCustomer').hide();
            $('#txtOrderDate').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
                .next().on(ace.click_event, function () {
                    $(this).prev().focus();
                });
            $('#txtOrderDate').datepicker('setDate', new Date());

            Invoice.ActiveEvent();
        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = Invoice.GetData();
        if (Invoice.ValidateData(FormData)) {
            AddUpdateData('/Invoice/AddUpdateData', { Model: FormData }, function (responce) {
                Invoice.SetForClose();
                Invoice.BindGrid();
            }, function () { });
        }
    },

    GetDataByID: function (_Id) {
        Reset_Form_Errors();
        Invoice.ClearData();

        if (Invoice.xhr_GetData_Edit && Invoice.xhr_GetData_Edit.readystate !== 4)
            Invoice.xhr_GetData_Edit.abort();

        Invoice.xhr_GetData_Edit = GetAjaxData('/Invoice/GetData', { InvoiceID: _Id, }, function (responce) {

            if (responce !== null && responce.Status === 'Success') {

                var json_data = (eval(responce)).Data;
                if (json_data.length === 1) {

                    var Modal = json_data[0];

                    LoadAddUpdateView(Invoice.divAddUpdateID, '/Invoice/_partialAddUpdate', Resource.Edit, function () {

                        $('#txtOrderDate').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
                            .next().on(ace.click_event, function () {
                                $(this).prev().focus();
                            });
                        $('#txtOrderDate').datepicker('setDate', new Date());

                        $('#divGridCustomer').hide();
                        $('#hf_InvoiceID').val(Modal.InvoiceID);
                        /*$('#hf_CustomerID').val(Modal.CustomerID);*/

                        $('#txtCustomerName').attr("data-id", Modal.CustomerID);
                        $('#txtCustomerName').val(Modal.GlobalID).attr('data-label', Modal.GlobalID);
                        $('#txtCustomerAddress').val(Modal.CustomerAddress);
                        $('#txtContactNumber').val(Modal.ContactNumber);
                        $('#txtDOB').val(Modal.DOBCustom);
                        $('#txtAnniversaryDate').val(Modal.AnniversaryDateCustom);

                        $('#txtInvoiceNo').val(Modal.InvoiceID).prop("disabled", true);
                        $('#txtOrderDate').val(Modal.OrderDateCustom);
                        $('#txtExpectedDeliveryDate').val(Modal.ExpectedDeliveryDateCustom);
                        $('#txtInvoiceName').val(Modal.InvoiceName);
                        $('#txtFrame').val(Modal.Frame);
                        $('#txtLens').val(Modal.Lens);
                        $('#txtFrameAmount').val(Modal.FrameAmount);
                        $('#txtLensAmount').val(Modal.LensAmount);
                        $('#txtRefractionBy').val(Modal.RefractionBy);
                        $('#txtRemarks').val(Modal.Remarks);

                        //console.log(Modal);

                        var FrameAmount = 0.00;
                        var LensAmount = 0.00;

                        if (Modal.FrameAmount !== null && Modal.FrameAmount !== "")
                            FrameAmount = Modal.FrameAmount;

                        if (Modal.LensAmount !== null && Modal.LensAmount !== "")
                            LensAmount = Modal.LensAmount;

                        var total = FrameAmount + LensAmount;

                        $('#txtTotal').val(total);
                        $('#txtAdvanceAmount').val(Modal.AdvanceAmount);
                        $('#txtPendingAmount').val(Modal.PendingAmount);

                        $('#txtRESPH').val(Modal.RESPH);
                        $('#txtRECYL').val(Modal.RECYL);
                        $('#txtREAXIS').val(Modal.REAXIS);
                        $('#txtREVA').val(Modal.REVA);
                        $('#txtREADD').val(Modal.READD);
                        $('#txtLESPH').val(Modal.LESPH);
                        $('#txtLECYL').val(Modal.LECYL);
                        $('#txtLEAXIS').val(Modal.LEAXIS);
                        $('#txtLEVA').val(Modal.LEVA);
                        $('#txtLEADD').val(Modal.LEADD);

                        Invoice.ActiveEvent();

                    }, function (ex) { });

                } else /*end json_data.length == 1 */ {
                    alert(responce.Message);
                }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },/*end GetDataByID */

    GetData: function () {

        var Invoice = {
            InvoiceID: $('#hf_InvoiceID').val().trim(),
            CustomerID: $('#txtCustomerName').attr("data-id"),
            OrderDate: $('#txtOrderDate').val().trim(),
            ExpectedDeliveryDate: $('#txtExpectedDeliveryDate').val().trim(),
            InvoiceName: $('#txtInvoiceName').val().trim(),
            Frame: $('#txtFrame').val().trim(),
            Lens: $('#txtLens').val().trim(),
            FrameAmount: $('#txtFrameAmount').val().trim(),
            LensAmount: $('#txtLensAmount').val().trim(),
            RefractionBy: $('#txtRefractionBy').val().trim(),
            Remarks: $('#txtRemarks').val().trim(),
            AdvanceAmount: $('#txtAdvanceAmount').val().trim(),

            RESPH: $('#txtRESPH').val().trim(),
            RECYL: $('#txtRECYL').val().trim(),
            REAXIS: $('#txtREAXIS').val().trim(),
            REVA: $('#txtREVA').val().trim(),
            READD: $('#txtREADD').val().trim(),
            LESPH: $('#txtLESPH').val().trim(),
            LECYL: $('#txtLECYL').val().trim(),
            LEAXIS: $('#txtLEAXIS').val().trim(),
            LEVA: $('#txtLEVA').val().trim(),
            LEADD: $('#txtLEADD').val().trim()
        };

        var eCustomer = {
            CustomerID: $('#txtCustomerName').attr("data-id"),
            CustomerName: $('#txtCustomerName').val().trim(),
            CustomerAddress: $('#txtCustomerAddress').val().trim(),
            ContactNumber: $('#txtContactNumber').val().trim(),
            DOB: $('#txtDOB').val().trim(),
            AnniversaryDate: $('#txtAnniversaryDate').val().trim(),
        };

        return {
            Invoice: Invoice,
            Customer: eCustomer
        };

    },

    ValidateData: function (FormData) {
        var valid = true;
        //valid = Validate_Control_NullBlank('#hf_InvoiceID', FormData.Invoice.InvoiceID, Resource.Required, valid);
        //valid = Validate_Control_NullBlank('#ddlCustomerID', FormData.Invoice.CustomerID, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtOrderDate', FormData.Invoice.OrderDate, Resource.Required, valid);
        valid = Validate_Control_DateDDMMYYYY('#txtExpectedDeliveryDate', FormData.Invoice.ExpectedDeliveryDate, Resource.InvalidFormat, valid);
        valid = Validate_Control_NullBlank('#txtInvoiceName', FormData.Invoice.InvoiceName, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtFrame', FormData.Invoice.Frame, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtFrameAmount', FormData.Invoice.FrameAmount, Resource.Required, valid);

        /*valid = Validate_Control_NullBlank('#txtLens', FormData.Lens, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtLensAmount', FormData.LensAmount, Resource.Required, valid);*/

        //valid = Validate_Control_NullBlank('#txtCustomerName', FormData.CustomerID, Resource.Required, valid);
        valid = Validate_Control_NullBlank('#txtCustomerName', FormData.Customer.CustomerName, Resource.Required, valid);
        valid = Validate_Control_DateDDMMYYYY('#txtDOB', FormData.Customer.DOB, Resource.InvalidFormat, valid);
        valid = Validate_Control_DateDDMMYYYY('#txtAnniversaryDate', FormData.Customer.AnniversaryDate, Resource.InvalidFormat, valid);

        var total = 0.00;
        var AdvanceAmount = 0.00;

        if (FormData.Invoice.FrameAmount !== null && FormData.Invoice.FrameAmount !== "")
            total = eval($('#txtFrameAmount').val().trim());

        if (FormData.Invoice.LensAmount !== null && FormData.Invoice.LensAmount !== "")
            total += eval($('#txtLensAmount').val().trim());

        if (FormData.Invoice.AdvanceAmount !== null && FormData.Invoice.AdvanceAmount !== "")
            AdvanceAmount = eval($('#txtAdvanceAmount').val().trim());

        if (AdvanceAmount > total) {
            valid = false;
            valid = Validate_Alert("#txtAdvanceAmount", "Advance more then Total", valid);
        }


        FocusOnError('#frm_InvoiceAddUpdate', valid);
        return valid;
    },

    CalculatePendingAmount: function () {

        var AdvanceAmount = 0.00;
        //var AdvanceAmount = $('#txtAdvanceAmount').val().trim();

        var FrameAmount = 0.00;
        var LensAmount = 0.00;
        var PendingAmount = 0.00;

        if ($('#txtFrameAmount').val().trim() !== null && $('#txtFrameAmount').val().trim() !== "")
            FrameAmount = eval($('#txtFrameAmount').val().trim());

        if ($('#txtLensAmount').val().trim() !== null && $('#txtLensAmount').val().trim() !== "")
            LensAmount = eval($('#txtLensAmount').val().trim());

        var total = FrameAmount + LensAmount;

        if ($('#txtAdvanceAmount').val().trim() !== null && $('#txtAdvanceAmount').val().trim() !== "")
            PendingAmount = (total - $('#txtAdvanceAmount').val().trim());
        else {
            PendingAmount = (total);
        }

        $('#txtTotal').val(total);
        //$('#txtAdvanceAmount').val(AdvanceAmount);
        $('#txtPendingAmount').val(PendingAmount);
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(Invoice.xhr_getData_For_Delete, '/Invoice/Delete', { InvoiceID: _id, CurrentScreenID: scrnID }, ItemInfo, function () { Invoice.BindGrid(); Invoice.ClearData(); Invoice.SetForClose(); })
    },

    ResetDataAddUpdate: function () {
        var ID = $('#hf_InvoiceID').val();
        $('#frm_InvoiceAddUpdate .has-error p').html('');
        $('#frm_InvoiceAddUpdate .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            Invoice.ClearData();
        else
            Invoice.GetDataByID(Invoice.xhr_getData_For_Edit, ID);
    },

    ClearData: function () {
        Reset_Form_Errors('#frm_InvoiceAddUpdate');
        ResetFormErrors('#frm_InvoiceAddUpdate');
        Clear_Form_Fields('#frm_InvoiceAddUpdate');
        $('#frm_InvoiceAddUpdate .has-error p').html('').hide();
        $('#frm_InvoiceAddUpdate .has-error').removeClass('has-error');
        $('#frm_InvoiceAddUpdate .form-control:first').focus();
    },

    SetForClose: function () {
        $('#divGridCustomer').show();
        $(Invoice.divAddUpdateID).html("");
    }
};
