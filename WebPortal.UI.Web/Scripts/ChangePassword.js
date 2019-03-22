var changepassword = {

    ActiveEvent: function () {

        $("#btn_Save_DataPasswordreset").click(function () {
            Reset_Form_Errors();
            var FormData = changepassword.Get_All_Form_Data();

            if (changepassword.Validate_Form_Data(FormData)) {
                //submit data to server
                $.ajax({
                    type: "POST", cache: false, url: "/Login/ChangePassword", data: { Model: FormData },
                    success: function (data) {
                        if (data != null) {
                            if (data.Status == 'Success') {
                                if (eval(data.Data) > 0) {
                                    Clear_Form_Data();
                                    toastr.success(data.Message);
                                } else toastr.error(data.Message);
                            }
                            else toastr.error(data.Message);
                        }
                        else toastr.error(data.Message);
                    }
                });
            }
        });

        $("#btn_Reset_DataPasswordreset").click(function () {
            changepassword.Clear_Form_Data();
            changepassword.Reset_Form_Errors();
        });

        $("#txtPasswordPasswordreset").focus();
        $("#txtConfirmNewPasswordreset").change(function () {
            var valid = true;
            valid = Validate_Control_ComparePassword("#txtConfirmNewPasswordreset", "#txtNewPasswordreset", "Confirm Password miss match", valid);
            valid = Validate_Control_ComparePasswordAll("#txtConfirmNewPasswordreset", "#txtNewPasswordreset", "#txtPassword", "New and old Password same", valid);
            if (valid) 
                changepassword.Reset_Form_Errors();
        });
    },

    Clear_Form_DataPassword: function () {
        $("#txtPassword").focus();
        $("#txtPassword").val("");
        $("#txtNewPassword").val("");
        $("#txtConfirmNewPassword").val("");
    },

    Reset_Form_Errors: function () {
        $(".form-group").removeClass("has-error");
        $(".form-group p").html("");
    },

    Get_All_Form_Data: function () {
        var Email = $("#txtEmail").val().trim();
        var Password = $("#txtPassword").val().trim();
        var NewPassword = $("#txtNewPassword").val().trim();
        var ConfirmNewPassword = $("#txtConfirmNewPassword").val().trim();
        return new { Email: Email, Password: Password, NewPassword: NewPassword, ConfirmNewPassword: ConfirmNewPassword };
    },

    Validate_Form_Data: function (FormData) {
        var valid = true;
        var FormData = changepassword.Get_All_Form_Data();

        valid = Validate_Control_NullBlank("#txtEmail", FormData.Email, "Email is required", valid);
        valid = Validate_Control_NullBlank("#txtPassword", FormData.Password, "Password is required", valid);
        valid = Validate_Control_NullBlank("#txtNewPassword", FormData.NewPassword, "New Password is required", valid);
        valid = Validate_Control_NullBlank("#txtConfirmNewPassword", FormData.ConfirmNewPassword, " Confirm New Password is required", valid);

        return valid;
    },
};