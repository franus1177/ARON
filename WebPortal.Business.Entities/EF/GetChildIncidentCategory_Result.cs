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
    
    public partial class GetChildIncidentCategory_Result
    {
        public short IncidentCategoryID { get; set; }
        public string text { get; set; }
        public string IncidentCategoryName { get; set; }
        public Nullable<short> ParentCategoryID { get; set; }
        public bool IsLeaf { get; set; }
        public int HasChild { get; set; }
    }
}
