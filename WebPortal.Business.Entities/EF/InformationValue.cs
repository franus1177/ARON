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
    
    public partial class InformationValue
    {
        public string InformationCode { get; set; }
        public string InformationValue1 { get; set; }
        public Nullable<int> ValueInt { get; set; }
        public string ValueVarchar { get; set; }
        public Nullable<System.DateTime> ValueDate { get; set; }
        public Nullable<System.DateTime> ValueDateTime { get; set; }
    
        public virtual InformationCode InformationCode1 { get; set; }
    }
}
