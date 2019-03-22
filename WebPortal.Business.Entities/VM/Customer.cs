using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
namespace WebPortal.Business.Entities.ViewModels
{
    public class Customer_VM : Base_VM
    {
        [Key]
        //[Required]
        public short? CustomerID { get; set; }

        [MaxLength(10)]
        [Required]
        public string CustomerShortCode { get; set; }

        [MaxLength(50)]
        [Required]
        public string CustomerName { get; set; }
        public string Text { get { return CustomerName.ToString(); } }
        public string Value { get { return CustomerID.ToString(); } }

        [MaxLength(50)]
        public string LegalEntityName { get; set; }

        public long? Logo { get; set; }

        public string LogoString { get; set; }
        public string FileType { get; set; }
        
        [MaxLength(100)]
        public string Remarks { get; set; }

        [MaxLength(100)]
        public string WebURL { get; set; }
        
        [Required]
        public int? AccountManagerID { get; set; }
        public string AccountManagerName { get; set; }

        [Required]
        public DateTime? EffectiveFromDate { get; set; }
        public string EffectiveFromDateCustom { get { return DateFormat(EffectiveFromDate); } }

        public DateTime? EffectiveTillDate { get; set; }

        public string EffectiveTillDateCustom
        {
            get
            {
                if (EffectiveTillDate != null)
                    return DateFormat(EffectiveTillDate);

                return null;
            }
        }

        public List<CustomerLanguage_VM> CustomerLanguageList { get; set; }

        //[Required]
        public List<CustomerLanguage_TableType_VM> CustomerLanguage_TableTypeList { get; set; }
        public List<CustomerLocation_VM> CustomerLocationList { get; set; }

        //[Required]
        public List<CustomerLocation_TableType_VM> CustomerLocation_TableTypeList { get; set; }

        public List<CustomerServiceLine_VM> CustomerServiceLineList { get; set; }

        //[Required] mandate if customer module has safety
        public List<CustomerServiceLine_TableType_VM> CustomerServiceLine_TableTypeList { get; set; }

        public List<CustomerModule_VM> CustomerModuleList { get; set; }

        //[Required]
        public List<CustomerModule_TableType_VM> CustomerModule_TableTypeList { get; set; }
    }

    public class CustomerDDL_VM
    {
        public short? CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string Text { get { return CustomerName.ToString(); } }
        public string Value { get { return CustomerID.ToString(); } }
    }
};