using System;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
    public class Part_VM : Base_VM
    {
        [Key]
        //[Required]
        public Nullable<int> PartID { get; set; }

        [MaxLength(200)]
        public string PartName { get; set; }

        [MaxLength(500)]
        public string PartDescription { get; set; }

        [MaxLength(50)]
        public string PartVendor { get; set; }

        public Nullable<decimal> PartCost { get; set; }

        public Nullable<int> PartQuantity { get; set; }
    }
};