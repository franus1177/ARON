using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerModule_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(2)]
		[Required]
		public string ModuleCode { get; set; }

        public string Text { get { return ModuleCode; } }
        public string Value { get { return ModuleCode; } }
    }
};
