var xhr_getData_For_Edit;
var xhr_SetForm_For_Permission;
var xhr_GetData;
var xhr_Persmission;
var xhr_GetMenu;
var divAddUpdateID = "#Master_Form";

$(document).ready(function () {
    $("#divGridUserRole").show();
    userRole.BindGrid();
});

var userRole = {
    /* User role master operation start */
    BindGrid: function () {
        $('#tblGrid').on('draw.dt', function () { userRole.ScreenAccessPermission(); });/*on page chanage event/Redraw table rows and will apply on all event*/
        LoadGrid(xhr_GetData, "tblGrid", "/UserRole/GetData", { Id: null }, function () {
            userRole.ScreenAccessPermission();
        });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);
        var flagDM = false;
        var flagPer = false;
        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'userRole.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExport").removeAttr("style");

        if (!(getAccess[0].HasUpdate)) {
                $("#tblGrid tbody tr .HasUpdatetds a").removeAttr("href");
        }

        if (getAccess.length > 1) {
            for (var i = 1; i < getAccess.length; i++) {
                if ((getAccess[i].ActionCode === 'Permission') && globalDeryptedScreenID.UserRoleAccesspermisssionID > 0)
                    flagPer = true;

                if (getAccess[i].ActionCode === 'DocumentMapping' && globalDeryptedScreenID.UserRoleDocumentID > 0)
                    flagDM = true;
            }
        }

        if (!flagPer) {
           $("#tblGrid .HasPermissiontds").addClass("hide").html("");
        }

        if (!flagDM) {
            $("#tblGrid .HasPermissiontdDM").addClass("hide").html("");
        }
    },
    //screen access code end

    SetForAdd: function () {
        Reset_Form_Errors();
        LoadAddUpdateView(divAddUpdateID, "/UserRole/_partialAddUpdate", AddNewUserRole, function () { userRole.ClearData(); });
    },

    //Save data to server
    AddUpdate: function () {
        Reset_Form_Errors();
        if (userRole.ValidateData()) {
            var FormData = userRole.GetData();
            $.ajax({
                type: "POST", cache: false, url: "/UserRole/AddUpdateData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            //Reload Grid

                            userRole.BindGrid();
                            userRole.ClearData();
                            userRole.SetForClose();
                            toastr.success(data.Message);
                        }
                        else {
                            if (data.Message.toString().indexOf("UserRole_UK_UserRoleName") >= 0) {
                                toastr.warning(UserRoleNamealreadyexists);
                            }
                            else
                                toastr.error(data.Message);
                        }
                    }
                    else toastr.error(data.Message);
                }
            });
        }
    },

    //Get data for edit
    GetDataByID: function (xhr, _Id) {
        Reset_Form_Errors();
        userRole.ClearData();

        if (xhr && xhr.readystate != 4)
            xhr.abort();

        xhr = $.ajax({
            url: "/UserRole/GetData", cache: false, data: { Id: _Id },
            success: function (data) {
                if (data != null && data.Status == "Success") {
                    LoadAddUpdateView(divAddUpdateID, "/UserRole/_partialAddUpdate", EditUserRole,
                        function () {
                            var json = JSON.stringify(data.Data);
                            var json_data = eval(json);
                            $("#hf_UserRoleID").val(json_data[0].UserRoleID);
                            $("#txtUserRole").val(json_data[0].UserRoleName);
                        });
                } else toastr.error(data.Message);
            }
        });
    },

    ResetData: function () {
        var UserRoleID = $("#hf_UserRoleID").val();

        if (UserRoleID == "" || UserRoleID == null || UserRoleID == 0)
            userRole.ClearData();
        else
            userRole.GetDataByID(xhr_getData_For_Edit, UserRoleID);
    },

    //Validate form data
    ValidateData: function () {

        var valid = true;
        var FormData = userRole.GetData();

        //validation for not null/Required
        valid = Validate_Control_NullBlank("#txtUserRole", FormData.UserRoleName, Resource.Required, valid);
        FocusOnError("#frm_UserRole", valid);
        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = { UserRoleID: $("#hf_UserRoleID").val(), UserRoleName: $("#txtUserRole").val().trim(), CurrentScreenID: scrnID };
        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_UserRole");
        $("#txtUserRole").focus();
    },

    SetForClose: function () {
        $(divAddUpdateID).html('').hide();
    },
    /* User role master operation end */

    /* User role permission start */
    SetForPermission: function (xhr, id) {
        $("#ScreenUserRoleAccess").show();
        $("#divGridUserRole").hide();
        $(divAddUpdateID).hide();

        Reload_ddl_Global(xhr_Persmission, "#ddlUserRole", "/AjaxCommonData/GetUserRole", { UserRoleID: id }, Resource.Select, function () { userRole.ClearAccessGrid(); });
        Reload_ddl_GlobalStatic("#ddlAccessModule", "ModuleAll", null, function () { });

        $("#divActions").hide();
    },

    ClearAccessGrid: function () {

        Reload_ddl_Global(xhr_GetMenu, "#ddlMenu", "/AjaxCommonData/GetMenuList", { ModuleCode: $("#ddlAccessModule").val() }, "Screens", function () { });

        $("#tblUserRoleScreenGrid tbody").html("<tr><td colspan='3' align='center'>No Record Found</td></tr>");
        $("#panelFooter").hide();
    },

    RoleAccessProceed: function () {
        Reset_Form_Errors();
        if (userRole.ValidateUserRoleData())
            userRole.BindGridUserRoleList();
        else
            toastr.error("Fill required Data");
    },

    SaveUserRoleAccessLevelData: function () {
        Reset_Form_Errors();
        var flag = false;
        $('#tblUserRoleScreenGrid tbody tr td input[name=Base]').each(function (i, e) { flag = true; });
        jsonObj = []; item = {};
        if (flag) {
            $('#tblUserRoleScreenGrid tbody tr').each(function (i, e) {
                item = {};
                item["CurrentModuleCode"] = $("#ddlAccessModule").val();
                item["MenuCode"] = ($("#ddlMenu").val());
                item["UserRoleID"] = parseInt($("#ddlUserRole").val());
                item["ScreenID"] = $(this).data("id");
                item["CurrentScreenID"] = globalDeryptedScreenID.UserRoleAccesspermisssionID;

                $("#" + this.id + " input[name=Base]").each(function (i, e) {
                    if (e.type === 'checkbox') {
                        var val = (this.id).split('_');
                        val = val[0].substring(4, val[0].length);
                        var assignVal = $(this).is(':checked');
                        switch (val) {
                            case "Insert": item["HasInsert"] = assignVal; break;
                            case "Update": item["HasUpdate"] = assignVal; break;
                            case "Delete": item["HasDelete"] = assignVal; break;
                            case "Select": item["HasSelect"] = assignVal; break;
                            case "AuditUpdate": item["UpdateAudit"] = assignVal; break;
                            case "AuditDelete": item["DeleteAudit"] = assignVal; break;
                            case "chkImport": item["HasImport"] = assignVal; break;
                            case "chkExport": item["HasExport"] = assignVal; break;
                        }
                    }
                });

                item["AdditionalAccess"] = null;
                jsonObjChild = ""; itemChild = {};
                var k = 0;
                //Additional
                $("#" + this.id + " input[name=Additional]").each(function (i, e) {
                    if (e.type === 'checkbox') {
                        var val = ((this.id).split('_'))[0];
                        var assignVal = $(this).is(':checked');
                        if (assignVal) {
                            jsonObjChild += val + ",";
                            k++;
                        }
                    }
                });

                if (k > 0) {
                    jsonObjChild = jsonObjChild.slice(0, -1);
                    item["AdditionalAccess"] = "[" + jsonObjChild + "]";
                }
                jsonObj.push(item);
            });//nested foreach

            var FormData = userRole.GetFormUserRoleData();
            //submit data to server
            $.ajax({
                type: "POST", url: "/UserRole/AddEditUserRolePermissionData", data: { Model: (JSON.stringify(jsonObj)) },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success' && data.Data > 0) {
                            toastr.success(data.Message);
                            userRole.BindGridUserRoleList();
                            SmoothScroll("#btnUserRoleAccessProceed");
                        } else toastr.error(data.Messsage);
                    } else toastr.error(data.Messsage);
                },
                beforeSend: function (data) { }
            });
        } else {
            toastr.error("No Data present to submit");
        }
    },

    GetFormUserRoleData: function () {
        var Data = {
            MenuCode: $("#ddlMenu").val(),
            UserRoleID: $("#ddlUserRole").val(),
            CurrentModuleCode: $("#ddlAccessModule").val(),
            CurrentScreenID: globalDeryptedScreenID.UserRoleAccesspermisssionID
        };

        return Data;
    },

    ValidateUserRoleData: function () {

        var valid = true;
        var FormData = userRole.GetFormUserRoleData();

        valid = Validate_Control_NullBlank("#ddlUserRole", FormData.UserRoleID, Resource.UserRoleisRequired, valid);
        valid = Validate_Control_NullBlank("#ddlAccessModule", FormData.CurrentModuleCode, Resource.ModuleCodeisRequired, valid);
        return valid;
    },

    SetForUserRoleAccessAdd: function () {
        userRole.ClearUserRoleAccessData();
        $("#ScreenUserRoleAccess").show();
        $("#FormHeading").html("Add User Role Access Permission");
        $("#ddlUserRole").focus();
    },

    ClearUserRoleAccessData: function () {
        $("#ddlUserRole").val("");
        $("#ddlMenu").val("");
        Reset_Form_Errors();
    },

    SetForUserRoleAccessClose: function () {
        $("#ScreenUserRoleAccess").hide();
        $("#divGridUserRole").show();
        $("#divActions").removeAttr("style");
    },

    BindGridUserRoleList: function () {

        $.ajax({
            url: "/UserRole/GetScreenAccess", data: { MenuCode: $("#ddlMenu").val(), UserRoleID: $("#ddlUserRole").val(), CurrentModuleCode: $("#ddlAccessModule").val() },
            success: function (data) {
                if (data.Status == 'Success') {
                    $("#tblUserRoleScreenGrid tbody").html("");
                    var Model = eval(data.Data);
                    $("#panelFooter").hide();
                    if (Model.length > 0) {
                        $("#panelFooter").show();
                        $.each(Model, function (ID, item) {
                            $("#Grid_Data_ScreenTemplate").tmpl(item).appendTo("#tblUserRoleScreenGrid tbody");
                            if (item.AdditionalAccess != null && item.AdditionalAccess != "") {
                                var JsonAdd = eval('[' + item.AdditionalAccess + ']');
                                $.each(JsonAdd, function (ID, item) {
                                    $("#Grid_Data_ScreenWiseTemplate").tmpl(item).appendTo("#ChildAdditionalScreenAction" + item.ScreenID);

                                    if (item.IsRendered == "0" || item.IsRendered == false)
                                        $("#" + item.ActionCode + "_" + item.ScreenID).attr("disabled", "disabled");
                                    else if (item.ActionCodeUserRole != "" && item.ActionCodeUserRole != null && item.ActionCodeUserRole != "null") {
                                        $("#" + item.ActionCode + "_" + item.ScreenID).attr("checked", "checked");
                                    }
                                });
                            }
                        });
                    }
                    else $("#tblUserRoleScreenGrid tbody").html("<tr><td colspan='3' align='center'>No Record Found</td></tr>");
                } else {
                    toastr.error(data.Message);
                }
            },
            error: function (ex) {
                alert("Message: " + ex);
            }
        });
    }
    /* User role permission end */
};

