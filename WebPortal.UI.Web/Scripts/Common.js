/*Custom Jquery Plug in Written Rajendra to Check element has attribute*/
/* Deviation Resolution Graph Colors*/
var RiskLevelGraphColor = { "High": "#ff0000", "Medium": "#fcc100", "Low": "#84b761", "None": "#778899" };
var DeviationCategoryGraphColor = { 0: "#9400D3", 1: "#6495ED", 2: "#DC143C", 3: "#DB7093", 4: "#cd82ad" };
var DeviationResolutionGraphColor = { 0: "#6495ED", 1: "#9400D3", 2: "#DC143C", 3: "#6495ED", 4: "#9400D3" };

/* Name: Color Utility
   Author:Sagar
   Date: 8-OCT-2918
   Use: First 20 Colours Fixed
*/
var dataColors = {
    0: "#91A8D0", 1: "#7F4145", 2: "#BD3D3A", 3: "#D5AE41", 4: "#E47A2E", 5: "#009B77", 6: "#D1B894", 7: "#EC9787", 8: "#672E3B", 9: "#92B6D5",
    10: "#006E51", 11: "#98DDDE", 12: "#6B5B95", 13: "#B18F6A", 14: "#F7CAC9", 15: "#92A8D1", 16: "#D65076", 17: "#006E6D", 18: "#C3447A", 19: "#98B4D4"
};

var InspectionColors = { Controlled: '#008000', NotControlled: '#FF0000', Future: '#FFA500', RiskMatrix: '#e43f3f', Controls: '#2a8a65' };
var color = { Controlled: '#008000', NotControlled: '#FF0000', Future: '#FFA500', RiskMatrix: '#e43f3f', Controls: '#2a8a65' };
/* Deviation Resolution Graph Colors
var RiskLevelGraphColor = { "High": "#ff0000", "Medium": "#fcc100", "Low": "#84b761", "None": "NULL" };
var DeviationCategoryGraphColor = { 0: "#9400D3", 1: "#6495ED", 2: "#DC143C", 3: "#DB7093", 4: "#cd82ad" };
var DeviationResolutionGraphColor = { 0: "#6495ED", 1: "#9400D3", 2: "#DC143C", 3: "#6495ED", 4: "#9400D3" };*/

/*Training Graph*/
var TrainingCertificationAndCoursesGraphColor = { 0: "#6495ED", 1: "#9400D3", 2: "#DC143C", 3: "#82af6f", 4: "#cd82ad" };

/*Training ARFF TRAINING SCHEDULE Graph*/
var TrainingScheduleColors = ["#6FB3E0", "#FFB752", "#9585BF", "#87B87F", "#A0A0A0", "#D15B47", "#FEE188", "#d54c7e", "#555", "#85b558", "#2a8bcb"]

var Month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
var CommonDayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var CommonDayShortName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

/*Is Deviation Responce Required use for hide show designation and department */
var GlobaleIsGroupRequired = 'IsGroupRequired';
var GlobaleIsDevRespRequired = 'IsDevRespRequired';

/*var DayNameResource = [Resource.Sunday, Resource.Monday, Resource.Tuesday, Resource.Wednesday, Resource.Thursday, Resource.Friday, Resource.Saturday];
var DayNameResource = [{ Day: "Sun", Name: "Sunday" }, { Day: "Mon", Name: "Monday" }, { Day: "Tue", Name: "Tuesday" }, { Day: "Wed", Name: "Wednesday" }, { Day: "Thu", Name: "Thursday" }, { Day: "Fri", Name: "Friday" }, { Day: "Sat", Name: "Saturday" }];*/

var CommonTodayDate = new Date();
/*  Current Month 1st day and last day */
var CommonFirstDay = new Date(CommonTodayDate.getFullYear(), CommonTodayDate.getMonth(), 1);
var CommonLastDay = new Date(CommonTodayDate.getFullYear(), CommonTodayDate.getMonth() + 1, 0);

/*  Current Year 1st day and last day */
var CurrentYearFirstDay = new Date(CommonTodayDate.getFullYear(), 0, 1);
var CurrentYearLastDay = new Date(CommonTodayDate.getFullYear(), 11, 31);

/* Added By Sagar */
/* Current Week 1st day */

var Weekstart = new Date(CommonTodayDate.setDate(CommonTodayDate.getDate() - CommonTodayDate.getDay() + 1));

$.fn.hasAttr = function (name) {
    return this.attr(name) !== undefined;
};
/*jQuery.ajaxSettings.traditional = true;*/

/*Ajax Helpers start*/
function CommaFormatted(amount) {

    if (amount > 0) {
        var delimiter = ",";
        var Amount = amount + '.00';
        var a = Amount.split('.', 2)
        var d = a[1];
        var i = parseInt(a[0]);
        if (isNaN(i)) { return ''; }
        var minus = '';
        if (i < 0) { minus = '-'; }
        i = Math.abs(i);
        var n = new String(i);
        var a = [];
        while (n.length > 3) {
            var nn = n.substr(n.length - 3);
            a.unshift(nn);
            n = n.substr(0, n.length - 3);
        }
        if (n.length > 0) { a.unshift(n); }
        n = a.join(delimiter);
        if (d.length < 1) { amount = n; }
        else { amount = n + '.' + d; }
        amount = minus + amount;
    }

    return amount;
}

function SetddlItem(controlID, length, value) {

    if (length === 1 && value == null) {

        if ($(controlID + " option:first").val() == '' || $(controlID + " option:first").val() == "" ||
            $(controlID + " option:first").val() == null) {

            $(controlID + " option:first").remove();
        }
        /*set default element*/
        $(controlID).val($(controlID + " option:first").val());

    } else if (value != null)
        $(controlID).val(value);
}

function Clear_ddl_Global(ddlID, DefaultLabel) {
    if (DefaultLabel == null || DefaultLabel == "")
        DefaultLabel = Resource.Select;
    $(ddlID).empty().html("<option value>" + DefaultLabel + "</option>");
}

function GetDayWiseResourceKey(Name) {

    var day = "";

    switch (Name) {

        case 'Sun':
            day = Resource.Sunday;
            break;
        case 'Mon':
            day = Resource.Monday;
            break;
        case 'Tue':
            day = Resource.Tuesday;
            break;
        case 'Wed':
            day = Resource.Wednesday;
            break;
        case 'Thu':
            day = Resource.Thursday;
            break;
        case 'Fri':
            day = Resource.Friday;
            break;
        case 'Sat':
            day = Resource.Saturday;
    }

    return day;
}

function Clear_ddl_Globalmultiselect(ddlID, DefaultLabel) {
    $(ddlID).empty().html("<option value>" + DefaultLabel + "</option>");
}

function Clear_ddl_Global2(ddlID, DefaultLabel) {
    if (DefaultLabel == null || DefaultLabel == "")
        DefaultLabel = "Select";
    $(ddlID).empty().html("<option value='' style='text-align: left;'>" + DefaultLabel + "</option>");
    /*$(ddlID).html("<option value=''>" + DefaultLabel + "</option>");*/
}

function Reload_ddl_GlobalWithPost(xhr, ddlID, AjaxURL, AjaxData, DefaultLabel, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    $(ddlID).html("").empty();

    if ($(ddlID).has('option').length === 0) {

        xhr = $.ajax({
            type: "POST", cache: false, url: AjaxURL, data: AjaxData,
            /*url: AjaxURL, traditional: true, cache: false, data: AjaxData,*/
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var items = eval(data.Data);

                    if (DefaultLabel != null && DefaultLabel != '')
                        $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

                    for (var i = 0; i < items.length; i++)
                        if ($(ddlID + " option[value='" + items[i].Value + "']").length === 0)
                            $(ddlID).append("<option  value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");

                    /*$(ddlID).change(); Fire the change event to initiate chained items.*/
                    if (callback && typeof (callback) === "function")
                        callback(data);
                } else
                    toastr.error(data.Message);
            }
        });
    }
}

function Reload_ddl_Global(xhr, ddlID, AjaxURL, AjaxData, DefaultLabel, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    $(ddlID).html("").empty();

    if ($(ddlID).has('option').length === 0) {
        xhr = $.ajax({
            url: AjaxURL, traditional: true, cache: false, data: AjaxData,
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    var items = eval(data.Data);

                    if (DefaultLabel != null && DefaultLabel != '')
                        $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

                    for (var i = 0; i < items.length; i++)
                        if ($(ddlID + " option[value='" + items[i].Value + "']").length === 0)
                            $(ddlID).append("<option  value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");

                    /*$(ddlID).change(); Fire the change event to initiate chained items.*/
                    if (callback && typeof (callback) === "function")
                        callback(data);
                } else
                    toastr.error(data.Message);
            }
        });
    }
}

function Reload_ddl_GlobalCustom(xhr, ddlID, AjaxURL, AjaxData, DefaultLabel, PreCallback, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    $(ddlID).html("").empty();

    if ($(ddlID).has('option').length === 0) {

        xhr = $.ajax({
            url: AjaxURL, traditional: true, cache: false, data: AjaxData,
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    if (DefaultLabel != null && DefaultLabel != '')
                        $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

                    var items = eval(data.Data);

                    if (PreCallback && typeof (PreCallback) === "function")
                        items = PreCallback(items);

                    for (var i = 0; i < items.length; i++)
                        if ($(ddlID + " option[value='" + items[i].Value + "']").length === 0)
                            $(ddlID).append("<option  value='" + items[i].Value + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");

                    /*$(ddlID).change(); Fire the change event to initiate chained items.*/

                    if (callback && typeof (callback) === "function")
                        callback();
                } else
                    toastr.error(data.Message);
            }
        });
    }
}

function Reload_ddl_GlobalCustomWithDataID(xhr, ddlID, AjaxURL, AjaxData, DefaultLabel, PreCallback, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    $(ddlID).html("");
    $(ddlID).empty();

    if ($(ddlID).has('option').length === 0) {

        xhr = $.ajax({
            url: AjaxURL,
            traditional: true,
            cache: false,
            data: AjaxData,
            /*dataType: "application/json",*/
            success: function (data) {
                if (data != null && data.Status == "Success") {

                    if (DefaultLabel != null && DefaultLabel != '')
                        $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

                    var items = eval(data.Data);
                    if (PreCallback && typeof (PreCallback) === "function")
                        items = PreCallback(items);

                    for (var i = 0; i < items.length; i++)
                        if ($(ddlID + " option[value='" + items[i].Value + "']").length === 0)
                            $(ddlID).append("<option value='" + items[i].Value + "' data-id='" + items[i].CategoryID + "' " + (items[i].Selected == true ? "selected='selected'" : "") + ">" + items[i].Text + "</option>");

                    /*$(ddlID).change(); Fire the change event to initiate chained items.*/

                    if (callback && typeof (callback) === "function")
                        callback();

                } else
                    toastr.error(data.Message);
            }
        });
    }
}

