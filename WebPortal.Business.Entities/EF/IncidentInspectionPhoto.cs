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
    
    public partial class IncidentInspectionPhoto
    {
        public int IncidentInspectionTaskID { get; set; }
        public Nullable<long> Photo { get; set; }
        public Nullable<long> SmallPhoto { get; set; }
        public bool ActionPhoto { get; set; }
        public bool ResolutionPhoto { get; set; }
        public bool ClosurePhoto { get; set; }
        public byte PhotoSequence { get; set; }
    
        public virtual FolderFile FolderFile { get; set; }
        public virtual FolderFile FolderFile1 { get; set; }
        public virtual IncidentInspectionTask IncidentInspectionTask { get; set; }
    }
}