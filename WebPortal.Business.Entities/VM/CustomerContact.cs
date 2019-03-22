using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
namespace WebPortal.Business.Entities.ViewModels
{
    public class CustomerContact_VM : Base_VM
	{
		[Key]
		[Required]
		public short? CustomerID { get; set; } 

		[Key]
		[MaxLength(50)]
		[Required]
		public string ContactName { get; set; } 
		public string ContactNameOld { get; set; }

        [MaxLength(100)]
		public string Email { get; set; } 

		[MaxLength(50)]
		public string Telephone { get; set; } 

		[MaxLength(50)]
		public string Mobile { get; set; } 

		public bool? IsPrimaryContact { get; set; }

        #region End User Parameters

        public bool? IsWebAccess { get; set; }

        public int? UserID { get; set; }

        public string LanguageCode { get; set; }

        public decimal? UTCOffset { get; set; }

        [MaxLength(2)]
        public string DefaultModuleCode { get; set; }

        [MaxLength(10)]
        public string Gender { get; set; }

        [MaxLength(16)]
        public string UserIdentity { get; set; }
    
        public List<EndUserModule_TableType_VM> EndUserModule_TableTypeList { get; set; }

        public List<UserRoleUser_TableType_VM> UserRoleUser_TableTypeList { get; set; }

        public List<EndUserModule_VM> EndUserModuleList { get; set; }

        public List<UserRoleUser_VM> UserRoleUserList { get; set; }

        #endregion End User Parameters
    }
};