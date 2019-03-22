using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
	public class Fixture_VM : Base_VM
	{
		[Key]
		//[Required]
		public Nullable<int> FixtureID { get; set; } 

		[MaxLength(200)]
		[Required]
		public string FixtureName { get; set; }

        [MaxLength(50)]
        public string FixtureCode { get; set; }

        public Nullable<decimal> FixtureCost { get; set; } 

		public List<FixturePart_VM> FixturePartList { get; set; } 

		[Required]
		public List<FixturePart_TableType_VM> FixturePart_TableTypeList { get; set; } 

	}
};
