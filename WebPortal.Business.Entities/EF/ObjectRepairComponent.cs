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
    
    public partial class ObjectRepairComponent
    {
        public short ObjectID { get; set; }
        public short RepairComponentID { get; set; }
        public Nullable<double> MaxUseQuantity { get; set; }
        public Nullable<double> DefaultQuantity { get; set; }
    
        public virtual Object Object { get; set; }
        public virtual RepairComponent RepairComponent { get; set; }
    }
}