function Reload_ddl_GlobalStatic(ddlID, TypeOrJsonData, DefaultLabel, callback) {

    $(ddlID).html("").empty();
    var ItemJsonList = "";

    switch (TypeOrJsonData) {
        case "Language": { ItemJsonList = ConfigurationData_LanguageList(); break; }
        case "Module": { ItemJsonList = ConfigurationData_ModuleList(); break; }
        case "ModuleAll": { ItemJsonList = ConfigurationData_ModuleListAll(); break; }
        case "Country": { ItemJsonList = ConfigurationData_CountryList(); break; }
        case "ServiceLine": { ItemJsonList = ConfigurationData_ServiceLineList(); break; }
        case "TimeUnit": { ItemJsonList = ConfigurationData_TimeUnitList(); break; }
        case "RiskLevel": { ItemJsonList = ConfigurationData_RiskLevelList(); break; }
        case "SeverityLevel": { ItemJsonList = ConfigurationData_SeverityLevelList(); break; }
        case "PriorityLevel": { ItemJsonList = ConfigurationData_PriorityLevelList(); break; }
        case "AttributeType": { ItemJsonList = ConfigurationData_AttributeTypeList(); break; }
        case "InspectionType": { ItemJsonList = ConfigurationData_InspectionTypeList(); break; }
        case "FRASInpectionType": { ItemJsonList = ConfigurationData_FRASInspectionTypeList(); break; }
        case "ServiceLevel": { ItemJsonList = ConfigurationData_ServiceLevelList(); break; }
        case "ConfigurationCode": { ItemJsonList = ConfigurationData_ConfigurationCodeList(); break; }
        default: { ItemJsonList = TypeOrJsonData; break; }
    }

    if (ItemJsonList.length > 0) {

        if (DefaultLabel != null && DefaultLabel != '')
            $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

        $.each(ItemJsonList, function (i, item) {
            if ($(ddlID + " option[value='" + item.Value + "']").length === 0)
                $(ddlID).append("<option value='" + item.Value + "'>" + item.Text + "</option>");
        });

        if (callback && typeof (callback) === "function")
            callback(ItemJsonList);
    } else {
        if (DefaultLabel != "" && DefaultLabel != null) {
            $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");
        }
    }
}

function Reload_ddl_GlobalGroupStatic(ddlID, TypeOrJsonData, DefaultLabel, GroupArray, callback) {

    $(ddlID).html("").empty();
    var ItemJsonList = "";

    /*switch (TypeOrJsonData) {
        case "Language": { ItemJsonList = ConfigurationData_LanguageList(); break; }
        case "Module": { ItemJsonList = ConfigurationData_ModuleList(); break; }
        case "ModuleAll": { ItemJsonList = ConfigurationData_ModuleListAll(); break; }
        case "Country": { ItemJsonList = ConfigurationData_CountryList(); break; }
        case "ServiceLine": { ItemJsonList = ConfigurationData_ServiceLineList(); break; }
        case "TimeUnit": { ItemJsonList = ConfigurationData_TimeUnitList(); break; }
        case "RiskLevel": { ItemJsonList = ConfigurationData_RiskLevelList(); break; }
        case "SeverityLevel": { ItemJsonList = ConfigurationData_SeverityLevelList(); break; }
        case "AttributeType": { ItemJsonList = ConfigurationData_AttributeTypeList(); break; }
        case "InspectionType": { ItemJsonList = ConfigurationData_InspectionTypeList(); break; }
        case "FRASInpectionType": { ItemJsonList = ConfigurationData_FRASInspectionTypeList(); break; }
        case "ServiceLevel": { ItemJsonList = ConfigurationData_ServiceLevelList(); break; }
        case "ConfigurationCode": { ItemJsonList = ConfigurationData_ConfigurationCodeList(); break; }
        default: { ItemJsonList = TypeOrJsonData; break; }
    }*/
    ItemJsonList = TypeOrJsonData;

    if (ItemJsonList.length > 0) {

        if (DefaultLabel != null && DefaultLabel != '')
            $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");

        if (GroupArray.length > 0) {

            $.each(GroupArray, function (j, item2) {
                $(ddlID).append("<optgroup label='" + item2 + "'></optgroup>");

                $.each(ItemJsonList, function (i, item) {

                    if (item.GlobalID == item2) {
                        if ($(ddlID + " option[value='" + item.Value + "']").length === 0)
                            $(ddlID + " optgroup[label='" + item2 + "']").append("<option value='" + item.Value + "'>" + item.Text + "</option>");
                    }
                });

            });
        }

        if (callback && typeof (callback) === "function")
            callback(ItemJsonList);
    } else {
        if (DefaultLabel != "" && DefaultLabel != null) {
            $(ddlID).html("<option value=''>" + DefaultLabel + "</option>");
        }
    }
}

function DualListBoxShiftAtoB(ddlSourseID, ddlDestinationID, IsSourseDelete) {
    var thevalue = $(ddlSourseID).val();

    if (thevalue[0] != null && thevalue[0] != "") {
        if (!(0 != $(ddlDestinationID + " option[value='" + thevalue[0] + "']").length)) {
            $(ddlDestinationID).append("<option value='" + thevalue[0] + "'>" + $(ddlSourseID + " option:selected").text() + "</option>");
            if (IsSourseDelete) $(ddlSourseID + " option[value='" + thevalue[0] + "']").remove();
        }
    }
}

function Reload_lbl_Global(xhr, lblID, AjaxURL, AjaxData, callback) {

    if (xhr && xhr.readystate != 4) {
        xhr.abort();
    }

    $(lblID).html("");
    xhr = $.ajax({
        url: AjaxURL,
        cache: false,
        data: AjaxData,
        /*dataType: "application/json",*/
        success: function (data) {
            if (data != null && data.Status == "Success") {

                var Model = eval(data.Data);

                $(lblID).html(Model.Text);
                $(lblID).attr("data-val", Model.Value);

                if (callback && typeof (callback) === "function") {
                    callback();
                }

            } else {
                toastr.error("Error occured while loading the data.");
            }
        }
    });
}

function ClearTextBox(MyArray) {
    jQuery.each(MyArray, function (i, val) { try { $(val).val(""); } catch (e) { } });
}
/*Ajax Helpers end*/

/*Grid Pagination helper start*/
/*Bind grid*/
function loadTable(tableID, model) {

    if ($.fn.DataTable.isDataTable("#" + tableID)) {
        $("#" + tableID).DataTable().destroy();
    }

    $("#" + tableID + " tbody").html("");
    $("#Grid_Data_Template_" + tableID).tmpl(model).appendTo("#" + tableID + " tbody");

    var options = {
        /*"aaSorting": [[0, 'asc']],*/
        "language": {
            "lengthMenu": "" + GridResourse.msgDisplay + " _MENU_ " + GridResourse.msgRecords + "",
            "zeroRecords": GridResourse.msgNothingFound,
            "info": "" + GridResourse.msgShowingPage + " _PAGE_ " + GridResourse.msgOf + " _PAGES_",
            "infoEmpty": GridResourse.msgNorecords,
            "infoFiltered": "(" + GridResourse.msgFiltered + " _MAX_ " + GridResourse.msgTotalRecords + ")",
            "sSearch": GridResourse.msgSearch + ": ",
            "oPaginate": { "sNext": GridResourse.msgNext, "sPrevious": GridResourse.msgPrevious }
        },

        //"bProcessing": true,
        //"sAutoWidth": false,
        "bDestroy": true,
        //"sPaginationType": "bootstrap", // full_numbers
        //"iDisplayStart ": 10,
        //"iDisplayLength": 10,
        "bPaginate": true, //hide pagination
        "bFilter": true, //hide Search bar
        "bInfo": true, // hide showing entries
    };

    var defaultRecordOrderby = $("#" + tableID + ' thead tr:first').attr("defaultRecordOrderby");

    if (defaultRecordOrderby == undefined || defaultRecordOrderby == null) {
        options["aaSorting"] = [[0, 'asc']];
    } else {
        options["aaSorting"] = eval(defaultRecordOrderby);
    }

    var columss = [];
    $("#" + tableID + " thead tr th").each(function () {
        if (!$(this).hasClass("sorting_disabled"))
            columss.push({ bSortable: true });
        else {
            columss.push({ bSortable: false });
        }
        options["aoColumns"] = columss;
    });

    if (model.length > 100) {
        options["lengthMenu"] = [10, 25, 50, 100, model.length];
    }

    $("#" + tableID).DataTable(options);

    //$("#" + tableID + " thead tr th[sorting=disabled]").removeClass("sorting");
    $("#" + tableID + " tbody .dataTables_empty").parent("tr").remove();
}

function loadTableWithoutPaging(tableID, model) {

    if ($.fn.DataTable.isDataTable("#" + tableID)) {
        $("#" + tableID).DataTable().destroy();
    }

    $("#" + tableID + " tbody").html("");
    $("#Grid_Data_Template_" + tableID).tmpl(model).appendTo("#" + tableID + " tbody");

    var options = {
        /*"aaSorting": [[0, 'asc']],*/
        "language": {
            "lengthMenu": "" + GridResourse.msgDisplay + " _MENU_ " + GridResourse.msgRecords + "",
            "zeroRecords": GridResourse.msgNothingFound,
            "info": "" + GridResourse.msgShowingPage + " _PAGE_ " + GridResourse.msgOf + " _PAGES_",
            "infoEmpty": GridResourse.msgNorecords,
            "infoFiltered": "(" + GridResourse.msgFiltered + " _MAX_ " + GridResourse.msgTotalRecords + ")",
            "sSearch": GridResourse.msgSearch + ": ",
            "oPaginate": { "sNext": GridResourse.msgNext, "sPrevious": GridResourse.msgPrevious }
        },

        //"bProcessing": true,
        //"sAutoWidth": false,
        "bDestroy": true,
        //"sPaginationType": "bootstrap", // full_numbers
        //"iDisplayStart ": 10,
        "iDisplayLength": 10,//model.length,
        "bPaginate": false, //hide pagination
        "bFilter": true, //hide Search bar
        "bInfo": true, // hide showing entries
    };

    var defaultRecordOrderby = $("#" + tableID + ' thead tr:first').attr("defaultRecordOrderby");

    if (defaultRecordOrderby == undefined || defaultRecordOrderby == null) {
        options["aaSorting"] = [[0, 'asc']];
    } else {
        options["aaSorting"] = eval(defaultRecordOrderby);
    }

    var columss = [];
    $("#" + tableID + " thead tr th").each(function () {
        if (!$(this).hasClass("sorting_disabled"))
            columss.push({ bSortable: true });
        else {
            columss.push({ bSortable: false });
        }
        options["aoColumns"] = columss;
    });

    if (model.length > 100) {
        options["lengthMenu"] = [10, 25, 50, 100, model.length];
    }

    $("#" + tableID).DataTable(options);

    //$("#" + tableID + " thead tr th[sorting=disabled]").removeClass("sorting");
    $("#" + tableID + " tbody .dataTables_empty").parent("tr").remove();
}

