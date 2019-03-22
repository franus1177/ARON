var xhr_getData_For_EditCustomerContact;
var xhr_getData_For_deleteCustomerContact;
var xhr_GetDataCustomerContact;

var divAddUpdateCustomerContactID = "#frm_CustomerContact";

$(document).ready(function () {
    customerContact.AddEvents();
    customerContact.SetForAdd();
});

var customerContact = {
    xhr_GetData_UserRole: null,
    AddEvents: function () {
        $("#chkIsHasWebAccess").change(function () {

            if ($("#chkIsHasWebAccess").prop("checked")) {
                $("#divEndUserBlock").show();
                customerContact.SetForAdd();
                customerContact.HasWebAccessClearData();
            } else {
                $("#divEndUserBlock").hide();
            }
        });
    },

    BindGrid: function () {
        var hf_CustomerID = $("#hf_CustomerID").val();

        if (!$.isNumeric(hf_CustomerID))
            hf_CustomerID = 0;

        $('#tblCustomerHolidayGrid').on('draw.dt', function () { customerContact.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGrid(xhr_GetDataCustomerContact, "tblGridCustomerContact", "/CustomerContact/GetData", { CustomerID: hf_CustomerID }, function () {
            customerContact.ScreenAccessPermission();
            $('#tblGridCustomerContact,#tblGridCustomerContact thead tr th').removeAttr("style");
        });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAddCustomerContact", 'customerContact.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExportCustomerContact").show();

        if (!getAccess[0].HasDelete)
            $("#tblGridCustomerContact .DeleteColumn").addClass("hide").html("");

        setTimeout(function () { if (!(getAccess[0].HasUpdate)) { $("#tblGridCustomerContact tbody tr").each(function () { $(".HasUpdatetds a").removeAttr("href").removeAttr("title").removeAttr("style"); }); } }, 1000);
    },
    //screen access code end

    SetForAdd: function () {

        Reload_ddl_Global(customerContact.xhr_GetData_UserRole, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: null }, Resource.Select, function () {
            $("#ddlUserRole").val("Customer");
        });

        Reload_ddl_GlobalStatic("#ddlLanguageContact", ConfigurationData_LanguageList(), Resource.Select, function () {
            $("#ddlLanguageContact").html("<option value>" + Resource.Select + "</option>");
            $("#ddlLanguage option:selected").each(function (i, item) {
                $("#ddlLanguageContact").append("<option value='" + $(item).val() + "'>" + $(item).text() + "</option>");
            });
        });

        Reload_ddl_GlobalStatic("#ddlModuleContact", "Module", null,
            function () {
                $("#ddlModuleContact").html("");
                $("#ddlModule option:selected").each(function (i, item) {
                    $("#ddlModuleContact").append("<option value='" + $(item).val() + "'>" + $(item).text() + "</option>");
                });
                LoadChosen("#ddlModuleContact", true);
            });

        $("#hidePass,#hideConfPass").show();
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = customerContact.GetData();
        if (customerContact.ValidateData(FormData)) {

            $.ajax({
                type: "POST", cache: false, url: "/CustomerContact/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                customerContact.ClearData();
                                toastr.success(data.Message);
                                customerContact.BindGrid();
                            } else
                                toastr.error(data.Message);
                        }
                        else
                            toastr.error(data.Message);
                    }
                    else
                        toastr.error(data.Message);
                }
            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        customerContact.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();
        var CustomerID2 = _Id.split('_')[0];
        var ContactName2 = _Id.split('_')[1];

        xhr = $.ajax({
            url: "/CustomerContact/GetData", cache: false, data: { CustomerID: CustomerID2, ContactName: ContactName2, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var json = JSON.stringify(data.Data);
                    var json_data = eval(json);

                    $("#lblHeadingContact").html(Resource.Edit);
                    $("#txtContactName").val(json_data[0].ContactName);
                    $("#hf_ContactNameOld").val(json_data[0].ContactName);
                    $("#txtEmail").val(json_data[0].Email);
                    $("#txtTelephone").val(json_data[0].Telephone);
                    $("#txtMobile").val(json_data[0].Mobile);
                    $("#chkIsPrimaryContact").prop("checked", json_data[0].IsPrimaryContact);

                    //Customer User is login User then Bind his informations
                    if (json_data[0].UserID != null) {
                        $("#chkIsHasWebAccess").prop("checked", true);
                        //$("#hidePass,#hideConfPass").hide();
                        $(".lblPasswordRequired").hide();
                        $("#divEndUserBlock").show();

                        customerContact.AddEvents();

                        Reload_ddl_Global(xhr_GetData_UserRole, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: json_data[0].UserRoleUserList[0].UserRoleID }, Resource.Select, function () { });
                        Reload_ddl_GlobalStatic("#ddlLanguage", ConfigurationData_LanguageList(), Resource.Select, function () { $("#ddlLanguage").val(json_data[0].LanguageCode); });
                        $("#ddlUTCOffset").val(json_data[0].UTCOffset);
                        LoadChosen("#ddlUTCOffset", true);

                        $("#ddlModuleContact").html("");
                        $("#ddlModule option:selected").each(function (i, item) {
                            $("#ddlModuleContact").append("<option value='" + $(item).val() + "'>" + $(item).text() + "</option>");
                        });

                        SetValueToListBox("#ddlModuleContact", json_data[0].EndUserModuleList);
                        LoadChosen("#ddlModuleContact", true);
                        customerContact.bindDefaultModule(json_data[0].DefaultModuleCode);

                        $("#ddlLanguageContact").html("<option value>" + Resource.Select + "</option>");
                        $("#ddlLanguage option:selected").each(function (i, item) {
                            $("#ddlLanguageContact").append("<option value='" + $(item).val() + "'>" + $(item).text() + "</option>");
                        });
                        $("#ddlLanguageContact").val(json_data[0].LanguageCode);

                        var Value = json_data[0].Gender;
                        var $radios = $('input:radio[name=gender]');
                        if (Value == "Male")
                            $radios.filter('[value=Male]').prop('checked', true);
                        else
                            $radios.filter('[value=Female]').prop('checked', true);

                        $("#hf_ContactNameOld").attr("UserID", json_data[0].UserID);
                    }

                } else {
                    toastr.error(data.Message);
                    $("#hf_ContactNameOld").val("");//reset hidden field to zero
                }
            }
        });
    },

    ResetData: function () {
        var CustomerID = $("#hf_CustomerID").val();
        var ContactNameOld = $("#hf_ContactNameOld").val();

        if (ContactNameOld == "" || ContactNameOld == null || ContactNameOld == undefined)
            customerContact.ClearData();
        else
            customerContact.GetDataByID(xhr_getData_For_Edit, CustomerID + "_" + ContactNameOld);
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        if (FormData.CustomerID == undefined || FormData.CustomerID == "" || FormData.CustomerID == null || FormData.CustomerID == 0) {
            valid = false;
            toastr.error("Customer must added first");
        }

        valid = Validate_Control_NullBlank("#txtContactName", FormData.ContactName, Resource.Required, valid);
        valid = Validate_Control_Email("#txtEmail", FormData.Email, Resource.InvalidEmail, valid);

        if (FormData.IsWebAccess) {
            valid = Validate_Control_NullBlank("#txtEmail", FormData.Email, Resource.Required, valid);
            valid = Validate_Control_NullBlank("#ddlUserRole", FormData.UserRoleUser_TableTypeList[0].UserRoleID, Resource.Required, valid);
            valid = Validate_Control_NullBlank("#ddlLanguageContact", FormData.LanguageCode, Resource.Required, valid);
            valid = Validate_Control_NullBlank("#ddlUTCOffset", FormData.UTCOffset, Resource.Required, valid);
            valid = Validate_Control_NullBlank("#ddlModuleContact", FormData.EndUserModule_TableTypeList, Resource.Required, valid);
            valid = Validate_Control_NullBlank("#ddlDefaultModule", FormData.DefaultModuleCode, Resource.Required, valid);

            var flag = (FormData.ContactNameOld == 0 || FormData.ContactNameOld == null || FormData.ContactNameOld == "");
            var flag2 = (FormData.UserIdentity != null && FormData.UserIdentity != "");
            var flag3 = (FormData.ConfirmPassword != null && FormData.ConfirmPassword != "");

            if (flag || (flag2 || flag3)) {
                valid = Validate_Control_NullBlank("#txtPassword", FormData.UserIdentity, Resource.Required, valid);
                valid = Validate_Control_NullBlank("#txtConfirmPassword", FormData.ConfirmPassword, Resource.Required, valid);
                valid = Validate_Control_ComparePassword("#txtConfirmPassword", "#txtPassword", Resource.ConfirmPasswordMissMatch, valid);
            }

        }

        FocusOnError("#frm_CustomerContact", valid);
        return valid;
    },

    //Get form data
    GetData: function () {

        var Data = {
            CustomerID: $("#hf_CustomerID").val(),
            ContactNameOld: $("#hf_ContactNameOld").val().trim(),
            ContactName: $("#txtContactName").val().trim(),
            Email: $("#txtEmail").val().trim(),
            Telephone: $("#txtTelephone").val().trim(),
            Mobile: $("#txtMobile").val().trim(),
            IsPrimaryContact: $("#chkIsPrimaryContact").prop("checked"),
            IsWebAccess: $("#chkIsHasWebAccess").prop("checked"),
            CurrentScreenID: scrnID,
        };

        if (Data.IsWebAccess) {
            /*End User's columns*/

            Data["UserID"] = $("#hf_ContactNameOld").attr("UserID");
            Data["LanguageCode"] = $("#ddlLanguageContact").val();
            Data["UTCOffset"] = $("#ddlUTCOffset").val();
            Data["DefaultModuleCode"] = $("#ddlDefaultModule").val();
            Data["Gender"] = 'Male';//$('input:radio[name=gender]:checked').val();
            Data["UserIdentity"] = $("#txtPassword").val().trim();
            Data["ConfirmPassword"] = $("#txtConfirmPassword").val().trim();
            Data["EndUserModule_TableTypeList"] = GetValueToListBoxSelected("#ddlModuleContact", "ModuleCode");
            Data["UserRoleUser_TableTypeList"] = GetValueToListBoxSelected("#ddlUserRole", "UserRoleID");
        }

        return Data;
    },

    //Clear form data
    HasWebAccessClearData: function () {

        Reset_Form_Errors();
        $("#txtPassword").val("");
        $("#txtConfirmPassword").val("");
        $("#ddlUTCOffset").val("");
        $("#ddlDefaultModule").val("");
        $("#ddlDefaultModule option").html("");
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_CustomerContact");
        $("#lblHeadingContact").html(Resource.Add);
        $("#chkIsPrimaryContact").prop("checked", false);
        $("#chkIsHasWebAccess").prop("checked", false).change();
        $("input[autofocus]").focus();
    },

    SetForClose: function () {
        //$(divAddUpdateCustomerContactID).html('').hide();
        //$("#divGridCustomerContact").show();
    },

    Delete: function (_Id, ItemInfo) {
        var CustomerID2 = _Id.split('_')[0];
        var ContactName2 = _Id.split('_')[1];
        DeleteData(xhr_getData_For_deleteCustomerContact, "/CustomerContact/Delete", { CustomerID: CustomerID2, ContactName: ContactName2, CurrentScreenID: scrnID }, ItemInfo, function () { customerContact.BindGrid(); /*customerContact.ClearData();*/ /*customerContact.SetForClose();*/ });
        $("#hf_ContactNameOld").val("");
    },

    bindDefaultModule: function (DefaultModuleCode) {
        var items = GetValueToListBoxSelectedValueText("#ddlModuleContact");
        $("#ddlDefaultModule").html('');
        for (var i = 0; i < items.length; i++) {
            if (items[i].Value == DefaultModuleCode)
                items[i].Selected = true;
            if ($("ddlDefaultModule option[value='" + items[i].Value + "']").length === 0)
                $("#ddlDefaultModule").append("<option value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");
        }
    },

    CheckPassword: function () {
        var valid = true;
        valid = Validate_Control_ComparePassword("#txtConfirmPassword", "#txtPassword", ConfirmPasswordMissMatch, valid);
        if (valid)
            Reset_Form_Errors();
    }
};