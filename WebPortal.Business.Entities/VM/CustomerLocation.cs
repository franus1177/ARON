using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
    public class CustomerLocation_VM : Base_VM
    {
        [Key]
        [Required]
        public short? CustomerID { get; set; }

        [Key]
        [Required]
        public int? LocationID { get; set; }
        public int? ParentLocationID { get; set; }
        public string ParentLocationName { get; set; }
        public bool? HasChild { get; set; }

        public string Text
        {
            get
            {
                if (ParentLocationName != null)
                    return ParentLocationName.ToString();
                else return string.Empty;
            }
        }
        public string Value { get { return ParentLocationID.ToString(); } }
    }
};