function LoadGrid(xhr, tableID, AjaxURL, AjaxData, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {
                var Model = eval(data.Data);

                loadTable(tableID, Model);

                if (callback && typeof (callback) === "function")
                    callback(Model);

                return Model;
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridCustom(xhr, tableID, AjaxURL, AjaxData, Precallback, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {

                var Model = eval(data.Data);

                if (Precallback && typeof (Precallback) === "function")
                    Precallback(Model);

                loadTable(tableID, Model);

                if (callback && typeof (callback) === "function")
                    callback(Model);

            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridPost(xhr, tableID, AjaxURL, AjaxData, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        type: "POST", cache: false, url: AjaxURL, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {
                var Model = eval(data.Data);

                loadTable(tableID, Model);

                if (callback && typeof (callback) === "function")
                    callback(Model);

                return Model;
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridWithoutPaginationWithPost(xhr, tableID, AjaxURL, AjaxData, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        type: "POST", cache: false, url: AjaxURL, data: AjaxData,
        /*type: "POST", url: AjaxURL, traditional: true, cache: false, data: AjaxData,*/
        success: function (data) {
            if (data != null && data.Status == "Success") {
                var Model = eval(data.Data);

                $("#" + tableID + " tbody").html("");
                $("#Grid_Data_Template_" + tableID).tmpl(Model).appendTo("#" + tableID + " tbody");

                if (callback && typeof (callback) === "function")
                    callback(Model);

                return Model;
            } else {

                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridWithoutPagination(xhr, tableID, AjaxURL, AjaxData, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {
                var Model = eval(data.Data);

                $("#" + tableID + " tbody").html("");
                $("#Grid_Data_Template_" + tableID).tmpl(Model).appendTo("#" + tableID + " tbody");

                //loadTableWithoutPaging(tableID, Model);

                if (callback && typeof (callback) === "function")
                    callback(Model);

                return Model;
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridCustomWithoutPagination(xhr, tableID, AjaxURL, AjaxData, Precallback, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {

                var Model = eval(data.Data);

                if (Precallback && typeof (Precallback) === "function")
                    Precallback(Model);

                $("#" + tableID + " tbody").html("");
                $("#Grid_Data_Template_" + tableID).tmpl(Model).appendTo("#" + tableID + " tbody");

                if (callback && typeof (callback) === "function")
                    callback(Model);
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function LoadGridWithoutPaginationWithDataModel(tableID, Model, callback) {

    $("#" + tableID + " tbody").html("");
    $("#Grid_Data_Template_" + tableID).tmpl(Model).appendTo("#" + tableID + " tbody");

    if (callback && typeof (callback) === "function")
        callback();
}

function GlobalGetData(AjaxURL, AjaxData, callback) {

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {

                if (callback && typeof (callback) === "function")
                    callback(data);
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        }
    });
}

function BindTable(xhr, tableID, AjaxURL, AjaxData, Precallback, callback) {

    if (xhr && xhr.readystate != 4)
        xhr.abort();

    xhr = $.ajax({
        url: AjaxURL, traditional: true, cache: false, data: AjaxData,
        success: function (data) {
            if (data != null && data.Status == "Success") {

                var Model = eval(data.Data);

                if (Precallback && typeof (Precallback) === "function")
                    Precallback(Model);

                $("#" + tableID + " tbody").html("");
                $("#Grid_Data_Template_" + tableID).tmpl(Model).appendTo("#" + tableID + " tbody");

                if (callback && typeof (callback) === "function")
                    callback();
            } else {
                if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                } else
                    toastr.error(data.Message);
            }
        },
        error: function (ex) {
            alert("Message: " + ex);
        }
    });
}

function GridSelectAll(tableID) {
    /*And for the first simple table, which doesn't have TableTools or dataTables
    select/deselect all rows according to table header checkbox*/
    var active_class = 'active';
    $('#' + tableID + ' > thead > tr > th input[type=checkbox]').eq(0).on('click', function () {
        var th_checked = this.checked;/*checkbox inside "TH" table header*/
        $(this).closest('table').find('tbody > tr').each(function () {
            var row = this;
            if (th_checked)
                $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
            else
                $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
        });
    });

    /*select/deselect a row when the checkbox is checked/unchecked*/
    $('#' + tableID).on('click', 'td input[type=checkbox]', function () {
        var $row = $(this).closest('tr');
        if ($row.is('.detail-row ')) return;

        if (this.checked) {

            var rowsCount = $('#' + tableID).closest('table').find('tbody > tr').length;
            var clickedCount = 0;

            $('#' + tableID).closest('table').find('tbody > tr').each(function () {
                var trrow = this;
                if ($(trrow).find('input[type=checkbox]').eq(0).prop('checked'))
                    clickedCount++;
            });

            if (rowsCount == clickedCount)
                $('#' + tableID + ' thead tr').find('input[type=checkbox]').eq(0).prop('checked', true);
        }
        else {
            $row.removeClass(active_class);
            $('#' + tableID + ' thead tr').find('input[type=checkbox]').eq(0).prop('checked', false);
        }
    });

}

function SelectAll(HeaderControlclass, RowControlClass) {
    /*HeaderControlclass / RowControlClass must have unique on same page*/

    var active_class = 'active';
    $("." + HeaderControlclass).click(function () {

        var HeaderControl = this;

        $("." + RowControlClass).each(function () {
            var row = this;

            if ($(HeaderControl).prop("checked"))
                $(row).prop('checked', true);
            else {
                $(row).prop('checked', false);
            }
        });
    });

    /*select/deselect a row when the checkbox is checked/unchecked*/
    $("." + RowControlClass).click(function () {

        if ($(this).prop("checked")) {

            var rowsCount = $("." + RowControlClass).length;
            var clickedCount = 0;

            $("." + RowControlClass).each(function () {
                var trrow = this;
                if ($(trrow).prop('checked'))
                    clickedCount++;
            });

            if (rowsCount == clickedCount)
                $("." + HeaderControlclass).prop('checked', true);
        }
        else {
            $("." + HeaderControlclass).prop('checked', false);
        }
    });
}


function Clear_Form_Fields(formId) {
    try {
        $(formId + ' input[type="text"]').each(function () {
            $(this).val("");
        });
    } catch (e) { }

    try {
        $(formId + ' input[type="password"]').each(function () {
            $(this).val("");
        });
    } catch (e) { }

    try {
        $(formId + ' input[type="hidden"]').each(function () {
            $(this).val("");
        });
    } catch (e) { }

    try {
        $(formId + ' textarea').each(function () {
            $(this).val("");
        });
    } catch (e) { }

    try {
        $(formId + ' select').each(function () {
            $("#" + $(this).attr('id') + " option:selected").removeAttr("selected");
        });
    } catch (e) { }

    /*ResetFormErrors(formId);*/
}

/*table sortable*/
function Bind_Grid_Sortable_Fields(callback) {

    $("th.sortable").click(function () {

        var CurrentStatusIsASC = $(this).hasClass("sorting_asc");

        $("th.sortable").removeClass("sorting_asc").removeClass("sorting_desc").addClass("sorting");

        GlobalSortBy = $(this).attr("data-sortby");
        GlobalSortOrder = CurrentStatusIsASC ? "desc" : "asc";

        $(this).addClass(CurrentStatusIsASC ? "sorting_desc" : "sorting_asc").removeClass("sorting");

        if (callback && typeof (callback) === "function") {
            callback();
        }
    });
}

function Bind_Grid_Sortable_FieldsForAll(tableID, SortBy, SortOrder, callback) {

    $("" + tableID + " th.sortable").click(function () {

        var CurrentStatusIsASC = $(this).hasClass("sorting_asc");

        $("" + tableID + " th.sortable").removeClass("sorting_asc").removeClass("sorting_desc").addClass("sorting");

        $("" + SortBy).val($(this).attr("data-sortby"));
        $("" + SortOrder).val(CurrentStatusIsASC ? "desc" : "asc");

        $(this).addClass(CurrentStatusIsASC ? "sorting_desc" : "sorting_asc").removeClass("sorting");

        if (callback && typeof (callback) === "function") {
            callback();
        }
    });
}

function Bind_Grid_Sortable_Fields2(callback) {

    $("th.sortable").click(function () {

        var CurrentStatusIsASC = $(this).hasClass("sorting_asc");

        $("th.sortable").removeClass("sorting_asc").removeClass("sorting_desc").addClass("sorting");

        GlobalSortByLocation = $(this).attr("data-sortby");
        GlobalSortOrderLocation = CurrentStatusIsASC ? "desc" : "asc";

        $(this).addClass(CurrentStatusIsASC ? "sorting_desc" : "sorting_asc").removeClass("sorting");

        if (callback && typeof (callback) === "function") {
            callback();
        }
    });
}

function Bind_Grid_Sortable_Fields2(callback, GlobalSortBy2, GlobalSortOrder2) {

    $("th.sortable").click(function () {

        var CurrentStatusIsASC = $(this).hasClass("sorting_asc");

        $("th.sortable").removeClass("sorting_asc").removeClass("sorting_desc").addClass("sorting");

        $(GlobalSortBy2).val($(this).attr("data-sortby"));
        $(GlobalSortOrder2).val(CurrentStatusIsASC ? "desc" : "asc");

        $(this).addClass(CurrentStatusIsASC ? "sorting_desc" : "sorting_asc").removeClass("sorting");

        if (callback && typeof (callback) === "function") {
            callback();
        }
    });
}

function Bind_Grid_Sortable_Fields3(callback) {

    $("th.sortable").click(function () {

        var CurrentStatusIsASC = $(this).hasClass("sorting_asc");

        $("th.sortable").removeClass("sorting_asc").removeClass("sorting_desc").addClass("sorting");
        GlobalSortByPriorAttempt = $(this).attr("data-sortby");
        GlobalSortOrderPriorAttempt = CurrentStatusIsASC ? "desc" : "asc";

        $(this).addClass(CurrentStatusIsASC ? "sorting_desc" : "sorting_asc").removeClass("sorting");

        if (callback && typeof (callback) === "function") {
            callback();
        }
    });
}
/*Grid Pagination helper end*/

/*Global Validators start*/
function Validate_Alert(ControlId, ErrorMessage, valid) {

    $(ControlId).parent().addClass("has-error");
    $(ControlId).parent().find("p").html(ErrorMessage).show();/*for required field not to show*/
    valid = false;
    return valid;
}

function Validate_Control_NullBlank(ControlId, FieldValue, ErrorMessage, valid) {
    if ($.trim(FieldValue) == null || $.trim(FieldValue) == '' || $.trim(FieldValue) == ',') {
        $(ControlId).parent().addClass("has-error");
        /*$(ControlId).parent().find("p").html(ErrorMessage).show();
        $("#lblError" + ControlId.replace("#","")).parent().find("p").html(ErrorMessage).show();*/
        valid = false;
    }

    return valid;
}

function Validate_Control_Location_NullBlank(ControlId, FieldValue, ErrorMessage, valid) {
    if ($.trim(FieldValue) == null || $.trim(FieldValue) == '' || $.trim(FieldValue) == ',') {
        $(ControlId).parent().parent().addClass("has-error");
        /*$(ControlId).parent().find("p").html(ErrorMessage).show();
        $("#lblError" + ControlId.replace("#","")).parent().find("p").html(ErrorMessage).show();*/
        valid = false;
    }

    return valid;
}

function Validate_Control_ComparePassword(ControlId, CompareFromControlId, ErrorMessage, valid) {
    if ($.trim($(ControlId).val()) != $(CompareFromControlId).val()) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }
    return valid;
}

function Validate_Control_ComparePasswordAll(ControlId, CompareFromControlId, CompareFromControlIdFrom, ErrorMessage, valid) {
    if (($.trim($(ControlId).val()) == $(CompareFromControlId).val()) && ($.trim($(ControlId).val()) == $(CompareFromControlIdFrom).val()) && ($.trim($(CompareFromControlId).val()) == $(CompareFromControlIdFrom).val())) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }
    return valid;
}

function Validate_Control_CompareMinMaxInteger(ControlIdMin, ControlIdMax, CompareFromControlId, CompareToControlId, ErrorMessage, valid) {
    if (($.trim(CompareFromControlId) != null || $.trim(CompareFromControlId) != '') && ((CompareToControlId) != null || $.trim(CompareToControlId) != '')) {
        if (eval(CompareFromControlId) > eval(CompareToControlId)) {

            $(ControlIdMin).parent().addClass("has-error");
            /*$(ControlIdMin).parent().parent().find("p").html(ErrorMessage).show();*/
            $('#CompairMinMaxhelp-block').html(ErrorMessage).show();
            $('#CompairMinMaxhelp-block').parent().addClass("has-error");
            valid = false;
        }
    }

    return valid;
}

function Validate_Control_NumericOnly(ControlId, FieldValue, ErrorMessage, valid) {

    /*Write code with RegX - Change RegX*/

    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(FieldValue) != true) {
            $(ControlId).parent().addClass("has-error");
            $(ControlId).parent().find("p").html(ErrorMessage).show();
            valid = false;
        }
    }
    return valid;
}

function Validate_Control_NumericOrFloat(ControlId, FieldValue, ErrorMessage, valid) {

    /*Write code with RegX - Change RegX*/
    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (/^[+-]?\d+(\.\d+)?$/.test(FieldValue) != true) {
            $(ControlId).parent().addClass("has-error");
            $(ControlId).parent().find("p").html(ErrorMessage).show();
            valid = false;
        }
    }

    return valid;
}

function Validate_Control_Email(ControlId, FieldValue, ErrorMessage, valid) {
    /*var email_Regx = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;*/
    var email_Regx = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (email_Regx.test(FieldValue) != true) {
            $(ControlId).parent().addClass("has-error");
            /*$(ControlId).parent().find("p").html(ErrorMessage).show();*/
            $("#lblError" + ControlId.replace("#", "")).parent().find("p").html(ErrorMessage).show();
            valid = false;
        }
    }
    return valid;
}

function Validate_Control_WebURL(ControlId, FieldValue, ErrorMessage, valid) {

    var WebUrl_Regx = /^(https?|http?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;

    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (WebUrl_Regx.test(FieldValue) != true) {
            $(ControlId).parent().addClass("has-error");
            /*$(ControlId).parent().find("p").html(ErrorMessage).show();*/
            $("#lblError" + ControlId.replace("#", "")).parent().find("p").html(ErrorMessage).show();/*for required field not to show*/
            valid = false;
        }
    }
    return valid;
}

function Validate_Control_DateDDMMYYYY(ControlId, FieldValue, ErrorMessage, valid) {

    var monthlist = Resource.Jan + "|" + Resource.Feb + "|" + Resource.Mar + "|" + Resource.Apr + "|" + Resource.May +
        "|" + Resource.June + "|" + Resource.July + "|" + Resource.Aug + "|" + Resource.Sep + "|" + Resource.Oct + "|" + Resource.Nov + "|" + Resource.Dec;
    var dtRegex = new RegExp("^([0]?[1-9]|[1-2]\\d|3[0-1])-(" + monthlist + ")-[1-2]\\d{3}$", 'i');

    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (dtRegex.test(FieldValue) == false) {
            $(ControlId).parent().addClass("has-error");
            $(ControlId).parent().find("p").html(ErrorMessage).show();
            $("#lblError" + ControlId.replace("#", "")).parent().find("p").html(ErrorMessage).show();/*for required field not to show*/
            valid = false;
        }
    }
    return valid;
}

function Validate_Control_DateFormat(FieldValue) {

    var monthlist = Resource.Jan + "|" + Resource.Feb + "|" + Resource.Mar + "|" + Resource.Apr + "|" + Resource.May +
        "|" + Resource.June + "|" + Resource.July + "|" + Resource.Aug + "|" + Resource.Sep + "|" + Resource.Oct + "|" + Resource.Nov + "|" + Resource.Dec;
    var dtRegex = new RegExp("^([0]?[1-9]|[1-2]\\d|3[0-1])-(" + monthlist + ")-[1-2]\\d{3}$", 'i');

    if (FieldValue.trim() != null && FieldValue.trim() != '') {
        if (dtRegex.test(FieldValue) == false) {
            return false;
        }
    }
    return true;
}

function Validate_Control_DateCompair(ControlId, ToControlId, FromDateValue, ToDateValue, ErrorMessage, valid) {

    if (ToDateValue != "" && ToDateValue != null) {
        if (new Date(FromDateValue) > new Date(ToDateValue)) {
            $(ControlId).parent().parent().addClass("has-error");
            $(ControlId).parent().parent().find("p").html(ErrorMessage).show();
            $("#lblError" + ControlId.replace("#", "")).html(ErrorMessage).show();
            valid = false;
        }
    }

    return valid;
}

$(document).ready(function () {

    //if (location.protocol != 'https:' && location.hostname != "localhost") location.href = 'https:' + window.location.href.substring(window.location.protocol.length);

    $("#aChangePasswordLink").click(function () {

        LoadAddUpdateView("#divPasswordlayout", "/Login/_PasswordChange", "Change Password", function () {
            $("#myPasswordresetModal").modal("show");
            changepassword.ActiveEvent();
        });

    });
});

function Validate_Control_MaxLengthString(ControlId, FieldValue, MaxLength, ErrorMessage, valid) {
    if (FieldValue != null && FieldValue != '' && FieldValue.length > MaxLength) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }
    return valid;
}

function Validate_Control_MaxLengthNumeric(ControlId, FieldValue, MaxLength, ErrorMessage, valid) {

    if (FieldValue != null && FieldValue != '' && $.isNumeric(FieldValue) == true && (FieldValue.toString().split('.')[0]).length > MaxLength) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}
function Validate_Control_MaxLengthNum(ControlId, FieldValue, MaxLength, ErrorMessage, valid) {

    if (FieldValue != null && FieldValue != '' && $.isNumeric(FieldValue) == true && (FieldValue.toString().length > MaxLength)) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}

function Validate_Control_MinMaxLengthNum(ControlId, FieldValue, MinLength, MaxLength, ErrorMessage, valid) {

    if (FieldValue != null && FieldValue != '' && $.isNumeric(FieldValue) == true && (FieldValue.toString().trim().length > MaxLength) && (FieldValue.toString().trim().length < MinLength)) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}

function Validate_Control_MinMaxValue(ControlId, FieldValue, MinValue, MaxValue, ErrorMessage, valid) {

    if ($.isNumeric(FieldValue) == false || ((FieldValue > MaxValue) || (FieldValue < MinValue))) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}

function Validate_Control_MinValue(ControlId, FieldValue, MinValue, ErrorMessage, valid) {
    if ($.isNumeric(FieldValue) && (FieldValue < MinValue)) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        $(ControlId).parent().show();
        $("#lblError" + (ControlId).replace("#", "")).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}

function Validate_Control_MaxValue(ControlId, FieldValue, MaxValue, ErrorMessage, valid) {
    if ($.isNumeric(FieldValue) && (Number(FieldValue) > Number(MaxValue))) {
        $(ControlId).parent().addClass("has-error");
        $(ControlId).parent().find("p").html(ErrorMessage).show();
        $(ControlId).parent().show();
        $("#lblError" + (ControlId).replace("#", "")).parent().find("p").html(ErrorMessage).show();
        valid = false;
    }

    return valid;
}

function Validate_Control_MaxLengthDecimalPoint(ControlId, FieldValue, MaxLengthBeforeDecimal, MaxLengthAfterDecimal, ErrorMessage, valid) {

    if (FieldValue != null && FieldValue != '') {
        if ($.isNumeric(FieldValue) != true) {
            $(ControlId).parent().addClass("has-error");
            $(ControlId).parent().find("p").html(ErrorMessage).show();
            valid = false;
        }
        else {
            if (FieldValue.indexOf(".") >= 0) {
                var LL = (FieldValue.toString().split('.')[0]).length;
                var RL = (FieldValue.toString().split('.')[1]).length;
                if (LL == 0 || RL == 0 || LL > MaxLengthBeforeDecimal || RL > MaxLengthAfterDecimal) {
                    $(ControlId).parent().addClass("has-error");
                    $(ControlId).parent().find("p").html(ErrorMessage).show();
                    valid = false;
                }
            }
        }
    }

    return valid;
}
/*Global Validators end*/

/*jAlert start*/
function jAlert(msg, title, theme) {
    $.jAlert({
        /*'title': ((title == null || title == '') ? "Message" : title),*/
        'content': msg,
        'theme': ((theme == null || theme == '') ? "default" : title),
        'btns': { 'text': 'Ok', 'theme': 'green' }
    });
}

/*General Helper Functions*/
function CSVToArray(strData, strDelimiter) {

    strDelimiter = (strDelimiter || ",");

    /*Create a regular expression to parse the CSV values.*/
    var objPattern = new RegExp((   /* Delimiters.*/
        "(\\" + strDelimiter + "|\\r?\\n|\\r|^)" +
        /* Quoted fields.*/
        "(?:\"([^\"]*(?:\"\"[^\"]*)*)\"|" +
        /*Standard fields.*/
        "([^\"\\" + strDelimiter + "\\r\\n]*))"
    ), "gi"
    );

    var arrData = [[]];
    var arrMatches = null;

    while (arrMatches = objPattern.exec(strData)) {

        /* Get the delimiter that was found.*/
        var strMatchedDelimiter = arrMatches[1];
        if (
            strMatchedDelimiter.length &&
            strMatchedDelimiter !== strDelimiter
        ) {
            arrData.push([]);
        }

        var strMatchedValue;

        if (arrMatches[2]) {
            strMatchedValue = arrMatches[2].replace(
                new RegExp("\"\"", "g"),
                "\""
            );
        } else {
            strMatchedValue = arrMatches[3];
        }

        arrData[arrData.length - 1].push(strMatchedValue);
    }

    return (arrData);
}

function MonthIncrement() {

    if (latest_Month < 12) {
        latest_Month += 1;
    }
    else {
        latest_Year += 1;
        latest_Month = 1;
    }
}

function MonthDecrement() {

    if (latest_Month > 1) {
        latest_Month -= 1;
    }
    else {
        latest_Year -= 1;
        latest_Month = 12;
    }
}

function GetMonthName(MonthValue) {
    var Months = [Resource.Jan, Resource.Feb, Resource.Mar, Resource.Apr, Resource.May, Resource.Jun, Resource.Jul, Resource.Aug, Resource.Sep, Resource.Oct, Resource.Nov, Resource.Dec];
    return Months[MonthValue - 1];
}

function DataArrayToViewModel(DataArray, FCVariableId, AppLevelId, CatId, SingleOrDouble, RECTypeId) {

    var ViewModel = { FCVariableId: FCVariableId, ApplicableLevelId: AppLevelId, CategoryId: CatId, SingleOrDoubleValue: SingleOrDouble, RECTypeId: RECTypeId, MonthRows: null };

    var MonthRows = new Array();

    $.each(DataArray, function (i, iRow) {

        var RowItem = {};
        RowItem.CurveData = new Array();

        $.each(Object.keys(iRow), function (j, jKey) {

            if (jKey.match("^CurveData") && iRow[jKey] != null && iRow[jKey] != undefined) {

                var CurveDataItem = {};

                CurveDataItem.PKValue = parseFloat(iRow[jKey].PKValue);
                CurveDataItem.DataVal1 = parseFloat(iRow[jKey].DataVal1);
                if (SingleOrDouble == FCSingleOrDoubleValue.Double.value) {
                    CurveDataItem.DataVal2 = parseFloat(iRow[jKey].DataVal2);
                }

                RowItem.CurveData.push(CurveDataItem);
            }
            else if (jKey == 'MonthValue') {
                RowItem.MonthValue = iRow[jKey];
            }
            else if (jKey == 'YearValue') {
                RowItem.YearValue = iRow[jKey];
            }
        });

        MonthRows.push(RowItem);
    });

    ViewModel.MonthRows = MonthRows;

    return ViewModel;
}

function ViewModelToDataArray(ViewModel, FKArray) {

    var DataArray = new Array();

    $.each(ViewModel, function (i, iRow) {

        var RowItem = {};
        RowItem.MonthValue = latest_Month = iRow.MonthValue;
        RowItem.YearValue = latest_Year = iRow.YearValue;
        RowItem.MonthYearLabel = GetMonthName(iRow.MonthValue) + ' ' + iRow.YearValue;

        MonthIncrement();

        /*var RowArray = new Array();*/
        $.each(FKArray, function (k, kValue) {

            RowItem["CurveData[" + k + "]"] = {};
            RowItem["CurveData[" + k + "]"].PKValue = kValue;
            RowItem["CurveData[" + k + "]"].DataVal1 = null;
            RowItem["CurveData[" + k + "]"].DataVal2 = null;

            $.each(iRow.CurveData, function (j, jCurve) {
                if (jCurve.PKValue == kValue) {
                    RowItem["CurveData[" + k + "]"].DataVal1 = jCurve.DataVal1;
                    RowItem["CurveData[" + k + "]"].DataVal2 = jCurve.DataVal2;
                }
            });
        });

        DataArray.push(RowItem);
    });

    return DataArray;
}

function ScreenLock() {
    $("#overlay").show();
}
function ScreenUnlock() {
    $("#overlay").hide();
}

$(document).ajaxStart(function () {
    ScreenLock();
});
$(document).ajaxStop(function () {
    ScreenUnlock();
});

function SmoothScroll(controlId) {
    $('html, body').stop().animate({ 'scrollTop': $(controlId).offset() == undefined ? 0 : $(controlId).offset().top }, 900, 'swing', function () { });
}

function CallInternalURL(url) {
    $("#frm").attr("src", url);
}

function OpenURLtoNewTab(url) {
    window.open(url, '_blank')
}

Date.prototype.mmddyyyy = function () {
    var yyyy = this.getFullYear().toString();
    var mm = (this.getMonth() + 1).toString();
    var dd = this.getDate().toString();
    return (mm[1] ? mm : "0" + mm[0]) + "/" + (dd[1] ? dd : "0" + dd[0]) + "/" + yyyy;
};

function numberWithCommas(x) {
    var a = (x || '').toString().split('.');

    var result = a[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    if (a[1] != null && a[1] != undefined) {
        result += '.' + a[1];
    }

    return result;
}

function ExportToExcel(tableName, type) {
    $(tableName).tableExport({ type: type, escape: 'false' });
}

function ExportToExcelGrid(tableName, type) {
    $("" + tableName + "_length select option:last").attr("selected", "selected").change();
    ExportToExcel(tableName, type);
}

function ExportToPDF(tableName, type) {
}

function SetSelectedListBox(ControlID) {

    $("" + ControlID + " option").each(function () {
        $(this).prop('selected', true);
    });
}

function SetValueToListBox(ControlID, jsonListObject, ColumnName) {

    $options = $("" + ControlID + " option");

    $.each(jsonListObject, function (i, item) {
        if (ColumnName == null || ColumnName == undefined) {
            $options.filter('[value="' + item.Value + '"]').prop('selected', true);
        } else
            $options.filter('[value="' + item[ColumnName] + '"]').prop('selected', true);
    });
}

function SetValueToListBoxType(ControlID, strlist, splitChar) {
    try {
        var TypeIDs = strlist.split(splitChar);
        $options = $("" + ControlID + " option");

        for (var i = 0; i < TypeIDs.length; i++) {
            $options.filter('[value="' + TypeIDs[i] + '"]').prop('selected', true);
        }

    } catch (e) {
    }
}

function GetValueToListBoxSelected(ControlID, PropertyName) {
    var returnVal = [];
    $(ControlID + " :selected").each(function (i, selected) {
        var rowstring = {};
        rowstring[PropertyName] = $(selected).val().toString().trim();
        returnVal.push(eval(rowstring));
    });

    return returnVal;
}

function GetValueToListBoxSelectedValueText(ControlID) {
    var returnVal = [];
    $(ControlID + " :selected").each(function (i, selected) {
        var rowstring = {
            Value: $(selected).val().toString().trim(),
            Text: $(selected).text().toString().trim(),
            Selected: false,
        };
        returnVal.push(eval(rowstring));
    });

    return returnVal;
}

function GetValueToListBoxNotSelected(ControlID) {
    var returnVal = '';

    var iddeStatus = $(ControlID).val();
    if ((iddeStatus != null) || (iddeStatus != "")) {
        var unSelected = $(ControlID).find('option').not(':selected');
        for (var i = 0; i < unSelected.length; i++) {
            returnVal += unSelected[i].value + ',';
        }

    } else {
        alert('else part')
    }

    return returnVal;
}


function GetValueToListBoxNotSelected(ControlID, PropertyName) {
    var returnVal = [];
    $(ControlID).find('option').not(':selected').each(function (i, item) {
        var rowstring = {};
        rowstring[PropertyName] = $(item).val().toString().trim();
        returnVal.push(eval(rowstring));
    });

    return returnVal;
}

function GetValueToListBoxNotSelected(ControlID, PropertyName) {
    var returnVal = [];
    $(ControlID).find('option').not(':selected').each(function (i, item) {
        var rowstring = {};
        rowstring[PropertyName] = $(item).val().toString().trim();
        returnVal.push(eval(rowstring));
    });

    return returnVal;
}

function GetValueToListBox(ControlID) {
    var returnVal = "";

    $(ControlID + " option").each(function () {
        returnVal += $(this).val().toString() + ",";
    });

    return returnVal;
}

function GetValueToListBoxSelectedCompanyType(ControlID) {
    return GetValueToListBoxSelectedType();
}

function GetValueToListBoxSelectedType(ControlID) {

    var returnVal = "";

    $(ControlID + " :selected").each(function (i, selected) {
        returnVal += $(selected).val().toString() + "#";
    });

    return returnVal;
}

function checkSubmit(e, submitBtnID) {

    $(document).ready(function () {
        if (e && e.keyCode == 13) {
            $(submitBtnID).click();
        }
    });
}

function Checkddmmyyyy(value) {
    var date = value.split("-");
    var d = parseInt(date[0], 10),
        m = parseInt(date[1], 10),
        y = parseInt(date[2], 10);
    return new Date(y, m - 1, d);
}

function GetTimeInto24Hour(value) {
    /*http://stackoverflow.com/questions/15083548/convert-12-hour-hhmm-am-pm-to-24-hour-hhmm*/
    var time = value.trim();
    var hours = Number(time.match(/^(\d+)/)[1]);
    var minutes = Number(time.match(/:(\d+)/)[1]);
    var AMPM = time.match(/\s(.*)$/)[1];
    if (AMPM == "PM" && hours < 12) hours = hours + 12;
    if (AMPM == "AM" && hours == 12) hours = hours - 12;
    var sHours = hours.toString();
    var sMinutes = minutes.toString();
    if (hours < 10) sHours = "0" + sHours;
    if (minutes < 10) sMinutes = "0" + sMinutes;
    return (sHours + ":" + sMinutes);
}

function GetTime24HourInto12(value) {
    /*https://www.webprogs.com/2017/05/convert-24-hour-time-12-hour-time-using-javascript/*/
    var time = new Date(2012, 01, 01, value.Hours, value.Minutes, 0, 0);
    var hours = time.getHours() > 12 ? time.getHours() - 12 : time.getHours();
    var am_pm = time.getHours() >= 12 ? "PM" : "AM";
    hours = hours < 10 ? "0" + hours : hours;
    var minutes = time.getMinutes() < 10 ? "0" + time.getMinutes() : time.getMinutes();
    var seconds = time.getSeconds() < 10 ? "0" + time.getSeconds() : time.getSeconds();

    time = hours + ":" + minutes + ":" /*+ seconds*/ + " " + am_pm;
    return (time);
}

function GetScreenAccessPermissions(ScreenID) {
    /*no such array*/
    ScreenID = eval(ScreenID);

    var userScreenInfo = ConfigurationData_UserScreenInfoList();
    var userScreenActionInfo = ConfigurationData_UserScreenActionInfoList();

    if (!(userScreenInfo.length > 0))
        return;

    var finalArray = [];
    /*search array for key*/
    for (var i = 0; i < userScreenInfo.length; ++i) {
        /*if the ScreenID is what we are looking for return it*/
        if (userScreenInfo[i].ScreenID === ScreenID) {
            finalArray.push(userScreenInfo[i]);
            if (userScreenActionInfo.length > 0 && userScreenActionInfo != null) {
                for (var j = 0; j < userScreenActionInfo.length; ++j) {
                    if (userScreenActionInfo[j].ScreenID === ScreenID) {
                        /*$.extend(userScreenInfo[i], userScreenActionInfo[j]);*/
                        finalArray.push(userScreenActionInfo[j]);
                        /*return finalArray;*/
                    }
                }
                return finalArray;
            }
            else
                return finalArray;
        }
    }
}

function GetScreenPermissions(ModuleCode, ScreenName) {

    var userScreenInfo = ConfigurationData_UserScreenInfoList();
    var userScreenActionInfo = ConfigurationData_UserScreenActionInfoList();

    if (!(userScreenInfo.length > 0))
        return;

    var finalArray = [];
    var ScreenSet = $.grep(userScreenInfo, function (item, i) { return item.ModuleCode === ModuleCode && item.ObjectName === ScreenName; });

    if (ScreenSet.length > 0) {
        finalArray.push(ScreenSet);

        var ScreenActionSet = [];
        $.each(ScreenSet, function (i, item) {
            if (item.ScreenID > 0) {
                var ScreenAction = $.grep(userScreenActionInfo, function (item2, i) { return item2.ScreenID === item.ScreenID; });
                if (ScreenAction.length > 0) {
                    ScreenActionSet.push(ScreenActionSet);
                }
            }
        });

        if (ScreenActionSet.length > 0)
            finalArray.push(ScreenActionSet);
    }

    return finalArray;
}

function AllowOnlyNumberOrDecimalValue(MyID) {
    $(MyID).on("input", function (evt) {
        var self = $(this);
        self.val(self.val().replace(/[^0-9\.]/g, ''));
        if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
            evt.preventDefault();
        }
    });
}

function AllowOnlyNumberValue(MyID) {
    $(MyID).on("input", function (evt) {
        var self = $(this);
        self.val(self.val().replace(/\D/g, ''));
        if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
            evt.preventDefault();
        }
    });
}

function AllowCharacterNumber(MyID) {
    /*this is Currenly use for LoginName purpose*/
    $(MyID).keypress(function (e) {
        var regex = new RegExp("^[a-zA-Z0-9]+$");
        var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
        if (regex.test(str))
            return true;
        e.preventDefault();
        return false;
    });
}


Date.isLeapYear = function (year) {
    return (((year % 4 === 0) && (year % 100 !== 0)) || (year % 400 === 0));
};

Date.getDaysInMonth = function (year, month) {
    return [31, (Date.isLeapYear(year) ? 29 : 28), 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
};

Date.prototype.isLeapYear = function () {
    return Date.isLeapYear(this.getFullYear());
};

Date.prototype.getDaysInMonth = function () {
    return Date.getDaysInMonth(this.getFullYear(), this.getMonth());
};

Date.prototype.addMonths = function (value) {
    var n = this.getDate();
    this.setDate(1);
    this.setMonth(this.getMonth() + value);
    this.setDate(Math.min(n, this.getDaysInMonth()));
    return this;
};

Date.prototype.addDays = function (days) {
    var dat = new Date(this.valueOf());
    dat.setDate(dat.getDate() + days);
    return dat;
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    month = GetMonthShortName(month);
    /*if (month.length < 2) month = '0' + month;*/
    if (day.length < 2) day = '0' + day;

    return [day, month, year].join('-');
}

function GetMonthShortName(MonthValue) {
    return Month[MonthValue - 1];
}

function FocusOnError(FormID, valid) {
    if (!valid) {
        SmoothScroll(FormID + " .has-error:first");
        $(FormID + " .has-error .form-control:first").focus();
    }
}

function Reset_Form_Errors() {
    $(".input-group").removeClass("has-error");
    $(".form-group").removeClass("has-error");
    $(".form-group p").html("");
    $(".form-group p").hide();
    $("td").removeClass("has-error");
}

function ResetFormErrors(formID) {
    $(formID + " .has-error p").html("").hide();
    $(formID + " .form-group").removeClass("has-error");
    $(formID + " .has-error").removeClass("has-error");
    $(formID + " .form-group p").html("");
    $(formID + " .form-group p").hide();
}

function ShowTotalCount(Resource, table, Count) {

    var row = ' <label style="margin-left:5%" class="' + table + '"> ' + Resource + ' : ' + Count + '</label> '
    $('#' + table).append(row);
}

function GetAddButton(divID, action) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;" class="fa fa-plus-square fa-2x"></i>');
}

function GetEditButton(divID, action) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;color: #379465;" class="fa fa-pencil-square fa-2x"></i>');
}

