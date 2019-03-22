using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System;

namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerWeeklyOff_VM : Base_VM
	{
		[Key]
		//[Required]
		public int? LocationID { get; set; }

        public int? CustomerID { get; set; }

        public int? CustomerLocationID { get; set; }
        public string LocationName { get; set; }

        [Key]
		[MaxLength(15)]
		//[Required]
		public string DayName { get; set; } 

		public List<CustomerWeeklyOffName_VM> CustomerWeeklyOffNameList { get; set; } 

		[Required]
		public List<CustomerWeeklyOffName_TableType_VM> CustomerWeeklyOffName_TableTypeList { get; set; }

        public List<CustomerLocationList_VM> CustomerLocationList { get; set; }

        [Required]
        public List<CustomerLocationList_VM> CustomerLocation_TableTypeList { get; set; }

    }

    public class CustomerLocationList_VM
    {
        [Required]
        public int? LocationID { get; set; }
    }
};
