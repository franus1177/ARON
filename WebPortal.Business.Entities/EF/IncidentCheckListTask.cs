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
    
    public partial class IncidentCheckListTask
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public IncidentCheckListTask()
        {
            this.IncidentCheckListTaskLanguages = new HashSet<IncidentCheckListTaskLanguage>();
            this.IncidentInspectionTasks = new HashSet<IncidentInspectionTask>();
        }
    
        public int IncidentCheckListTaskID { get; set; }
        public short IncidentCheckListID { get; set; }
        public short TaskSequence { get; set; }
        public bool IsMandatory { get; set; }
        public Nullable<short> ChecklistTaskGroupID { get; set; }
        public string AttributeType { get; set; }
        public Nullable<short> TextLength { get; set; }
        public Nullable<byte> FloatPrecision { get; set; }
        public Nullable<byte> FloatScale { get; set; }
        public Nullable<short> UOMID { get; set; }
        public System.DateTime EffectiveFrom { get; set; }
        public Nullable<System.DateTime> EffectiveTill { get; set; }
    
        public virtual ChecklistTaskGroup ChecklistTaskGroup { get; set; }
        public virtual IncidentCheckList IncidentCheckList { get; set; }
        public virtual UOM UOM { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentCheckListTaskLanguage> IncidentCheckListTaskLanguages { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspectionTask> IncidentInspectionTasks { get; set; }
    }
}