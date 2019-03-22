using System.Collections.Generic;

namespace WebPortal.Business.Entities.ViewModels
{
    public class BaseDashboard_VM : Base_VM
    {
        public short? CustomerID { get; set; }
        public int MonthDuration { get; set; }
    }

    public class BaseDashboardCustomerList_VM
    {
        public short? CustomerID { get; set; }
        public int TrainingStatusCount { get; set; }
        public string CustomerName { get; set; }
        public int Risk { get; set; }
        public int Controlled { get; set; }
        public int IncidentCount { get; set; }
        public int DrillActionClosureCount { get; set; }

        public List<EndUserModule_VM> ModuleCodeListEndUserwise { get; set; }
    }
};