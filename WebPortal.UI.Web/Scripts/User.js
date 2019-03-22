var xhr_getData_For_Delete;
var xhr_getData_For_Edit;
var xhr_GetData;
var xhr_GetData_UserRole;
var xhr_GetData_ModuleList;
var xhr_GetData_Language;
var xhr_GetData_DefaultModule;
var divAddUpdateID = "#Master_Form";
var OrgLevel = "Organization Level";
var xhr_GetData_Designation;
var xhr_GetData_Department;

$(document).ready(function () {
    user.BindGrid();

    BindAutoComplete("#txtUser", "/User/GetData", 1, "FirstName", "EndUserID");

    var selValue = $('input[name=UserType]:checked').val();

    FillStaticCustomer("#txtCustomerName", function () {
        $('#divUserType').hide();
        $('#rdcl').prop('checked', true)
    });

});

var user = {

    ActiveEvent: function () {
        AllowCharacterNumber("#txtUserName");

        $("#txtUserName").blur(function (e) {
            var str = $(this).val().trim();
            str = str.replace(" ", "");
            $(this).val(str);
        });
    },

    ShowUserTypeData: function () {

        if ($("#rdcl").prop("checked") == true) {

            $("#divCustomerName").show();
            $("#treeULList").html("");
            $("#txtCustomerName").val("");

            Clear_ddl_Global("#ddlModule", Resource.Select);
            LoadChosen("#ddlModule");
            Clear_ddl_Global("#ddlServiceLine", null);
            LoadChosen("#ddlServiceLine");

            BindAutoComplete("#txtCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID",
                function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#txtCustomerName").val() } },
                function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/

                    contractCustomerLocation.GetLocation("#locationTreeView", eval($("#txtCustomerName").attr("data-id")));
                    GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: eval($("#txtCustomerName").attr("data-id")) }, function (Model) {
                        Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                        $.each(Model, function (i, item) {//module loop
                            item.Text = item.ModuleName;
                        });
                        Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function () { LoadChosen("#ddlModule", true); });
                        Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function () { LoadChosen("#ddlServiceLine", true); });
                    }, null);

                }, function (event, ui) { });
            //contractCustomerLocation.BindStaticCustomer();

            $.ajax({
                url: "/User/GetUserLocationData", cache: false, data: { UserID: $("#hf_EndUserID").val(), IsChildResult: true },
                success: function (data) {
                    if (data != null && data.Status == "Success") {

                        var json = JSON.stringify(data.Data);
                        var json_data = eval(json);

                        var json_dataNoCustomer;
                        var json_dataCustomer;
                        var json_dataForCustomer = [];

                        var cust = 0;
                        var Nocust = 0;

                        var CustomerID = json_data[0].UserLocationLocationList;
                        var CustomerLevelUserLocationArr = [];

                        var ModuleListCustomerLevel = json_data[0].UserLocationModuleList;
                        var ModuleListCustomerLevelArr = [];
                        $.each(json_data, function (i, item) {
                            if (item.CustomerID == null)
                                Nocust = 1;
                            else
                                cust = 1;
                        });

                        if ((cust == 1 && Nocust == 1) || (cust == 1 && Nocust == 0)) {
                            $.each(json_data, function (i, item) {//module loop

                                json_dataForCustomer.push(item);
                                $('#rdcl').prop('checked', true)
                                $("#divCustomerName").show();

                                $.each(CustomerID, function (i, item) {//module loop
                                    if (item.CustomerID != null)
                                        CustomerLevelUserLocationArr.push(item);
                                });

                                $.each(ModuleListCustomerLevel, function (j, item1) {//module loop
                                    if (item1.CustomerID != null)
                                        ModuleListCustomerLevelArr.push(item1);
                                });

                            });

                            contractCustomerLocation.GetLocation("#locationTreeView", CustomerLevelUserLocationArr[0].CustomerID, true, json_data[0].UserLocationLocationList);

                            GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: CustomerLevelUserLocationArr[0].CustomerID }, function (Model) {
                                Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                                $.each(Model, function (i, item) {//module loop
                                    item.Text = item.ModuleName;
                                });
                                Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                    SetddlItem("#ddlModule", data.length, null);
                                    LoadChosen("#ddlModule");
                                    SetValueToListBox("#ddlModule", ModuleListCustomerLevelArr);
                                    $('#ddlModule').trigger('chosen:updated');
                                });
                            }, null);

                            Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                LoadChosen("#ddlServiceLine");
                                SetValueToListBox("#ddlServiceLine", json_data[0].UserLocationServiceLineList);
                                $('#ddlServiceLine').trigger('chosen:updated');
                            });

                            $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");

                            BindAutoComplete("#txtCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID",
                                function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#txtCustomerName").val() } },
                                function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
                                    GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: eval($("#txtCustomerName").attr("data-id")) }, function (Model) {
                                        Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");

                                        $.each(Model, function (i, item) {//module loop
                                            item.Text = item.ModuleName;
                                        });

                                        Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                            SetddlItem("#ddlModule", data.length, null);
                                            LoadChosen("#ddlModule");
                                            SetValueToListBox("#ddlModule", ModuleListCustomerLevelArr);
                                            $('#ddlModule').trigger('chosen:updated');
                                        });

                                        Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                            LoadChosen("#ddlServiceLine");
                                            SetValueToListBox("#ddlServiceLine", json_data[0].UserLocationServiceLineList);
                                            $('#ddlServiceLine').trigger('chosen:updated');
                                        });

                                        $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                                        contractCustomerLocation.GetLocation("#locationTreeView", eval($("#txtCustomerName").attr("data-id")), true, json_data[0].UserLocationLocationList);

                                    }, null);
                                }, function (event, ui) { });
                            $("#txtCustomerName").val(CustomerLevelUserLocationArr[0].CustomerName);
                            $("#txtCustomerName").attr("data-id", CustomerLevelUserLocationArr[0].CustomerID);
                            //BindAutoComplete("#txtCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID");

                            $("#txtUserName").prop('disabled', false); /*$("#hidePass,#hideConfPass").removeAttr("style");*/
                            $("#divTree").addClass("col-md-5").removeClass("col-md-4");
                        }
                    } else {
                        var id = $("#hf_EndUserID").val();
                        customer.AddEvents();
                        contractCustomerLocation.AddEvents(id);
                    }
                }
            });
        }
        else {
            $("#treeULList").html("");
            $("#txtCustomerName").val("").attr("data-id", null);
            $("#divCustomerName").hide();

            $.ajax({
                url: "/User/GetUserLocationData", cache: false, data: { UserID: $("#hf_EndUserID").val(), IsChildResult: true },
                success: function (data) {
                    if (data != null && data.Status == Resource.SuccessMessage) {

                        var json = JSON.stringify(data.Data);
                        var json_data = eval(json);

                        var json_dataNoCustomer;
                        var json_dataCustomer;
                        var json_dataForCustomer = [];

                        var cust = 0;
                        var Nocust = 0;

                        $.each(json_data, function (i, item) {
                            if (item.CustomerID == null)
                                Nocust = 1;
                            else
                                cust = 1;
                        });

                        if ((Nocust == 1 && cust == 1) || (Nocust == 1 && cust == 0)) {

                            $.each(json_data, function (i, item) {//module loop

                                if (item.CustomerID == null)
                                    $("#divCustomerName").hide();
                            });

                            json_dataNoCustomer = json_data[0];

                            var UserLocationLocationList;
                            UserLocationLocationList = json_dataNoCustomer.UserLocationLocationList;
                            var UserLocationLocationListArr = [];
                            $.each(UserLocationLocationList, function (i, item2) {//module loop
                                if (item2.CustomerID == null)
                                    //UserLocationLocationList = UserLocationLocationList[i];
                                    UserLocationLocationListArr.push(item2);
                            });

                            locations.GetLocation("#locationTreeView", UserLocationLocationListArr);

                            var UserLocationModuleList;
                            UserLocationModuleList = json_dataNoCustomer.UserLocationModuleList;

                            var UserLocationModuleListArr = [];
                            $.each(UserLocationModuleList, function (j, item1) {//module loop
                                if (item1.CustomerID == null)
                                    UserLocationModuleListArr.push(item1);
                                // UserLocationModuleListArr = UserLocationModuleListArr[j];
                            });

                            Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                SetddlItem("#ddlModule", data.length, null);
                                LoadChosen("#ddlModule");
                                SetValueToListBox("#ddlModule", UserLocationModuleListArr);
                                $('#ddlModule').trigger('chosen:updated');
                            });

                            var UserLocationServicelineList;
                            UserLocationServicelineList = json_dataNoCustomer.UserLocationServiceLineList;

                            var UserLocationServicelineListArr = [];
                            $.each(UserLocationServicelineList, function (k, item3) {//module loop
                                if (item3.CustomerID == null)
                                    UserLocationServicelineListArr.push(item3);
                            });

                            Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                LoadChosen("#ddlServiceLine");
                                SetValueToListBox("#ddlServiceLine", UserLocationServicelineListArr);
                                $('#ddlServiceLine').trigger('chosen:updated');
                            });

                            $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                            $("#txtUserName").prop('disabled', false);/* $("#hidePass,#hideConfPass").removeAttr("style"); */
                            $("#divTree").addClass("col-md-5").removeClass("col-md-4");
                        }
                        else {
                            var userid = $("#hf_EndUserID").val();
                            customer.AddEvents();
                            contractCustomerLocation.AddEvents(userid);
                        }
                    }
                    else {
                        var userid = $("#hf_EndUserID").val();
                        customer.AddEvents();
                        contractCustomerLocation.AddEvents(userid);
                    }
                }
            });
        }

    },

    BindCustomerGrid: function (_Id) {

        $.ajax({
            type: "POST", cache: false, url: "/User/GetCustomerData", data: { EndUserID: _Id, LocationID: null, CurrentLanguageCode: CurrentLang },
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var Model = eval(data.Data);
                    $("#tblAssignedCustomer tbody").html("");
                    $("#Grid_Data_Template_tblAssignedCustomer").tmpl(Model).appendTo("#tblAssignedCustomer tbody");
                    $("#divAssignedCustomer").show();
                }
                else {
                    $("#divAssignedCustomer").hide();
                    $("#tblAssignedCustomer tbody").html("");
                }
            },
            error: function (ex) {
                alert("Message: " + ex);
            }
        });
    },

    BindGrid: function () {

        $('#tblGrid').on('draw.dt', function () { user.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGridCustom(xhr_GetData, "tblGrid", "/User/GetData", { EndUserID: null, IsChildResult: false },
            function (Model) {
                Model = Merge2JsonObject(Model, ConfigurationData_LanguageList(), "LanguageName", "LanguageCode", "LanguageCode");
            },
            function () {
                user.ScreenAccessPermission();
                $('#tblGrid thead tr th,#tblGrid').removeAttr("style");
            });
    },

    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'user.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExport").removeAttr("style");

        if (!getAccess[0].HasDelete)
            $("#tblGrid .DeleteColumn").addClass("hide").html("");

        if (!getAccess[0].HasUpdate)
            $("#tblGrid .HasUpdatetds").removeAttr("onclick");

        if (getAccess.length > 1) {
            if (getAccess[1].ActionCode == "UserLocation")
                $("#tblGrid .UserLocationColumn").removeClass("hide");
        }
    },
    //screen access code end

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(divAddUpdateID, "/User/_partialAddUpdate", AddNewUser,
            function () {
                user.ClearData();
                $("#txtUserName").prop('disabled', false); /*$("#hidePass").removeAttr("style"); $("#hideConfPass").removeAttr("style");*/
                Reload_ddl_Global(xhr_GetData_UserRole, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: null }, Resource.Select, function () { });
                Reload_ddl_Global(xhr_GetData_Designation, "#ddlDesignation", "/AjaxCommonData/GetDesignation", { DesignationID: null }, Resource.Select, function () { });
                Reload_ddl_Global(xhr_GetData_Department, "#ddlDepartment", "/AjaxCommonData/GetDepartment", { DepartmentID: null, CurrentLanguageCode: CurrentLang }, Resource.Select, function () { });
                Reload_ddl_GlobalStatic("#ddlLanguage", ConfigurationData_LanguageList(), Resource.Select, function () { });
                Reload_ddl_GlobalStatic("#ddlModule", "ModuleAll", null, function () { LoadChosen("#ddlModule", true); });
                user.ActiveEvent();
                LoadChosen("#ddlUTCOffset");

                user.DesignationDepartmentShowHide();
            });
    },

    DesignationDepartmentShowHide: function () {

        var DevRespRequired = ConfigurationData_ConfigurationCodeList();
        var filteredArray = DevRespRequired.filter(el => el.ConfigurationCode === GlobaleIsDevRespRequired);
        if (filteredArray != "") {
            val = filteredArray[0].ConfigurationValue;
            if (val === 0) {
                $("#divDesignation").hide();
                $("#divDepartment").hide();
                $("#ddlDesignation").val("");
                $("#ddlDepartment").val("");
            }
            else {
                $("#divDesignation").show();
                $("#divDepartment").show();
            }
        }
    },

    CheckPassword: function () {
        var valid = true;
        valid = Validate_Control_ComparePassword("#txtConfirmPassword", "#txtPassword", ConfirmPasswordMissMatch, valid);
        if (valid)
            Reset_Form_Errors();
    },

    CheckEmail: function () {
        var valid = true;
        valid = Validate_Control_Email("#txtEmail", $("#txtEmail").val(), "Invalid Email", valid);
        if (valid)
            Reset_Form_Errors();
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = user.GetData();
        if (user.ValidateData(FormData)) {

            AddUpdateData("/User/AddUpdateData", FormData, function (data) {

                if (data != null) {
                    if (data.Status == 'Success') {
                        if (eval(data.Data) > 0) {
                            user.SetForClose();
                            user.BindGrid();
                        } else
                            toastr.error(data.Message);
                    }
                    else if ((data.Message.indexOf("EndUser_UK_LoginID") !== -1))
                        toastr.error(Resource.UserAlreadyExists);
                    else toastr.error(data.Message);
                }
                else
                    toastr.error(data.Message);

            }, function (data) {

                if ((data.Message.indexOf("_UK_") !== -1))
                    toastr.error("Message");

            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        user.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();

        xhr = $.ajax({
            url: "/User/GetData", cache: false, data: { EndUserID: _Id, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == 'Success') {
                    LoadAddUpdateView(divAddUpdateID, "/User/_partialAddUpdate", EditUser,
                        function () {
                            SetSelectedRow("#tblGrid", _Id);
                            $("#txtUserName").prop('disabled', true);
                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);
                            $("#hf_EndUserID").val(json_data[0].EndUserID);  //save id into Hidden field edit submit
                            $("#txtUserName").val(json_data[0].LoginID);
                            $("#txtFirstName").val(json_data[0].FirstName);
                            $("#txtMiddleName").val(json_data[0].MiddleName);
                            $("#txtLastName").val(json_data[0].LastName);
                            $("#txtEmail").val(json_data[0].EmailID);
                            Reload_ddl_Global(xhr_GetData_UserRole, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: json_data[0].UserRoleUserList[0].UserRoleID }, Resource.Select, function () { });

                            Reload_ddl_Global(xhr_GetData_Designation, "#ddlDesignation", "/AjaxCommonData/GetDesignation", { DesignationID: null }, Resource.Select, function () { $("#ddlDesignation").val(json_data[0].DesignationID) });
                            Reload_ddl_Global(xhr_GetData_Department, "#ddlDepartment", "/AjaxCommonData/GetDepartment", { DepartmentID: null, CurrentLanguageCode: CurrentLang }, Resource.Select, function () { $("#ddlDepartment").val(json_data[0].DepartmentID) });

                            Reload_ddl_GlobalStatic("#ddlLanguage", ConfigurationData_LanguageList(), Resource.Select, function () { $("#ddlLanguage").val(json_data[0].LanguageCode); });
                            $("#ddlUTCOffset").val(parseInt(json_data[0].UTCOffset));
                            LoadChosen("#ddlUTCOffset");

                            Reload_ddl_GlobalStatic("#ddlModule", "ModuleAll", null, function (data) {
                                LoadChosen("#ddlModule", true);
                                SetValueToListBox("#ddlModule", json_data[0].EndUserModuleList);
                                $('#ddlModule').trigger('chosen:updated');
                                user.bindDefaultModule(json_data[0].DefaultModuleCode);
                            });

                            var Value = json_data[0].Gender;

                            var $radios = $('input:radio[name=gender]');
                            if (Value == "Male")
                                $radios.filter('[value=Male]').prop('checked', true);
                            else
                                $radios.filter('[value=Female]').prop('checked', true);

                            /*$("#hidePass,#hideConfPass").attr("style", "display:none;");*/
                            $("#hidePass asterisk,#hideConfPass asterisk").remove();

                            user.ActiveEvent();
                            user.DesignationDepartmentShowHide();

                        });
                } else {
                    toastr.error(data.Message);
                    $("#hf_EndUserID").val("");//reset hidden field to zero
                }
            }
        });
    },

    ResetData: function () {
        var EndUserID = $("#hf_EndUserID").val();

        if (EndUserID == "" || EndUserID == null || EndUserID == 0)
            user.ClearData();
        else
            user.GetDataByID(xhr_getData_For_Edit, EndUserID);
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#txtUserName", FormData.LoginID, "Required", valid);
        valid = Validate_Control_NullBlank("#txtFirstName", FormData.FirstName, "Required", valid);
        valid = Validate_Control_NullBlank("#txtLastName", FormData.LastName, "Required", valid);
        valid = Validate_Control_NullBlank("#txtEmail", FormData.EmailID, "Required", valid);
        valid = Validate_Control_Email("#txtEmail", FormData.EmailID, "Invalid Email", valid);

        valid = Validate_Control_NullBlank("#ddlUserRole", FormData.UserRoleUser_TableTypeList[0].UserRoleID, "Required", valid);
        valid = Validate_Control_NullBlank("#ddlLanguage", FormData.LanguageCode, "Required", valid);
        valid = Validate_Control_NullBlank("#ddlUTCOffset", FormData.UTCOffset, "Required", valid);
        valid = Validate_Control_NullBlank("#ddlModule", FormData.EndUserModule_TableTypeList, "Required", valid);
        valid = Validate_Control_NullBlank("#ddlDefaultModule", FormData.DefaultModuleCode, "Required", valid);

        //valid = Validate_Control_NullBlank("#ddlDesignation", FormData.DesignationID, Resource.Required, valid);
        //valid = Validate_Control_NullBlank("#ddlDepartment", FormData.DepartmentID, Resource.Required, valid);

        var id = FormData.EndUserID;
        if (id == 0 || id == null || id == "" || id == undefined) {
            valid = Validate_Control_NullBlank("#txtPassword", FormData.UserIdentity, "Required", valid);
            valid = Validate_Control_NullBlank("#txtConfirmPassword", FormData.ConfirmPassword, "Required", valid);
            valid = Validate_Control_ComparePassword("#txtConfirmPassword", "#txtPassword", "Confirm Password miss match", valid);
        }

        FocusOnError("#frm_User", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {
            EndUserID: $("#hf_EndUserID").val(),
            LoginID: $("#txtUserName").val().trim(),
            FirstName: $("#txtFirstName").val().trim(),
            MiddleName: $("#txtMiddleName").val().trim(),
            LastName: $("#txtLastName").val().trim(),
            LanguageCode: $("#ddlLanguage").val(),
            UTCOffset: $("#ddlUTCOffset").val(),
            DefaultModuleCode: $("#ddlDefaultModule").val(),
            Gender: $('input:radio[name=gender]:checked').val(),
            EmailID: $("#txtEmail").val().trim(),
            DesignationID: $("#ddlDesignation").val(),
            DepartmentID: $("#ddlDepartment").val(),
            UserIdentity: $("#txtPassword").val().trim(),
            ConfirmPassword: $("#txtConfirmPassword").val().trim(),
            EndUserModule_TableTypeList: GetValueToListBoxSelected("#ddlModule", "ModuleCode"),
            UserRoleUser_TableTypeList: GetValueToListBoxSelected("#ddlUserRole", "UserRoleID"),
            CurrentScreenID: scrnID
        };
        return Data;
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(xhr_getData_For_Delete, "/User/Delete", { EndUserID: _id, CurrentScreenID: scrnID }, ItemInfo, function () { user.BindGrid(); user.ClearData(); user.SetForClose(); });
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_User");
        $('#ddlModule').val("").trigger("chosen:updated");
        Clear_ddl_Global("#ddlDefaultModule", '');
        $("#txtUserName").focus();
    },

    SetForClose: function () {
        $(divAddUpdateID).html('').hide();

    },

    bindDefaultModule: function (DefaultModuleCode) {
        var items = GetValueToListBoxSelectedValueText("#ddlModule");
        $("#ddlDefaultModule").html('');
        for (var i = 0; i < items.length; i++) {
            if (items[i].Value == DefaultModuleCode)
                items[i].Selected = true;
            if ($("ddlDefaultModule option[value='" + items[i].Value + "']").length === 0)
                $("#ddlDefaultModule").append("<option value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");
        }
    },

    ValidateUserLocationData: function (FormData) {
        var valid = true;
        return valid;
    },
    //Get form User Location
    GetDataUserLocation: function () {

        var Data = {
            UserID: $("#hf_EndUserID").val(),
            CustomerID: $("#txtCustomerName").attr("data-id"),
            CurrentScreenID: scrnID,
        };

        var ServiceLineList = GetValueToListBoxSelected("#ddlServiceLine", "ServiceLineCode");
        var ModuleList = GetValueToListBoxSelected("#ddlModule", "ModuleCode");

        /// Get all top level selected parent Location ids
        var inputarray = $("#treeULList li input[type=checkbox]:checked");
        var locationArr = [];
        $.each(inputarray, function (i, item) {
            var locationid = eval($(item).attr("locationid"));
            var parentlocationid = eval($(item).attr("parentlocationid"));
            var isParentChecked = $("#chk" + parentlocationid).prop("checked");
            if (!isParentChecked || !IsNotNull(isParentChecked))
                locationArr.push(locationid);
        });

        var UserLocation_TableTypeList = [];

        $.each(ModuleList, function (j, item1) {//module loop
            $.each(locationArr, function (i, item2) {
                if (item1.ModuleCode == "SF") {
                    $.each(ServiceLineList, function (k, item3) {
                        UserLocation_TableTypeList.push({ LocationID: item2, ModuleCode: item1.ModuleCode, ServiceLineCode: item3.ServiceLineCode });
                    });
                }
                else
                    UserLocation_TableTypeList.push({ LocationID: item2, ModuleCode: item1.ModuleCode, ServiceLineCode: null });
            });
        });

        Data["UserLocation_TableTypeList"] = UserLocation_TableTypeList;

        return Data;
    },

    AddUserLocation: function () {
        Reset_Form_Errors();
        var FormData = user.GetDataUserLocation();

        if (user.ValidateUserLocationData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/User/AddUserLocationData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                user.SetForClose();
                                toastr.success(data.Message);
                                user.BindGrid();
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

    ShowViewLoad: function () {
        var locationArr = [];
        $('input[type="checkbox"]').each(function () {
            var tr = $(this);
            if (tr.prop('checked') && !tr.parent().hasAttr('haschild'))
                locationArr.push(tr.attr('locationid'));
        });
        user.ViewLoad($("#hf_GlobalCustomerID").attr('data-id'), locationArr);
        $("#divViewLoad").modal("show");
    },

    ViewLoad: function (CustomerID, LocationArr) {

        var Model = {};
        Model["CustomerID"] = CustomerID;
        Model["ContractLocation_TableType"] = [];
        $.each(LocationArr, function (index, value) {
            Model["ContractLocation_TableType"].push({ 'LocationID': value, 'IsLocationScheduled': null });
        });


        $.ajax({
            url: "/User/GetViewLoadData", cache: false, data: { Model: Model }, dataType: "json", type: "POST",
            success: function (data) {
                var sum = 0;
                if (data.Data != null) {
                    for (var i = 0; i < data.Data.length; i++) {
                        sum = sum + data.Data[i].ObjectInstanceCount;
                    }

                    data.Data.push({ CategoryID: '', CategoryName: 'Total', ObjectInstanceCount: sum })

                    if (data != null && data.Status == Resource.SuccessMessage) {
                        $("#tblViewLoad tbody").html('');
                        $("#Grid_Data_Template_tblViewLoad").tmpl(data.Data).appendTo("#tblViewLoad tbody");
                    }
                }
            }
        });
    }
};

var customer = {
    OpenAddPopUp: function () {

        customer.AddEvents();

    },
    AddEvents: function () {

        $("#ddlModule").change(function (evt, params) {

            customer.EnabledDisabledServiceLine();
        });
    },

    EnabledDisabledServiceLine: function () {

        var Modules = $('#ddlModule').val();
        var isSafety = false;

        if (Modules != null) {
            $.each(Modules, function (i, item) {
                if (item == "SF")
                    isSafety = true;
            });
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
};

/*For User Location*/
var UserLocation = {
    xhr_getData_For_Edit: null,
    xhr_GetData: null,

    SetForUserLocation: function (xhr, _Id, UserName) {
        if (xhr && xhr.readystate != 4)
            xhr.abort();

        /*var UserRole;*/
        $.ajax({
            url: "/User/GetData", cache: false, data: { EndUserID: _Id, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == Resource.SuccessMessage) {
                    var json = JSON.stringify(data.Data);
                    var json_data = eval(json);
                    UserRole = json_data[0].UserRoleUserList[0].UserRoleID;
                    $('#tblGrid thead tr th').removeAttr("style");
                }
            }
        });

        xhr = $.ajax({
            url: "/User/GetUserLocationData", cache: false, async: true, data: { UserID: _Id, IsChildResult: true },
            success: function (data) {
                $('#tblGrid thead tr th').removeAttr("style");

                if (data.Data != undefined) {
                    var LoactionArrayForViewLoad = [];
                    LoadAddUpdateView(divAddUpdateID, "/User/_partialUserLocation", Resource.UserLocation,
                        function () {
                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);

                            //User Customer Grid 
                            user.BindCustomerGrid(_Id);

                            var json_dataNoCustomer;
                            var json_dataCustomer;
                            var json_dataForCustomer = [];

                            var cust = 0;
                            var Nocust = 0;
                            $.each(json_data, function (i, item) {//module loop
                                if (item.CustomerID == null)
                                    Nocust = 1;
                                else
                                    cust = 1;
                            });

                            if ((Nocust == 1 && cust == 0) || (Nocust == 1 && cust == 1)) {

                                $.each(json_data, function (i, item) {//module loop
                                    if (item.CustomerID == null)
                                        $("#divCustomerName").hide();
                                });

                                json_dataNoCustomer = json_data[0];
                                var UserLocationLocationList;
                                UserLocationLocationList = json_dataNoCustomer.UserLocationLocationList;
                                var UserLocationLocationListArr = [];
                                $.each(UserLocationLocationList, function (i, item2) {//module loop
                                    if (item2.CustomerID == null) {
                                        //UserLocationLocationList = UserLocationLocationList[i];
                                        UserLocationLocationListArr.push(item2);
                                    }
                                });
                                LoactionArrayForViewLoad = UserLocationLocationListArr;
                                locations.GetLocation("#locationTreeView", UserLocationLocationListArr);

                                var UserLocationModuleList;
                                UserLocationModuleList = json_dataNoCustomer.UserLocationModuleList;

                                var UserLocationModuleListArr = [];
                                $.each(UserLocationModuleList, function (j, item1) {//module loop
                                    if (item1.CustomerID == null)
                                        UserLocationModuleListArr.push(item1);
                                    // UserLocationModuleListArr = UserLocationModuleListArr[j];
                                });

                                Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                    SetddlItem("#ddlModule", data.length, null);
                                    LoadChosen("#ddlModule");
                                    SetValueToListBox("#ddlModule", UserLocationModuleListArr);
                                    $('#ddlModule').trigger('chosen:updated');
                                });

                                var UserLocationServicelineList;
                                UserLocationServicelineList = json_dataNoCustomer.UserLocationServiceLineList;

                                var UserLocationServicelineListArr = [];
                                $.each(UserLocationServicelineList, function (k, item3) {//module loop
                                    if (item3.CustomerID == null)
                                        UserLocationServicelineListArr.push(item3);
                                    //UserLocationServicelineListArr = UserLocationServicelineListArr[k];
                                });

                                Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                    LoadChosen("#ddlServiceLine");
                                    SetValueToListBox("#ddlServiceLine", UserLocationServicelineListArr);
                                    $('#ddlServiceLine').trigger('chosen:updated');
                                });

                                $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                            }
                            else if (Nocust == 0 && cust == 1) {

                                $.each(json_data, function (i, item) {//module loop
                                    json_dataForCustomer.push(item);
                                });

                                json_dataCustomer = json_data[0];
                                var UserLocationLocationList;

                                $('#rdcl').prop('checked', true)
                                $("#divCustomerName").show();

                                var CustomerID = json_data[0].UserLocationLocationList;
                                contractCustomerLocation.GetLocation("#locationTreeView", CustomerID[0].CustomerID, true, json_data[0].UserLocationLocationList);

                                GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: CustomerID[0].CustomerID }, function (Model) {
                                    Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                                    $.each(Model, function (i, item) {//module loop
                                        item.Text = item.ModuleName;
                                    });
                                    Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                        SetddlItem("#ddlModule", data.length, null);
                                        LoadChosen("#ddlModule");
                                        SetValueToListBox("#ddlModule", json_data[0].UserLocationModuleList);
                                        $('#ddlModule').trigger('chosen:updated');
                                    });
                                }, null);


                                Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                    LoadChosen("#ddlServiceLine");
                                    SetValueToListBox("#ddlServiceLine", json_data[0].UserLocationServiceLineList);
                                    $('#ddlServiceLine').trigger('chosen:updated');
                                });
                                $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");

                                BindAutoComplete("#txtCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID",
                                    function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#txtCustomerName").val() } },
                                    function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
                                        GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: eval($("#txtCustomerName").attr("data-id")) }, function (Model) {
                                            Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                                            $.each(Model, function (i, item) {//module loop
                                                item.Text = item.ModuleName;
                                            });
                                            Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                                                SetddlItem("#ddlModule", data.length, null);
                                                LoadChosen("#ddlModule");
                                                SetValueToListBox("#ddlModule", json_data[0].UserLocationModuleList);
                                                $('#ddlModule').trigger('chosen:updated');
                                            });

                                            Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                                                LoadChosen("#ddlServiceLine");
                                                SetValueToListBox("#ddlServiceLine", json_data[0].UserLocationServiceLineList);
                                                $('#ddlServiceLine').trigger('chosen:updated');
                                            });
                                            $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                                            contractCustomerLocation.GetLocation("#locationTreeView", eval($("#txtCustomerName").attr("data-id")), true, json_data[0].UserLocationLocationList);
                                        }, null);
                                    }, function (event, ui) { });
                                FillStaticCustomer("#txtCustomerName", function () {
                                    $('#divUserType').hide();
                                    $("#hf_EndUserID").val(_Id);
                                });

                                $("#txtCustomerName").val(CustomerID[0].CustomerName);
                                $("#txtCustomerName").attr("data-id", CustomerID[0].CustomerID);
                            }

                            $("#txtUserName").prop('disabled', false);
                            /*$("#hidePass,#hideConfPass").removeAttr("style");*/
                            $("#lblUser").text(UserName);
                            $("#divTree").addClass("col-md-5").removeClass("col-md-4");
                            $("#hf_EndUserID").val(_Id);

                            $('#tblGrid thead tr th').removeAttr("style");

                        });
                }
                else {
                    LoadAddUpdateView(divAddUpdateID, "/User/_partialUserLocation", Resource.UserLocation,
                        function () {
                            //contractCustomerLocation.BindStaticCustomer();
                            customer.AddEvents();
                            contractCustomerLocation.AddEvents(_Id);
                            $("#lblUser").text(UserName);
                            $("#hf_EndUserID").val(_Id);

                            //Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                            //    LoadChosen("#ddlServiceLine");
                            //    //SetValueToListBox("#ddlServiceLine", UserLocationServicelineListArr);
                            //    $('#ddlServiceLine').trigger('chosen:updated');
                            //});
                            //$('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");

                        });

                    $('#tblGrid thead tr th').removeAttr("style");
                }
            }
        });

        $('#tblGrid thead tr th').removeAttr("style");
    }
};

