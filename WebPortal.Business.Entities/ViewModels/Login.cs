using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Username is required.")]
        public string Username { get; set; }
        [Required(ErrorMessage = "Password is required.")]
        public string Password { get; set; }
        public bool RememberMe { get; set; }
        public string IPAddress { get; set; }
    }

    public class ResetPasswordVM
    {
        public int? EndUserID { get; set; }

        public int? EmployeeID { get; set; }

        public int? RememberMe { get; set; }

        public string Email { get; set; }

        public string LoginID { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string ConfirmNewPassword { get; set; }
    }
    public class LoginDetails_VM
    {
        public int EndUserID { get; set; }
        public string UserName { get; set; }
    }

    public class ChangePasswordVM
    {
        public int? EndUserID { get; set; }

        public int? EmployeeID { get; set; }

        public int? RememberMe { get; set; }

        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string ConfirmNewPassword { get; set; }
    }

    public class CustomerLocation_CommonControlVM
    {
        public string txtCustomer { get; set; }
        public string txtLocation { get; set; }
        public string CustomerMandatory { get; set; }
        public string LocationMandatory { get; set; }
        public string LocationEvents { get; set; }
    }
}
