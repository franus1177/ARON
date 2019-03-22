using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System;

namespace WebPortal.Business.Entities.ViewModels
{
	public class UserLocation_VM : Base_VM
	{
		[MaxLength(2)]
		public string ModuleCode { get; set; } 

		[MaxLength(2)]
		public string ServiceLineCode { get; set; } 

		[Required]
		public int? UserID { get; set; }

        public short? CustomerID { get; set; }
        public string CustomerName { get; set; }
        public DateTime? Date { get; set; }
        
        //public List<UserLocation_TableType_VM> UserLocation_TableTypeList { get; set; }

        public List<UserLocationModule_VM> UserLocationModuleList { get; set; }
        public List<UserLocationServiceLine_VM> UserLocationServiceLineList { get; set; }

        public List<UserLocationLocation_VM> UserLocationLocationList { get; set; }

    }
    public class UserLocationModule_VM 
    {
        public short? CustomerID { get; set; }
        public string ModuleCode { get; set; }

        public string Text { get { return ModuleCode; } }
        public string Value { get { return ModuleCode; } }
    }
    public class UserLocationServiceLine_VM : Base_VM
    {
        public short? CustomerID { get; set; }
        public string ServiceLineCode { get; set; }

        public string Text { get { return ServiceLineCode; } }
        public string Value { get { return ServiceLineCode; } }
    }

    public class UserLocationLocation_VM : Base_VM
    {
       
        [Key]
        [Required]
        public int? LocationID { get; set; }
        public short? CustomerID { get; set; }
        public string CustomerName { get; set; }
        
        public int? ParentLocationID { get; set; }

        public bool? IsLocationScheduled { get; set; }

        public string Value { get { return "" + LocationID.ToString(); } }

    }
};
