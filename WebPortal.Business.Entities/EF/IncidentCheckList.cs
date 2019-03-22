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
    
    public partial class IncidentCheckList
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public IncidentCheckList()
        {
            this.IncidentCheckListTasks = new HashSet<IncidentCheckListTask>();
            this.IncidentInspections = new HashSet<IncidentInspection>();
        }
    
        public short IncidentChecklistID { get; set; }
        public byte IncidentTypeID { get; set; }
        public Nullable<short> DepartmentID { get; set; }
        public string Remarks { get; set; }
    
        public virtual IncidentType IncidentType { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentCheckListTask> IncidentCheckListTasks { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspection> IncidentInspections { get; set; }
    }
}