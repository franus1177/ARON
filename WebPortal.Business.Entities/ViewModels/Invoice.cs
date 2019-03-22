using System;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class Invoice_VM : Base_VM
    {
        [Key]
        public Nullable<int> InvoiceID { get; set; }

        //[Required]
        public Nullable<short> CustomerID { get; set; }

        [Required]
        public Nullable<DateTime> OrderDate { get; set; }
        public string OrderDateCustom { get { return DateFormat(OrderDate); } }

        public Nullable<DateTime> ExpectedDeliveryDate { get; set; }

        public string ExpectedDeliveryDateCustom { get { return DateFormat(ExpectedDeliveryDate); } }

        [MaxLength(50)]
        [Required]
        public string InvoiceName { get; set; }

        [MaxLength(50)]
        public string Frame { get; set; }

        [MaxLength(50)]
        public string Lens { get; set; }

        [Required]
        public Nullable<decimal> FrameAmount { get; set; }

        [Required]
        public Nullable<decimal> LensAmount { get; set; }

        [MaxLength(50)]
        public string RefractionBy { get; set; }

        [MaxLength(100)]
        public string Remarks { get; set; }

        [MaxLength(10)]
        public string RESPH { get; set; }

        [MaxLength(10)]
        public string RECYL { get; set; }

        [MaxLength(10)]
        public string REAXIS { get; set; }

        [MaxLength(10)]
        public string REVA { get; set; }

        [MaxLength(10)]
        public string READD { get; set; }

        [MaxLength(10)]
        public string LESPH { get; set; }

        [MaxLength(10)]
        public string LECYL { get; set; }

        [MaxLength(10)]
        public string LEAXIS { get; set; }

        [MaxLength(10)]
        public string LEVA { get; set; }

        [MaxLength(10)]
        public string LEADD { get; set; }

        //[Required]
        public Nullable<short> AdvanceAmount { get; set; }
        
        public Nullable<short> TotalAmount { get; set; }
        
        public Nullable<short> PendingAmount { get; set; }

        public bool IsDelivery { get; set; }
        
        #region Customer info
        public string CustomerName { get; set; }

        public string CustomerAddress { get; set; }

        public string ContactNumber { get; set; }

        public Nullable<DateTime> DOB { get; set; }

        public string DOBCustom { get { return DateFormat(DOB); } }

        public Nullable<DateTime> AnniversaryDate { get; set; }
        public string AnniversaryDateCustom { get { return DateFormat(AnniversaryDate); } }

        #endregion 
    }

    public class InvoiceCustomerWrapper_VM : Base_VM
    {
        [Required]
        public Invoice_VM Invoice { get; set; }

        public eCustomer_VM Customer { get; set; }
    }
};
