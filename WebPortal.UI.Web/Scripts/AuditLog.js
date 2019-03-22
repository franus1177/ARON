$(document).ready(function () {

    $("#divGridMaster").show();

    AuditLog.ActiveEvent();
    AuditLog.BindGrid();
});
//var divAddUpdateID = "#Master_Form";

var AuditLog = {

    xhr_getData_For_Edit: null,
    xhr_getData_For_Delete: null,
    xhr_GetData: null,
    xhr_User: null,
    xhr_Screen: null,
    divAddUpdateID: "#Master_Form",

    ActiveEvent: function () {

        GetAjaxData("/User/GetData", { EndUserID: null, IsChildResult: false, UserRoleName: null },
           function (data_Response) {
               Reload_ddl_GlobalStatic('#ddlUser', data_Response.Data, Resource.All, null);
           }, function (Error_Response) { });

        //Reload_ddl_Global(AuditLog.xhr_User, "#ddlUser", "/AjaxCommonData/GetUserRole", {}, Resource.Select, function () { });
        Reload_ddl_Global(AuditLog.xhr_Screen, "#ddlScreen", "/AjaxCommonData/GetScreen", {}, Resource.All, function () { });
        Reload_ddl_GlobalStatic("#ddlModule", "ModuleAll", Resource.All, function (data) { SetddlItem("#ddlModule", data.length, null); });

        $('.input-daterange').datepicker({ autoclose: true, format: DateTimeDataFormat.ddMyyyy });
        $('#txtStartSearch').datepicker('setDate', CommonFirstDay);
        $('#txtEndSearch').datepicker('setDate', CommonLastDay);
    },

    /* User role master operation start */
    BindGrid: function () {

        var Model = AuditLog.GetData(); //{ CurrentScreenID: scrnID };
        LoadGridWithoutPaginationWithPost(AuditLog.xhr_GetData, "tblGrid", "/AuditLog/GetDataGrid", Model, function () {
            AuditLog.ScreenAccessPermission();
        });
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'AuditLog.SetForAdd(null)');

        if (!getAccess[0].HasDelete)
            $("#tblGrid .DeleteColumn").addClass("hide").html("");

        if (!getAccess[0].HasUpdate)
            $("#tblGrid .HasUpdatetds").removeAttr("onclick");

        if (getAccess[0].HasExport)
            $("#divExport").show();
    },
    //screen access code end

    ResetData: function () {
        $('#txtStartSearch').datepicker('setDate', CommonFirstDay);
        $('#txtEndSearch').datepicker('setDate', CommonLastDay);
        AuditLog.ClearData();
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;
        //validation for not null/Required
        var itemList = FormData.UOMLanguage_TableTypeList;

        $.each(itemList, function (i, item) {
            valid = Validate_Control_NullBlank("#txtUOMName" + item.LanguageCode, item.UOMName, Resource.Required, valid);
        });

        FocusOnError("#frm_UOMMaster", valid);
        return valid;
    },

    //Get form data
    GetData: function () {

        var AuditLog = {

            ScreenID: $("#ddlScreen").val(),
            EndUserID: $("#ddlUser").val(),
            OperationType: $("#ddlOperation").val(),
            ModuleCode: $("#ddlModule").val(),
            StartDate: $("#txtStartSearch").val(),
            EndDate: $("#txtEndSearch").val(),
            ObjectName: $("#txtObject").val(),
            AccessPoints: $("#txtAccessPoint").val(),
            CurrentScreenID: scrnID
        };

        return AuditLog;
    },

    //Clear form data
    ClearData: function () {
        ResetFormErrors("#frm_AuditLog");
        Clear_Form_Fields("#frm_AuditLog");
        $(".has-error p").html("").hide();
        $(".has-error").removeClass("has-error");
        AuditLog.BindGrid();
    },
};

