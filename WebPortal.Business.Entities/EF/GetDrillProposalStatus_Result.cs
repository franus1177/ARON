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
    
    public partial class GetDrillProposalStatus_Result
    {
        public int DrillProposalID { get; set; }
        public int DrillID { get; set; }
        public Nullable<int> DrillSetupID { get; set; }
        public System.DateTime ProposedDrillDatetime { get; set; }
        public string ProposalRemarks { get; set; }
        public string DrillStakeholderName { get; set; }
    }
}
