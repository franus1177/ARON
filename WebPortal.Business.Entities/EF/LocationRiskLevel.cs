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
    using System.Collections.Generic;
    
    public partial class LocationRiskLevel
    {
        public string ModuleCode { get; set; }
        public int LocationID { get; set; }
        public byte RiskLevelID { get; set; }
    
        public virtual Location Location { get; set; }
    }
}
