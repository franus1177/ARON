//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebPortal.Business.Entities.EF
{
    using System;
    
    public partial class GetContractExpiryReportData_Result
    {
        public int ContractID { get; set; }
        public string CustomerName { get; set; }
        public short CustomerID { get; set; }
        public System.DateTime ContractDate { get; set; }
        public System.DateTime ContractStartDate { get; set; }
        public Nullable<System.DateTime> ContractEndDate { get; set; }
        public byte ContractDuration { get; set; }
        public string SourceRefID { get; set; }
        public string SalesPerson { get; set; }
        public string Remarks { get; set; }
        public string InspectionType { get; set; }
        public Nullable<int> Days { get; set; }
    }
}
