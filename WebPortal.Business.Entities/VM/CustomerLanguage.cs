using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerLanguage_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(2)]
		[Required]
		public string LanguageCode { get; set; }
        public string Text { get { return LanguageCode; } }
        public string Value { get { return LanguageCode; } }


    }
};
