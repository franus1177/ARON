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
    
    public partial class DrillType
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DrillType()
        {
            this.Drills = new HashSet<Drill>();
            this.DrillCheckLists = new HashSet<DrillCheckList>();
            this.DrillTypeLanguages = new HashSet<DrillTypeLanguage>();
        }
    
        public byte DrillTypeID { get; set; }
        public string Frequency { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Drill> Drills { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillCheckList> DrillCheckLists { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillTypeLanguage> DrillTypeLanguages { get; set; }
    }
}
