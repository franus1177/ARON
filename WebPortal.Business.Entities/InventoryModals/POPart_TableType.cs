using System;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.InventoryModels
{
	public class POPart_TableType_VM
	{
		public Nullable<int> POPartID { get; set; }

        [Required]
        public Nullable<int> PartID { get; set; }

        [Required]
        public Nullable<int> Quantity { get; set; } 
	}
};