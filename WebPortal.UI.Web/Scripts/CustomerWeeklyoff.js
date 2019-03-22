
$(document).ready(function () {
    //customerWeeklyoff.BindGrid();
});

var customerWeeklyoff = {

    xhr_getData_For_Delete: null,
    xhr_getData_For_Edit: null,
    xhr_GetData: null,
    xhr_GetData_Country: null,
    xhr_GetData_WeeklyOffLocation: null,
    divAddUpdateID: "#Master_Form_CustomerWeeklyOff",

    bindDatePicker: function () {
        $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
            .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });
    },

    BindGrid: function () {
        $('#tblCustomerWeeklyOffGrid').on('draw.dt', function () { customerWeeklyoff.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGridCustom(customerWeeklyoff.xhr_GetData, "tblCustomerWeeklyOffGrid", "/CustomerWeeklyOff/GetData", { CustomerID: $("#hf_CustomerID").val(), CurrentLanguageCode: CurrentLang },
            function (Model) {
                //Model = Merge2JsonObject(Model, ConfigurationData_CountryList(), "CountryName", "CountryCode", "CountryCode");
            },
            function () {
                $('#tblCustomerWeeklyOffGrid,#tblCustomerWeeklyOffGrid thead tr th').removeAttr("style");
            });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'customerWeeklyoff.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExport").removeAttr("style");

        if (!getAccess[0].HasDelete)
            $("#tblCustomerHolidayGrid .DeleteColumn").addClass("hide").html("");

        if (!getAccess[0].HasUpdate)
            $("#tblCustomerHolidayGrid .HasUpdatetds").removeAttr("onclick");
    },
    //screen access code end

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(customerWeeklyoff.divAddUpdateID, "/CustomerLocationHoliday/_partialAddUpdate", Resource.Add,
            function () {
                customerWeeklyoff.ClearData();
                customerWeeklyoff.GetLanguageDataForAddEdit(null);
            });
    },

    GetLanguageDataForAddEdit: function (Holiday_data) {
        BindEntityLanguageGrid("tblHolidayAddEdit", Holiday_data, "HolidayName");
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = customerWeeklyoff.GetData();
        if (customerWeeklyoff.ValidateData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/CustomerWeeklyOff/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                customerWeeklyoff.ClearData();
                                toastr.success(data.Message);
                                customerWeeklyoff.BindGrid();
                            } else
                                toastr.error(data.Message);
                        } else if (data.Message.toString().indexOf("CustomerWeeklyOff_PK_LocationID_DayName") >= 0) {
                            toastr.warning(WeeklyOffExistMessage);
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

    ResetData: function () {
        customerWeeklyoff.ClearData();
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#ddlDateWeekly", $("#ddlDateWeekly").val(), "Required", valid);

        if (FormData.CustomerLocation_TableTypeList.length === 0)
            valid = Validate_Control_NullBlank("#ddlWeeklyOffLocation", "", "Required", valid);

        //FocusOnError("#frm_WeeklyOff", valid);
        return valid;
    },

    //Get form data
    GetData: function () {

        var Data = {
            CustomerID: $("#hf_CustomerID").val().trim(),
            CustomerLocationID: $("#HCustomerLocation").val(),
            CurrentScreenID: scrnID
        };

        var CustomerWeeklyOffName_TableTypeList = [];

        CustomerWeeklyOffName_TableTypeList.push({
            DayName: $("#ddlDateWeekly").val()
        });

        if ($("#ddlDateWeekly1").val() != "") {
            CustomerWeeklyOffName_TableTypeList.push({
                DayName: $("#ddlDateWeekly1").val()
            });
        }

        Data["CustomerWeeklyOffName_TableTypeList"] = CustomerWeeklyOffName_TableTypeList;

        var Locationlist = $("#ddlWeeklyOffLocation").val();
        var CustomerLocation_TableTypeList = [];

        if (Locationlist != null) {
            for (var i = 0, l = Locationlist.length; i < l; i++) {
                CustomerLocation_TableTypeList.push({
                    LocationID: Locationlist[i]
                });
            }
        }

        Data["CustomerLocation_TableTypeList"] = CustomerLocation_TableTypeList;

        return Data;
    },

    Delete: function (_id, DayName) {
        DeleteData(customerWeeklyoff.xhr_getData_For_Delete, "/CustomerWeeklyOff/Delete", { LocationID: _id, DayName: DayName, CurrentScreenID: scrnID }, '', function () { customerWeeklyoff.BindGrid(); customerWeeklyoff.ClearData(); });
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_WeeklyOff");
        $('#ddlWeeklyOffLocation').val("").trigger("chosen:updated");
        $("#chkRepeat").prop("checked", false);
        customerWeeklyoff.bindDatePicker();
        $("#ddlWeeklyOffLocation").focus();
    },

    SetForClose: function () {
        $(customerWeeklyoff.divAddUpdateID).html('').hide();
    },

};