//For Organization Level User Location
var locations = {

    //Get Location
    GetLocation: function (divID, LocationID) {
        $("#treeULList").html("");
        $.ajax({
            url: "/User/_partialTreeView",
            contentType: 'application/html; charset=utf-8',
            type: 'GET',
            dataType: 'html',
            success: function (data) {
                $("#divGridLocation").html(data).show();
                locations.bindTree(divID, LocationID, true);
            },
            error: function (ex) { alert("Message: " + ex); }
        });
    },

    bindTree: function (divID, LocationID, isBase) {
        $.ajax({
            type: "GET",
            cache: false,
            url: "/Location/GetRootLocation",
            data: { LocationID: LocationID },
            success: function (data) {
                var Model = eval(data.Data);
                if (isBase)
                    locations.setLocationTree(divID, Model, LocationID);
                else
                    locations.setToSelectParentLocationTree(divID, Model);
            },
            error: function (ex) { alert("Message: " + ex); }
        });
    },

    //Set Location
    setLocationTree: function (divID, Model, LocationID) {

        $.each(Model, function (i, value) {
            var clsApply; var styleCls;
            if (value.HasChild) {
                clsApply = 'collapse'; styleCls = '';
            } else {
                clsApply = '';
                styleCls = "style=background-image:none;display:inline-block;width:15px;";
            }
            //$("#treeULList").append('<li>' +
            //                            '<div class="collapsible" onclick="locations.onDemandAjax(this)" data-loaded="false" id="divID' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' HasCustomers=' + value.HasCustomers + ' LocationName="' + value.text + '" HasChild="' + value.HasChild + '">' +
            //                            '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
            //                            '<span class="textcls">' +
            //                                '<a href="#">' + value.LocationName + '</a>' +
            //                            '</span></div>' +
            //                        '</li>');

            $("#treeULList").append('<li>' +
                '<div class="collapsible" onclick="contractCustomerLocation.onDemandAjax(this)" data-loaded="false" id="divID' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' HasCustomers=' + value.HasCustomers + ' HasChild=' + value.HasChild + ' LocationName="' + value.text + '">' +
                '<input type = "checkbox" id="chk' + value.LocationID + '" LocationID="' + value.LocationID + '" ParentLocationID="' + value.ParentLocationID + '">' +
                '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                '<span class="textcls">' + '<a href="#">' + value.LocationName + '</a>' + '</span></div>' + '</li>');
            //if (isEdit != undefined && isEdit) {
            //if (LocationID  !=   null)
            //{
            if (LocationID != null) {
                var Locations = [];
                if (LocationID.length == 1) {
                    //Locations.push(LocationID);
                    Locations = LocationID;

                    $.each(Locations, function (j, item5) {
                        if (item5.LocationID != null) {
                            if (value.LocationID == item5.LocationID) {
                                $("#chk" + value.LocationID).prop("checked", true);
                            }
                        }
                    });
                    contractCustomerLocation.onDemandAjax($("#divID" + value.LocationID), true, Locations);
                }
                else {
                    //Locations = LocationID;
                }

            }
            //}

            //}
        });
    },

    onDemandAjax: function (xhr) {
        var data = {
            LocationID: $(xhr).attr('LocationID'),
            ParentLocationID: $(xhr).attr('ParentLocationID'),
            LocationName: $(xhr).attr('LocationName'),
            HasCustomers: $(xhr).attr('HasCustomers'),
            HasChild: $(xhr).attr('HasChild')
        }
        locations.fireOnNodeSelect(data)

        var this1 = $(xhr);
        var isLoaded = $(xhr).attr('data-loaded');
        if (isLoaded == "false") {
            $(this1).children('span.symbolcls').addClass('loadingP');
            $(this1).children('span.symbolcls').removeClass('collapse');
            // Load data here 
            $.ajax({
                url: "/Location/GetChildLocation",
                type: "POST",
                data: { Model: data },
                dataType: "json",
                success: function (d) {
                    $(this1).children('span.symbolcls').removeClass('loadingP');
                    locations.removeaddclass(this1);
                    if (d.Data.length > 0) {
                        var $ul = $('<ul></ul>');
                        $.each(d.Data, function (i, ele) {
                            var clsApply; var styleCls;
                            if (ele.HasChild) {
                                clsApply = 'collapse'; styleCls = '';
                            } else {
                                clsApply = '';
                                styleCls = "style=background-image:none;display:inline-block;width:15px;";
                            }
                            $ul.append(
                                $("<li></li>").append(
                                    '<div class="collapsible" onclick="locations.onDemandAjax(this)" data-loaded="false" id="divID' + ele.LocationID + '" LocationID=' + ele.LocationID + ' ParentLocationID=' + ele.ParentLocationID + ' HasCustomers=' + ele.HasCustomers + ' LocationName="' + ele.text + '" HasChild="' + ele.HasChild + '">' +
                                    '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                                    '<span class="textcls">' +
                                    '<a href="#">' + ele.LocationName + '</a>' +
                                    '</span></div>'
                                )
                            )
                        });
                        $(this1).parent().append($ul);
                        $(this1).children('span.symbolcls').addClass('collapse');
                        $(this1).children('span.symbolcls').toggleClass("collapse expand");
                        $(this1).closest('li').children('ul').slideDown();
                    }
                    else {
                        // no sub item found
                        $(this1).children('span.symbolcls').css({ 'display': 'inline-block', 'width': '15px' });
                    }
                    $(this1).attr('data-loaded', true);
                },
                error: function () {
                    alert("Error loading...");
                }
            })
        }
        else {
            $(xhr).children('span.symbolcls').toggleClass("collapse expand");
            $(xhr).closest('li').children('ul').slideToggle();
            locations.removeaddclass(this1)
        }
    },

    removeaddclass: function (this1) {
        $("#treeULList div.collapsible").removeClass("markselected");
        $(this1).addClass("markselected");
    },

    //Set Parent Location
    setToSelectParentLocationTree: function (divID, Model) {
        $("#treeParentULList").html('');
        $.each(Model, function (i, value) {
            var clsApply; var styleCls; var disClass;
            if (value.HasChild) {
                clsApply = 'collapse'; styleCls = '';
            } else {
                clsApply = '';
                styleCls = "style=background-image:none;display:inline-block;width:15px;";
            }
            if (value.LocationID === selectedLocationID || value.HasCustomers)
                disClass = "hideShow";
            else
                disClass = "";

            $("#treeParentULList").append('<li>' +
                '<div class="collapsible" onclick="locations.onDemandAjaxParent(this)" data-loaded="false" id="divIDParent' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' HasCustomers=' + value.HasCustomers + ' LocationName="' + value.text + '">' +
                '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                '<span class="textcls">' +
                '<a href="#" class="' + disClass + '">' + value.LocationName + '</a>' +
                '</span></div>' +
                '</li>');
        });
    },

    onDemandAjaxParent: function (xhr) {
        if (!($(xhr).find("a").hasClass("hideShow"))) {
            $("#btnParentLocationIDPopup").removeAttr("style");

            tempParentLocationID = eval($(xhr).attr('LocationID'));
            tempLocationText = $(xhr).attr('LocationName');
            var data = {
                LocationID: tempParentLocationID,
            }

            var this1 = $(xhr);
            var isLoaded = $(xhr).attr('data-loaded');
            if (isLoaded == "false") {
                $(this1).children('span.symbolcls').addClass('loadingP');
                $(this1).children('span.symbolcls').removeClass('collapse');
                // Load data here 
                $.ajax({
                    url: "/Location/GetChildLocation",
                    type: "POST",
                    data: { Model: data },
                    dataType: "json",
                    success: function (d) {
                        $(this1).children('span.symbolcls').removeClass('loadingP');
                        locations.removeaddclassParent(this1);
                        if (d.Data.length > 0) {
                            var $ul = $('<ul></ul>');
                            $.each(d.Data, function (i, ele) {
                                var clsApply; var styleCls; var disClass;
                                if (ele.HasChild) {
                                    clsApply = 'collapse'; styleCls = '';
                                } else {
                                    clsApply = '';
                                    styleCls = "style=background-image:none;display:inline-block;width:15px;";
                                }
                                if (ele.LocationID === selectedLocationID || ele.HasCustomers)
                                    disClass = "hideShow";
                                else
                                    disClass = "";

                                $ul.append(
                                    $("<li></li>").append(
                                        '<div class="collapsible" onclick="locations.onDemandAjaxParent(this)" data-loaded="false" id="divIDParent' + ele.LocationID + '" LocationID=' + ele.LocationID + ' ParentLocationID=' + ele.ParentLocationID + ' HasCustomers=' + ele.HasCustomers + ' LocationName="' + ele.text + '">' +
                                        '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                                        '<span class="textcls">' +
                                        '<a href="#" class="' + disClass + '">' + ele.LocationName + '</a>' +
                                        '</span></div>'
                                    )
                                )
                            });
                            $(this1).parent().append($ul);
                            $(this1).children('span.symbolcls').addClass('collapse');
                            $(this1).children('span.symbolcls').toggleClass("collapse expand");
                            $(this1).closest('li').children('ul').slideDown();
                        }
                        else {
                            // no sub item found
                            $(this1).children('span.symbolcls').css({ 'display': 'inline-block', 'width': '15px' });
                        }
                        $(this1).attr('data-loaded', true);
                    },
                    error: function () {
                        alert("Error loading...");
                    }
                })
            }
            else {
                $(xhr).children('span.symbolcls').toggleClass("collapse expand");
                $(xhr).closest('li').children('ul').slideToggle();
                locations.removeaddclassParent(this1)
            }
        }
    },

    removeaddclassParent: function (this1) {
        $("#treeParentULList div.collapsible").removeClass("markselected");
        $(this1).addClass("markselected");
    },

    fireOnNodeSelect: function (data) {
        // Selected
        selectedLocationID = eval(data.LocationID);
        selectedLocationText = data.LocationName;
        selectedParentLocationID = eval(data.ParentLocationID);
        hasCustomers = eval(data.HasCustomers);
        hasChild = eval(data.HasChild);
        if (hasCustomers) {
            $("#divAdd i").addClass("hideShow");

            $("#divCustomer i").removeClass("hideShow");
        }
        else {
            $("#divAdd i").removeClass("hideShow");

            $("#divCustomer i").addClass("hideShow");
        }

        if (selectedLocationID > 0) {
            $("#divEdit i,#divDelete i").removeClass("hideShow");
            locations.SetForClose();
        } else
            $("#divEdit i,#divDelete i").addClass("hideShow");
    },

    setValues: function () {
        $("#hf_LocationID").val("");
        $("#hf_ParentLocationID").val(selectedLocationID);
        $("#btnChangeParentLocation").remove("a"); //$("#btnChangeParentLocation").css("display", "none");
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = locations.GetData();
        if (locations.ValidateData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/Location/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                locations.SetForClose();
                                toastr.success(data.Message);
                                locations.GetLocation("#locationTreeView", locationID);
                                selectedLocationID = null;
                            } else
                                toastr.error(data.Message);
                        } else if (data.Message.toString().indexOf("Location_UK_ParentLocationID_LocationName") >= 0) {
                            toastr.warning(LocationNameExist);
                        }
                    }
                },
                error: function (data) {
                }
            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr) {
        if (!($("#divEdit i").hasClass("hideShow"))) {
            Reset_Form_Errors();
            locations.ClearData();
            if (selectedLocationID > 0) {
                if (xhr && xhr.readystate != 4)
                    xhr.abort();

                xhr = $.ajax({
                    url: "/Location/GetDataByID", cache: false, data: { LocationID: selectedLocationID, HasCustomers: hasCustomers },
                    success: function (data) {
                        if (data != null && data.Status == "Success") {
                            LoadAddUpdateView(divAddUpdateID, "/Location/_partialAddUpdate", EditLocation,
                                function () {
                                    isEdit = true;
                                    var json_data = eval(data.Data);
                                    if (json_data.length > 0) {
                                        locations.getExpandedParentNodes(false);
                                        $("#hf_LocationID").val(json_data[0].LocationID);  //save id into Hidden field edit submit
                                        $("#hf_ParentLocationID").val(json_data[0].ParentLocationID);
                                        $("#txtLocationName").val(json_data[0].LocationName).focus();
                                        $("#txtLatitude").val(json_data[0].Latitude);
                                        $("#txtLongitude").val(json_data[0].Longitude);
                                        $("#txtRemark").val(json_data[0].Remarks);
                                        $("#chkCustomer").prop('checked', json_data[0].HasCustomers);
                                        if (eval(json_data[0].CustomerCount) > 0) {
                                            $("#chkCustomer").prop('disabled', true);
                                            $("#chkCustomer").attr('title', hasCustomerTooltipMessage);
                                            $("#chkCustomer").removeAttr('style').parent().removeAttr('style');
                                        } else if (hasChild) {
                                            $("#chkCustomer").prop('disabled', true);
                                            $("#chkCustomer").removeAttr('style').parent().removeAttr('style');
                                        } else {
                                            $("#chkCustomer").prop('disabled', false);
                                            $("#chkCustomer").removeAttr('title');
                                        }
                                        if (json_data[0].ParentLocationID > 0 && json_data[0].ParentLocationID !== null)
                                            locations.getParentButton();
                                        else
                                            $("#btnChangeParentLocation").remove("a");
                                    } else {
                                        toastr.error(NorecordsavailableMessage);
                                        locations.SetForClose();
                                    }
                                });
                        } else {
                            toastr.error(data.Message);
                            $("#hf_LocationID").val("");       //reset hidden field to zero
                        }
                    }
                });
            }
        }
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;
        //var FormData = locations.GetData();

        valid = Validate_Control_NullBlank("#txtLocationName", FormData.LocationName, "", valid);

        FocusOnError("#frm_Location", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {};
        Data["LocationID"] = $("#hf_LocationID").val();
        Data["LocationName"] = $("#txtLocationName").val().trim();
        Data["ParentLocationID"] = $("#hf_ParentLocationID").val().trim();
        Data["HasCustomers"] = $("#chkCustomer").is(":checked");
        Data["Longitude"] = $("#txtLongitude").val().trim();
        Data["Latitude"] = $("#txtLatitude").val().trim();
        Data["Remarks"] = $("#txtRemark").val().trim();
        Data["CurrentScreenID"] = scrnID;
        //return Data;

        var inputarray = $("#treeULList li input[type=checkbox]:checked");
        var locationArr = [];
        $.each(inputarray, function (i, item) {
            var locationid = eval($(item).attr("locationid"));
            var parentlocationid = eval($(item).attr("parentlocationid"));
            var isParentChecked = $("#chk" + parentlocationid).prop("checked");
            if (!isParentChecked || !IsNotNull(isParentChecked))
                locationArr.push({ LocationID: locationid });
        });

        Data["ContractLocation_TableTypeList"] = locationArr;
        return Data;

    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Location");
        $("#chkCustomer").prop("checked", false);
        $("#txtLocationName").focus();
    },

    getParentButton: function () {
        $("#divExpandedParent").append('<a id="btnChangeParentLocation" style="margin-top: 5px;" onclick="locations.ShowParentTree();" title="' + ChangeParentLocationText + '" class="label label-lg label-pink pull-left">Change</a>&nbsp;');
    },

    refreshTreeView: function () {
        $("div.collapsible").removeClass("markselected");
        selectedLocationID = null;
        selectedParentLocationID = null;
        selectedLocationText = null;
        hasCustomers = null;
        $("#divEdit i,#divDelete i").addClass("hideShow");
        $("#divAdd i").removeClass("hideShow");
        locations.SetForClose();
        locations.GetLocation("#locationTreeView", locationID);
    },

    getExpandedParentNodes: function (isEditParent) {
        $("#divExpandedParent").html("");
        if (selectedLocationID > 0) {
            var parentText;
            if (!isEditParent)
                parentText = locations.getParentNodes().reverse();
            else
                parentText = locations.getParentNodesPopUp(isEditParent).reverse();

            $.each(parentText, function (i, item) {
                $("#divExpandedParent").append('<span style="margin-top: 5px;" class="label label-lg label-yellow arrowed-right">' + item + '</span>&nbsp;');
            });
        }
    },

    getParentNodes: function () {
        locationArr = [];
        if (selectedLocationID > 0) {
            if (!isEdit)
                if (selectedLocationText !== null)
                    locationArr.push(selectedLocationText);
            var parentid = $("#divID" + selectedLocationID).attr("parentlocationid");
            locations.getparentText(parentid);
        }
        return locationArr;
    },

    getparentText: function (parentid) {
        if (parentid !== undefined && parentid !== null && parentid !== "null" && parentid !== "") {
            var text = $("#divID" + parentid).attr("LocationName");
            locationArr.push(text);
            var parentid = $("#divID" + parentid).attr("parentlocationid");
            locations.getparentText(parentid);
        }
    },

    getParentNodesPopUp: function (isEditParent) {
        locationArr = [];
        if (selectedParentLocationID > 0) {
            if (isEditParent)
                locationArr.push(tempLocationText);
            var parentid = $("#divIDParent" + selectedParentLocationID).attr("parentlocationid");
            locations.getparentTextPopUp(parentid);
        }
        return locationArr;
    },

    getparentTextPopUp: function (parentid) {
        if (parentid !== undefined && parentid !== null && parentid !== "null" && parentid !== "") {
            var text = $("#divIDParent" + parentid).attr("LocationName");
            locationArr.push(text);
            var parentid = $("#divIDParent" + parentid).attr("parentlocationid");
            locations.getparentTextPopUp(parentid);
        }
    },

    ShowParentTree: function () {
        $("#locationTreePopup").modal("show");
        locations.bindTree("#locationTreeViewPopup", null, false);
        $("#btnParentLocationIDPopup").css("display", "none");
    },
};

