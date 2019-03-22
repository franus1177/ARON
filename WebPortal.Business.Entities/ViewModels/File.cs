using System;
using System.ComponentModel.DataAnnotations;
using System.Drawing;

namespace WebPortal.Business.Entities.ViewModels
{
    public class File_VM
    {
        public Int64 DeviationID { get; set; }
        public Int64 FileID { get; set; }

        [Required]
        public string FileName { get; set; }
        public string FilePath { get; set; }

        public string Type { get; set; }

        [Required]
        public string FileType { get; set; }
        public string FileRemarks { get; set; }

        [Required]
        public string FileRelativePath { get; set; }
        public virtual byte[] TxnTimestamp { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime LastAccessDateTime { get; set; }
        public int AccessCount { get; set; }
    }

    public class DeviationImages
    {
        public Image image { get; set; }
        public string fileName { get; set; }
    }
};