var DocumentMapping = {
    SetForDocumentMapping: function (xhr, id) {

        LoadAddUpdateView(divAddUpdateID, "/UserRole/_partialDocumentMappingView", Resource.DocumentMapping,
            function () {
                DocumentMapping.BindGrid("", id);
            });
    },

    BindGrid: function (DocumentCategoryID, UserRoleID) {

        LoadGridWithoutPagination(xhr_GetData, "tblDocumentGrid", "/UserRole/GetDocumentForUserRole", { DocumentCategoryID: DocumentCategoryID, IsChildResult: false }, function (data) {
            var HeaderControlclass = "tblDocumentGridHeader";
            var RowControlClass = "tblDocumentGridRow";

            $("#hf_UserRoleID").val(UserRoleID);

            /* Function For select all checkbox */
            SelectAll(HeaderControlclass, RowControlClass);

            GetAjaxData("/UserRole/GetDocumentMapping", { EntityID: UserRoleID, EntityType: "UserRole" }, function (data) {
                if (data != null && data.Status == "Success") {
                    var model = eval(data.Data);
                    $.each(model, function (j, item1) {
                        var RowsCount;
                        var cid = item1.DocumentID;
                        $('#' + cid + 'Document').attr('checked', true);
                    });
                }

            }, null)

        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var id = $("#hf_UserRoleID").val();
        var FormData = DocumentMapping.GetDocumentMappingData();
        if (DocumentMapping.ValidateDocumentMappingData(FormData)) {
            AddUpdateData("/UserRole/AddUpdateDocumentMapping", { Model: FormData }, function () {
                userRole.BindGrid();
                DocumentMapping.ClearData();
                DocumentMapping.SetForClose();
            }, function (responce_data) {//Handle Error Block
            });
        }
    },

    GetDocumentMappingData: function () {
        var DocumentID_TableTypeList = [];

        var DocumentMapping = {
            EntityType: "UserRole",
            EntityID: $("#hf_UserRoleID").val(),
            CurrentScreenID: globalDeryptedScreenID.UserRoleDocumentID
        };

        $("#tblDocumentGrid tbody tr").each(function (i, item) {
            var id = item.dataset;
            id = id.id;
            if ($('input[value="' + id + '"]').prop('checked') == true) {
                DocumentID_TableTypeList.push({ DocumentID: $('input[value="' + id + '"]').val() });
            }
        });

        DocumentMapping["DocumentID_TableTypeList"] = DocumentID_TableTypeList;
        return DocumentMapping;
    },

    SetForClose: function () {
        $(divAddUpdateID).html('').hide(); UnSelectRow("#tblGrid");
    },

    ClearData: function () {
        ResetFormErrors("#frm_DocumentMapping");
        Clear_Form_Fields("#frm_DocumentMapping");
        $(".has-error p").html("").hide();
        $(".has-error").removeClass("has-error");
        $("#frm_DocumentMapping .form-control:first").focus();
    },

    ResetData: function () {
        var _id = $("#hf_UserRoleID").val();
        DocumentMapping.BindGrid("", _id);
    },

    ValidateDocumentMappingData: function (FormData) {
        var valid = true;
        return valid;
    },
};

var Document = {

    BindGrid: function (DocumentCategoryID) {

        LoadGridWithoutPagination(Document.xhr_GetData, "tblDocumentGrid", "/Document/GetData", { DocumentCategoryID: DocumentCategoryID, IsChildResult: false }, function (data) {
            var HeaderControlclass = "tblDocumentGridHeader";
            var RowControlClass = "tblDocumentGridRow";

            var UserRoleID = $("#hf_UserRoleID").val();

            /* Function For select all checkbox */
            SelectAll(HeaderControlclass, RowControlClass);

            GetAjaxData("/UserRole/GetDocumentMapping", { EntityID: UserRoleID }, function (data) {
                if (data != null && data.Status == "Success") {
                    var model = eval(data.Data);
                    $.each(model, function (j, item1) {
                        var RowsCount;
                        var cid = item1.DocumentID;
                        $('#' + cid + 'Document').attr('checked', true);
                    });
                }
            }, null);
        });
    },

    ResetCategoryData: function () {

        Document.ClearData();
        Document.SetForClose()
        Clear_ddl_Global2("#divExpandedCategoryGrid", "Select");
        $("#hf_AddEditParentCategoryID").val("");
        Document.BindGrid("");
    },

    FileDownload: function (_id, FileType, FilePath) {

        var valFileDownloadPath = ProjectURL.BaseURL + '/Documents/' + FilePath + FileType;
        window.open(valFileDownloadPath, '_blank');
    }
};