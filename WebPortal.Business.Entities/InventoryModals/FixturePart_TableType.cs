using System;
using System.ComponentModel.DataAnnotations;
namespace WebPortal.Business.Entities.InventoryModels
{
	public class FixturePart_TableType_VM
	{
		public Nullable<int> FixturePartID { get; set; }

		public Nullable<int> FixtureID { get; set; }

        [Required]
        public Nullable<int> PartID { get; set; } 

		[Required]
		public Nullable<int> Quantity { get; set; } 
	}
};
