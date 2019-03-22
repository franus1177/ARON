using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
	public class POItem_VM : Base_VM
	{
		[Key]
		[Required]
		public Nullable<int> POItemID { get; set; }

		public Nullable<int> POFixtureID { get; set; }

		public Nullable<int> POFixtureQuantity { get; set; }

		public Nullable<int> POID { get; set; }
	}
};