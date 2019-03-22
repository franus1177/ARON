$(document).ready(function () {
    BaseDashboard.ActiveEvent();

    $("#txtCustomerSearch").autocomplete({
        select: function (e, i) {

            $(e.target).attr("data-id", i.item.val).attr("data-label", i.item.label);
            BaseDashboard.callOnCustomerSelect();
        },
    });
   
});

var BaseDashboard = {

    OnMonthchange:function(){
        BaseDashboard.callOnCustomerSelect();
    },

    callOnCustomerSelect: function () {
        CustomerList.ScreenAccessPermission();
        YearlySnapshot.ScreenAccessPermission();
        MonthlySnapshot.ScreenAccessPermission();
    },

    ActiveEvent: function () {
        BindAutoComplete("#txtCustomerSearch", "/Customer/GetData", 1, "CustomerName", "CustomerID",
                function (DataJson) { /*serachData Pass*/ return { CurrentLanguageCode: CurrentLang, CustomerName: $("#txtCustomerSearch").val() } });

        FillStaticCustomer("#txtCustomerSearch", function () { });
    },

    RefreshUserLeafLocation: function () {

        var formdata = {};//{UserID:10};

        GetAjaxData("/SafetyDashboard/RefreshUserLeafLocation", formdata, function (data) {
            var model = eval(data.Data);

            if (model > 0) {
                //alert('done');
            }
            BaseDashboard.callOnCustomerSelect();
        }, null);
    }
}