function GetDeleteButton(divID, action) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;color: #d21c1c;" class="fa fa-trash fa-2x"></i>');
}

function GetExpandButton(divID, action) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;color: #e06fa7;" class="fa fa-expand fa-2x"></i>');
}

function GetCollapseButton(divID, action) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;color: #e06fa7;" class="fa fa-compress fa-2x"></i>');
}

function GetExportButton(divID, buttonID, tableName, type) {
    var method = "onclick='ExportToExcel(" + tableName + "," + type + ");'";
    return $(divID).html("<a id=" + buttonID + " href='#' style='margin-right: 9px !important;color:#FFF;' class='dt-button buttons-excel' tabindex='0' aria-controls='dynamic-table' " + method + "><i style='font-size: 20px !important;' class='fa fa-file-excel-o bigger-110' title='Export to " + type + "'></i> <span class='hidden'>Export to " + type + "</span></a>");
}

function GetButton(divID, action, symbolClass) {
    return $(divID).html('<i onclick=' + action + ' style="cursor:pointer; margin-top: 7px;" class="' + symbolClass + '"></i>');
}

/*Load add/update partial view*/
function LoadAddUpdateView(divID, AjaxURL, panelTitle, callback) {
    $.ajax({
        url: AjaxURL,
        contentType: 'application/html; charset=utf-8',
        type: 'GET',
        dataType: 'html',
        success: function (data) {

            $(divID).html("");//.find(".panel-heading span").html(panelTitle);
            $(divID).append(data);//.find(".panel-heading span").html(panelTitle);
            $(divID).show();

            if (panelTitle != null && panelTitle != "")
                $(divID).find(".panel-heading span").html(panelTitle);

            /*SmoothScroll(divID); commented due to it scroll page*/
            if (callback && typeof (callback) === "function")
                callback();
        }
    });
}