//For Customer Level User Location
var contractCustomerLocation = {
    xhr_getData_For_Edit: null,
    xhr_GetData: null,
    xhr_getData_For_delete: null,
    divAddUpdateID: "#Master_Form",

    selectedLocationID: null,
    selectedLocationText: null,
    tempLocationText: null,
    selectedParentLocationID: null,
    tempParentLocationID: null,
    hasCustomers: null,
    isEdit: false,
    locationArr: [],

    xhr_GetFrequency: null,
    xhr_GetData_Duration: null,
    xhr_GetData_Location: null,

    BindStaticCustomer: function () {

        FillStaticCustomer("#txtCustomerName", function () {

            contractCustomerLocation.GetLocation("#locationTreeView", eval($("#txtCustomerName").attr("data-id")));

            GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: eval($("#txtCustomerName").attr("data-id")) }, function (Model) {
                Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                $.each(Model, function (i, item) {//module loop
                    item.Text = item.ModuleName;
                });
                Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function () { LoadChosen("#ddlModule", true); });
                Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) { LoadChosen("#ddlServiceLine"); });
                $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
                $('#divUserType').hide();
            }, null);
        });
    },

    AddEvents: function (ID) {
        var selValue = $('input[name=UserType]:checked').val();
        if (selValue == Resource.CustomerLevel) {
            //if ($(".ddlUserType").val() == 'Customer Level') {
            $("#divCustomerName").show();
            $("#treeULList").html("");
            $("#txtCustomerName").val("").focus();
            $("#ddlModule").empty();
            BindAutoComplete("#txtCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID",
                function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#txtCustomerName").val() } },
                function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
                    contractCustomerLocation.GetLocation("#locationTreeView", eval($("#txtCustomerName").attr("data-id")));

                    GetAjaxData("/AjaxCommonData/GetModuleList", { CustomerID: eval($("#txtCustomerName").attr("data-id")) }, function (Model) {
                        Model = Merge2JsonObject(Model.Data, ConfigurationData_ModuleList(), "ModuleName", "ModuleCode", "ModuleCode");
                        $.each(Model, function (i, item) {//module loop
                            item.Text = item.ModuleName;
                        });
                        Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function () { LoadChosen("#ddlModule", true); });
                        Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) { LoadChosen("#ddlServiceLine"); });
                        $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");

                    }, null);

                }, function (event, ui) { });
            contractCustomerLocation.BindStaticCustomer();
        }
        else
            if (selValue == OrgLevel) {
                $("#divCustomerName").hide();

                Reload_ddl_GlobalStatic("#ddlModule", "Module", null, function (data) {
                    SetddlItem("#ddlModule", data.length, null);
                    LoadChosen("#ddlModule");
                    //$('#ddlModule').trigger('chosen:updated');
                });

                Reload_ddl_GlobalStatic("#ddlServiceLine", "ServiceLine", null, function (data) {
                    SetddlItem("#ddlServiceLine", data.length, null);
                    LoadChosen("#ddlServiceLine");
                    //$('#ddlServiceLine').trigger('chosen:updated');
                });
                $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");

                locations.GetLocation("#locationTreeView", locationID);
            }
    },

    EnableDisabled: function (id) {
        var CategoryID = $(id).attr("data-id");
        $("#ddlFrequency" + CategoryID).val("");
        $("#ddlServiceLevel" + CategoryID).val("");
        $("#ddlFrequency" + CategoryID).addClass('disabled').prop("disabled", true);
        if ($(id).prop("checked")) {
            contractCustomerLocation.GetFrequencyData(CategoryID);
            //$("#ddlFrequency" + CategoryID).removeClass('disabled').prop("disabled", false);
            $("#ddlServiceLevel" + CategoryID).removeClass('disabled').prop("disabled", false);
        } else {
            $("#ddlServiceLevel" + CategoryID).addClass('disabled').prop("disabled", true);
        }
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = contractCustomerLocation.GetData();

        if (contractCustomerLocation.ValidateData(FormData)) {

            AddUpdateData("/Safety/Contract/AddUpdateData", { Model: FormData }, function () {
                contractCustomerLocation.ClearData();

            }, function (responce_data) {//Handle Error Block
                var valid = true;

                if (responce_data.Message.toString().indexOf("_UK_") >= 0) {
                    valid = false;
                    toastr.warning(ContractCustomerErrorMessage);
                }

                if (responce_data.Message.toString().indexOf("_PK_") >= 0) {
                    valid = false;
                    toastr.warning(ContractCustomerErrorMessage);
                }
            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        contractCustomerLocation.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();

        xhr = $.ajax({
            url: "/Safety/Contract/GetData", cache: false, data: { ContractID: _Id, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {
                    LoadAddUpdateView(contractCustomerLocation.divAddUpdateID, "/Safety/Contract/_partialAddUpdate", Resource.Edit,
                        function () {
                            $("#divGridContract,#divExport,#divAdd").hide();
                            Reload_ddl_GlobalStatic('#ddlInspectionType', "InspectionType", Resource.Select, null);
                            $("#ddlInspectionType option[value='Resolution']").remove();

                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);

                            $("#hf_ContractID").val(json_data[0].ContractID);  //save id into Hidden field edit submit
                            $("#txtCustomerName").val(json_data[0].CustomerName).prop("disabled", true);
                            $("#txtCustomerName").attr("data-id", json_data[0].CustomerID);
                            $("#txtContractRefNo").val(json_data[0].SourceRefID);
                            $("#txtContractDate").val(json_data[0].ContractDateCustom);
                            $("#txtFromDate").val(json_data[0].ContractStartDateCustom);
                            $("#txtRemark").val(json_data[0].Remarks);
                            $("#ddlInspectionType").val(json_data[0].InspectionType);
                            $("#ddlDuration").val(json_data[0].ContractDuration);
                            $("#divLoadCategory").remove();
                            $("#divTree").addClass("col-md-5").removeClass("col-md-4");

                            Reload_ddl_Global(contractCustomerLocation.xhr_GetData_Duration, "#ddlDuration", "/AjaxCommonData/GetDurationList", {}, null, function () {
                                $("#ddlDuration").val(json_data[0].ContractDuration);

                                contractCustomerLocation.GetLocation("#locationTreeView", json_data[0].CustomerID, true, json_data[0].ContractLocationList);
                                $("#divContractCategory").show();

                                contractCustomerLocation.showCategoryGrid(function () {

                                    $.each(json_data[0].ContractCategoryList, function (index, item) {

                                        $("#tblContractCategory tbody tr").each(function () {
                                            var CategoryID = parseInt(eval($(this).attr("data-id")));

                                            if (parseInt(item.CategoryID) === CategoryID) {

                                                $(this).find("td:first input:checkbox").prop('checked', true);
                                                var ddlServiceLevel = $("#ddlServiceLevel" + CategoryID);
                                                var ddlFrequency = $("#ddlFrequency" + CategoryID);

                                                //$("#radServiceLevel" + CategoryID + "," + "#radFrequency" + CategoryID).prop('disabled', false);
                                                ddlServiceLevel.prop('disabled', false);
                                                ddlFrequency.prop('disabled', true).attr('disabled');

                                                ddlFrequency.attr("Frequency", item.Frequency).prop('disabled', true);
                                                ddlFrequency.val(item.Frequency);
                                                ddlFrequency.prop('disabled', true);

                                                if (item.ServiceLevelID > 0) {
                                                    ddlServiceLevel.val(item.ServiceLevelID);//.prop('disabled',false);
                                                    //$("#radServiceLevel" + CategoryID).prop("checked", true);
                                                    //$("#ddlServiceLevel" + CategoryID).removeAttr('disabled');
                                                } else {
                                                    //$("#ddlFrequency" + CategoryID).prop('disabled', false);
                                                    //$("#radFrequency" + CategoryID).prop("checked", true);
                                                    //$("#ddlFrequency" + CategoryID).val(item.Frequency);
                                                    var visits = GetNoOfVisits($("#txtFromDate").val(), parseInt($("#ddlDuration").val()), $(this).find("td select#ddlFrequency" + CategoryID + "").val());
                                                    $(this).find("#lblNoOfVisit").html("").html(visits);
                                                }
                                            }

                                            $(ddlServiceLevel).change(function () {
                                                contractCustomerLocation.GetFrequencyData($(this).val());
                                            });
                                        });

                                        contractCustomerLocation.selectDurationCategory();
                                    });
                                });

                                contractCustomerLocation.AddEvents(_Id);
                            });
                        });
                } else {
                    toastr.error(data.Message);
                    $("#hf_CustomerID").val("");//reset hidden field to zero
                }
            }
        });
    },

    ShowSerLev: function (CategoryID, Item) {

        if (Item == "SerLev") {
            $("#ddlFrequency" + CategoryID).attr('disabled', 'disabled');
            $("#ddlServiceLevel" + CategoryID).removeAttr('disabled');
            $("select#ddlFrequency" + CategoryID)[0].selectedIndex = 0;
            $(this).parent().parent().parent().find("#lblNoOfVisit").html("");
        }
        else {
            $("#ddlServiceLevel" + CategoryID).attr('disabled', 'disabled');
            //$("#ddlFrequency" + CategoryID).removeAttr('disabled');
            $("select#ddlServiceLevel" + CategoryID)[0].selectedIndex = 0;

            //var visits = GetNoOfVisits($("#txtFromDate").val(), parseInt($("#ddlDuration").val()), $(this).find("td select#ddlFrequency" + CategoryID + "").val());
            //$(this).find("#lblNoOfVisit").html("");
        }
    },

    GetFrequencyData: function (CategoryId) {

        var ServiceLevelID = $("#ddlServiceLevel" + CategoryId).val();
        var IsCustomerSpecific = false;

        if (ServiceLevelID == "" || ServiceLevelID == null || ServiceLevelID == undefined)
            IsCustomerSpecific = true;

        GetAjaxData("/Safety/Contract/GetCustomerSpecificChecklist", {
            CustomerID: $("#txtCustomerName").attr("data-id"), InspectionType: $("#ddlInspectionType").val(),
            ContractID: $().val(), CategoryID: CategoryId,
            ServiceLevelID: ServiceLevelID,
            IsCustomerSpecific: IsCustomerSpecific,
            CurrentLanguageCode: CurrentLang
        }, function (data) {
            var val = data.Data;
            $("#ddlFrequency" + CategoryId).val(val);
            $("#ddlFrequency" + CategoryId).change();//to show counts

        }, function (errorData) { });
    },

    //Validate form data
    ValidateData: function (FormData, callback) {
        var valid = true;
        valid = Validate_Control_NullBlank("#txtCustomerName", FormData.CustomerName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtFromDate", FormData.ContractStartDate, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtContractDate", FormData.ContractDate, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlDuration", FormData.ContractDuration, Resource.Required, valid);

        if (callback == null)
            if (FormData.ContractLocation_TableTypeList.length == 0 || FormData.ContractLocation_TableTypeList.length == undefined) {
                valid = false;
                Validate_Alert("#treeULList", "", valid);
                toastr.warning(LocationisRequired);
            }

        valid = Validate_Control_NullBlank("#ddlInspectionType", FormData.InspectionType, Resource.Required, valid);

        var Check = false;
        var cnt = 0;
        $("#tblContractCategory tbody tr").each(function () {
            var CategoryID, Frequency, ServiceLevel;

            if ($(this).find("td:first input:checkbox").is(":checked")) {
                cnt++;
                CategoryID = eval($(this).attr("data-id"));
                Frequency = $(this).find("td select#ddlFrequency" + CategoryID).val();
                ServiceLevel = $(this).find("td select#ddlServiceLevel" + CategoryID).val();

                if (Frequency == "" || Frequency == null /*|| (Frequency != "" && ServiceLevel != "")*/) {
                    valid = Validate_Control_NullBlank($(this).find("td select#ddlFrequency" + CategoryID), Frequency, Resource.Required, valid);
                    //valid = Validate_Control_NullBlank($(this).find("td select#ddlServiceLevel" + CategoryID), $(this).find("td select#ddlServiceLevel" + CategoryID).val(), Resource.Required, valid);
                    Check = true;
                    valid = false;
                }
            }
        });

        if (callback === undefined && cnt == 0)
            toastr.error(Resource.SelectatleastoneCategory);

        if (Check)
            toastr.warning(Resource.FrequencyisRequired);

        FocusOnError("#frm_Contract", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {
            ContractID: $("#hf_ContractID").val(),
            CustomerID: $("#txtCustomerName").data("id"),
            CustomerName: $("#txtCustomerName").val().trim(),
            ContractDate: $("#txtContractDate").val().trim(),
            ContractStartDate: $("#txtFromDate").val().trim(),
            ContractDuration: $("#ddlDuration").val(),
            SourceRefID: $("#txtContractRefNo").val(),
            Location: $("#ddlLocation").val(),
            Remarks: $("#txtRemark").val(),
            InspectionType: $("#ddlInspectionType").val(),
            CurrentScreenID: scrnID,
        };

        var ContractCategory_TableTypeList = [];

        $("#tblContractCategory tbody tr").each(function () {
            if ($(this).find("td:first input:checkbox").is(":checked")) {
                var CategoryID = $(this).attr("data-id");

                ContractCategory_TableTypeList.push({
                    CategoryID: CategoryID,
                    ServiceLevelID: $("#ddlServiceLevel" + CategoryID).val(),
                    Frequency: $("#ddlFrequency" + CategoryID).val()
                });
            }
        });

        Data["ContractCategory_TableTypeList"] = ContractCategory_TableTypeList;

        /// Get all top level selected parent Location ids
        var inputarray = $("#treeULList li input[type=checkbox]:checked");
        var locationArr = [];
        $.each(inputarray, function (i, item) {
            var locationid = eval($(item).attr("locationid"));
            var parentlocationid = eval($(item).attr("parentlocationid"));
            var isParentChecked = $("#chk" + parentlocationid).prop("checked");
            if (!isParentChecked || !IsNotNull(isParentChecked))
                locationArr.push({ LocationID: locationid });
        });

        Data["ContractLocation_TableTypeList"] = locationArr;
        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Contract");

        $('input:checkbox').removeAttr('checked');
        $("#txtCustomer").attr("data-id", "");
        $("#tblContractCategory tbody").html("");
        $("#divContractCategory").hide();
        $("#divFooter").hide();
        Clear_ddl_Global("#ddlLocation", "");
        $("#ddlLocation option").html("");
        $("#txtContractRefNo").val("");
        $("#txtRemark").val("");
        $("#treeULList").html("");
        $('#ddlDuration,#ddlLocation').val("").trigger("chosen:updated");
        $("input[autofocus]").focus();
    },

    RedirectScheduledLocation: function (_Id, CustId) {
        //window.location = "/Safety/Scheduler/List?ContractID=" + _Id + "&CustomerID=" + CustId + "&ContractStartDate=" + ContractStartDate + "&ContractDuration=" + ContractDuration + "&InspectionType=" + InspectionType;
        window.location = "/Safety/Scheduler/List?ContractID=" + _Id + "&CustomerID=" + CustId + "&GlobalID=" + globalScreenID.SchedulerScreenID;
    },

    bindDatePicker: function () {

        $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
            .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });

        $("#txtContractDate").datepicker().datepicker("setDate", new Date());
        $("#txtFromDate").datepicker().datepicker("setDate", new Date());

        contractCustomerLocation.bindStartContractDateDatePicker();
    },

    showCategoryGrid: function (callback) {

        Reset_Form_Errors();
        var FormJsonData = contractCustomerLocation.GetData();

        if (contractCustomerLocation.ValidateData(FormJsonData, callback) || (callback != null && FormJsonData.ContractID != null && FormJsonData.ContractID != null && FormJsonData.ContractID != ""))
            LoadGridWithoutPagination(contractCustomerLocation.xhr_GetData, "tblContractCategory", "/Safety/Category/GetRootCategory", { CurrentLanguageCode: CurrentLang },
                function () {
                    $("#divContractCategory").show();
                    $("#divFooter").show();
                    contractCustomerLocation.selectAllCategory();
                    contractCustomerLocation.bindGridFrequencyDDL();
                    contractCustomerLocation.bindServiceLevelDDL();

                    /*$(".frqCls option[value='SA']").prop('disabled', true);
                    $(".frqCls option[value='YR']").prop('disabled', true);
                    $(".frqCls option[value='2Y']").prop('disabled', true);
                    $(".frqCls option[value='5Y']").prop('disabled', true);*/

                    contractCustomerLocation.selectDurationCategory();

                    if (callback && typeof (callback) === "function")
                        callback();
                });
    },

    bindServiceLevelDDL: function () {
        $("#tblContractCategory tbody tr td select.SerLevCls").each(function (i, item) {
            var id = $(this).attr("id");
            Reload_ddl_GlobalStatic("#" + id, "ServiceLevel", (Resource.CustomerSpecific).replace("?", ""), null);
        });
    },

    bindGridFrequencyDDL: function () {
        $("#tblContractCategory tbody tr td select.frqCls").each(function (i, item) {
            var id = $(this).attr("id");
            /*Reload_ddl_Global(xhr_GetFrequency, "#" + id, "/AjaxCommonData/GetUOM", { UOMID: null }, selectText, function () { });*/
            Reload_ddl_GlobalStatic("#" + id, ConfigurationData_FrequencyTimeUnitList(), Resource.None, function () { });
        });
    },

    bindContractDateDatePicker: function () {
        /*alert("CD");
        var Enddate = $('#txtFromDate').val();
        $("#txtContractDate").datepicker('setEndDate', Enddate);*/
    },

    bindStartContractDateDatePicker: function () {

        var CurrentDate = new Date();
        var startdate = $('#txtContractDate').val();
        if (startdate != "") {
            var SelectedDate = new Date(startdate);
            if (CurrentDate > SelectedDate) {
                $('#txtFromDate').val(formatDate(CurrentDate));
            }
            else {
                SelectedDate = SelectedDate.addDays(0);
                $('#txtFromDate').val(formatDate(SelectedDate));
            }
            $("#txtFromDate").datepicker('setStartDate', startdate);

        } else {
            $("#txtFromDate").val('');
        }
    },

    selectAllCategory: function () {

        $(".select-all").change(function () {
            if ($(this).is(':checked')) {

                $('[name="check"]').prop('checked', true);
                /*$(".frqCls").removeAttr('disabled');$(".SerLevCls").removeAttr('disabled');*/
                contractCustomerLocation.GetFrequencyData();

                $("select[name='ServiceLevel']").prop("disabled", true);
                $("select[name='Frequency']").prop("disabled", true);
            } else {

                $("input[type='radio']").prop('checked', false);
                $('[name="check"]').prop('checked', false);
                /*$(".frqCls").prop('disabled', true).val("");//$(".SerLevCls").prop('disabled', true).val("");*/
                $("label[name='lblVisit']").html("");
            }
            Reset_Form_Errors();
        });

        $("input[name='check']").change(function () {

            if ($(this).is(':checked')) {

                $(this).parent().parent().parent().find("input[type='radio']").removeAttr("disabled");

            } else {

                $(this).parent().parent().parent().find("input[type='radio']").prop('checked', false);
                $(this).parent().parent().parent().find(".SerLevCls").prop("disabled", true);
                $(this).parent().parent().parent().find(".SerLevCls").val("");
                $(this).parent().parent().parent().find("#lblNoOfVisit").html("");
            }
        });

        $("select[name='Frequency']").change(function () {
            if ($(this).val() !== null && $(this).val() !== "") {
                var visits = GetNoOfVisits($("#txtFromDate").val(), parseInt($("#ddlDuration").val()), $(this).val());
                $(this).parent().parent().parent().find("#lblNoOfVisit").html(visits);
            } else {
                $(this).parent().parent().parent().find("#lblNoOfVisit").html("");
            }
        });

        $("#ddlDuration").change(function () {

            $("#tblContractCategory tbody tr").each(function () {
                var CategoryID = eval($(this).attr("data-id"));

                if ($(this).find("td:first input:checkbox").is(":checked")) {

                    if ($("#ddlFrequency" + CategoryID).val() != "") {

                        var visits = GetNoOfVisits($("#txtFromDate").val(), parseInt($("#ddlDuration").val()), $(this).find("td select#ddlFrequency" + CategoryID + "").val());
                        $(this).find("#lblNoOfVisit").html("");
                        $(this).find("#lblNoOfVisit").html(visits);
                    }
                }

                contractCustomerLocation.selectDurationCategory();
            });
        });
    },

    selectDurationCategory: function () {

        $(".frqCls option").prop('disabled', false);

        if ($("#ddlDuration").val() == 3) {
            $(".frqCls option[value='SA']").prop('disabled', true);
            $(".frqCls option[value='YR']").prop('disabled', true);
            $(".frqCls option[value='2Y']").prop('disabled', true);
            $(".frqCls option[value='5Y']").prop('disabled', true);
        }
        else if ($("#ddlDuration").val() == 6) {

            $(".frqCls option[value='YR']").prop('disabled', true);
            $(".frqCls option[value='2Y']").prop('disabled', true);
            $(".frqCls option[value='5Y']").prop('disabled', true);
        }
        else if ($("#ddlDuration").val() >= 12 && $("#ddlDuration").val() < 24) {

            $(".frqCls option[value='2Y']").prop('disabled', true);
            $(".frqCls option[value='5Y']").prop('disabled', true);
        }
        else if ($("#ddlDuration").val() >= 24 && $("#ddlDuration").val() <= 36) {

            $(".frqCls option[value='5Y']").prop('disabled', true);
        }
    },

    getNoOfVisits: function (fromDate, months, frequency) {
        return GetNoOfVisits(fromDate, parseInt(months), frequency);
    },

    bindCustomerLocation: function (DefaultModuleCode) {

        var items = GetValueToListBoxSelectedValueText("#ddlLocation");
        $("#ddlDefaultLocation").html('');
        for (var i = 0; i < items.length; i++) {
            if (items[i].Value == DefaultModuleCode)
                items[i].Selected = true;
            if ($("ddlDefaultLocation option[value='" + items[i].Value + "']").length === 0)
                $("#ddlDefaultLocation").append("<option value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");
        }
    },

    //Tree Get Location
    GetLocation: function (divID, CustomerID, isEdit, ContractLocationList) {

        $("#treeULList").html("");
        $.ajax({
            url: "/User/_partialTreeView", contentType: 'application/html; charset=utf-8', type: 'GET', dataType: 'html',
            success: function (data) {
                $("#divGridLocation").html(data).show();

                contractCustomerLocation.bindTree(divID, CustomerID, true, isEdit, ContractLocationList);
            },
            error: function (ex) { alert("Message: " + ex); }
        });
    },

    bindTree: function (divID, CustomerID, isBase, isEdit, ContractLocationList) {
        $.ajax({
            type: "GET", cache: false, url: "/Customer/GetCustomerRootLocation",
            data: { CustomerID: CustomerID },
            success: function (data) {
                var Model = eval(data.Data);

                if (isBase)
                    contractCustomerLocation.setLocationTree(divID, Model, isEdit, ContractLocationList);
                else
                    contractCustomerLocation.setToSelectParentLocationTree(divID, Model);
            },
            error: function (ex) { alert("Message: " + ex); }
        });
    },

    //Set Location
    setLocationTree: function (divID, Model, isEdit, ContractLocationList) {

        $.each(Model, function (i, value) {
            var clsApply; var styleCls;
            if (value.HasChild) {
                clsApply = 'collapse'; styleCls = '';
            } else {
                clsApply = '';
                styleCls = "style=background-image:none;display:inline-block;width:15px;";
            }

            $("#treeULList").append('<li>' +
                '<div class="collapsible" onclick="contractCustomerLocation.onDemandAjax(this)" data-loaded="false" id="divID' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' HasCustomers=' + value.HasCustomers + ' HasChild=' + value.HasChild + ' LocationName="' + value.text + '">' +
                '<input type = "checkbox" id="chk' + value.LocationID + '" LocationID="' + value.LocationID + '" ParentLocationID="' + value.ParentLocationID + '">' +
                '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                '<span class="textcls">' + '<a href="#">' + value.LocationName + '</a>' + '</span></div>' + '</li>');
            if (isEdit != undefined && isEdit) {

                $.each(ContractLocationList, function (i, item) {
                    if (value.LocationID == item.LocationID) {
                        $("#chk" + value.LocationID).prop("checked", true);
                    }
                });

                contractCustomerLocation.onDemandAjax($("#divID" + value.LocationID), true, ContractLocationList);
            }

            /*$("#divID" + value.LocationID).click();*/
        });
    },

    onDemandAjax: function (xhr, isOnEditOpenAll, ContractLocationList) {

        if (isOnEditOpenAll == undefined)
            isOnEditOpenAll = false;

        var data = {
            ID: $(xhr).attr('id'),
            LocationID: $(xhr).attr('LocationID'),
            ParentLocationID: $(xhr).attr('ParentLocationID'),
            LocationName: $(xhr).attr('LocationName'),
            HasCustomers: $(xhr).attr('HasCustomers'),
            HasChild: $(xhr).attr('HasChild')
        }

        contractCustomerLocation.fireOnNodeSelect(data);

        var this1 = $(xhr);
        var isLoaded = $(xhr).attr('data-loaded');

        if (isLoaded == "false") {
            $(this1).children('span.symbolcls').addClass('loadingP');
            $(this1).children('span.symbolcls').removeClass('collapse');
            // Load data here 
            $.ajax({
                url: "/Location/GetChildLocation", type: "POST", data: { Model: data }, dataType: "json",
                success: function (d) {
                    var Model = eval(data.Data);
                    var count = d.Data.length;
                    $(this1).children('span.symbolcls').removeClass('loadingP');
                    //contractCustomerLocation.removeaddclass(this1);
                    if (d.Data.length > 0) {
                        var $ul = $('<ul></ul>');
                        $.each(d.Data, function (i, ele) {
                            var clsApply; var styleCls;
                            if (ele.HasChild) {
                                clsApply = 'collapse'; styleCls = '';
                            } else {
                                clsApply = ''; styleCls = "style=background-image:none;display:inline-block;width:15px;";
                            }

                            $ul.append(
                                $("<li></li>").append(
                                    '<div class="collapsible" onclick="contractCustomerLocation.onDemandAjax(this)" data-loaded="false" id="divID' + ele.LocationID + '" LocationID="' + ele.LocationID + '" ParentLocationID="' + ele.ParentLocationID + '" HasCustomers="' + ele.HasCustomers + '" LocationName="' + ele.text + '">' +
                                    '<input type = "checkbox" id="chk' + ele.LocationID + '" LocationID="' + ele.LocationID + '" ParentLocationID="' + ele.ParentLocationID + '">' +
                                    '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                                    '<span class="textcls">' +
                                    '<a href="#">' + ele.LocationName + '</a>' + '</span></div>'
                                )
                            );
                        });

                        $(this1).parent().append($ul);
                        $(this1).children('span.symbolcls').addClass('collapse');
                        $(this1).children('span.symbolcls').toggleClass("collapse expand");
                        $(this1).closest('li').children('ul').slideDown();

                        if ($(this1).find("input[type=checkbox]").is(":checked"))
                            contractCustomerLocation.checkTheChild(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
                    }
                    else {
                        // no sub item found
                        $(this1).children('span.symbolcls').css({ 'display': 'inline-block', 'width': '15px' });
                    }

                    $(this1).attr('data-loaded', true);

                    if (isOnEditOpenAll) {
                        $.each(d.Data, function (i, ele) {

                            if ($('#chk' + ele.ParentLocationID).prop("checked"))
                                $('input[locationid=' + ele.LocationID + ']').prop("checked", true);

                            $.each(ContractLocationList, function (j, item) {
                                if (ele.LocationID == item.LocationID) {
                                    $("#chk" + ele.LocationID).prop("checked", true);
                                }
                            });

                            contractCustomerLocation.onDemandAjax($("#divID" + ele.LocationID), true, ContractLocationList);
                        });
                    }
                },
                error: function () { console.log("Error loading..."); }
            })
        }
        else {
            $(xhr).children('span.symbolcls').toggleClass("collapse expand");
            $(xhr).closest('li').children('ul').slideToggle();
        }
    },

    removeaddclass: function (this1) {
        $("#treeULList div.collapsible").removeClass("markselected");
        $(this1).addClass("markselected");
    },

    fireOnNodeSelect: function (data) {

        contractCustomerLocation.selectedLocationID = eval(data.LocationID);
        contractCustomerLocation.selectedLocationText = data.LocationName;
        contractCustomerLocation.selectedParentLocationID = eval(data.ParentLocationID);
        contractCustomerLocation.hasCustomers = eval(data.HasCustomers);
        contractCustomerLocation.hasChild = eval(data.HasChild);
        if (contractCustomerLocation.hasCustomers) {
            $("#divAdd i").addClass("hideShow");
            $("#divCustomer i").removeClass("hideShow");
        }
        else {
            $("#divAdd i").removeClass("hideShow");
            $("#divCustomer i").addClass("hideShow");
        }

        if (contractCustomerLocation.selectedLocationID > 0) {
            $("#divEdit i,#divDelete i").removeClass("hideShow");
        } else
            $("#divEdit i,#divDelete i").addClass("hideShow");

        $(':checkbox').change(function (xhr) {
            if ($("#chk" + $("#divID" + contractCustomerLocation.selectedLocationID).attr('LocationID')).is(":checked")) {
                contractCustomerLocation.checkTheParents(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
                contractCustomerLocation.checkTheSiblingsNew(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
                contractCustomerLocation.checkTheChild(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
            }
            else {
                contractCustomerLocation.UncheckTheParents(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
                contractCustomerLocation.UncheckTheSiblings(contractCustomerLocation.selectedLocationID, contractCustomerLocation.selectedParentLocationID);
            }
        });

        contractCustomerLocation.GatherCheckedBoxes();
    },

    GatherCheckedBoxes: function () {
        /*var status = $(ele).find("input[type=checkbox]").is(":checked");*/
        $('input:checkbox.class').each(function () {
            var sThisVal = (this.checked ? $(this).val() : "");
        });
    },

    UncheckTheParents: function (locId, parentlocId) {
        if (parentlocId === null || parentlocId === "null" || parentlocId === undefined || parentlocId === " ") {
            $("#divID" + locId).find("input[type=checkbox]").prop("checked", false);
            $('div[ParentLocationID="' + locId).find("input[type=checkbox]").prop("checked", false);
            $('div[LocationID="' + parentlocId).find("input[type=checkbox]").prop("checked", false);
            contractCustomerLocation.UncheckTheChild(locId, parentlocId);
        }
        else {
            contractCustomerLocation.UncheckTheSiblings(locId, parentlocId);
            contractCustomerLocation.UncheckTheChild(locId, parentlocId);
            $('div[ParentLocationID="' + locId).find("input[type=checkbox]").prop("checked", false);

            contractCustomerLocation.PlainUncheckParent(locId);
        }
    },

    PlainUncheckParent: function (parentId) {
        if (parentId === null || parentId === "null" || parentId === undefined || parentId === " ")
            return false;
        else {
            $('div[LocationID="' + parentId).find("input[type=checkbox]").prop("checked", false);
            var parentVal = $('div[LocationID="' + parentId + '"]').attr("ParentLocationID");
            contractCustomerLocation.PlainUncheckParent(parentVal);
        }
    },

    UncheckTheChild: function (locId, parentlocId) {

        var temp2 = $('div[ParentLocationID="' + locId + '"]');
        var temp3 = $('div[LocationID="' + parentlocId + '"]');

        if (temp2.length > 0) {
            temp2.each(function (i, ele) {

                $(ele).find("input[type=checkbox]").prop("checked", false);

                var loc = $(ele).attr("LocationID");
                var parentloc = $(ele).attr("ParentLocationID");

                $('div[LocationID="' + parentlocId).find("input[type=checkbox]").prop("checked", false);

                if (temp3.length > 0) {
                    var parentlocId = contractCustomerLocation.selectedParentLocationID;

                    $('div[LocationID="' + parentlocId).find("input[type=checkbox]").prop("checked", false);
                }

                contractCustomerLocation.UncheckTheChild(loc, parentloc);
            });
        }

        var parentVal = $('div[ParentLocationID="' + parentlocId + '"]').attr("LocationID");

        if (parentVal === null || parentVal === "null" === parentVal === undefined || parentVal === " ")
            contractCustomerLocation.checkTheSiblingsNew(locId, parentlocId);
        else
            return false;

        contractCustomerLocation.UncheckTheSiblings(locId, parentlocId);
    },

    UncheckTheSiblings: function (locId, parentlocId) {

        var temp = $("#divID" + locId).parent().siblings();
        var checkCounter = 0;
        if (temp.length > 0) {
            temp.each(function (i, ele) {
                var status = $(ele).find("input[type=checkbox]").is(":checked");
                if (!status)
                    return false;
                else {
                    checkCounter++;
                    if (checkCounter == temp.length) {
                        $("#divID" + parentlocId).find("input[type=checkbox]").prop("checked", false);
                        var childVal = $("#divID" + parentlocId).attr("LocationID");
                        var parentVal = $("#divID" + parentlocId).attr("ParentLocationID");
                        return false;
                    }
                }
            });
        } else {
            var childVal = $("#divID" + parentlocId).attr("LocationID");
            var parentVal = $("#divID" + parentlocId).attr("ParentLocationID");

            /*marking the parent then -*/
            $("#divID" + parentlocId).find("input[type=checkbox]").prop("checked", true);
            contractCustomerLocation.UncheckTheParents(childVal, parentVal);
        }
    },

    checkTheParents: function (locId, parentlocId) {
        if (parentlocId === null || parentlocId === "null" === parentlocId === undefined || parentlocId === " ") {
            $("#divID" + locId).find("input[type=checkbox]").prop("checked", true);
            contractCustomerLocation.checkTheChild(locId, parentlocId);
        }
        else {
            contractCustomerLocation.checkTheSiblingsNew(locId, parentlocId);
        }
    },

    checkTheChild: function (locId, parentlocId) {
        var temp2 = $('div[ParentLocationID="' + locId + '"]');

        if (temp2.length > 0) {
            temp2.each(function (i, ele) {
                $(ele).find("input[type=checkbox]").prop("checked", true);
                var loc = $(ele).attr("LocationID");
                var parentloc = $(ele).attr("ParentLocationID");

                contractCustomerLocation.checkTheChild(loc, parentloc);
            });
        }

        var parentVal = $('div[ParentLocationID="' + parentlocId + '"]').attr("LocationID");

        if (parentVal === null || parentVal === "null" === parentVal === undefined || parentVal === " ")
            contractCustomerLocation.checkTheSiblingsNew(locId, parentlocId);
        else
            return false;

        contractCustomerLocation.checkTheSiblingsNew(locId, parentlocId);
    },

    checkTheSiblingsNew: function (locId, parentlocId) {

        var temp = $("#divID" + locId).parent().siblings();
        var checkCounter = 0;

        if (temp.length > 0) {
            temp.each(function (i, ele) {
                var childloc = $(ele).find("div").attr("LocationID");
                var status = $(ele).find("#chk" + childloc).is(":checked");
                var partloc = $(ele).find("div").attr("ParentLocationID");

                if (!status)
                    return false;
                else {
                    checkCounter++;
                    if (checkCounter == temp.length) {

                        $("#chk" + partloc).prop("checked", true);
                        var childVal = $("#divID" + parentlocId).attr("LocationID");
                        var parentVal = $("#divID" + parentlocId).attr("ParentLocationID");
                        contractCustomerLocation.checkTheParents(childVal, parentVal);
                        contractCustomerLocation.checkTheChild(childVal, parentVal);
                    }
                }
            });
        }
        else {
            if (parentlocId != undefined) {/*added by raj*/
                var childVal = $("#divID" + parentlocId).attr("LocationID");
                var parentVal = $("#divID" + parentlocId).attr("ParentLocationID");
                $("#divID" + parentlocId).find("input[type=checkbox]").prop("checked", true);
                contractCustomerLocation.checkTheParents(childVal, parentVal);
            }
        }
    }
};
