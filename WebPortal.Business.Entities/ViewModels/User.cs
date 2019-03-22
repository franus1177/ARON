using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class EndUser_VM : Base_VM
    {
        [Key]
        public int? EndUserID { get; set; }

        [Required]
        [MaxLength(50)]
        public string LoginID { get; set; }
        [MaxLength(30)]

        [Required]
        public string FirstName { get; set; }

        [MaxLength(30)]
        public string MiddleName { get; set; }

        [MaxLength(30)]
        [Required]
        public string LastName { get; set; }

        [MaxLength(2)]
        [Required]
        public string LanguageCode { get; set; }

        [Required]
        public decimal? UTCOffset { get; set; }

        [Required]
        [MaxLength(2)]
        public string DefaultModuleCode { get; set; }

        [Required]
        [MaxLength(10)]
        public string Gender { get; set; }

        [Required]
        [MaxLength(50)]
        public string EmailID { get; set; }

        public short? UserRoleID { get; set; }
        public string UserRoleName { get; set; }

        [MaxLength(16)]
        public string UserIdentity { get; set; }
        public DateTime? ActivatedDTM { get; set; }

        [MaxLength(25)]
        public string LastAccessPoint { get; set; }
        public DateTime? LastLoginDTM { get; set; }

        [MaxLength(100)]
        public string SecretQuestion { get; set; }

        [MaxLength(100)]
        public string SecretAnswer { get; set; }
        public int? ActivationURLID { get; set; }
        public int? ResetPasswordURLID { get; set; }

        public string Text { get { return FirstName + " " + LastName; } }
        public string Value { get { return EndUserID.ToString(); } }
        public string Name { get; set; }

        public short? DesignationID { get; set; }
        public short? DepartmentID { get; set; }

        public string DesignationName { get; set; }
        public string DepartmentName { get; set; }

        public List<EndUserModule_VM> EndUserModuleList { get; set; }

        [Required]
        public List<EndUserModule_TableType_VM> EndUserModule_TableTypeList { get; set; }

        public List<UserRoleUser_VM> UserRoleUserList { get; set; }
        [Required]
        public List<UserRoleUser_TableType_VM> UserRoleUser_TableTypeList { get; set; }

        //Not to make nullable
        public bool IsCustomerUser { get; set; }
    }

    public class TimeZone_VM
    {
        public int TimeZoneID { get; set; }
        public double TimeZoneValue { get; set; }
        public string Descriptions { get; set; }
    }

    public class UserEmployee_VM : Base_VM
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string LoginID { get; set; }
        public Int16 UserRoleID { get; set; }
        public string UserName { get; set; }
        public string UserRoleName { get; set; }
        public int EndUserID { get; set; }
        public string LanguageCode { get; set; }
        public string DefaultModuleCode { get; set; }
        public bool IsCustomerUser { get; set; }
    }

    public class UserCustomerList_VM : Base_VM
    {
        public int? EndUserID { get; set; }
        public int? LocationID { get; set; }
        public string LocationName { get; set; }
        public short? CustomerID { get; set; }
        public string CustomerName { get; set; }
    }
    public class EndUserModule_TableType_VM
    {
        [Key]
        [MaxLength(2)]
        [Required]
        public string ModuleCode { get; set; }
    }

    public class EndUserModule_VM
    {
        [Key]
        [Required]
        public int? EndUserID { get; set; }
        [Key]
        [MaxLength(2)]
        [Required]
        public string ModuleCode { get; set; }
        public string Value { get { return ModuleCode; } }
    }

    public class UserRoleUser_VM
    {
        [Key]
        [Required]
        public short? UserRoleID { get; set; }
        [Key]
        [Required]
        public int? EndUserID { get; set; }
    }

    public class UserRoleUser_TableType_VM
    {
        [Key]
        [Required]
        public short? UserRoleID { get; set; }
    }

    public class MailEndUser_VM
    {
        public int? EndUserID { get; set; }

        [MaxLength(50)]
        public string LoginID { get; set; }

        [MaxLength(30)]
        public string FirstName { get; set; }

        [MaxLength(30)]
        public string MiddleName { get; set; }

        [MaxLength(30)]
        public string LastName { get; set; }

        [MaxLength(2)]
        public string LanguageCode { get; set; }

        public decimal? UTCOffset { get; set; }

        [MaxLength(2)]
        public string DefaultModuleCode { get; set; }

        [MaxLength(10)]
        public string Gender { get; set; }

        [MaxLength(50)]
        public string EmailID { get; set; }

        //[MaxLength(16)]
        //public string UserIdentity { get; set; }
        public DateTime? ActivatedDTM { get; set; }

        [MaxLength(25)]
        public string LastAccessPoint { get; set; }
        public DateTime? LastLoginDTM { get; set; }

        [MaxLength(100)]
        public string SecretQuestion { get; set; }

        [MaxLength(100)]
        public string SecretAnswer { get; set; }
        public int? ActivationURLID { get; set; }
        public int? ResetPasswordURLID { get; set; }

        public string Text { get { return FirstName + " " + LastName; } }
        public string Value { get { return EndUserID.ToString(); } }
        public string Name { get; set; }

    }
}