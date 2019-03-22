using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System;

namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerLocationHolidayName_VM : Base_VM
	{
		[Key]
		[Required]
		public int? CustomerLocationID { get; set; } 

		[Key]
		[Required]
		public DateTime? HolidayDate { get; set; } 

		[Key]
		[MaxLength(2)]
		[Required]
		public string LanguageCode { get; set; } 

		[MaxLength(50)]
		[Required]
		public string HolidayName { get; set; } 


	}
};