function SetSelectedRow(ControlId, id) {
    $(ControlId + " tr").removeClass("selected");
    $(ControlId + " #tr" + id).addClass("selected");
}

function UnSelectRow(tableID) {
    $(tableID + " tr").removeClass("selected");
}

function SetScreenInfo(data) {
    //if (localStorage["UserScreenInfo"] == null)
    localStorage["UserScreenInfo"] = data;
}

function ScreenActionInfo(data) {
    //if (localStorage["UserScreenActionInfo"] == null)
    localStorage["UserScreenActionInfo"] = data;
}

function ConfigurationData_UserScreenInfoList() {
    var GetconfigData = localStorage["UserScreenInfo"];
    return (JSON.parse(GetconfigData));
}

function ConfigurationData_UserScreenActionInfoList() {
    var GetconfigData = localStorage["UserScreenActionInfo"];
    return (JSON.parse(GetconfigData));
}

function SetConfigurationData(data) {
    if (localStorage["GetConfigurationData"] == null)
        localStorage["GetConfigurationData"] = data;
}

function ConfigurationDatalocalStorage() {
    var GetconfigData = localStorage["GetConfigurationData"];
    return (JSON.parse(GetconfigData));
}

function ConfigurationData_LanguageList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.LanguageList);
}

function ConfigurationData_ModuleList() {
    var json1 = ConfigurationDatalocalStorage();
    var updatedlist = RemoveJsonItem("IsForEndUser", "0", json1.ModuleList);
    return (updatedlist);
}

