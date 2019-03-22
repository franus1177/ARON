using System.ComponentModel.DataAnnotations;
namespace WebPortal.Business.Entities.ViewModels
{
    public class CustomerAddress_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(25)]
		[Required]
		public string AddressType { get; set; }

        [MaxLength(25)]
        public string AddressTypeOld { get; set; }
    
        [MaxLength(100)]
		[Required]
		public string AddressLine1 { get; set; } 

		[MaxLength(100)]
		public string AddressLine2 { get; set; }

        public string Address { get { return AddressLine1 + " " + AddressLine2; } }

        [MaxLength(25)]
		[Required]
		public string CityName { get; set; } 

		[MaxLength(25)]
		public string StateName { get; set; } 

		[MaxLength(25)]
		[Required]
		public string CountryName { get; set; } 

		[MaxLength(10)]
		public string Pincode { get; set; } 

		[Required]
		public bool? IsPrimaryAddress { get; set; } 
	}
};
