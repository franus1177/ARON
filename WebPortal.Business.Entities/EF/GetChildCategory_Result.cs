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
    
    public partial class GetChildCategory_Result
    {
        public short CategoryID { get; set; }
        public string CategoryName { get; set; }
        public string ServiceLineCode { get; set; }
        public Nullable<short> ParentCategoryID { get; set; }
        public int HasChild { get; set; }
        public Nullable<int> AttributeCount { get; set; }
        public bool IsLeaf { get; set; }
    }
}