function ConfigurationData_ModuleListAll() {
    var json1 = ConfigurationDatalocalStorage();
    var updatedlist = json1.ModuleList;/*RemoveJsonItem("IsForEndUser", "0", json1.ModuleList);*/
    return (updatedlist);
}

function ConfigurationData_CountryList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.CountryList);
}

function ConfigurationData_ServiceLineList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.ServiceLineList);
}

function ConfigurationData_ConfigurationCodeList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.ConfigurationCodeList);
}

function ConfigurationData_TimeUnitList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.TimeUnitList);
}

function ConfigurationData_PriorityLevelList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.PriorityLevelList);
}

function ConfigurationData_FrequencyTimeUnitList() {
    var json1 = ConfigurationData_TimeUnitList();
    var freqData = [];
    $.each(json1, function (i, item) {
        if (item.IsUsedForFrequency) {
            item.Text = item.FrequencyName;
            freqData.push(item);
        }
    });
    /*This is sorting for Training Dashbord purpose*/
    freqData.sort(function (a, b) {
        return a.SequenceNo - b.SequenceNo;
    });

    return (freqData);
}

function ConfigurationData_ResolutionTimeUnitList() {
    var json1 = ConfigurationData_TimeUnitList();
    var resData = [];
    $.each(json1, function (i, item) {
        if (item.IsUsedForResolution)
            resData.push(item);
    });
    return (resData);
}

function ConfigurationData_RiskLevelList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.RiskLevelList);
}

function ConfigurationData_SeverityLevelList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.SeverityLevelList);
}

function ConfigurationData_InspectionTypeList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.InspectionTypeList);
}

function ConfigurationData_FRASInspectionTypeList() {
    var json1 = ConfigurationDatalocalStorage();
    //var json1 = {
    //    FRASInspectionTypeList: [{
    //        Value: "RISK", Text: "Risk Assessment Full",
    //        InspectionType: "RISK", InspectionTypeName: "Risk Assessment Full",
    //    }, {
    //        Value: "RISKBURN", Text: "Risk Assessment - Burn",
    //        InspectionType: "RISKBURN", InspectionTypeName: "Risk Assessment - Burn"
    //    }, {
    //        Value: "RISKESCAPE", Text: "Risk Assessment - Escape",
    //        InspectionType: "RISKESCAPE", InspectionTypeName: "Risk Assessment - Escape"
    //    }, {
    //        Value: "RISKControl", Text: "Risk Assessment - MgtControl",
    //        InspectionType: "RISKControl", InspectionTypeName: "Risk Assessment - MgtControl"
    //    }, {
    //        Value: "RISKMainControl", Text: "Risk Assessment - MainControl",
    //        InspectionType: "RISKMainControl", InspectionTypeName: "Risk Assessment - Main Control"
    //    }, {
    //        Value: "HAZ", Text: "Hazards",
    //        InspectionType: "HAZ", InspectionTypeName: "Hazards"
    //    }, {
    //        Value: "PreFirePlan", Text: "Pre Fire Plan",
    //        InspectionType: "PreFirePlan", InspectionTypeName: "Pre Fire Plan"
    //    }
    //    ]
    //}; /*ConfigurationDatalocalStorage();*/

    return json1.FRASInspectionTypeList;
}

function ConfigurationData_ServiceLevelList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.ServiceLevelList);
}

function ConfigurationData_AttributeTypeList() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.AttributeTypeList);
}

function ConfigurationData_CheckListsAttributeTypeList() {
    var json1 = ConfigurationData_AttributeTypeList();
    var checkListData = [];
    $.each(json1, function (i, item) {
        if (item.IsUsedForCheckLists) {
            item.Text = item.AttributeTypeName;
            checkListData.push(item);
        }
    });
    return (checkListData);
}

var DateTimeDataFormat = {
    DatePickerFormat: "DD-MMM-YYYY",
    DateTimePickerFormat: "dd-M-yyyy hh:mm:tt",
    DateTimeAMPMPickerFormat: "DD-MMM-YYYY hh:mm A",
    DateLabelFormat: "dd-MMM-yyyy",

    ddMyyyy: 'dd-M-yyyy',
    ddMMyyyy: 'dd-MM-yyyy'
};

function ConfigurationData_DateFormat() {
    return DateTimeDataFormat.DatePickerFormat;
}

function ConfigurationData_DateTimeFormat() {
    return DateTimeDataFormat.DateTimePickerFormat;
}

function ConfigurationData_DateTimeAMPMFormat() {
    return DateTimeDataFormat.DateTimeAMPMPickerFormat;
}

function ConfigurationData_IsSingleCustomer() {
    var json1 = ConfigurationDatalocalStorage();
    return (json1.IsSingleCustomerList);
    /*return ({ IsSingleUserCustomer: false, IsSingleInstance: false, CustomerID: 8, CustomerName: "CSIA" });*/
}

function FillStaticCustomer(CustomerID, callback) {
    var obj = ConfigurationData_IsSingleCustomer();
    if (obj[0].IsSingleInstance || obj[0].IsSingleUserCustomer) {
        $(CustomerID).val(obj[0].CustomerName).attr("data-label", obj[0].CustomerName).attr("data-id", obj[0].CustomerID).css({ "cursor": "default", "background-color": "#f5f5f5!important" });
        $(CustomerID).prop('readonly', true).prop('disabled', true);

        if (callback && typeof (callback) === "function")
            callback(obj);
    }
}

function GetLanguageWiseMasterAddEditForm(masterModel) {
    var LanguageJson = ConfigurationData_LanguageList();/*eval(data.Data);*/

    if (masterModel != null) {
        for (var i = 0; i < masterModel.length; i++) {
            var item = masterModel[i];
            for (var j = 0; j < LanguageJson.length; j++) {
                var itemSub = LanguageJson[j];
                if (item.LanguageCode == itemSub.LanguageCode) {
                    /*ADD COLUMN LanguageName INTO JSON ROW*/
                    item["LanguageName"] = itemSub.LanguageName;
                    break;
                }
            }
        }

        return LanguageJson = masterModel;
    }

    return LanguageJson;
}

function BindEntityLanguageGrid(tbl, Data, PropertyName) {

    var LanguageJson = ConfigurationData_LanguageList();

    $("#" + tbl + " tbody").html("");
    $("#Grid_Data_Template_" + tbl).tmpl(LanguageJson).appendTo("#" + tbl + " tbody");

    if (Data != null)
        $.each(Data, function (ID, item) {
            $("#" + tbl + " tbody tr").each(function () {
                if ($(this).attr("data-id") === item.LanguageCode) {
                    $("#txt" + PropertyName + "" + $(this).attr("data-id")).val(item[PropertyName]);
                }
            });
        });
}

