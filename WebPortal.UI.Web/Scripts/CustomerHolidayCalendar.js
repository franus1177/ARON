
$(document).ready(function () {
    //customerHoliday.BindGrid();
});

var customerHoliday = {

    xhr_getData_For_Delete: null,
    xhr_getData_For_Edit: null,
    xhr_GetData: null,
    xhr_GetData_Country: null,
    xhr_GetData_HolidayLocation: null,
    divAddUpdateID: "#Master_Form_CustomerHoliday",

    bindDatePicker: function () {

        $('.date-picker').datepicker({ autoclose: true, todayHighlight: true, format: DateTimeDataFormat.ddMyyyy, useCurrent: false, minDate: 0 })/*show datepicker when clicking on the icon*/
            .next().on(ace.click_event, function () {
                $(this).prev().focus();
            });
    },

    BindGrid: function () {

        $('#tblCustomerHolidayGrid').on('draw.dt', function () { customerHoliday.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGridCustom(customerHoliday.xhr_GetData, "tblCustomerHolidayGrid", "/CustomerLocationHoliday/GetData", { CustomerID: $("#hf_CustomerID").val(), customerHoliday: null, IsChildResult: false, CurrentLanguageCode: CurrentLang },
            function (Model) {
                //Model = Merge2JsonObject(Model, ConfigurationData_CountryList(), "CountryName", "CountryCode", "CountryCode");
            },
            function () {
                //customerHoliday.ScreenAccessPermission();
                $('#tblCustomerHolidayGrid,#tblCustomerHolidayGrid thead tr th').removeAttr("style");
            });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'customerHoliday.SetForAdd()');

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
        LoadAddUpdateView(customerHoliday.divAddUpdateID, "/CustomerLocationHoliday/_partialAddUpdate", Resource.Add,
            function () {
                customerHoliday.ClearData();
                customerHoliday.GetLanguageDataForAddEdit(null);
            });
    },

    GetLanguageDataForAddEdit: function (Holiday_data) {
        BindEntityLanguageGrid("tblHolidayAddEdit", Holiday_data, "HolidayName");
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = customerHoliday.GetData();
        if (customerHoliday.ValidateData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/CustomerLocationHoliday/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                customerHoliday.ClearData();
                                toastr.success(data.Message);
                                customerHoliday.BindGrid();
                            } else
                                toastr.error(data.Message);
                        } else if (data.Message.toString().indexOf("CustomerLocationHoliday_PK_CustomerLocationID_HolidayDate") >= 0) {
                            toastr.warning(HolidayExistMessage);
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
        customerHoliday.ClearData();
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#txtHolidayDate", FormData.HolidayDate, "Required", valid);
        if (FormData.Location_TableTypeList.length === 0)
            valid = Validate_Control_NullBlank("#ddlHolidayLocation", "", "Required", valid);

        $("#tblHolidayAddEdit tr td input").each(function (i, item) {
            valid = Validate_Control_NullBlank("#txtHolidayName" + $(this).attr("data-id"), $(this).val().trim(), Resource.Required, valid);
        });
        FocusOnError("#frm_Holiday", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {
            CustomerID: $("#hf_CustomerID").val().trim(),
            HolidayDate: $("#txtHolidayDate").val().trim(),
            CurrentScreenID: scrnID
        };
        var holidayDate = [];

        if ($("#chkRepeat").is(":checked")) {
            if ($("#txtHolidayDate").val().trim() !== "" && $("#txtHolidayDate").val().trim() !== null) {
                var tempDate = new Date($("#txtHolidayDate").val().trim());

                for (var i = 0; i < 10; i++) {
                    var dd;
                    if (i === 0)
                        dd = new Date(tempDate.setFullYear(tempDate.getFullYear()));
                    else
                        dd = new Date(tempDate.setFullYear(tempDate.getFullYear() + 1));

                    holidayDate.push(formatDate(dd));
                }
            }
        } else {
            holidayDate.push($("#txtHolidayDate").val().trim());
        }
        Data["HolidayDate"] = holidayDate;

        var locationNames = GetValueToListBoxSelected("#ddlHolidayLocation", "CustomerLocationID");

        Data["Location_TableTypeList"] = locationNames;

        var HolidayList = [];

        for (var j = 0; j < holidayDate.length; j++) {
            for (var i = 0; i < locationNames.length; i++) {
                $("#tblHolidayAddEdit tr td input").each(function () {
                    HolidayList.push({ CustomerLocationID: locationNames[i].CustomerLocationID, HolidayDate: holidayDate[j], LanguageCode: "" + $(this).attr("data-id") + "", HolidayName: $(this).val().trim() });
                });
            }
        }

        Data["CustomerLocationHolidayName_TableTypeList"] = HolidayList;

        return Data;
    },

    Delete: function (_id, holidayDate, ItemInfo) {
        DeleteData(customerHoliday.xhr_getData_For_Delete, "/CustomerLocationHoliday/Delete", { CustomerLocationID: _id, HolidayDate: holidayDate, CurrentScreenID: scrnID }, ItemInfo, function () { customerHoliday.BindGrid(); customerHoliday.ClearData(); });
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Holiday");
        $('#ddlHolidayLocation').val("").trigger("chosen:updated");
        $("#chkRepeat").prop("checked", false);
        customerHoliday.bindDatePicker();
        $("#ddlHolidayLocation").focus();
    },

    SetForClose: function () {
        $(customerHoliday.divAddUpdateID).html('').hide();
    },

}