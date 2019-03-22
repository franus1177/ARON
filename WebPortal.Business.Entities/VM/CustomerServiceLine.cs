using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerServiceLine_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(2)]
		[Required]
		public string ServiceLineCode { get; set; }

        public string Text { get { return ServiceLineCode; } }
        public string Value { get { return ServiceLineCode; } }
    }
};
