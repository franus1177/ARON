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
    
    public partial class CustomerContact
    {
        public short CustomerID { get; set; }
        public string ContactName { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public string Mobile { get; set; }
        public bool IsPrimaryContact { get; set; }
        public Nullable<int> UserID { get; set; }
    
        public virtual Customer Customer { get; set; }
        public virtual EndUser EndUser { get; set; }
    }
}
