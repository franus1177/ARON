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
    
    public partial class ObjectLanguage
    {
        public short ObjectID { get; set; }
        public string LanguageCode { get; set; }
        public string ObjectName { get; set; }
    
        public virtual Object Object { get; set; }
    }
}
