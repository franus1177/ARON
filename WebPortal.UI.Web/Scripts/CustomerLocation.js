var xhr_getData_For_Edit;
var xhr_GetData;
var xhr_GetData_Location;
var LocationRiskLevelList = [];
var xhr_CustomerLocation;
var divAddUpdateID = "#Master_Form";
var selectedLocationID = null;
var selectedLocationText = null;
var tempLocationText = null;
var selectedParentLocationID = null;
var tempParentLocationID = null;
var isEdit = false;
var locationArr = [];
var locationID = null;
var customerLocationText = null;
var hasObjectInstance = null;
var hasChild = null;
var xhr_SetForm_For_Permission = null;

$(document).ready(function () {

    if (customerID !== "")
        locations.BindData();
    else
        locations.BindCustomer();

    locations.ScreenAccessPermission();
});

var locations = {

    BindCustomer: function () {

        BindAutoComplete("#lblCustomerName", "/Customer/GetData", 1, "CustomerName", "CustomerID",
            function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#lblCustomerName").val() } },
            function (e, i) {/*select call*/ $(e.target).attr("data-id", i.item.val);/*set to search input box*/
                customerID = eval($("#lblCustomerName").attr("data-id"));
                locations.BindData();

            }, function (event, ui) { });

        $.ajax({
            url: "/Customer/GetData", cache: false, data: {},
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var json = JSON.stringify(data.Data);
                    var json_data = eval(json);

                    if (json_data.length > 0) {
                        customerID = json_data[0].CustomerID;
                        locations.BindData();
                        $('#lblCustomerName').removeAttr("disabled");
                    }
                }
            }
        });

    },

    BindData: function () {

        var formdata = { CurrentModuleCode: _ModuleCodeLayout, CurrentServiceLineCode: _ServiceLineCodeLayout, CustomerID: customerID, LocationID: null };
        Reload_ddl_Global(xhr_CustomerLocation, "#ddlCustomerLocation", "/AjaxCommonData/GetCustomerLocation"/*AjaxCommonData/GetCustomerLocation*/, formdata, null, function () {
            locations.bindLocationTree($("#ddlCustomerLocation"));
            locations.GetCustomerName();

            //if ($("#ddlCustomerLocation option").length == 0) {
            //    $("#ddlCustomerLocation").append("<option>" + Resource.Select + "</option>");
            //}

        });

    },

    xhr_GetData: null,

    GetCustomerName: function () {
        $.ajax({
            url: "/Customer/GetData", cache: false, data: { CustomerID: customerID, IsChildResult: false },
            success: function (data) {
                if (data != null && data.Status == "Success") {
                    var json = JSON.stringify(data.Data); var json_data = eval(json);
                    $("#lblCustomerName").val(json_data[0].CustomerName);
                }
            }
        });
    },

    xhr_getData_For_Delete: null,

    //Get Location
    GetLocation: function (divID, LocationID) {
        locations.bindTree(divID, LocationID, true);
    },

    bindModelDDL: function () {
        $("#tblGridModelRisk tbody tr td select.RisklevelCls").each(function (i, item) {
            var id = $(this).attr("id");
            Reload_ddl_GlobalStatic("#" + id, "RiskLevel", Resource.Select, null);
        });
    },

    BindModelRiskGrid: function (callback) {

        $.ajax({
            url: "/Customer/GetData", cache: false, data: { CustomerID: customerID, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var json = JSON.stringify(data.Data);
                    var json_data = eval(json);

                    var Model = json_data[0].CustomerModuleList;
                    Merge2JsonObject(Model, ConfigurationData_ModuleListAll(), "ModuleName", "ModuleCode", "ModuleCode");

                    $("#tblGridModelRisk tbody").html("");
                    $("#Grid_Data_Template_tblModelRisk").tmpl(Model).appendTo("#tblGridModelRisk tbody");

                    locations.bindModelDDL();

                    if (callback && typeof (callback) === "function")
                        callback();
                }
            }
        });

    },

    GetRootAndChildCustomerLocationRiskLevel: function () {

        $.ajax({
            url: "/Customer/GetRootAndChildCustomerLocationRiskLevel",
            cache: false,
            data: { LocationID: selectedLocationID, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var json_data = eval(data.Data);
                    var Roollocation = 0;

                    if (json_data.length > 0) {

                        $.each(json_data, function (index, value) {

                            $("#tblGridModelRisk tbody tr").each(function () {
                                if (value.ModuleCode == $(this).attr("data-id")) {

                                    if (value.Node == "Root") {
                                        Roollocation = value.RiskLevelID;

                                        for (var i = value.RiskLevelID; i < $("#ddlRiskLevel" + value.ModuleCode).val(); i++) {
                                            $("#ddlRiskLevel" + value.ModuleCode + " option[value=" + i + "]").prop('disabled', false);
                                        }
                                    }

                                    if (value.Node == "Child") {
                                        for (var i = Roollocation; i < value.RiskLevelID; i++) {
                                            $("#ddlRiskLevel" + value.ModuleCode + " option[value=" + i + "]").prop('disabled', false);
                                        }
                                    }
                                }
                            });
                        });
                    }
                }
            }
        });
    },

    bindTree: function (divID, LocationID, isBase) {
        $.ajax({
            type: "GET",
            cache: false,
            url: "/Customer/GetCustomerChildLocation",
            data: { LocationID: LocationID },
            success: function (data) {
                var Model = eval(data.Data);
                if (isBase)
                    locations.setLocationTree(divID, Model);
                else
                    locations.setToSelectParentLocationTree(divID, Model);
            },
            error: function (ex) { alert("Message: " + ex); }
        });
    },

    //Set Location
    setLocationTree: function (divID, Model) {
        $("#treeULList").html('');
        $.each(Model, function (i, value) {
            var clsApply; var styleCls;
            if (value.HasChild) {
                clsApply = 'collapse'; styleCls = '';
            } else {
                clsApply = '';
                styleCls = "style=background-image:none;display:inline-block;width:15px;";
            }
            $("#treeULList").append('<li>' +
                '<div class="collapsible" onclick="locations.onDemandAjax(this)" data-loaded="false" id="divID' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' LocationName="' + value.text + '" HasChild=' + value.HasChild + '>' +
                '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                '<span class="textcls">' +
                '<a href="#">' + value.LocationName + '</a>' +
                '</span></div>' +
                '</li>');
        });
    },

    onDemandAjax: function (xhr) {
        $("#divAddDocumentMapping").show();

        var data = {
            LocationID: $(xhr).attr('LocationID'),
            ParentLocationID: $(xhr).attr('ParentLocationID'),
            LocationName: $(xhr).attr('LocationName'),
            HasChild: $(xhr).attr('HasChild'),
        }
        locations.fireOnNodeSelect(data)

        var this1 = $(xhr);
        var isLoaded = $(xhr).attr('data-loaded');
        if (isLoaded == "false") {
            $(this1).children('span.symbolcls').addClass('loadingP');
            $(this1).children('span.symbolcls').removeClass('collapse');
            // Load data here 
            $.ajax({
                url: "/Customer/GetCustomerChildLocation",
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
                                    '<div class="collapsible" onclick="locations.onDemandAjax(this)" data-loaded="false" id="divID' + ele.LocationID + '" LocationID=' + ele.LocationID + ' ParentLocationID=' + ele.ParentLocationID + ' LocationName="' + ele.text + '" HasChild=' + ele.HasChild + '>' +
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
        //alert('H');
        $("#treeParentULList").html('');
        $.each(Model, function (i, value) {
            var clsApply; var styleCls; var disClass;
            if (value.HasChild) {
                clsApply = 'collapse'; styleCls = '';
            } else {
                clsApply = '';
                styleCls = "style=background-image:none;display:inline-block;width:15px;";
            }
            if (value.LocationID === selectedLocationID)
                disClass = "hideShow";
            else
                disClass = "";

            if (eval(value.LocID) > 0)
                disClass = "hideShow";

            $("#treeParentULList").append('<li>' +
                '<div class="collapsible" onclick="locations.onDemandAjaxParent(this)" data-loaded="false" id="divIDParent' + value.LocationID + '" LocationID=' + value.LocationID + ' ParentLocationID=' + value.ParentLocationID + ' LocationName="' + value.text + '">' +
                '<span class="symbolcls ' + clsApply + '" ' + styleCls + '>&nbsp;</span>' +
                '<span class="textcls">' +
                '<a href="#" class="' + disClass + '">' + value.LocationName + '</a>' +
                '</span></div>' +
                '</li>');
        });
    },

    onDemandAjaxParent: function (xhr) {

        //alert('H');

        if (!($(xhr).find("a").hasClass("hideShow"))) {
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
                    url: "/Customer/GetCustomerChildLocation",
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
                                if (ele.LocationID === selectedLocationID)
                                    disClass = "hideShow";
                                else
                                    disClass = "";

                                if (eval(ele.LocID) > 0)
                                    disClass = "hideShow";

                                $ul.append(
                                    $("<li></li>").append(
                                        '<div class="collapsible" onclick="locations.onDemandAjaxParent(this)" data-loaded="false" id="divIDParent' + ele.LocationID + '" LocationID=' + ele.LocationID + ' ParentLocationID=' + ele.ParentLocationID + ' LocationName="' + ele.text + '">' +
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
        hasObjectInstance = eval(data.hasObjectInstance);
        hasChild = eval(data.HasChild);

        if (selectedLocationID > 0) {
            $("#divEdit i,#divDelete i").removeClass("hideShow");
            locations.SetForClose();
        } else
            $("#divEdit i,#divDelete i").addClass("hideShow");

        if (hasObjectInstance || !hasChild) {
            $("#divObjectInstance i").removeClass("hideShow");
        }
        else {
            $("#divObjectInstance i").addClass("hideShow");
        }
    },

    ChkRootLocation: function () {

        if ($("#ChkRootLocation").prop('checked') == true) {
            $("#divExpandedParentGrid").attr("disabled", "disabled").attr("customerparentlocationname", "");
        }
        else {
            $("#divExpandedParentGrid").removeAttr("disabled").removeAttr("customerparentlocationname");
        }

        //_LocationID = $("#ddlCustomerLocation").val();
    },

    //screen access code start
    ScreenAccessPermission: function () {
        var getAccess = GetScreenAccessPermissions(scrnID);

        if (getAccess[0].HasInsert)
            GetAddButton("#divAdd", 'locations.SetForAdd()');

        if (getAccess[0].HasExport)
            $("#divExport").removeAttr("style");

        if (getAccess[0].HasUpdate)
            GetEditButton("#divEdit", 'locations.GetDataByID(xhr_getData_For_Edit)', 'disabled');

        if (getAccess[0].HasDelete)
            GetDeleteButton("#divDelete", 'locations.DeleteLocation()');

        if (getAccess[0].HasSelect) {
            var flag = false;
            for (var i = 1; i < getAccess.length; i++) {
                if (getAccess.length > 1) {
                    if ((getAccess[i].ActionCode == "ObjectData")) {
                        flag = true;
                    }
                }
            }

            if (!flag) {
                $("#divObjectData").remove();
            }

            var flagSort = false;
            for (var i = 1; i < getAccess.length; i++) {
                if (getAccess.length > 1) {
                    if ((getAccess[i].ActionCode == "CustomerLocSort")) {
                        flagSort = true;
                    }
                }
            }
            if (!flagSort) {
                $("#divSort").remove();
            } else {
                $("#divSort").show();
            }
        }

        GetButton("#divObjectInstance", "locations.RedirectToObjectInstance()", "fa fa-building fa-2x");

        //$("#divEdit i,#divDelete i").prop("disables", true);
        $("#divEdit i,#divDelete i,#divObjectInstance i").addClass("hideShow");

        /*Check Object Instance add access*/
        getAccess = GetScreenAccessPermissions(globalDeryptedScreenID.ObjectInstanceScreenID);
        if (getAccess != undefined && getAccess != null)
            if (getAccess[0].HasSelect && getAccess[0].HasInsert)
                $(".HasObjectInstanceAddColumn").remove();
    },
    //screen access code end

    SetForAdd: function () {
        if (!($("#divAdd i").hasClass("hideShow"))) {
            var locID = eval($("#ddlCustomerLocation").val());
            if (locID > 0 && locID !== undefined) {
                Reset_Form_Errors();

                var Checklevel = ConfigurationData_ConfigurationCodeList();
                var filteredArray = Checklevel.filter(el => el.ConfigurationCode == 'LocLvl');
                var val = "";

                if (filteredArray != "") {

                    val = filteredArray[0].ConfigurationValue;

                    var PLID = $("#treeULList .markselected").attr('parentlocationid');
                    for (i = 1; i < val - 1; i++) {
                        PLID = $("#divID" + PLID).attr('parentlocationid');
                    }

                    if ($("#divID" + PLID).attr('parentlocationid') === undefined || eval(val) === 0) {
                        LoadAddUpdateView(divAddUpdateID, "/Customer/_partialLocationAddUpdate", AddLocation,
                            function () {
                                locations.ClearData();
                                Reload_ddl_GlobalStatic("#ddlRiskLevel", ConfigurationData_RiskLevelList(), null, function () { $("#ddlRiskLevel").val("4"); });
                                locations.setValues();

                                locations.GetLocationRiskLevelData(function () {

                                    locations.BindModelRiskGrid(function () {

                                        $.each(LocationRiskLevelList, function (index, value) {

                                            //$("select[name='RiskLevel'] option:gt(0)").attr("disabled", "disabled");

                                            $("#tblGridModelRisk tbody tr").each(function () {

                                                if (value.ModuleCode == $(this).attr("data-id")) {
                                                    $("#ddlRiskLevel" + value.ModuleCode).val(value.RiskLevelID);

                                                    //$("#ddlRiskLevel" + value.ModuleCode).prop('disabled', true);
                                                    //$("#ddlRiskLevel" + value.ModuleCode + " option").prop('disabled', false);
                                                    $("#ddlRiskLevel" + value.ModuleCode).find("option").eq(0).prop('disabled', true);

                                                    for (var i = 0; i < value.RiskLevelID; i++) {
                                                        $("#ddlRiskLevel" + value.ModuleCode + " option[value=" + i + "]").prop('disabled', true);
                                                    }
                                                }
                                            });

                                        });
                                    });
                                });

                                locations.getExpandedParentNodes(false);
                            });
                        isEdit = false;
                    }
                    else {
                        toastr.warning(Resource.Cannotaddlocation + ' (' + val.toString() + ')');
                    }
                }

            } else {
                toastr.warning(locationWarning);
                var valid = true;
                valid = Validate_Control_NullBlank("#ddlCustomerLocation", locID, "", valid);
                FocusOnError("#divCustInfo", valid);
            }
        }
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
                type: "POST", cache: false, url: "/Customer/AddUpdateCustomerLocationData", data: { Model: FormData },
                success: function (data) {
                    if (data != null) {
                        if (data.Status == 'Success') {
                            if (eval(data.Data) > 0) {
                                //locations.SetForClose();
                                toastr.success(data.Message);
                                locations.bindLocationTree($("#ddlCustomerLocation"));
                            } else
                                toastr.error(data.Message);
                        }
                        else if (data.Message.toString().indexOf("ObjectInstance_CK_LocationHasObjectInstanceThenDontAddNewLocation") >= 0) {
                            toastr.warning(Resource.ParentLocationHasObjectInstance);
                        }
                        else if (data.Message.toString().indexOf("Location_UK_ParentLocationID_LocationName") >= 0) {
                            toastr.warning(LocationNameExist);
                        } else {
                            toastr.error(data.Message);
                        }
                    }
                    else
                        toastr.error(data.Message);
                }
            });
        }
    },

    //Get data for edit
    GetLocationRiskLevelData: function (callback) {
        $.ajax({
            url: "/Customer/GetDataByID", cache: false, data: { LocationID: selectedLocationID, IsChildResult: true },
            success: function (data) {
                if (data != null && data.Status == "Success") {
                    var json_data = eval(data.Data);
                    if (json_data.length > 0) {
                        LocationRiskLevelList = [];
                        LocationRiskLevelList = json_data[0].LocationRiskLevelList;
                    }
                    else
                        LocationRiskLevelList = [];

                    if (callback && typeof (callback) === "function")
                        callback();
                }
            }
        });

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
                    url: "/Customer/GetDataByID", cache: false, data: { LocationID: selectedLocationID, IsChildResult: true },
                    success: function (data) {
                        if (data != null && data.Status == "Success") {
                            LoadAddUpdateView(divAddUpdateID, "/Customer/_partialLocationAddUpdate", EditLocation,
                                function () {
                                    locations.ScreenAccessPermission();
                                    isEdit = true;
                                    var json_data = eval(data.Data);
                                    if (json_data.length > 0) {
                                        if (json_data[0].FileID != null)
                                            $("#spanObjectData").html(Resource.Edit + " " + Resource.ObjectData);
                                        else
                                            $("#spanObjectData").html(Resource.Add + " " + Resource.ObjectData);
                                        locations.getExpandedParentNodes(false);
                                        $("#hf_LocationID").val(json_data[0].LocationID);  //save id into Hidden field edit submit
                                        $("#hf_ParentLocationID").val(json_data[0].ParentLocationID);
                                        $("#txtLocationName").val(json_data[0].LocationName).focus();
                                        $("#txtLatitude").val(json_data[0].Latitude);
                                        $("#txtLongitude").val(json_data[0].Longitude);
                                        $("#txtRemark").val(json_data[0].Remarks);
                                        Reload_ddl_GlobalStatic("#ddlRiskLevel", ConfigurationData_RiskLevelList(), null, function () { $("#ddlRiskLevel").val(json_data[0].RiskLevelID); });

                                        $("#chkCustomer").prop('checked', json_data[0].HasCustomers);
                                        if (eval(json_data[0].CustomerCount) > 0) {
                                            $("#chkCustomer").prop('disabled', true);
                                            $("#chkCustomer").attr('title', hasCustomerTooltipMessage);
                                            $("#chkCustomer").removeAttr('style').parent().removeAttr('style');
                                        }
                                        else {
                                            $("#chkCustomer").prop('disabled', false);
                                            $("#chkCustomer").removeAttr('title');
                                        }

                                        if (json_data[0].ParentLocationID > 0 && json_data[0].ParentLocationID !== null)
                                            locations.getParentButton();
                                        else
                                            $("#btnChangeParentLocation").remove("a");

                                        locations.BindModelRiskGrid(function () {

                                            $.each(json_data[0].LocationRiskLevelList, function (index, value) {
                                                $("#tblGridModelRisk tbody tr").each(function () {
                                                    if (value.ModuleCode == $(this).attr("data-id")) {

                                                        $("#ddlRiskLevel" + value.ModuleCode).val(value.RiskLevelID);
                                                        $("#ddlRiskLevel" + value.ModuleCode).find("option").prop('disabled', true);
                                                        $("#ddlRiskLevel" + value.ModuleCode + " option[value=" + value.RiskLevelID + "]").prop('disabled', false);
                                                        //for (var i = 0; i < value.RiskLevelID; i++) {
                                                        //    $("#ddlRiskLevel" + value.ModuleCode + " option[value=" + i + "]").prop('disabled', true);
                                                        //}
                                                    }
                                                });
                                            });

                                            locations.GetRootAndChildCustomerLocationRiskLevel();
                                        });

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

    ResetData: function () {
        var LocationID = $("#hf_LocationID").val();

        if (LocationID == "" || LocationID == null || LocationID == 0)
            locations.ClearData();
        else
            locations.GetDataByID(xhr_getData_For_Edit, LocationID);
    },

    //Validate form data
    ValidateData: function (FormData) {
        var valid = true;
        var Check = 0;

        valid = Validate_Control_NullBlank("#txtLocationName", FormData.LocationName, "", valid);

        $("#tblGridModelRisk tbody tr").each(function () {
            var ModuleCode = $(this).attr("data-id");
            var RiskLevelID = $(this).find("td select#ddlRiskLevel" + ModuleCode + "").val();

            if (RiskLevelID == "" || RiskLevelID == null) {
                valid = Validate_Control_NullBlank($(this).find("td select#ddlRiskLevel" + ModuleCode + ""), $(this).find("td select#ddlRiskLevel" + ModuleCode + "").val(), Resource.Required, valid);
                Check = 1;
                valid = false;
            }
        });

        if (Check == 1) {
            toastr.warning(SelectRiskLevel);
        }

        FocusOnError("#frm_Location", valid);

        return valid;
    },

    //Get form data
    GetData: function () {
        var Data = {};
        Data["CustomerID"] = customerID;
        Data["LocationID"] = $("#hf_LocationID").val();
        Data["LocationName"] = $("#txtLocationName").val().trim();
        Data["ParentLocationID"] = $("#hf_ParentLocationID").val().trim();
        Data["HasCustomers"] = $("#chkCustomer").is(":checked");
        Data["Longitude"] = $("#txtLongitude").val().trim();
        Data["Latitude"] = $("#txtLatitude").val().trim();
        //Data["RiskLevelID"] = $("#ddlRiskLevel").val();
        Data["Remarks"] = $("#txtRemark").val().trim();
        Data["CurrentScreenID"] = scrnID;

        var LocationRiskLevel_TableTypeList = [];

        $("#tblGridModelRisk tbody tr").each(function () {
            var ModuleCode = $(this).attr("data-id");

            if (parseInt($(this).find("td select#ddlRiskLevel" + ModuleCode + "").val()) > 0) {

                LocationRiskLevel_TableTypeList.push({
                    ModuleCode: $(this).attr("data-id"),
                    RiskLevelID: $(this).find("td select#ddlRiskLevel" + ModuleCode + "").val()
                });
            }
        });

        Data["LocationRiskLevel_TableTypeList"] = LocationRiskLevel_TableTypeList;
        return Data;
    },

    //Clear form data
    ClearData: function () {
        Reset_Form_Errors();
        Clear_Form_Fields("#frm_Location");
        $("#txtLocationName").focus();
    },

    SetForClose: function () {
        $(divAddUpdateID).html('').hide();
    },

    DeleteLocation: function () {
        if (!($("#divDelete i").hasClass("hideShow"))) {
            if (selectedLocationID > 0)
                DeleteData(locations.xhr_getData_For_Delete, "/Customer/DeleteLocation", { LocationID: selectedLocationID, CurrentScreenID: scrnID }, selectedLocationText, function () { locations.bindLocationTree($("#ddlCustomerLocation")); });
        }
    },

    getParentButton: function () {
        $("#divExpandedParent").append('<a id="btnChangeParentLocation" style="margin-top: 5px;" onclick="locations.ShowParentTree();" title="' + ChangeParentLocationText + '" class="label label-lg label-pink pull-left">Change</a>&nbsp;');
    },

    refreshTreeView: function () {
        locationID = null;
        $("div.collapsible").removeClass("markselected");
        selectedLocationID = null;
        selectedParentLocationID = null;
        selectedLocationText = null;
        $("#divEdit i,#divDelete i").addClass("hideShow");
        $("#divAdd i").removeClass("hideShow");
        locations.SetForClose();
        locations.GetLocation("#locationTreeView", locationID);

        Reload_ddl_Global(xhr_CustomerLocation, "#ddlCustomerLocation", "/AjaxCommonData/GetCustomerLocation" /*/AjaxCommonData/GetCustomerLocation*/, { CustomerID: customerID }, null, function () {
            locations.bindLocationTree($("#ddlCustomerLocation"));
            locations.GetCustomerName();

            //if ($("#ddlCustomerLocation option").length == 0) {
            //    $("#ddlCustomerLocation").append("<option>" + Resource.Select + "</option>");
            //}
        });
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
            if (!isEdit) {
                if (selectedLocationText !== null)
                    locationArr.push(selectedLocationText);
            }
            var parentid = $("#divID" + selectedLocationID).attr("parentlocationid");
            locations.getparentText(parentid);
            locationArr.push(customerLocationText);
        }
        return locationArr;
    },

    getparentText: function (parentid) {
        if (parentid !== undefined && parentid !== null && parentid !== "null" && parentid !== "") {
            var text = $("#divID" + parentid).attr("LocationName");
            if (text !== undefined)
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
            locationArr.push(customerLocationText);
        }
        return locationArr;
    },

    getparentTextPopUp: function (parentid) {
        if (parentid !== undefined && parentid !== null && parentid !== "null" && parentid !== "") {
            var text = $("#divIDParent" + parentid).attr("LocationName");
            if (text !== undefined)
                locationArr.push(text);
            var parentid = $("#divIDParent" + parentid).attr("parentlocationid");
            locations.getparentTextPopUp(parentid);
        }
    },

    ShowParentTree: function () {
        $("#locationTreePopup").modal("show");
        locations.bindTree("#locationTreeViewPopup", locationID, false);
    },

    GetParentlocation: function () {
        selectedParentLocationID = tempParentLocationID;
        $("#hf_ParentLocationID").val(selectedParentLocationID);
        tempParentLocationID = null;
        locations.getExpandedParentNodes(true);
        $("#locationTreePopup").modal("hide");
        selectedLocationText = tempLocationText;
        tempLocationText = null;
        locations.getParentButton();
    },

    bindLocationTree: function (xhr) {
        locationID = eval($(xhr).val());
        if (locationID > 0 && locationID !== undefined) {
            locations.GetLocation("#locationTreeView", locationID);
            var data = {
                LocationID: locationID,
                LocationName: $(xhr).find('option:selected').text()
            }
            locations.fireOnCustomerLocationSelect(data)
        } else {
            locations.SetForClose();
            locations.GetLocation("#locationTreeView", locationID);
        }
    },

    fireOnCustomerLocationSelect: function (data) {
        // Selected
        selectedLocationID = eval(data.LocationID);
        customerLocationText = data.LocationName;
        selectedLocationText = null;
        $("#divEdit i,#divDelete i").addClass("hideShow");
        locations.SetForClose();
    },

    RedirectToObjectInstance: function () {
        if (!($("#divObjectInstance i").hasClass("hideShow"))) {
            window.location = "/Safety/ObjectInstance/ObjectInstance?CID=" + customerID + "&LocationID=" + selectedLocationID + "&GlobalID=" + globalScreenID.ObjectInstanceScreenID;
        }
    },

    RedirectToObjectData: function (_Id) {
        window.location = "/ObjectData/ObjectData?CustomerID=" + customerID + "&LocationID=" + selectedLocationID + "&GlobalID=" + EncryptScreenID;
    },


    /*-Sorting-----------------------------------------------------------------------------------------------------------------------*/
    BindGridSort: function () {
        Reset_Form_Errors();

        //$("#frm_ChecklistTaskGroupGrid .has-error").removeClass("has-error");
        //ResetFormErrors("#frm_ChecklistTaskGroupGrid");

        var FormData = locations.GetDataGridSort();

        if (locations.ValidateDataGridSort(FormData)) {

            LoadGridCustom(locations.xhr_GetData, "tblGrid", "/Customer/GetCustomerChildLocation", FormData, function (Data) {

                $("#dtMaster_wrapper").show();
                $("#tblGrid,#tblGrid thead tr th").removeAttr("style");
                $("#tblGrid").attr("style", "width:100%;");
                SelectAll("tblGridHeaderSelect", "tblGridRowSelect");
                $("#chkGridMutileDelete").prop("checked", false).change();
                //ShowTotalCount(Resource.TotalObjectInstance, 'tblGrid_length', Data.length);

            }, function () {
                $("#tblGrid_length select option:last").attr("selected", "selected").change();
                $("#tblGrid_length select").prop("disabled", true);
                $("#tblGrid_paginate").hide();
                locations.ScreenAccessPermission();
            });
        }
    },

    Sort: function () {

        var FormData = locations.GetDataGridSort();
        if (locations.ValidateDataGridSort(FormData)) {
            Reset_Form_Errors();
            LoadAddUpdateView(divAddUpdateID, "/Customer/_partialLocationSorting", 'Sort',
                function () {
                    locations.BindGridSort();
                    $("#tblGrid_paginate").hide();
                    $('#tblGrid tbody').addClass('sortable');

                    $('.sortable').sortable({
                        disabled: false,
                        update: function (event, ui) {
                            var index = ui.item.index();
                            var dataid = ui.item[0].attributes[1].value;
                            //alert(index);

                            xhr_UpdateSortingData = AddUpdateData("/Customer/UpdateSortingGrid", { Type: 'Customer Location', ID: dataid, Index: index + 1/*why 2 but it 1 at checklist task*/ }, function (data) {
                                if (data != null && data.Status == "Success") {
                                    var Model = eval(data.Data);
                                    if (Model > 0) {
                                        locations.BindGridSort();
                                    }
                                    else {
                                        locations.BindGridSort();
                                    }

                                } else toastr.error(data.Message);
                            }, function () {
                                locations.BindGridSort();
                            });
                            //Ajax call for update sequence ends here
                        }
                    });
                });
        } else {
            $('#tblGrid tbody').sortable({ disabled: true });
        }
    },

    GetDataGridSort: function () {
        var LocId = 0;

        if (selectedLocationID > 0) {
            LocId = selectedLocationID;
        }
        else {
            LocId = $("#ddlCustomerLocation").val();
        }
        return {
            locationID: LocId,
            CurrentScreenID: scrnID,
            CurrentLanguageCode: CurrentLang
        };
    },

    ValidateDataGridSort: function (FormData) {
        var valid = true;

        valid = Validate_Control_NullBlank("#ddlCustomerLocation", FormData.locationID, Resource.Required, valid);

        return valid;
    },

    /*-Sorting End--------------------------------------------------------------------------------------------------------------------*/

    BindGrid: function (DocumentCategoryID, LocationID) {

        LoadGridWithoutPagination(xhr_GetData, "tblDocumentGrid", "/UserRole/GetDocumentForUserRole", { DocumentCategoryID: DocumentCategoryID, IsChildResult: false }, function (data) {
            var HeaderControlclass = "tblDocumentGridHeader";
            var RowControlClass = "tblDocumentGridRow";
            var DocCount = eval(data.length);

            $("#hf_DocMappLocationID").val(LocationID);

            /* Function For select all checkbox */
            SelectAll(HeaderControlclass, RowControlClass);

            GetAjaxData("/UserRole/GetDocumentMapping", { EntityID: LocationID, EntityType: "Location" }, function (data) {
                if (data != null && data.Status == "Success") {
                    var model = eval(data.Data);

                    $.each(model, function (j, item1) {
                        var RowsCount;
                        var cid = item1.DocumentID;
                        $('#' + cid + 'Document').attr('checked', true);
                    });

                    if (eval(DocCount) === eval(model.length)) {
                        $("input:checkbox[name=checks]").attr('checked', true);
                    }
                }

            }, null)

        });
    },
}

var DocumentMapping = {

    SetForDocumentMapping: function (xhr, id) {

        LoadAddUpdateView(divAddUpdateID, "/Location/_partialDocumentMappingView", Resource.DocumentMapping,
            function () {
                DocumentMapping.BindGrid("", id);
            });
    },

    BindGrid: function (DocumentCategoryID, LocationID) {

        LoadGridWithoutPagination(xhr_GetData, "tblDocumentGrid", "/UserRole/GetDocumentForUserRole", { DocumentCategoryID: DocumentCategoryID, IsChildResult: false }, function (data) {
            var HeaderControlclass = "tblDocumentGridHeader";
            var RowControlClass = "tblDocumentGridRow";
            var DocCount = eval(data.length);

            $("#hf_DocMappLocationID").val(LocationID);

            /* Function For select all checkbox */
            SelectAll(HeaderControlclass, RowControlClass);

            GetAjaxData("/UserRole/GetDocumentMapping", { EntityID: LocationID, EntityType: "Location" }, function (data) {
                if (data != null && data.Status == "Success") {
                    var model = eval(data.Data);

                    $.each(model, function (j, item1) {
                        var RowsCount;
                        var cid = item1.DocumentID;
                        $('#' + cid + 'Document').attr('checked', true);
                    });

                    if (eval(DocCount) === eval(model.length)) {
                        $("input:checkbox[name=checks]").attr('checked', true);
                    }
                }

            }, null)

        });
    },

    AddUpdate: function () {
        Reset_Form_Errors();
        var id = $("#hf_DocMappLocationID").val();
        var FormData = DocumentMapping.GetDocumentMappingData();
        if (DocumentMapping.ValidateDocumentMappingData(FormData)) {
            AddUpdateData("/UserRole/AddUpdateDocumentMapping", { Model: FormData }, function () {

                locations.BindData();
                //locations.GetLocation("#locationTreeView", $("#hf_DocMappLocationID").val());
                DocumentMapping.ClearData();
                DocumentMapping.SetForClose();
            }, function (responce_data) {//Handle Error Block

            });
        }
    },

    GetDocumentMappingData: function () {
        var DocumentMapping;
        var DocumentID_TableTypeList = [];

        DocumentMapping = {
            EntityType: "Location",
            EntityID: $("#hf_DocMappLocationID").val(),
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
        var _id = $("#hf_DocMappLocationID").val();
        DocumentMapping.BindGrid("", _id);
        $('.tblDocumentGridHeader').prop('checked', false);
    },

    ValidateDocumentMappingData: function (FormData) {
        var valid = true;

        return valid;
    },

    ClearCategoryData: function () {

        DocumentMapping.SetForDocumentMapping(xhr_SetForm_For_Permission, $("#hf_DocMappLocationID").val());
    },

    ShowDocumentMapping: function () {

        DocumentMapping.SetForDocumentMapping(xhr_SetForm_For_Permission, $("#treeULList .markselected").attr('locationid'));
    },
};

var Document = {

    BindGrid: function (DocumentCategoryID) {

        var LocationID = $("#treeULList .markselected").attr('locationid');

        LoadGridWithoutPagination(xhr_GetData, "tblDocumentGrid", "/UserRole/GetDocumentForUserRole", { DocumentCategoryID: DocumentCategoryID, IsChildResult: false }, function (data) {
            var HeaderControlclass = "tblDocumentGridHeader";
            var RowControlClass = "tblDocumentGridRow";
            var DocCount = eval(data.length);

            $("#hf_DocMappLocationID").val(LocationID);

            /* Function For select all checkbox */
            SelectAll(HeaderControlclass, RowControlClass);

            GetAjaxData("/UserRole/GetDocumentMapping", { EntityID: LocationID, EntityType: "Location" }, function (data) {
                if (data != null && data.Status == "Success") {
                    var model = eval(data.Data);
                    var selectDoc = 0
                    $.each(model, function (j, item1) {
                        var RowsCount;
                        var cid = item1.DocumentID;
                        $('#' + cid + 'Document').attr('checked', true);
                    });

                    $("#tblDocumentGrid tbody tr").each(function () {
                        if ($(this).find("td:first input:checkbox").is(":checked")) {
                            selectDoc = Number(selectDoc) + 1;
                        }
                    });

                    if (DocCount === selectDoc) {
                        $("input:checkbox[name=checks]").attr('checked', true);
                    }
                    else {
                        $("input:checkbox[name=checks]").attr('checked', false);
                    }
                }

            }, null)

        });
    },

    ResetCategoryData: function () {

        DocumentMapping.SetForDocumentMapping(xhr_SetForm_For_Permission, $("#hf_DocMappLocationID").val());

        //Document.ClearData();
        //Document.SetForClose()
        //Clear_ddl_Global2("#divExpandedCategoryGrid", "Select");
        //$("#hf_AddEditParentCategoryID").val("");
        //Document.BindGrid("");
    },

    FileDownload: function (_id, FileType, FilePath) {

        var valFileDownloadPath = ProjectURL.BaseURL + '/Documents/' + FilePath + FileType;
        window.open(valFileDownloadPath, '_blank');
    },
}