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
    
    public partial class GetCheckList_Result
    {
        public short CheckListID { get; set; }
        public short CategoryID { get; set; }
        public string CategoryName { get; set; }
        public string InspectionType { get; set; }
        public string Frequency { get; set; }
        public string FrequencyName { get; set; }
        public Nullable<byte> ExecutionDuration { get; set; }
        public string ExecutionUnit { get; set; }
        public Nullable<byte> ServiceLevelID { get; set; }
        public string ServiceLevelName { get; set; }
        public Nullable<short> CustomerID { get; set; }
        public string CustomerName { get; set; }
        public string ShortExecutionUnit { get; set; }
        public Nullable<int> CheckListTaskCount { get; set; }
    }
}