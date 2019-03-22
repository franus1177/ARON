

namespace WebPortal.Business.Entities.ViewModels
{
    public class CustomerDashboard_VM : Base_VM
    {
        public int LocationCount { get; set; }
        public int ObjectInstanceCount { get; set; }
        public int ContractCount { get; set; }
        public int CategoryCount { get; set; }
        public string CustomerLogo { get; set; }
    }
   
}
