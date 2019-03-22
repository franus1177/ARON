using System;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class MailLog_VM : Base_VM
    {
        [Key]
        public Int64? MailID { get; set; }

        public string MailType { get; set; }

        public DateTime? CreatedDate { get; set; }

        public bool IsMailFromFrontEnd { get; set; }

        [Required]
        public string FromMailID { get; set; }

        [Required]
        public string RecipientMailList { get; set; }
        public string CCMailList { get; set; }
        public string BCCMailList { get; set; }

        [Required]
        public string MailSubject { get; set; }

        [Required]
        public string Body { get; set; }
        public Int64? MailItemID { get; set; }
    }
}
