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
    
    public partial class GetMenuAndScreenData_Result
    {
        public string ModuleCode { get; set; }
        public string ObjectName { get; set; }
        public bool IsObjectMenu { get; set; }
        public short Sequence { get; set; }
        public string MenuCode { get; set; }
        public Nullable<short> ScreenID { get; set; }
        public Nullable<bool> HasInsert { get; set; }
        public Nullable<bool> HasUpdate { get; set; }
        public Nullable<bool> HasDelete { get; set; }
        public Nullable<bool> HasSelect { get; set; }
        public Nullable<bool> HasImport { get; set; }
        public Nullable<bool> HasExport { get; set; }
    }
}
