var xhr_getData_For_EditCustomerAddress;
var xhr_getData_For_deleteCustomerAddress;
var xhr_GetDataCustomerAddress;

var divAddUpdateCustomerAddressID = "#frm_CustomerAddress";

$(document).ready(function () {
    customerAddress.AddEvents();
});

var customerAddress = {

    AddEvents: function () {
        $("#tabAddress").click(function () {
            customerAddress.BindGrid();
            $("#lblHeading").html(Resource.Add);
        });
    },

    BindGrid: function () {
        var hf_CustomerID = $("#hf_CustomerID").val();

        if (!$.isNumeric(hf_CustomerID))
            hf_CustomerID = 0;
        LoadGrid(xhr_GetDataCustomerAddress, "tblGridCustomerAddress", "/CustomerAddress/GetData", { CustomerID: hf_CustomerID }, function () { customerAddress.ScreenAccessPermission(); });
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

        if (isSafety)
            $('#ddlServiceLine').prop('disabled', false).trigger("chosen:updated");
        else {
            $('#ddlServiceLine').prop('disabled', true).trigger("chosen:updated");
            $('#ddlServiceLine').val("").trigger("chosen:updated");
        }

        return isSafety;
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAddCustomerAddress", 'customerAddress.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExportCustomerAddress").show();

        if (!getAccess[0].HasDelete)
            $("#tblGridCustomerAddress .DeleteColumn").addClass("hide").html("");

        setTimeout(function () { if (!(getAccess[0].HasUpdate)) { $("#tblGridCustomerAddress tbody tr").each(function () { $(".HasUpdatetds a").removeAttr("href").removeAttr("title").removeAttr("style"); }); } }, 1000);
    },
    //screen access code end

    SetForAdd: function () {
        panel - heading
        $("#lblHeading").html(Resource.Add);
        Reset_Form_Errors();

        LoadAddUpdateView(divAddUpdateCustomerAddressID, "/CustomerAddress/_partialAddUpdate", Resource.Add, function () {
            customerAddress.ClearData();
        });
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = customerAddress.GetData();
        if (customerAddress.ValidateData(FormData)) {

            $.ajax({
                type: "POST", cache: false, url: "/CustomerAddress/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                //customerAddress.SetForClose();
                                customerAddress.ClearData();
                                toastr.success(data.Message);
                                customerAddress.BindGrid();
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
        customerAddress.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();
        var CustomerID2 = _Id.split('_')[0];
        var AddressType2 = _Id.split('_')[1];

        xhr = $.ajax({
            url: "/CustomerAddress/GetData", cache: false, data: { CustomerID: CustomerID2, AddressType: AddressType2, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var json = JSON.stringify(data.Data);
                    var json_data = eval(json);

                    $("#lblHeading").html(Resource.Edit);

                    $("#txtAddressType").val(json_data[0].AddressType);
                    $("#hf_AddressTypeOld").val(json_data[0].AddressType);
                    $("#txtCustomerAddressAddressLine1").val(json_data[0].AddressLine1);
                    $("#txtCustomerAddressAddressLine2").val(json_data[0].AddressLine2);
                    $("#txtCityName").val(json_data[0].CityName);
                    $("#txtStateName").val(json_data[0].StateName);
                    $("#txtCountryName").val(json_data[0].CountryName);
                    $("#txtPincode").val(json_data[0].Pincode);
                    $("#chkIsPrimaryAddress").prop("checked", json_data[0].IsPrimaryAddress);

                    customerAddress.AddEvents();
                    //LoadAddUpdateView(divAddUpdateCustomerAddressID, "/CustomerAddress/_partialAddUpdate", Resource.Edit,function () {});
                } else {
                    toastr.error(data.Message);
                    $("#AddressTypeOld").val("");//reset hidden field to zero
                }
            }
        });
    },

    ResetData: function () {
        var CustomerID = $("#hf_CustomerID").val();
        var AddressTypeOld = $("#hf_AddressTypeOld").val();

        //if ((CustomerID == "" || CustomerID == null || CustomerID == 0) && (AddressTypeOld == "" || AddressTypeOld == null || AddressTypeOld == undefined))
        if (AddressTypeOld == "" || AddressTypeOld == null || AddressTypeOld == undefined)
            customerAddress.ClearData();
        else
            customerAddress.GetDataByID(xhr_getData_For_Edit, CustomerID + "_" + AddressTypeOld);
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;

        if (FormData.CustomerID == undefined || FormData.CustomerID == "" || FormData.CustomerID == null || FormData.CustomerID == 0) {
            valid = false;
            toastr.error("Customer must added first");
        }

        valid = Validate_Control_NullBlank("#txtAddressType", FormData.AddressType, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtCustomerAddressAddressLine1", FormData.AddressLine1, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtCountryName", FormData.CountryName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtStateName", FormData.StateName, Resource.Required, valid);
        valid = Validate_Control_NullBlank("#txtCityName", FormData.CityName, Resource.Required, valid);

        //FocusOnError("#frm_CustomerAddress", valid);
        return valid;
    },

    //Get form data
    GetData: function () {

        var Data = {
            CustomerID: $("#hf_CustomerID").val(),
            AddressTypeOld: $("#hf_AddressTypeOld").val().trim(),
            AddressType: $("#txtAddressType").val().trim(),
            AddressLine1: $("#txtCustomerAddressAddressLine1").val().trim(),
            AddressLine2: $("#txtCustomerAddressAddressLine2").val().trim(),
            CityName: $("#txtCityName").val().trim(),
            StateName: $('#txtStateName').val().trim(),
            CountryName: $("#txtCountryName").val().trim(),
            Pincode: $("#txtPincode").val().trim(),
            IsPrimaryAddress: $("#chkIsPrimaryAddress").prop("checked"),
            CurrentScreenID: scrnID
        };

        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_CustomerAddress");
        $("#lblHeading").html(Resource.Add);
        $("#chkIsPrimaryAddress").prop("checked", false);
        $("input[autofocus]").focus();
    },

    SetForClose: function () {},

    Delete: function (_Id, ItemInfo) {
        var CustomerID2 = _Id.split('_')[0];
        var AddressType2 = _Id.split('_')[1];
        DeleteData(xhr_getData_For_deleteCustomerAddress, "/CustomerAddress/Delete", { CustomerID: CustomerID2, AddressType: AddressType2, CurrentScreenID: scrnID }, ItemInfo, function () { customerAddress.BindGrid(); /*customerAddress.ClearData();*/ /*customerAddress.SetForClose();*/ });
        $("#hf_AddressTypeOld").val("");
    }
}