var xhr_getData_For_Delete;
var xhr_getData_For_Edit;
var xhr_GetData;
var xhr_GetData_UserRole;
var xhr_GetData_Squad;
var xhr_GetData_Shift;
var xhr_GetData_Designation;
var xhr_GetData_Department;
var xhr_GetData_User;
var xhr_GetData_ReportingEmployee;

var xhr_GetData_UserRole;
var xhr_GetData_ModuleList;
var xhr_GetData_Language;
var xhr_GetData_DefaultModule;
var divAddUpdateID = "#Master_Form";
var OrgLevel = "Organization Level";

$(document).ready(function () {
    Employee.BindGrid();
    Reload_ddl_Global(xhr_GetData_Designation, "#ddlDesignationSearch", "/AjaxCommonData/GetDesignation", { DesignationID: null }, Resource.Select, function () { });
    Reload_ddl_Global(xhr_GetData_Department,   "#ddlDepartmentSearch", "/AjaxCommonData/GetDepartment", { DepartmentID: null, CurrentLanguageCode: CurrentLang }, Resource.Select, function () { });
});

//For Employee
var Employee = {

    ActiveEvent: function () {
        AllowCharacterNumber("#txtUserName");

        $("#txtUserName").blur(function (e) {
            var str = $(this).val().trim();
            str = str.replace(" ", "");
            $(this).val(str);
        });
    },

    BindGrid: function () {
        $('#tblGrid').on('draw.dt', function () { Employee.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGrid(xhr_GetData, "tblGrid", "/Employee/GetData", {
            CurrentScreenID: scrnID, IsChildResult: false, CustomerID: $("#txtCustomerSearch").attr('data-id'), DesignationID: $("#ddlDesignationSearch").val(), DepartmentID: $("#ddlDepartmentSearch").val()
        }, function (data) {
            Employee.ScreenAccessPermission();
            $('#tblGrid,#tblGrid thead tr th').removeAttr("style");
        });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'Employee.SetForAdd()');
        else $("#divAdd").remove();

        if (getAccess[0].HasExport)
            $("#divExport").removeAttr("style");
        else $("#divExport").remove();

        if (!getAccess[0].HasDelete)
            $("#tblGrid .DeleteColumn").addClass("hide").html("");

        if (!getAccess[0].HasUpdate)
            $("#tblGrid .HasUpdatetds").removeAttr("onclick");

    },
    //screen access code end

    bindDatePicker: function () {
        jQuery(function ($) {
            //datepicker plugin
            $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
                .next().on(ace.click_event, function () {
                    $(this).prev().focus();
                });
        });
        // $("#txtAppointmentDate").datepicker().datepicker("setDate", new Date());
    },

    SetForAdd: function () {

        Reset_Form_Errors();
        LoadAddUpdateView(divAddUpdateID, "/Employee/_partialAddUpdate", AddNewUser,
            function () {

                Employee.ClearData();
                $("#divGridUser,#divExport,#divAdd,#divFilters").hide();

                Reload_ddl_Global(xhr_GetData_Designation, "#ddlDesignation", "/AjaxCommonData/GetDesignation", { DesignationID: null }, Resource.Select, function () { });
                Reload_ddl_Global(xhr_GetData_Department, "#ddlDepartment", "/AjaxCommonData/GetDepartment", { DepartmentID: null, CurrentLanguageCode: CurrentLang }, Resource.Select, function () { });
                Reload_ddl_Global(xhr_GetData_ReportingEmployee, "#ddlReportingEmployee", "/AjaxCommonData/GetEmployee", { EmployeeID: null, LanguageCode: CurrentLang }, Resource.Select, function () { });

                Reload_ddl_Global(xhr_GetData_Squad, "#ddlSquad", "/AjaxCommonData/GetSquad", { SquadCode: null }, Resource.Select, function () { });
                Reload_ddl_Global(xhr_GetData_Shift, "#ddlShift", "/AjaxCommonData/GetShift", { Shiftcode: null }, Resource.Select, function () { });

                Reload_ddl_Global(xhr_GetData_User, "#ddlUser", "/AjaxCommonData/GetUser", { EndUserID: null }, Resource.Select, function () { });

                //$("#txtUserName").prop('disabled', false); $("#hidePass").removeAttr("style"); $("#hideConfPass").removeAttr("style");
                //Reload_ddl_Global(xhr_GetData_UserRole, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: null }, Resource.Select, function () { });
                //Reload_ddl_GlobalStatic("#ddlLanguage", ConfigurationData_LanguageList(), Resource.Select, function () { });
                //Reload_ddl_GlobalStatic("#ddlModule", "ModuleAll", null, function () { LoadChosen("#ddlModule", true); });

                PartialCustomer.BindCustomer();
                Employee.ActiveEvent();
                Employee.bindDatePicker();
            });
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
        var FormData = Employee.GetData();
        if (Employee.ValidateData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/Employee/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                Employee.SetForClose();
                                toastr.success(data.Message);
                                Employee.BindGrid();
                            } else
                                toastr.error(data.Message);
                        }
                        else
                            if (data.Message.toString().indexOf("Email Already Exist") >= 0) {
                                toastr.error(Resource.EmailAlreadyExist);
                            }
                            else
                                toastr.error(data.Message);
                    }
                    else toastr.error(data.Message);
                }
            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        Employee.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();

        xhr = $.ajax({
            url: "/Employee/GetData", cache: false, data: { EmployeeID: _Id, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == 'Success') {
                    LoadAddUpdateView(divAddUpdateID, "/Employee/_partialAddUpdate", EditUser,
                        function () {

                            SetSelectedRow("#tblGrid", _Id);
                            $("#txtUserName").prop('disabled', true);
                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);

                            $("#hf_EmployeeID").val(json_data[0].EmployeeID);  //save id into Hidden field edit submit
                            $("#ddlSalutation").val(json_data[0].Salutation);
                            $("#txtFirstName").val(json_data[0].FirstName);
                            $("#txtMiddleName").val(json_data[0].MiddleName);
                            $("#txtLastName").val(json_data[0].LastName);
                            $("#txtEmail").val(json_data[0].Email);
                            $("#txtHRMSEmployeeCode").val(json_data[0].HRMSEmployeeID);

                            $("#txtShortCode").val(json_data[0].ShortCode);
                            $("#txtEmployeeAddress").val(json_data[0].FullEmployeeAddress);
                            $("#txtTelephoneNo").val(json_data[0].TelephoneNo);
                            $("#txtCellNo").val(json_data[0].CellNo);
                            $("#txtExtensionNo").val(json_data[0].ExtensionNo);
                            $("#txtEmergencyContNo1").val(json_data[0].EmergencyContact1);
                            $("#txtEmergencyContNo2").val(json_data[0].EmergencyContact2);

                            $("#txtAppointmentDate").val(json_data[0].AppointmentDateCustom);
                            $("#txtLeavingDate").val(json_data[0].LeavingDateCustom);
                            $("#txtDateofBirth").val(json_data[0].DOBCustom);

                            $("#txtCustomerAddEdit").attr('data-id', json_data[0].CustomerID);
                            $("#txtCustomerAddEdit").val(json_data[0].CustomerName);

                            Reload_ddl_Global(xhr_GetData_Designation, "#ddlDesignation", "/AjaxCommonData/GetDesignation", { DesignationID: null }, Resource.Select, function () { $("#ddlDesignation").val(json_data[0].DesignationID); });
                            Reload_ddl_Global(xhr_GetData_Department, "#ddlDepartment", "/AjaxCommonData/GetDepartment", { DepartmentID: null, LanguageCode: CurrentLang, CurrentLanguageCode: CurrentLang }, Resource.Select, function () { $("#ddlDepartment").val(json_data[0].DepartmentID); });
                            Reload_ddl_Global(xhr_GetData_ReportingEmployee, "#ddlReportingEmployee", "/AjaxCommonData/GetEmployee", { EmployeeID: null }, Resource.Select, function () { $("#ddlReportingEmployee").val(json_data[0].ReportingEmployeeID); });

                            Reload_ddl_Global(xhr_GetData_Squad, "#ddlSquad", "/AjaxCommonData/GetSquad", { SquadCode: null }, Resource.Select, function () { $("#ddlSquad").val(json_data[0].SquadCode); });
                            Reload_ddl_Global(xhr_GetData_Shift, "#ddlShift", "/AjaxCommonData/GetShift", { Shiftcode: null }, Resource.Select, function () { $("#ddlShift").val(json_data[0].Shiftcode); });

                            Reload_ddl_Global(xhr_GetData_User, "#ddlUser", "/AjaxCommonData/GetUser", { EndUserID: null }, Resource.Select, function () {
                                if (json_data[0].EndUserID != "" && json_data[0].EndUserID != null) { $("#ddlUser").val(json_data[0].EndUserID) }
                            });

                            var Value = json_data[0].Gender;

                            var $radios = $('input:radio[name=gender]');
                            if (Value == "Male")
                                $radios.filter('[value=Male]').prop('checked', true);
                            else
                                $radios.filter('[value=Female]').prop('checked', true);

                            $("#divGridUser,#divExport,#divAdd,#divFilters").hide();

                            //$("#hidePass,#hideConfPass").attr("style", "display:none;");

                            //Employee.ActiveEvent();
                            PartialCustomer.BindCustomer();
                            Employee.bindDatePicker();

                        });
                } else {
                    toastr.error(data.Message);
                    $("#hf_EmployeeID").val("");//reset hidden field to zero
                }
            }
        });
    },

    ResetData: function () {
        var EmployeeID = $("#hf_EmployeeID").val();

        if (EmployeeID == "" || EmployeeID == null || EmployeeID == 0)
            Employee.ClearData();
        else
            Employee.GetDataByID(xhr_getData_For_Edit, EmployeeID);
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#ddlSalutation", FormData.Salutation, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtFirstName", FormData.FirstName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtLastName", FormData.LastName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtEmail", FormData.Email, Resource.Required, valid);
        valid = Validate_Control_Email("#txtEmail", FormData.Email, Resource.InvalidEmail, valid);
        valid = Validate_Control_NullBlank("#txtAppointmentDate", FormData.AppointmentDate, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlDesignation", FormData.DesignationID, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlDepartment", FormData.DepartmentID, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlShift", FormData.Shiftcode, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#ddlSquad", FormData.SquadCode, Resource.Required, valid);
        /*Commented For Future Requirements*/
        //valid = Validate_Control_NullBlank("#txtCustomerAddEdit", FormData.CustomerID, Resource.Required, valid);

        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {
            EmployeeID: $("#hf_EmployeeID").val(),
            CustomerID: $("#txtCustomerAddEdit").attr('data-id'),
            HRMSEmployeeID: $("#txtHRMSEmployeeCode").val(),
            Salutation: $("#ddlSalutation").val(),
            FirstName: $("#txtFirstName").val(),
            MiddleName: $("#txtMiddleName").val(),
            LastName: $("#txtLastName").val(),
            Gender: $('input:radio[name=gender]:checked').val(),
            ShortCode: $("#txtShortCode").val(),
            FullEmployeeAddress: $("#txtEmployeeAddress").val(),
            TelephoneNo: $("#txtTelephoneNo").val(),
            CellNo: $("#txtCellNo").val(),
            ExtensionNo: $("#txtExtensionNo").val(),
            Email: $("#txtEmail").val(),
            EmergencyContact1: $("#txtEmergencyContNo1").val(),
            EmergencyContact2: $("#txtEmergencyContNo2").val(),
            ReportingEmployeeID: $("#ddlReportingEmployee").val(),
            AppointmentDate: $("#txtAppointmentDate").val(),
            LeavingDate: $("#txtLeavingDate").val(),
            DesignationID: $("#ddlDesignation").val(),
            DepartmentID: $("#ddlDepartment").val(),
            Shiftcode: $("#ddlShift").val(),
            SquadCode: $("#ddlSquad").val(),
            EndUserID: $("#ddlUser").val(),
            DOB: $("#txtDateofBirth").val().trim(),
            CurrentScreenID: scrnID
        };
        return Data;
    },

    Delete: function (_id, ItemInfo) {
        DeleteData(xhr_getData_For_Delete, "/Employee/Delete", { EmployeeID: _id, CurrentScreenID: scrnID }, ItemInfo, function () { Employee.BindGrid(); Employee.ClearData(); Employee.SetForClose(); });
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Employee");
        $("#txtFirstName").focus();
    },

    SetForClose: function () {
        $(divAddUpdateID).html('').hide();
        $("#divGridUser,#divExport,#divAdd,#divFilters").show();
        UnSelectRow("#tblGrid");
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
            UserID: $("#hf_EmployeeID").val(),
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
        var FormData = Employee.GetDataUserLocation();

        if (Employee.ValidateUserLocationData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/Employee/AddUserLocationData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                Employee.SetForClose();
                                toastr.success(data.Message);
                                Employee.BindGrid();
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
    }
};
