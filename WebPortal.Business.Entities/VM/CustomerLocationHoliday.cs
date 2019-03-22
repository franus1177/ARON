using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System;

namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerLocationHoliday_VM : Base_VM
	{
        [Required]
        public int? CustomerID { get; set; }
        [Key]
		//[Required]
		public int? CustomerLocationID { get; set; }
        public string LocationName { get; set; }
        [Key]
		[Required]
		public DateTime? HolidayDate { get; set; }
        public string HolidayDateCustom { get { return DateFormat(HolidayDate); } }
        public string HolidayName { get; set; }
        public List<CustomerLocationHolidayName_VM> CustomerLocationHolidayNameList { get; set; } 

		[Required]
		public List<CustomerLocationHolidayName_TableType_VM> CustomerLocationHolidayName_TableTypeList { get; set; } 

	}
};