/*it only work for POST method*/
function DeleteData(xhr, Ajaxurl, AjaxData, ItemInfo, callback) {

    if (true) {
        console.log(ItemInfo.toString().indexOf("("));

        if (ItemInfo != "" && ItemInfo != null && ItemInfo.toString().indexOf("(") < 0)
            ItemInfo = ' (' + ItemInfo + ')';

        if (AjaxData != null) {
            $.confirm({
                confirmButton: Resource.Yes, cancelButton: Resource.No, confirmButtonClass: 'btn btn-danger', text: Resource.DeleteConfMessage + " " + ItemInfo,
                confirm: function (button) {
                    if (xhr && xhr.readystate != 4)
                        xhr.abort();

                    xhr = $.ajax({
                        /*url: Ajaxurl, cache: false, data: AjaxData,*/
                        type: "POST", cache: false, url: Ajaxurl, data: AjaxData,
                        success: function (data) {
                            if (data != null && data.Status == "Success") {
                                toastr.success(data.Message);

                                if (callback && typeof (callback) === "function")
                                    callback();

                            } else if (data != null && data.Status == "Error") {

                                if ((data.Message.indexOf("_FK_") !== -1))
                                    toastr.warning(Resource.UseInAnotherEntityMessage);
                                else
                                    toastr.error(data.Message);
                            }
                            else toastr.error(data.Message);
                        }
                    });
                },
                cancel: function (button) { /*toastr.error("ss");*/ }
            });
        }
    }
}

var LoadChosen = function (chosenID, IsMultipleSelect) {
    if (!ace.vars['touch']) {
        $(chosenID).chosen({ allow_single_deselect: IsMultipleSelect, default_multiple_text: "Rajendra" });

        /*resize the chosen on window resize*/
        $(window).off('resize.chosen').on('resize.chosen', function () {
            $(chosenID).each(function () {
                var $this = $(this);
                $this.next().css({ 'width': $this.parent().width() });
            });
        }).trigger('resize.chosen');

        /*resize chosen on sidebar collapse/expand*/
        $(document).on('settings.ace.chosen', function (e, event_name, event_val) {
            if (event_name != 'sidebar_collapsed') return;
            $(chosenID).each(function () {
                var $this = $(this);
                $this.next().css({ 'width': $this.parent().width() });
            });
        });

        $(chosenID).trigger('chosen:updated');
    }
}

function RemoveJsonItem(property, value, JsonItemArray) {
    for (var i in JsonItemArray)
        if (JsonItemArray[i][property] == value)
            JsonItemArray.splice(i, 1);

    return JsonItemArray;
}

function findElement(arr, propName, propValue) {
    for (var i = 0; i < arr.length; i++)
        if (arr[i][propName] == propValue)
            return arr[i];

    /* will return undefined if not found; you could return a default instead*/
}

function IsNotNull(val) { if (val == 0 || val == null || val == "" || val == undefined) return false; else return true; }

function AddUpdateData(Ajaxurl, AjaxData, SuccessCallback, ErrorCallback) {

    $.ajax({
        type: "POST", cache: false, url: Ajaxurl, data: AjaxData,
        success: function (data) {
            if (data != null) {
                if (data.Status == 'Success') {
                    toastr.success(data.Message);
                    if (SuccessCallback && typeof (SuccessCallback) === "function")
                        SuccessCallback(data);
                } else if (data.Status == 'Error') {

                    if (data.toString().indexOf("LoginBody") >= 0) {
                        window.open(ProjectURL.BaseURL, "_self")
                    }

                    if ((data.Message.indexOf("Sequence") !== -1))
                        toastr.warning(Resource.SequenceExistMessage);
                    /*else toastr.error(data.Message);*/

                    if (ErrorCallback && typeof (ErrorCallback) === "function")
                        ErrorCallback(data);
                }

            } /*else toastr.error(data.Message);*/
        }
    });
}

function GetAjaxData(Ajaxurl, AjaxData, SuccessCallback, ErrorCallback) {

    $.ajax({
        type: "POST", cache: false, url: Ajaxurl, data: AjaxData,
        success: function (data) {
            if (data != null) {
                if (data.Status == 'Success') {
                    if (SuccessCallback && typeof (SuccessCallback) === "function")
                        SuccessCallback(data);
                } else if (data.Status == 'Error') {

                    if (data.toString().indexOf("LoginBody") >= 0) {
                        window.open(ProjectURL.BaseURL, "_self")
                    }

                    if (ErrorCallback && typeof (ErrorCallback) === "function")
                        ErrorCallback(data);
                } else if (data.toString().indexOf("LoginBody") >= 0) {
                    window.open(ProjectURL.BaseURL, "_self")
                }

            } else toastr.error(data.Message);
        }
    });
}

function Merge2JsonObject(MergeToModel, MasterSourceJson, AddNewMergeColumnName, MergeColumnNameValue, MergeColumnValue) {

    var returnModel = [];

    if (MergeToModel != null) {
        if (MergeColumnValue == null) MergeColumnValue = MergeColumnNameValue;

        for (var i = 0; i < MergeToModel.length; i++) {/*Destination model*/

            var to = MergeToModel[i];

            for (var j = 0; j < MasterSourceJson.length; j++) {
                var from = MasterSourceJson[j];
                if (to[MergeColumnValue] != null)
                    if (to[MergeColumnValue].toString() === from[MergeColumnNameValue].toString()) {
                        to[AddNewMergeColumnName] = from[MergeColumnNameValue];
                        returnModel.push(to);
                        break;
                    }
            }
        }
    }

    return returnModel;
}

function ChosenItemDisable(formcontrol, data, CheckPropertyName, PropertyName, DisabledToolTip) {
    $.each(data, function (i, item) {
        if (item[CheckPropertyName] === true) {
            $(formcontrol + " option[value='" + item[PropertyName].toString() + "']").prop("disabled", true);
            $(formcontrol).trigger('chosen:updated');
            if (DisabledToolTip != null)
                $(formcontrol + "_chosen .search-choice-disabled").attr("title", DisabledToolTip);
        }
    });
}

function BindAutoComplete(ControlID, AjaxUrl, MinLengthSearch, TextColumnName, ValueColumnName, preCallback, SelectCallback, onChangeCallback) {

    $(ControlID).autocomplete({
        source: function (request, response) {
            var AjaxData = {};
            if (preCallback && typeof (preCallback) === "function")
                AjaxData = preCallback(AjaxData);

            if (AjaxData === undefined)
                return;

            $.ajax({
                url: AjaxUrl, data: AjaxData,/*type: "POST",*/traditional: true, cache: false,
                success: function (data) {

                    response($.map(eval(data.Data), function (item) {
                        if (TextColumnName == null || ValueColumnName == null)
                            return { label: item.Text, val: item.Value };
                        else
                            return { label: item[TextColumnName], val: item[ValueColumnName] };
                    }));
                },
                error: function (response) { }, failure: function (response) { }
            });
        },
        select: function (e, i) {

            $(e.target).attr("data-id", i.item.val).attr("data-label", i.item.label);

            if (SelectCallback && typeof (SelectCallback) === "function")
                SelectCallback(e, i);
        },
        change: function (event, ui) {

            if (ui.item == null || ui.item == undefined) {
                if ($(event.target).val().trim().length > 0) {/*Bind Previous Item*/
                    if ($(event.target).hasAttr('data-label') != false && $(event.target).hasAttr('data-id') != false) {
                        $(event.target).val($(event.target).attr("data-label")).attr($(event.target).attr("data-id"));
                    } else
                        $(event.target).val("");
                } else $(event.target).attr("data-label", "").attr("data-id", "");
            } else {
                $(event.target).attr("data-id", ui.item.val).attr("data-label", ui.item.label);
            }

            if (onChangeCallback && typeof (onChangeCallback) === "function")
                onChangeCallback(event, ui);
        },
        minLength: MinLengthSearch
    });
}

function BindAutoCompleteForNewAndOld(ControlID, AjaxUrl, MinLengthSearch, TextColumnName, ValueColumnName, preCallback, SelectCallback, onChangeCallback) {

    $(ControlID).autocomplete({
        source: function (request, response) {
            var AjaxData = {};
            if (preCallback && typeof (preCallback) === "function")
                AjaxData = preCallback(AjaxData);

            if (AjaxData === undefined)
                return;

            $.ajax({
                url: AjaxUrl, data: AjaxData,/*type: "POST",*/traditional: true, cache: false,
                success: function (data) {

                    response($.map(eval(data.Data), function (item) {
                        if (TextColumnName == null || ValueColumnName == null)
                            return { label: item.Text, val: item.Value };
                        else
                            return { label: item[TextColumnName], val: item[ValueColumnName] };
                    }));
                },
                error: function (response) { }, failure: function (response) { }
            });
        },
        select: function (e, i) {

            $(e.target).attr("data-id", i.item.val).attr("data-label", i.item.label);

            if (SelectCallback && typeof (SelectCallback) === "function")
                SelectCallback(e, i);
        },
        change: function (event, ui) {

            if (ui.item == null || ui.item == undefined) {
                if ($(event.target).val().trim().length > 0) {/*Bind Previous Item*/
                    //if ($(event.target).hasAttr('data-label') != false && $(event.target).hasAttr('data-id') != false) {
                    //    $(event.target).val($(event.target).attr("data-label")).attr($(event.target).attr("data-id"));
                    //}
                    //else $(event.target).val("");

                    if ($(event.target).hasAttr('data-label') != false && $(event.target).hasAttr('data-id') != false &&
                        $(event.target).val().trim() == $(event.target).attr('data-label').trim()) {

                        $(event.target).val($(event.target).attr("data-label")).attr($(event.target).attr("data-id"));
                    }
                    else {
                        $(event.target).attr("data-label", "").attr("data-id", "");
                    }

                } else $(event.target).attr("data-label", "").attr("data-id", "");
            } else {
                $(event.target).attr("data-id", ui.item.val).attr("data-label", ui.item.label);
            }

            if (onChangeCallback && typeof (onChangeCallback) === "function")
                onChangeCallback(event, ui);
        },
        minLength: MinLengthSearch
    });
}

function BindAutoCompleteCurrentData(ControlID, AjaxUrl, MinLengthSearch, TextColumnName, ValueColumnName, preCallback, SelectCallback, onChangeCallback) {

    $(ControlID).autocomplete({
        source: function (request, response) {
            var AjaxData = {};
            if (preCallback && typeof (preCallback) === "function")
                AjaxData = preCallback(AjaxData);

            if (AjaxData === undefined)
                return;

            $.ajax({
                url: AjaxUrl, data: AjaxData,/*type: "POST",*/traditional: true, cache: false,
                success: function (data) {

                    response($.map(eval(data.Data), function (item) {
                        if (TextColumnName == null || ValueColumnName == null)
                            return { label: item.Text, val: item.Value };
                        else
                            return { label: item[TextColumnName], val: item[ValueColumnName] };
                    }));
                },
                error: function (response) { }, failure: function (response) { }
            });
        },
        select: function (e, i) {

            $(e.target).attr("data-id", i.item.val).attr("data-label", i.item.label);

            if (SelectCallback && typeof (SelectCallback) === "function")
                SelectCallback(e, i);
        },
        minLength: MinLengthSearch
    });
}

function ShowUploadImagePreview(input, ImageControlID) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            /*$(ImageControlID).css('visibility', 'visible');*/
            $(ImageControlID).attr('src', e.target.result);
            $(ImageControlID).show();
        }
        reader.readAsDataURL(input.files[0]);
        $(ImageControlID).show();
    } else {

    }
}

function GetNoOfVisits(fromDate, months, frequency) {
    var FromDate = new Date(fromDate); var ToDate = new Date(fromDate); ToDate.setMonth(ToDate.getMonth() + months);
    /*var days = dayDiff(FromDate, ToDate) - 1;*/
    var days = dayDiff(FromDate, ToDate);
    switch (frequency) {
        case "DY":
            days = days; break;
        case "WK":
            days = Math.round(days / 7); break;
        case "MT":
            days = months; break;
        case "QR":
            days = Math.round(months / 3); break;
        case "SA":
            if (months > 3)
                days = Math.round(months / 6);
            else
                days = 0;
            break;
        case "YR":
            if (months > 6)
                days = Math.round(months / 12);
            else
                days = 0;
            break;
        case "2Y":
            if (months > 12)
                days = Math.round(months / (2 * 12));
            else
                days = 0;
            break;
        case "5Y":
            if (months > 24)
                days = Math.round(months / (5 * 12));
            else
                days = 0;
            break;
        default:
            break;
    }

    return days;
}

