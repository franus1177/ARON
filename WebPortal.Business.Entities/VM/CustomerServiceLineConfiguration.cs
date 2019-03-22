using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerServiceLineConfiguration_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(2)]
		[Required]
		public string ServiceLineCode { get; set; } 

		[Key]
		[MaxLength(20)]
		[Required]
		public string ConfigurationCode { get; set; } 

		public int? ConfigurationValue { get; set; } 


	}
};
