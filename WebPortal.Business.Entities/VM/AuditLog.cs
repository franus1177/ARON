using System;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.VM
{
    public class AuditLogReport_VM : Base_VM
    {
        public int? EndUserID { get; set; }
        public short? UserRoleID { get; set; }
        public short? ScreenID { get; set; }

        public string ObjectID { get; set; }
        public string OperationType { get; set; }

        public string ScreenName { get; set; }
        public string UserName { get; set; }
        public string ObjectName { get; set; }
        public string AccessPoints { get; set; }

        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public DateTime? OperationDateTime { get; set; }
        public string OperationDateTimeCustom
        {
            get
            {
                if (OperationDateTime != null) return Convert.ToDateTime(OperationDateTime).ToString("dd-MMM-yyyy h:mm tt"); return "";
            }
        }
        public double AuditLogID { get; set; }

        public string PreImageCustom { get; set; }

        public string TableName { get; set; }

        public string ModuleCode { get; set; }

        public string OperationTypeCustom {
            get
            {
                if (OperationType == "I")
                    return "Add";
                else if (OperationType == "U")
                    return "Edit";
                else if (OperationType == "D")
                    return "Delete";
                else return "";
            }
        }
    }
}
