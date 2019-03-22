using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerServiceLine_TableType_VM
	{
		[Key]
		[MaxLength(2)]
		[Required]
		public string ServiceLineCode { get; set; } 


	}
};
