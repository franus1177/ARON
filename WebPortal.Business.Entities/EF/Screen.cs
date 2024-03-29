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
    
    public partial class Screen
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Screen()
        {
            this.ScreenActions = new HashSet<ScreenAction>();
            this.ScreenTables = new HashSet<ScreenTable>();
            this.UserRoleScreens = new HashSet<UserRoleScreen>();
        }
    
        public short ScreenID { get; set; }
        public string ScreenName { get; set; }
        public string MenuCode { get; set; }
        public string ModuleCode { get; set; }
        public byte Sequence { get; set; }
        public bool HasInsert { get; set; }
        public bool HasUpdate { get; set; }
        public bool HasDelete { get; set; }
        public bool HasSelect { get; set; }
        public bool HasImport { get; set; }
        public bool HasExport { get; set; }
        public bool UpdateAudit { get; set; }
        public bool DeleteAudit { get; set; }
    
        public virtual Menu Menu { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScreenAction> ScreenActions { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ScreenTable> ScreenTables { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserRoleScreen> UserRoleScreens { get; set; }
    }
}
