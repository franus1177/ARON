using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class UserRole_VM : Base_VM
    {
        [Key]
        public short? UserRoleID { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(50)]
        [Display(Name = "User Role Name")]
        public string UserRoleName { get; set; }
    }
}
