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
    
    public partial class GetDeviationType_Result
    {
        public short DeviationTypeID { get; set; }
        public Nullable<short> DeviationGroupID { get; set; }
        public string DeviationTypeName { get; set; }
        public string CheckListTaskGroupName { get; set; }
        public string ServiceLineCode { get; set; }
        public Nullable<short> CategoryID { get; set; }
        public string CategoryName { get; set; }
        public short DeviationTypeSequence { get; set; }
        public Nullable<byte> ResolutionDuration { get; set; }
        public string ResolutionUnit { get; set; }
        public string ExecutionUnit { get; set; }
        public string LanguageCode { get; set; }
        public byte RiskLevelID { get; set; }
        public string DeviationTypeCode { get; set; }
        public Nullable<int> DeviationTypeResolutionCount { get; set; }
    }
}
