using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class Language_VM : Base_VM
    {
        [Key]
        public string LanguageCode { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(50)]
        [Display(Name = "Language Name")]
        public string LanguageName { get; set; }

        public string Text { get { return LanguageName; } }
        public string Value { get { return LanguageCode; } }
    }
}