function dayDiff(FromDate, ToDate) {
    return ((ToDate - FromDate) / (1000 * 60 * 60 * 24));
}

function ConvertTimeAMPMTo24Hour(inputval) {

    if (inputval.length > 0) {
        var tokens = /([10]?\d):([0-5]\d) ([ap]m)/i.exec(inputval);
        if (tokens == null) { return null; }
        if (tokens[3].toLowerCase() === 'pm' && tokens[1] !== '12') {
            tokens[1] = '' + (12 + (+tokens[1]));
        } else if (tokens[3].toLowerCase() === 'am' && tokens[1] === '12') {
            tokens[1] = '00';
        }

        var convertedval = tokens[1] + ':' + tokens[2];
        return (convertedval);
    } else {
        return null;
    }
}

function ArraytoObject(arr) {
    var rv = {};
    for (var i = 0; i < arr.length; ++i)
        rv[i] = arr[i];
    return rv;
}

function GetXrefModelByLanguageCode(MergeToModel, XrefModelName, AddNewColumnName, ColumnName, CurrentLangugeCode) {
    var returnModel = [];

    if (MergeToModel != null) {
        for (var i = 0; i < MergeToModel.length; i++) {

            var to = MergeToModel[i];
            var sourceJson = MergeToModel[i][XrefModelName];

            for (var j = 0; j < sourceJson.length; j++) {
                var from = sourceJson[j];
                if (from[ColumnName] === CurrentLangugeCode) {
                    to[AddNewColumnName] = from[AddNewColumnName];
                    returnModel.push(to);
                    break;
                }
            }
        }
    }

    return returnModel;
}

function ImageViewer(ID) {
    /*<link href='~/Assets/css/colorbox.min.css' rel='stylesheet' /> <script src='~/Assets/js/jquery.colorbox.min.js'></script>*/
    $(document).ready(function () {

        var $overflow = '';
        var colorbox_params = {
            rel: 'colorbox', reposition: true, scalePhotos: true, scrolling: false,
            previous: '<i class="ace-icon fa fa-arrow-left"></i>',
            next: '<i class="ace-icon fa fa-arrow-right"></i>',
            close: '&times;', current: '{current} of {total}', maxWidth: '100%', maxHeight: '100%',
            onOpen: function () { $overflow = document.body.style.overflow; document.body.style.overflow = 'hidden'; },
            onClosed: function () { document.body.style.overflow = $overflow; },
            onComplete: function () { $.colorbox.resize(); }
        };

        $(ID + ' [data-rel="colorbox"]').colorbox(colorbox_params);
        /*$("#cboxLoadingGraphic").html("<i class='ace-icon fa fa-spinner orange fa-spin'></i>");let's add a custom loading icon*/

        $(document).one('ajaxloadstart.page', function (e) { $('#colorbox, #cboxOverlay').remove(); });
    });
}

/*---------------------------------------------------------------------------*/

var url = window.location;
var ProjectURL = { BaseURL: url.origin, CurrentURL: url.href };

var InspectionRedirect = {

    /*AMC, Audit, Resolution*/
    InspectionType: null,

    Status: null,

    FromDate: null,
    ToDate: null,

    CustomerID: null,
    LocationID: null,

    TravelFrom: null,

    GoInspectionTypeStatus: function (InspectionType, flag) {
        this.InspectionType = InspectionType;

        this.Status = "NotChecked";
        this.FromDate = null;
        this.ToDate = _DashboardToDateCustom;

        this.CustomerID = $("#txtCustomerSearch").attr("data-id");

        this.TravelFrom = "InspectionTypeStatusGraph";
        var GlobalID = globalScreenID.InspectionScreenID;

        var urlparam = "?GlobalID=" + GlobalID;

        if (this.CustomerID != null)
            urlparam += "&CustomerID=" + this.CustomerID;

        if (this.InspectionType != null)
            urlparam += "&InspectionType=" + this.InspectionType;

        if (this.TravelFrom != null)
            urlparam += "&TravelFrom=" + this.TravelFrom;

        if (this.Status != null)
            urlparam += "&Status=" + this.Status;

        if (this.ToDate != null)
            urlparam += "&ToDate=" + this.ToDate;
        if (parseInt(flag) > 0 && IsNotNull(GlobalID))
            window.open(ProjectURL.BaseURL + "/Safety/Inspection/RedirectFrom/" + urlparam, "_self");
    },

    GoInspectionMonthlySnapShot: function (flag) {
        /*this.InspectionType = null;

        this.Status = Status;
        this.FromDate = null;
        this.ToDate = _DashboardToDateCustom;

        this.CustomerID = $("#txtCustomerSearch").attr("data-id");
        this.LocationID = "";
        this.TravelFrom = "InspectionTypeStatusGraph";*/
        var GlobalID = globalScreenID.InspectionScreenID;

        var urlparam = "?GlobalID=" + GlobalID;

        if (this.CustomerID != null)
            urlparam += "&CustomerID=" + this.CustomerID;

        if (this.InspectionType != null)
            urlparam += "&InspectionType=" + this.InspectionType;

        if (this.TravelFrom != null)
            urlparam += "&TravelFrom=" + this.TravelFrom;

        if (this.Status != null)
            urlparam += "&Status=" + this.Status;

        if (this.FromDate != null)
            urlparam += "&FromDate=" + this.FromDate;

        if (this.ToDate != null)
            urlparam += "&ToDate=" + this.ToDate;

        if (parseInt(flag) > 0 && IsNotNull(GlobalID))
            window.open(ProjectURL.BaseURL + "/Safety/Inspection/RedirectFrom/" + urlparam, "_self");
    },

    GoInspectionYearlySnapShot: function (flag) {
        /*this.InspectionType = null;
        this.Status = Status;
        this.FromDate = null;
        this.ToDate = _DashboardToDateCustom;

        this.CustomerID = $("#txtCustomerSearch").attr("data-id");
        this.LocationID = "";
        this.TravelFrom = "InspectionTypeStatusGraph";*/
        var GlobalID = globalScreenID.InspectionScreenID;

        var urlparam = "?GlobalID=" + GlobalID;

        if (this.CustomerID != null)
            urlparam += "&CustomerID=" + this.CustomerID;

        if (this.InspectionType != null)
            urlparam += "&InspectionType=" + this.InspectionType;

        if (this.TravelFrom != null)
            urlparam += "&TravelFrom=" + this.TravelFrom;

        if (this.Status != null)
            urlparam += "&Status=" + this.Status;

        if (this.FromDate != null)
            urlparam += "&FromDate=" + this.FromDate;

        if (this.ToDate != null)
            urlparam += "&ToDate=" + this.ToDate;

        if (/*parseInt(flag) > 0 && */ IsNotNull(GlobalID))
            window.open(ProjectURL.BaseURL + "/Safety/Inspection/RedirectFrom/" + urlparam, "_self");
    },

    GoInspectionYearlyCalenderSnapShot: function (flag) {
        /*this.InspectionType = null;

        this.Status = Status;
        this.FromDate = null;
        this.ToDate = _DashboardToDateCustom;

        this.CustomerID = $("#txtCustomerSearch").attr("data-id");
        this.LocationID = "";
        this.TravelFrom = "InspectionTypeStatusGraph";*/
        var GlobalID = globalScreenID.InspectionScreenID;

        var urlparam = "?GlobalID=" + GlobalID;

        if (this.CustomerID != null)
            urlparam += "&CustomerID=" + this.CustomerID;

        if (this.LocationID != null)
            urlparam += "&LocationID=" + this.LocationID;

        if (this.InspectionType != null)
            urlparam += "&InspectionType=" + this.InspectionType;

        if (this.TravelFrom != null)
            urlparam += "&TravelFrom=" + this.TravelFrom;

        if (this.Status != null)
            urlparam += "&Status=" + this.Status;

        if (this.FromDate != null)
            urlparam += "&FromDate=" + this.FromDate;

        if (this.ToDate != null)
            urlparam += "&ToDate=" + this.ToDate;

        if (parseInt(flag) > 0 && IsNotNull(GlobalID))
            window.open(ProjectURL.BaseURL + "/Safety/Inspection/RedirectFrom/" + urlparam, "_self");
    },

    GoResolutionStatus: function (InspectionType, Status) {
        this.InspectionType = InspectionType;

        this.Status = Status;
        this.ToDate = _DashboardToDateCustom;
        this.CustomerID = $("#txtCustomerSearch").attr("data-id");
        this.TravelFrom = "DeviationStatusGraph";
        var GlobalID = globalScreenID.ResolutionDeviationID;

        var urlparam = "?GlobalID=" + GlobalID;

        if (this.CustomerID != null)
            urlparam += "&CustomerID=" + this.CustomerID;

        if (this.InspectionType != null)
            urlparam += "&InspectionType=" + this.InspectionType;

        if (this.TravelFrom != null)
            urlparam += "&TravelFrom=" + this.TravelFrom;

        if (this.Status != null)
            urlparam += "&Status=" + this.Status;

        if (this.FromDate != null)
            urlparam += "&FromDate=" + this.FromDate;

        if (this.ToDate != null)
            urlparam += "&ToDate=" + this.ToDate;

        if (IsNotNull(GlobalID))
            window.open(ProjectURL.BaseURL + "/Safety/InspectionResoultion/RedirectFrom/" + urlparam, "_self");
    },

};
var ResolutionRedirect = {};

/*---------------------------------------------------------------------------*/
function getScreenOnSearch(objectName) {
    var data = [];

    $(".MyScreen").each(function (i, ele) { data.push({ "ObjectName": $(this).attr('data-label'), "ScreenID": $(this).attr('data-id') }); });

    var searchData = data.filter(function (el) { return el.ObjectName.toLowerCase().indexOf(objectName.toLowerCase()) > -1; });
    return searchData;
}

function GetValueToListBoxSelectedCommaSplit(ControlID) {
    var returnVal = "";

    $(ControlID + " :selected").each(function (i, selected) {
        returnVal += $(selected).val().toString() + ",";
    });

    return returnVal;
}

/* Get random Color */
function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

function MenuScreenSearch() {

    $("#txt-nav-search-input").autocomplete({
        source: function (request, response) {
            var data = getScreenOnSearch($("#txt-nav-search-input").val().trim());
            response($.map(eval(data),
                function (item) {
                    return { label: item.ObjectName, val: item.ScreenID }
                }));
        },
        select: function (e, i) {
            $(e.target).attr("data-id", i.item.val).attr("data-label", i.item.label);
            window.location = $("#Search_" + i.item.val).attr('href');
        },

        change: function (event, ui) {
            if (ui.item == null || ui.item == undefined) {
                if ($(event.target).val().trim().length > 0) {/*Bind Previous Item*/
                    if ($(event.target).hasAttr('data-label') != false && $(event.target).hasAttr('data-id') != false) {
                        $(event.target).val($(event.target).attr("data-label")).attr($(event.target).attr("data-id"));
                    } else
                        $(event.target).val("");
                } else $(event.target).attr("data-label", "").attr("data-id", "");
            } else {
                $(event.target).attr("data-id", ui.item.val).attr("data-label", ui.item.label);
            }
        }
    });
}