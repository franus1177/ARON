using System;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class eCustomer_VM : Base_VM
	{
		[Key]
        //[Required]
        public Nullable<short> CustomerID { get; set; } 

		[MaxLength(100)]
		[Required]
		public string CustomerName { get; set; } 

		[MaxLength(100)]
		public string CustomerAddress { get; set; } 

		[MaxLength(50)]
		public string ContactNumber { get; set; } 

		public Nullable<DateTime> DOB { get; set; } 

		public Nullable<DateTime> AnniversaryDate { get; set; }
	}
};