var EntityType = {
    ShowEntityType: function (AuditLogID, ScreenName, OperationType, UserName, OperationDateTime, AccessPoint, ObjectID) {
        LoadAddUpdateView(AuditLog.divAddUpdateID, "/AuditLog/_partialViewEntityDetails/", Resource.EntityType, function () {

            $("#divEntityDetails").modal("show");
            $("#lblObjectID").html(ObjectID);
            $("#lblScreenName").html(ScreenName);
            console.log(UserName);
            $("#lblUser").html(UserName);
            $("#lblOperationDate").html(OperationDateTime);
            $("#lblAccessPoint").html(AccessPoint);
            if (OperationType == 'I') {
                $("#lblOperationType").html("Add");
            } else
                if (OperationType == 'U') {
                    $("#lblOperationType").html("Edit");
                } else
                    if (OperationType == 'D') {
                        $("#lblOperationType").html("Delete");
                    }


            var FormData = {
                AuditLogID: AuditLogID,
                CurrentLanguageCode: CurrentLang
            };

            GetAjaxData("/AuditLog/GetEntityDetails", FormData, function (data) {
                var model = data.Data;
                console.log(model);

                var i = 1;
                var PreImage;
                var htmltable = "";
                var htmlhead = "";
                var htmlbody = "";
                var tableName = "";
                var OperationDateTime = "";
                var OperationType = "";
                if (model.length > 0) {

                    $.each(model, function (i, item) {
                        console.log(item.PreImageCustom);
                        /* create preimage in xml format*/
                        PreImage = "<?xml version='1.0'?>";
                        PreImage += item.PreImageCustom;
                        console.log(PreImage);

                        /* Check EntityType is  xml or not */
                        var isXML = EntityType.isXML(PreImage);
                        console.log(isXML);
                        if (isXML == true) {
                            tableName = item.TableName;
                            
                            OperationDateTime = item.OperationDateTimeCustom;
                            OperationType = item.OperationTypeCustom;
                            if (item.TableName == null) {
                                tableName = "-";
                            } 
                            if (item.OperationDateTimeCustom == null) {
                                OperationDateTime = "";
                            }
                            if (item.OperationTypeCustom == null) {
                                OperationType = "";
                            }
                            htmltable = "<span class='bold'>" + OperationDateTime + "</span><br/><span class='bold'>" + Resource.Action + " : </span> &nbsp; " + OperationType + "&nbsp;&nbsp;&nbsp;&nbsp;<span class='bold'>" + Resource.Table + " : </span>&nbsp;&nbsp; " + tableName + "<br/>";
                            
                            /* create table */
                            htmltable += "<table class='table table-bordered dataTable' id='tblEntityDetails" + i + "' role='grid' style='width: 100%;'>";
                            htmlhead = "<thead><tr>"; /* Declare header structure in table */
                            htmlbody = "<tbody><tr>"; /* Declare body structure in table */

                            var xmlDocument = $.parseXML(PreImage);

                            console.log(xmlDocument);

                            var xmlAttr = xmlDocument.all[0];
                            var xmlAttributes = xmlAttr.attributes;
                            console.log(xmlAttributes);
                            $.each(xmlAttributes, function (j, item1) {
                                var k = xmlAttributes[j]
                                var nodeName = k.nodeName;
                           
                                nodeName = EntityType.getText(nodeName);/* get sentence in proper format */
                           
                                var nodeValue = k.nodeValue;
                                htmlhead += " <th>";
                                htmlhead += nodeName;
                                htmlhead += " </th>";

                                htmlbody += " <td>";
                                htmlbody += nodeValue;
                                htmlbody += " </td>";
                            });

                            htmlhead += "</tr></thead>";
                            htmlbody += "</tr></tbody></table><br/>";  /* table end */
                          
                            htmltable += htmlhead + htmlbody;

                            /* append table to div */
                            $("#divEntityDetailsforTable").append(htmltable);
                            console.log(htmltable);
                            i++;
                        }
                    });
                }
                else {
                    $("#divEntityDetailsforTable").append("<span style='color:red' >No records found</span>");
                }
            });
        });
    },

    hideEntityDetails: function () {
        $("#divEntityDetails").modal("hide");
    },

    /* check is it xml or not   */
    isXML: function (xml) {
        try {
            xmlDoc = $.parseXML(xml); //is valid XML
            return true;
        } catch (err) {
            // was not XML
            return false;
        }
    },

    /* get sentence from string   */
    getText: function (input) {
        var word = '';
        for (var i = 0; i < input.length; i++) {
            var str = input.charAt(i);
            var upperstr = str.toUpperCase();

            if ((str === upperstr) && (i != 0)) {
                word += ' ' + str;
            }
            else {
                word += str;
            }
        }
        return word;
    }
};