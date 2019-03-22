

$(document).ready(function () {

});


var user = {

    xhr_getData_For_Delete: null,
    xhr_getData_For_Edit: null,
    xhr_GetData: null,
    xhr_GetData_UserRole: null,
    xhr_GetData_Language: null,
    xhr_GetData_DefaultModule: null,

    CheckPassword: function () {
        var valid = true;
        valid = Validate_Control_ComparePassword("#txtConfirmPassword", "#txtPassword", ConfirmPasswordMissMatch, valid);
        if (valid)
            Reset_Form_Errors();
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        var FormData = user.GetData();
        if (user.ValidateData(FormData)) {
            $.ajax({
                type: "POST", cache: false, url: "/Login/UserForgotpassword", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {

                                user.ClearData();
                                toastr.success(data.Message);
                                setTimeout(window.location = "/Login/index", 5000);

                            } else
                                toastr.error(data.Message);
                                User.ClearPasswordData();
                        }
                        else
                            toastr.error(data.Message);
                            User.ClearPasswordData();
                    }
                    else
                        toastr.error(data.Message);
                        User.ClearPasswordData();
                }
            });
        }
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

        valid = Validate_Control_NullBlank("#txtUserName", FormData.UserEmail, "User Name can't be empty.", valid);
        valid = Validate_Control_NullBlank("#txtPassword", FormData.NewPassword, "New password can't be empty.", valid);
        valid = Validate_Control_NullBlank("#txtConfirmPassword", FormData.ConfirmNewPassword, "Confirm password can't be empty.", valid);

        FocusOnError("#divForgotChangePassword", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {

            Password:  $("#txtPassword").val(),
            UserEmail: $("#txtUserName").val(),
            NewPassword: $("#txtPassword").val(),
            ConfirmNewPassword: $("#txtConfirmPassword").val(),
            EndUserID: parseInt(EndUserId),
            LoginID: $("#txtUserName").val().trim()

        };
        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        $("#txtUserName").val('');
        $("#txtPassword").val('');
        $("#txtConfirmPassword").val('');
    },

    ClearPasswordData: function () {
        $("#txtPassword").val('');
        $("#txtConfirmPassword").val('');
    },
}