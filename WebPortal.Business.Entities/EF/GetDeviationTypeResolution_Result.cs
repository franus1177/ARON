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
    
    public partial class GetDeviationTypeResolution_Result
    {
        public int DeviationTypeResolutionID { get; set; }
        public string ResolutionName { get; set; }
        public string LanguageCode { get; set; }
        public short DeviationTypeID { get; set; }
        public string DeviationTypeName { get; set; }
        public short ResolutionSequence { get; set; }
        public Nullable<byte> ResolutionDuration { get; set; }
        public string ResolutionUnit { get; set; }
        public bool CanAddRepairComponent { get; set; }
        public Nullable<bool> UseRepairComponents { get; set; }
        public Nullable<short> CategoryID { get; set; }
        public string CategoryName { get; set; }
    }
}
