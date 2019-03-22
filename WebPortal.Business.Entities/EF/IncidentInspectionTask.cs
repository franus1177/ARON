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
    
    public partial class IncidentInspectionTask
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public IncidentInspectionTask()
        {
            this.IncidentInspectionPhotoes = new HashSet<IncidentInspectionPhoto>();
        }
    
        public int IncidentInspectionTaskID { get; set; }
        public int IncidentInspectionID { get; set; }
        public int IncidentCheckListTaskID { get; set; }
        public Nullable<bool> InspectionValueBit { get; set; }
        public Nullable<double> InspectionValueFloat { get; set; }
        public Nullable<System.DateTime> InspectionValueDateTime { get; set; }
        public string InspectionValueString { get; set; }
        public Nullable<long> InspectionValuePhoto { get; set; }
        public Nullable<long> InspectionValueSmallPhoto { get; set; }
        public bool IsDeviation { get; set; }
        public Nullable<System.DateTime> ActionDueDateTime { get; set; }
        public Nullable<int> ActionBy { get; set; }
        public Nullable<System.DateTime> ActionDateTime { get; set; }
        public string ActionRemarks { get; set; }
        public Nullable<int> ResolvedBy { get; set; }
        public Nullable<System.DateTime> ResolutionDateTime { get; set; }
        public string ResolutionRemarks { get; set; }
        public Nullable<int> ClosedBy { get; set; }
        public Nullable<System.DateTime> ClosedDateTime { get; set; }
        public string ClosureRemarks { get; set; }
    
        public virtual Employee Employee { get; set; }
        public virtual Employee Employee1 { get; set; }
        public virtual Employee Employee2 { get; set; }
        public virtual FolderFile FolderFile { get; set; }
        public virtual FolderFile FolderFile1 { get; set; }
        public virtual IncidentCheckListTask IncidentCheckListTask { get; set; }
        public virtual IncidentInspection IncidentInspection { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspectionPhoto> IncidentInspectionPhotoes { get; set; }
    }
}