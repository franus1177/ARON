
var PurchaseOrder = {
    xhr_GetData: null,
    xhr_EditData: null,

    xhr_DeleteData: null,

    divAddUpdateID: '#MasterForm',

    ActiveEvent: function () {

        $('#txtPORecDate,#txtPOEstShipDate,#txtPOActShipDate').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
                           .next().on(ace.click_event, function () {
                               $(this).prev().focus();
                           });

        AllowOnlyNumberValue(".Quantity");
        AllowOnlyNumberOrDecimalValue(".Price");
        AllowOnlyNumberOrDecimalValue(".Commision");

        $(".FixtureNameRow").change(function () {

            var tr = $(this).parent().parent();
            var FixtureID = $(this).val();

            GetAjaxData('/Fixture/GetData', { FixtureID: FixtureID }, function (responce) {
                if (responce !== null && responce.Status === 'Success') {
                    var json_data = eval(responce).Data;
                    if (json_data.length === 1) {
                        var Modal = json_data[0];

                        $(tr).find(".FixturePrice").html("$ " + Modal.FixtureCost);

                    } else /*end json_data.length == 1 */ { alert(responce.Message); }
                } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
            });
        });
        LoadChosen("#ddlCustomer");

        BindAutoCompleteCurrentData("#txtCustomer", "/Customer/GetDataDDL", 1, "CustomerName", "CustomerID",
           function (DataJson) { /*serachData Pass*/ return { CustomerName: $("#txtCustomer").val().trim() } },
           function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
               //var CustomerID = $("#txtCustomer").hasAttr("data-id") == true ? $("#txtCustomer").attr("data-id") : null;
           }, function (event, ui) { });
    },

    BindGrid: function () {
        var FormData = PurchaseOrder.GetDataGrid();
        if (PurchaseOrder.ValidateDataGrid(FormData)) {
            $('#tblGrid').on('draw.dt', function () { PurchaseOrder.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
            LoadGrid(PurchaseOrder.xhr_GetData, 'tblGrid', '/PurchaseOrder/GetData', FormData, function () { PurchaseOrder.ScreenAccessPermission(); });
        }
    },

    GetDataGrid: function () {
        var PurchaseOrder = {
            //POID: $('#hf_POIDSearch').val().trim(),
            //PONumber: $('#txtPONumberSearch').val().trim(),
            //POItemID: $('#ddlPOItemIDSearch').val(),
            //PORecDate: $('#txtPORecDateSearch').val().trim(),
            //POEstShipDate: $('#txtPOEstShipDateSearch').val().trim(),
            //POActShipDate: $('#txtPOActShipDateSearch').val().trim(),
            //POCost: $('#txtPOCostSearch').val().trim(),
            //POPrice: $('#txtPOPriceSearch').val().trim(),
            //POCompleted: $('#chkPOCompletedSearch').prop('checked'),
            //CreatedAt: $('#txtCreatedAtSearch').val().trim(),
            //POPartID: $('#ddlPOPartIDSearch').val(),
        };
        return PurchaseOrder;
    },

    ValidateDataGrid: function (FormData) {
        var valid = true;
        //valid = Validate_Control_NullBlank('#hf_SearchPOID', FormData.POID, Resource.Required, valid);
        //valid = Validate_Control_DDMMYYYY('#txtSearchPOEstShipDate', FormData.POEstShipDate, Resource.InvalidFormat, valid);
        //valid = Validate_Control_DDMMYYYY('#txtSearchPOActShipDate', FormData.POActShipDate, Resource.InvalidFormat, valid);

        FocusOnError('#frm_PurchaseOrderGrid', valid);
        return valid;
    },

    ResetDataGrid: function () {
        var ID = $('#hf_PurchaseOrderID').val();
        $('#frm_PurchaseOrderGrid .has-error p').html('');
        $('#frm_PurchaseOrderGrid .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            PurchaseOrder.ClearData();
        else
            PurchaseOrder.BindGrid();
    },

    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);
        if (getAccess[0].HasInsert)
            GetAddButton('#divAdd', 'PurchaseOrder.SetForAdd()');
        if (!getAccess[0].HasUpdate)
            $('#tblGrid .HasUpdatetds a').removeAttr('href').removeAttr('title').removeAttr('style');
        if (!getAccess[0].HasDelete)
            $('#tblGrid .DeleteColumn').html('').hide();
        if (getAccess[0].HasExport)
            $('#divExport').removeAttr('style');
    },

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(PurchaseOrder.divAddUpdateID, '/PurchaseOrder/_partialAddUpdate', Resource.Add, function () {
            PurchaseOrder.ClearData();
            $('#divGridPurchaseOrder').hide();


            $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl({ POFixtureID: 1, FixtureCost: 0 }).appendTo("#tblFixturePartAddEdit tbody");
            LoadChosen(".FixtureNameRow");
            var PONumber = "";
            var d = new Date();

            var month = d.getMonth() + 1;
            var day = d.getDate();
            var year = d.getFullYear();
            var Hour = d.getHours();
            var Minute = d.getMinutes();
            var Second = d.getSeconds();

            PONumber = d.getFullYear() + '' + (month < 10 ? '0' : '') + month + '' + (day < 10 ? '0' : '') + '' + day + '' + Hour + '' + Minute + '' + Second;

            $('#txtPONumber').val(PONumber).prop("disabled", true);

            PurchaseOrder.AddNewItemPart();

            PurchaseOrder.ActiveEvent();

            $('#txtPORecDate,#txtPOEstShipDate,#txtPOActShipDate').datepicker('setDate', new Date());
        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = PurchaseOrder.GetData();
        if (PurchaseOrder.ValidateData(FormData)) {
            AddUpdateData('/PurchaseOrder/AddUpdateData', { Model: FormData }, function (responce) {
                PurchaseOrder.SetForClose();
            });
        }
    },

    GetDataByID: function (_Id) {
        Reset_Form_Errors();
        PurchaseOrder.ClearData();

        if (PurchaseOrder.xhr_EditData && PurchaseOrder.xhr_EditData.readystate !== 4)
            PurchaseOrder.xhr_EditData.abort();

        PurchaseOrder.xhr_EditData = GetAjaxData('/PurchaseOrder/GetData', { POID: _Id, IsChildResult: true }, function (responce) {
            if (responce !== null && responce.Status === 'Success') {
                var json_data = eval(responce).Data;
                if (json_data.length === 1) {
                    var Modal = json_data[0];
                    LoadAddUpdateView(PurchaseOrder.divAddUpdateID, '/PurchaseOrder/_partialAddUpdate', Resource.Edit + " PO-" + Modal.PONumber, function () {
                        $('#divGridPurchaseOrder').hide();
                        $('#hf_POID').val(Modal.POID);

                        $('#txtPONumber').val(Modal.PONumber).prop("disabled", true);
                        $('#txtPORecDate').val(Modal.PORecDateCustom);
                        $('#txtPOEstShipDate').val(Modal.POEstShipDateCustom);
                        $('#txtPOActShipDate').val(Modal.POActShipDateCustom);

                        $('#txtCustomer').attr("data-id", Modal.CustomerID);
                        $('#txtCustomer').attr("data-label", Modal.CustomerName).prop("disabled", true).prop("readonly", true);
                        $('#txtCustomer').val(Modal.CustomerName);

                        if (Modal.POCompleted === true || Modal.POCompleted === 1)
                            $('#chkPOCompleted').prop('checked', true);

                        var childtbl = Modal.POItem_TableTypeList2;
                        if (childtbl.length > 0) {
                            $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl(childtbl).appendTo("#tblFixturePartAddEdit tbody");
                        } else {
                            $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl({ POFixtureID: 1, FixtureCost: 0 }).appendTo("#tblFixturePartAddEdit tbody");
                        }

                        $(".FixtureNameRow").each(function (i, item) {
                            $(this).val($(this).attr("selectedvalue"));
                        });
                        LoadChosen(".FixtureNameRow");

                        childtbl = Modal.POPartList;
                        if (childtbl.length > 0) {
                            $("#Grid_Data_Template_tblPOPartAddEdit").tmpl(childtbl).appendTo("#tblPOPartAddEdit tbody");
                        } else {
                            PurchaseOrder.AddNewItemPart();
                        }

                        $(".PartRow").each(function (i, item) {
                            $(this).val($(this).attr("selectedvalue"));
                        });
                        LoadChosen(".PartRow");

                        PurchaseOrder.ActiveEvent();

                    }, function (ex) { });
                } else /*end json_data.length == 1 */ { alert(responce.Message); }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },/*end GetDataByID */

    GetData: function () {

        var PurchaseOrder = {
            CustomerID: $('#txtCustomer').attr("data-id"),
            CustomerName: $('#txtCustomer').val().trim(),

            POID: $('#hf_POID').val().trim(),
            PONumber: $('#txtPONumber').val().trim(),

            PORecDate: $('#txtPORecDate').val().trim(),
            POEstShipDate: $('#txtPOEstShipDate').val().trim(),
            POActShipDate: $('#txtPOActShipDate').val().trim(),

            /*POCost: $('#txtPOCost').val().trim(),
            POPrice: $('#txtPOPrice').val().trim(),
            CreatedAt: $('#txtCreatedAt').val().trim(),
            POPartID: $('#ddlPOPartID').val(),*/

            POCompleted: $('#chkPOCompleted').prop('checked'),
        };

        var POItemList = [];
        $('#tblFixturePartAddEdit tbody tr').each(function (i, tr) {
            var POItem = {
                FixtureID: $(this).find(".FixtureNameRow").val(),

                POFixtureID: $(this).attr("data-id"),
                POFixtureQuantity: $(this).find(".Quantity").val().trim(),
                FixturePrice: $(this).find(".Price").val().trim(),
                FixtureCommision: $(this).find(".Commision").val().trim()
            };

            if (POItem.POFixtureID === null || POItem.POFixtureID === "")
                POItem.POFixtureID = 0;

            if (POItem.POFixtureQuantity > 0)
                POItemList.push(POItem);
        });

        PurchaseOrder['POItem_TableTypeList'] = POItemList;

        //var POPartList = [];
        //$('#tblPOPartAddEdit tr').each(function (i, tr) {
        //    var POPart = {
        //        //POPartID: $(this).attr('data-id').trim(),
        //        POItemID: $('#ddlPOItemID' + i).val(),
        //        PartID: $('#ddlPartID' + i).val(),
        //        Quantity: $('#txtQuantity' + i).val().trim(),
        //    };
        //    POPartList.push(POPart)
        //});

        //POPart['POPart_TableTypeList'] = POPartList;
        return PurchaseOrder;
    },

    ValidateData: function (FormData) {
        var valid = true;
        valid = Validate_Control_NullBlank('#txtCustomer', FormData.CustomerName, Resource.Required, valid);
        valid = Validate_Control_DateDDMMYYYY('#txtPOEstShipDate', FormData.POEstShipDate, Resource.InvalidFormat, valid);

        var POItemList = FormData.POItem_TableTypeList;
        if (POItemList.length > 0) {
            $.each(POItemList, function (i, item) {
                valid = Validate_Control_NullBlank('#txtFixturePrice' + i + 1, item.FixturePrice, Resource.Required, valid);
                valid = Validate_Control_NullBlank('#txtFixtureCommision' + i + 1, item.FixtureCommision, Resource.Required, valid);
            });/*each POItem */
        }

        //var POPartList = FormData.POPart_TableTypeList;
        //if (POPartList.length > 0) {
        //    $.each(POPartList, function (i, item) {
        //        valid = Validate_Control_NullBlank('#hf_POPartID', FormData.POPartID, Resource.Required, valid);
        //        valid = Validate_Control_NullBlank('#ddlPOItemID', FormData.POItemID, Resource.Required, valid);
        //    });/*each POPart */
        //}

        FocusOnError('#frm_PurchaseOrderAddUpdate', valid);

        return valid;
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(PurchaseOrder.xhr_DeleteData, '/PurchaseOrder/Delete', { POID: _id, CurrentScreenID: scrnID }, ItemInfo, function () {
            PurchaseOrder.BindGrid();
            //PurchaseOrder.ClearData();
            //PurchaseOrder.SetForClose();
        });
    },

    ResetDataAddUpdate: function () {
        var ID = $('#hf_PurchaseOrderID').val();
        $('#frm_PurchaseOrderAddUpdate .has-error p').html('');
        $('#frm_PurchaseOrderAddUpdate .has-error').removeClass('has-error');
        if (ID === '' || ID === null || ID === 0 || ID === undefined)
            PurchaseOrder.ClearData();
        else
            PurchaseOrder.GetDataByID(PurchaseOrder.xhr_EditData, ID);
    },

    ClearData: function () {
        Reset_Form_Errors('#frm_PurchaseOrderAddUpdate');
        ResetFormErrors('#frm_PurchaseOrderAddUpdate');
        Clear_Form_Fields('#frm_PurchaseOrderAddUpdate');
        $('#frm_PurchaseOrderAddUpdate .has-error p').html('').hide();
        $('#frm_PurchaseOrderAddUpdate .has-error').removeClass('has-error');
        $('#frm_PurchaseOrderAddUpdate .form-control:first').focus();
    },

    SetForClose: function () {
        $(PurchaseOrder.divAddUpdateID).html('').hide();

        PurchaseOrder.BindGrid();
        $('#hf_PurchaseOrderID').val('');
        $('#divGridPurchaseOrder,#divExport,#divAdd').show();
    },

    AddNewItem: function () {

        var rows = $("#tblFixturePartAddEdit tbody tr").length;

        $("#Grid_Data_Template_tblFixturePartAddEdit").tmpl({ POFixtureID: rows + 1, FixtureCost: 0 }).appendTo("#tblFixturePartAddEdit tbody");
        LoadChosen(".FixtureNameRow");
        PurchaseOrder.ActiveEvent();

    },

    RemoveItem: function (controlid) {

        $(controlid).parent().parent().remove();
        var rows = $("#tblFixturePartAddEdit tbody tr").length;
        if (rows == 0)
            PurchaseOrder.AddNewItem();
    },

    AddNewItemPart: function () {

        var rows = $("#tblPOPartAddEdit tbody tr").length;

        $("#Grid_Data_Template_tblPOPartAddEdit").tmpl({ POFixtureID: rows + 1, FixtureCost: 0 }).appendTo("#tblPOPartAddEdit tbody");
        LoadChosen(".FixtureNameRow");
        PurchaseOrder.ActiveEvent();
    },

    RemoveItemPart: function (controlid) {

        $(controlid).parent().parent().remove();

        if ($("#tblPOPartAddEdit tbody tr").length == 0)
            PurchaseOrder.AddNewItemPart();
    },

    OpenParts: function (controlId) {

        var _POID = $(controlId).parent().parent().attr("data-id");

        GetAjaxData('/PurchaseOrder/GetDataPOPart', { POID: _POID, IsActive: true }, function (responce) {
            if (responce !== null && responce.Status === 'Success') {

                $("#divTreePopup").modal("show");
                $("#hf_POPartID").val(_POID);

                var Modal = eval(responce).Data;
                if (Modal.length > 0) {

                    $("#tblPOPartAddEdit tbody").html("");
                    $("#Grid_Data_Template_tblPOPartAddEdit").tmpl(Modal).appendTo("#tblPOPartAddEdit tbody");
                    AllowOnlyNumberValue(".Number");

                } else /*end json_data.length == 1 */ {
                    //alert(responce.Message);
                }
            } else/*end responce.Status === 'Success' */ { alert(responce.Message); }
        });/*end GetAjaxData */
    },

    GetDataPart: function () {

        var PurchaseOrder = {
            POID: $('#hf_POPartID').val()
        };

        var POPartList = [];
        $('#tblPOPartAddEdit tbody tr').each(function (i, tr) {

            var POPart = {
                POPartID: $(this).attr('POPartID'),
                PartID: $(this).attr('data-id'),
                Quantity: $(this).find(".POPartQuantity").val().trim(),
            };

            if (POPart.Quantity > 0)
                POPartList.push(POPart);

        });

        PurchaseOrder['POPart_TableTypeList'] = POPartList;
        return PurchaseOrder;
    },

    ValidateDataPart: function (FormData) {
        var valid = true;

        var POPartList = FormData.POPart_TableTypeList;
        if (POPartList.length > 0) {
            $.each(POPartList, function (i, item) {

                //valid = Validate_Control_NullBlank('#txtFixturePrice' + i + 1, item.FixturePrice, Resource.Required, valid);
                //valid = Validate_Control_NullBlank('#txtFixtureCommision' + i + 1, item.FixtureCommision, Resource.Required, valid);

            });/*each POItem */
        } else {
            valid = false;
        }

        //FocusOnError('#frm_PurchaseOrderAddUpdate', valid);
        return valid;
    },

    AddUpdatePart: function () {
        Reset_Form_Errors();
        var FormData = PurchaseOrder.GetDataPart();
        if (PurchaseOrder.ValidateDataPart(FormData)) {
            AddUpdateData('/PurchaseOrder/AddUpdateDataPart', { Model: FormData }, function (responce) {
                $("#divTreePopup").modal("hide");

            });
        }
    },
};