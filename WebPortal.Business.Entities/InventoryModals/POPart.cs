using System;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
	public class POPart_VM : Base_VM
	{
		[Key]
        //[Required]
        public Nullable<int> POPartID { get; set; }

        public Nullable<int> POID { get; set; }

        public Nullable<int> PartID { get; set; }
		public string PartName { get; set; }
		public string PartDescription { get; set; }
		public string PartVendor { get; set; }
		public decimal? PartCost { get; set; }
		public int PartQuantity { get; set; }

        public Nullable<int> Quantity { get; set; }
	}
};