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
    
    public partial class ContractScheduledLocation
    {
        public int ContractID { get; set; }
        public int LocationID { get; set; }
        public int ScheduledLocationID { get; set; }
        public int ScheduledByUserID { get; set; }
        public System.DateTime ScheduledDateTime { get; set; }
        public short CategoryID { get; set; }
    
        public virtual Category Category { get; set; }
        public virtual ContractLocation ContractLocation { get; set; }
        public virtual EndUser EndUser { get; set; }
        public virtual Location Location { get; set; }
    }
}
