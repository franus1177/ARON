using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerLanguage_TableType_VM
	{
		[Key]
		[MaxLength(2)]
		[Required]
		public string LanguageCode { get; set; } 


	}
};
