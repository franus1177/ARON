var xhr_getData_For_Edit;
var xhr_GetData;
var xhr_getData_For_delete;
var xhr_GetData_UserRole;
var xhr_GetData_Language;
var xhr_GetData_AccountManager;
var xhr_GetData_ddlLocation;
var divAddUpdateID = "#Master_Form";

$(document).ready(function () {
    customer.OpenAddPopUp();
});

var customer = {

    OpenAddPopUp: function () {

        customer.ScreenAccessPermission();

        if (eval(_LocationID) > 0 && $("#divAdd").length > 0) {
            customer.SetForAdd();
        } else {
            customer.BindGrid();
            customer.AddEvents();
        }
    },

    BindGrid: function () {
        $('#tblGrid').on('draw.dt', function () { customer.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGrid(xhr_GetData, "tblGrid", "/Customer/GetData", { Id: null }, function (data) {

            customer.ScreenAccessPermission(data);
            $('#tblGrid,#tblGrid thead tr th').removeAttr("style");
        });
    },

    AddEvents: function () {

        $("#ddlModule").change(function (evt, params) { customer.EnabledDisabledServiceLine(); });

        $("#tabAddress").click(function () { customerAddress.BindGrid(); });

        $("#tabContact").click(function () {
            customerContact.BindGrid();
            customerContact.AddEvents();
            $("#lblHeadingContact").html(Resource.Add);
        });

        $("#tabHoliday").click(function () {
            customerHoliday.BindGrid();
            Reload_ddl_Global(customerHoliday.xhr_GetData_HolidayLocation, "#ddlHolidayLocation", "/AjaxCommonData/GetCustomerLocation", { CustomerID: $("#hf_CustomerID").val() }, null/*Resource.Select*/, function () {
                LoadChosen("#ddlHolidayLocation");
            });
            customerHoliday.GetLanguageDataForAddEdit(null);
        });

        $("#tabWeeklyOff").click(function () {
            customerWeeklyoff.BindGrid();
            Reload_ddl_Global(customerWeeklyoff.xhr_GetData_WeeklyOffLocation, "#ddlWeeklyOffLocation", "/AjaxCommonData/GetCustomerLocation", { CustomerID: $("#hf_CustomerID").val() }, null/*Resource.Select*/, function () {
                LoadChosen("#ddlWeeklyOffLocation");
            });
            //customerHoliday.GetLanguageDataForAddEdit(null);
        });

        AllowCharacterNumber(".NumberCharactor,#txtCustomerShortCode");
    },

    EnabledDisabledServiceLine: function () {

        var Modules = $('#ddlModule').val();
        var isSafety = false;

        if (Modules != null) {
            $.each(Modules, function (i, item) { if (item == "SF") { isSafety = true; } });
        }

        if (isSafety && IsServiceLineShow) {
            var length = $('#ddlServiceLine option').length;
            SetddlItem("#ddlServiceLine", length, null);
            $('#ddlServiceLine').trigger("chosen:updated");
            $('#ddlServiceLine').prop('disabled', false).trigger("chosen:updated");
        }
        else {

            $('#ddlServiceLine').val("");
            $('#ddlServiceLine').prop("disabled", true).trigger("chosen:updated");
            $('#ddlServiceLine').val("").trigger("chosen:updated");

            if (!IsServiceLineShow && isSafety)
                $("#ddlServiceLine").val("FR").trigger("chosen:updated");
        }

        return isSafety;
    },

    //screen access code start
    ScreenAccessPermission: function (data) {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'customer.SetForAdd()');
        else $("#divAdd").remove();

        if (!getAccess[0].HasDelete)
            $("#tblGrid .DeleteColumn").addClass("hide").html("");

        if (!getAccess[0].HasUpdate)
            $(".HasUpdatetds").removeAttr("onclick").removeAttr("title").removeAttr("style").prop("disabled", true);

        if (getAccess[0].HasExport)
            $("#divExport").show();
        else $("#divExport").remove();

        if (getAccess[0].HasSelect) {
            var flag = false;
            var flag2 = false;

            for (var i = 1; i < getAccess.length; i++) {
                if (getAccess.length > 1) {
                    if ((getAccess[i].ActionCode == "CustDashbaord")) {
                        flag = true;
                    }
                    else if ((getAccess[i].ActionCode == "CustomerLoc")) {
                        flag2 = true;
                    }
                }
            }

            if (!flag)
                $("#tblGrid .CustDashbaordColumn").addClass("hide").html("");

            if (!flag2)
                $("#tblGrid .CustLocationColumn").addClass("hide").html("");
        }
    },
    //screen access code end

    SetForAdd: function () {
        Reset_Form_Errors();

        LoadAddUpdateView(divAddUpdateID, "/Client/_partialAddUpdate", Resource.Add,
            function () {
                customer.ClearData();
                customer.AddEvents();

                $("#divGridCustomer,#divExport,#divAdd").hide();

                //Reload_ddl_Global(xhr_GetData_ddlLocation, "#ddlLocation", "/Location/GetHasCustomerLocations", {}, null, function (data) { SetddlItem("#ddlLocation", data.Data.length, null); if (eval(_LocationID) > 0) $("#ddlLocation").val(_LocationID); LoadChosen("#ddlLocation"); });
                //Reload_ddl_GlobalStatic("#ddlLanguage", "Language", null, function (data) { SetddlItem("#ddlLanguage", data.length, null); LoadChosen("#ddlLanguage"); });
                //Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                //    SetddlItem("#ddlModule", data.length, null);
                //    LoadChosen("#ddlModule");
                //});

                //Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                //    SetddlItem("#ddlServiceLine", data.length, null);
                //    LoadChosen("#ddlServiceLine");
                //});

                //Reload_ddl_Global(xhr_GetData_AccountManager, "#ddlAccountManager", "/User/GetData", {}, Resource.Select, function (data) { SetddlItem("#ddlAccountManager", data.Data.length, null); });
                //customer.bindDatePicker();

                //$('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                customer.AddEvents();
                //customerAddress.AddEvents();
            });
    },

    //Save data to server
    AddUpdate: function () {

    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        customer.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();

        xhr = $.ajax({
            url: "/Customer/GetData", cache: false, data: { CustomerID: _Id, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {
                    LoadAddUpdateView(divAddUpdateID, "/Customer/_partialAddUpdate", Resource.Edit,
                        function () {

                            $("#divGridCustomer,#divExport,#divAdd").hide();
                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);

                            $("#HCustomerLocation").val(json_data[0].CustomerID);
                            $("#hf_CustomerID").val(json_data[0].CustomerID);  //save id into Hidden field edit submit
                            $("#txtCustomerShortCode").val(json_data[0].CustomerShortCode);
                            $("#txtCustomerShortCode").attr('disabled', 'disabled');

                            $("#txtCustomerName").val(json_data[0].CustomerName);
                            $("#txtLegalEntityName").val(json_data[0].LegalEntityName);
                            $("#txtRemarks").val(json_data[0].Remarks);
                            $("#ddlAccountManager").val(json_data[0].AccountManagerID);

                            Reload_ddl_GlobalStatic("#ddlLanguage", "Language", null, function () {
                                LoadChosen("#ddlLanguage", true);
                                SetValueToListBox("#ddlLanguage", json_data[0].CustomerLanguageList);
                                $('#ddlLanguage').trigger('chosen:updated');
                            });

                            Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function () {
                                LoadChosen("#ddlModule", true);
                                SetValueToListBox("#ddlModule", json_data[0].CustomerModuleList);
                                $('#ddlModule').trigger('chosen:updated');
                            });

                            Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function () {
                                LoadChosen("#ddlServiceLine", true);
                                SetValueToListBox("#ddlServiceLine", json_data[0].CustomerServiceLineList);
                                $('#ddlServiceLine').trigger('chosen:updated');
                            });

                            Reload_ddl_Global(xhr_GetData_AccountManager, "#ddlAccountManager", "/User/GetData", {}, Resource.Select, function () { $("#ddlAccountManager").val(json_data[0].AccountManagerID); });

                            Reload_ddl_Global(xhr_GetData_ddlLocation, "#ddlLocation", "/Location/GetHasCustomerLocations", {}, null, function () {
                                LoadChosen("#ddlLocation", true);
                                SetValueToListBox("#ddlLocation", json_data[0].CustomerLocationList);
                                ChosenItemDisable("#ddlLocation", json_data[0].CustomerLocationList, "HasChild", "ParentLocationID", CanNotChanageLocationMessages);
                                LoadChosen("#ddlLocation", true);
                            });

                            customer.bindDatePicker();
                            customer.AddEvents();
                            customer.EnabledDisabledServiceLine();
                            customerAddress.AddEvents();

                            var url = window.location.origin;
                            //data: image / png; base64,
                            if (json_data[0].Logo != null) {
                                ImageViewer("#ulfuPreview");
                                $("#fuPreview").attr("src", url + "/CustomerLogo" + json_data[0].LogoString + json_data[0].FileType).show();
                                ($("#fuPreview").parent()).attr("href", "/CustomerLogo/" + json_data[0].LogoString + json_data[0].FileType).show();
                            }

                            $("#txtEffectiveFromDate").val(json_data[0].EffectiveFromDateCustom);
                            $("#txtEffectiveTillDate").val(json_data[0].EffectiveTillDateCustom);
                        });

                } else {
                    toastr.error(data.Message);
                    $("#hf_CustomerID").val("");       //reset hidden field to zero
                }
            }
        });
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#txtCustomerShortCode", FormData.CustomerShortCode, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtCustomerName", FormData.CustomerName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtEffectiveFromDate", FormData.EffectiveFromDate, Resource.Required, valid);

        valid = Validate_Control_NullBlank("#ddlLanguage", FormData.CustomerLanguage_TableTypeList, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlModule", FormData.CustomerModule_TableTypeList, Resource.Required, valid);

        if (customer.EnabledDisabledServiceLine() && FormData.CustomerServiceLine_TableTypeList.length == 0)
            valid = Validate_Control_NullBlank("#ddlServiceLine", null, Resource.Required, valid);

        if (FormData.CustomerLocation_TableTypeList.length == 0)
            valid = Validate_Control_NullBlank("#ddlLocation", null, Resource.Required, valid);

        valid = Validate_Control_NullBlank("#ddlAccountManager", FormData.AccountManagerID, Resource.Required, valid);
        valid = Validate_Control_DateCompair("#txtEffectiveFromDate", "#txEffectiveTillDate", FormData.EffectiveFromDate, FormData.EffectiveTillDate, Resource.FromDateisGreaterMessage, valid);

        if (!(FormData.EffectiveTillDate == null || FormData.EffectiveTillDate == "" || FormData.EffectiveTillDate == undefined)) {
            valid = Validate_Control_NullBlank("#txtEffectiveFromDate", FormData.EffectiveFromDate, Resource.Required, valid);
        }

        FocusOnError("#frm_Customer", valid);
        return valid;
    },

    //Get form data
    GetData: function () {

        var Data = {
            CustomerID: $("#hf_CustomerID").val(),
            CustomerShortCode: $("#txtCustomerShortCode").val().trim(),
            CustomerName: $("#txtCustomerName").val().trim(),
            LegalEntityName: $("#txtLegalEntityName").val().trim(),
            Logo: $('txtLogo').val(),
            Remarks: $("#txtRemarks").val().trim(),
            AccountManagerID: $("#ddlAccountManager").val(),
            EffectiveFromDate: $("#txtEffectiveFromDate").val().trim(),
            EffectiveTillDate: $("#txtEffectiveTillDate").val().trim(),
            CustomerLanguage_TableTypeList: GetValueToListBoxSelected("#ddlLanguage", "LanguageCode"),
            CustomerLocation_TableTypeList: GetValueToListBoxSelected("#ddlLocation", "LocationID"),
            CustomerServiceLine_TableTypeList: GetValueToListBoxSelected("#ddlServiceLine", "ServiceLineCode"),
            CustomerModule_TableTypeList: GetValueToListBoxSelected("#ddlModule", "ModuleCode"),
            CurrentScreenID: scrnID,
        };

        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Customer");
        $('#ddlServiceLine,#ddlModule,#ddlLanguage,#ddlLocation').val("").trigger("chosen:updated");
        $('#ddlServiceLine').prop('disabled', false).trigger("chosen:updated");
        $('#fuLogo').val(null);
        $("#fuPreview").parent().hide();
        customer.bindDatePicker();
        $("input[autofocus]").focus();
        $("#HCustomerLocation").val("");
    },

    ResetData: function () {
        var CustomerID = $("#hf_CustomerID").val();

        if (!IsNotNull(CustomerID)) {
            customer.ClearData();
            if (eval(_LocationID) > 0) {
                $('#ddlLocation').val(_LocationID).trigger("chosen:updated");
            }
        }
        else
            customer.GetDataByID(xhr_getData_For_Edit, CustomerID);
    },

    SetForClose: function () {
        _LocationID = 0;
        $(divAddUpdateID).html('').hide();
        customer.BindGrid();
        $("#hf_CustomerID").val("");
        $("#divGridCustomer,#divExport,#divAdd").show();
    },

    Delete: function (_Id, ItemInfo) {
        DeleteData(xhr_getData_For_delete, "/Customer/Delete", { CustomerID: _Id, CurrentScreenID: scrnID }, ItemInfo, function () { customer.BindGrid(); });
    },

    RedirectToDashboard: function (_Id) {
        //window.location = "/Customer/Dashboard?CustomerID=" + _Id + "&GlobalID=" + encryptScreenID;
        //customerportal / customerDashboard / Dashboard / 5
        $('#tblGrid').on('draw.dt', function () { customer.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        window.location = "/CustomerPortal/CustomerDashboard/Dashboard/" + _Id + "CustomerDashboard" + "$" + globalScreenID.CustomerDashboardID;// + "&GlobalID=" + encryptScreenID;
    },

    RedirectToCustomeLocation: function (_Id) {
        window.location = "/Customer/Location?CustomerID=" + _Id + "&TravelFrom=Customer&GlobalID=" + globalScreenID.CustomerLocationScreenID;
    },

    RedirectToControllerTagging: function (_Id) {
        window.location = "/Safety/ControllerTagging/List?CustomerID=" + _Id + "&GlobalID=" + globalScreenID.ControllerTaggingScreenID;
    },

    bindDatePicker: function () {

        $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
            .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });

        $("#txtEffectiveFromDate").datepicker().datepicker("setDate", new Date());

        //$('#txtEffectiveFromDate').change(function () {
        //    //- get date from another datepicker without language dependencies
        //    var minDate = $('#txtEffectiveFromDate').datepicker('getDate');
        //    $('#txtEffectiveTillDate').datepicker('option', 'minDate', new Date(minDate));
        //});
        //$('#txtEffectiveTillDate').change(function () {
        //    //- get date from another datepicker without language dependencies
        //    var maxDate = $('#txtEffectiveTillDate').datepicker('getDate');
        //    $('#txtEffectiveFromDate').datepicker('option', 'maxDate', new Date(maxDate));
        //});
    },

    ShowUploadImagePreview: function (id) {
        var InByte = (id.files[0].size);
        var InKByte = (InByte / 1024);
        var InMByte = (InKByte / 1024);

        $("#fuPreview").parent().show();
        $("#fuPreview").show();

        if (InMByte <= 1 && InMByte > 0)
            ShowUploadImagePreview(id, "#fuPreview");
        else {
            $("#fuLogo").val("");
            $("#fuPreview").parent().hide();
            $("#fuPreview").hide();
            toastr.error(Logosizeshouldnotbeexceed);
        }
    }
};