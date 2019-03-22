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
    
    public partial class Inspection
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Inspection()
        {
            this.Deviations = new HashSet<Deviation>();
            this.InspectionCheckLists = new HashSet<InspectionCheckList>();
            this.ObjectInstanceInspections = new HashSet<ObjectInstanceInspection>();
            this.ResolutionInspectionDeviations = new HashSet<ResolutionInspectionDeviation>();
            this.Contracts = new HashSet<Contract>();
        }
    
        public int InspectionID { get; set; }
        public string InspectionType { get; set; }
        public Nullable<short> CheckListID { get; set; }
        public short CheckListInstanceNo { get; set; }
        public Nullable<int> LocationID { get; set; }
        public System.DateTime ScheduledStartDateTime { get; set; }
        public System.DateTime ScheduledEndDateTime { get; set; }
        public Nullable<int> ControllerID { get; set; }
        public Nullable<System.DateTime> CheckINDateTime { get; set; }
        public Nullable<System.DateTime> CheckOUTDateTime { get; set; }
        public string Remarks { get; set; }
        public Nullable<int> CustomerIRemarksID { get; set; }
        public Nullable<System.DateTime> CancelDateTime { get; set; }
    
        public virtual CheckList CheckList { get; set; }
        public virtual CustomerIRemark CustomerIRemark { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Deviation> Deviations { get; set; }
        public virtual EndUser EndUser { get; set; }
        public virtual Location Location { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<InspectionCheckList> InspectionCheckLists { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ObjectInstanceInspection> ObjectInstanceInspections { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ResolutionInspectionDeviation> ResolutionInspectionDeviations { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Contract> Contracts { get; set; }
    }
}
