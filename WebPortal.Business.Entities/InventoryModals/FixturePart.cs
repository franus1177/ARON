using System;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
	public class FixturePart_VM : Base_VM
	{
		[Key]
		//[Required]
		public Nullable<int> FixturePartID { get; set; } 

		[Required]
		public Nullable<int> FixtureID { get; set; } 

		[Required]
		public Nullable<int> PartID { get; set; } 
		public string PartName { get; set; }

        [Required]
		public Nullable<int> Quantity { get; set; } 
	}
};