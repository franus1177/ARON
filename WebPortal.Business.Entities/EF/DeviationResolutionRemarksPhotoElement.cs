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
    
    public partial class DeviationResolutionRemarksPhotoElement
    {
        public long DeviationID { get; set; }
        public System.DateTime PhotoDateTime { get; set; }
        public byte PhotoSequence { get; set; }
        public Nullable<long> Photo { get; set; }
        public Nullable<long> SmallPhoto { get; set; }
    
        public virtual Deviation Deviation { get; set; }
        public virtual DeviationResolutionRemarksPhoto DeviationResolutionRemarksPhoto { get; set; }
        public virtual FolderFile FolderFile { get; set; }
        public virtual FolderFile FolderFile1 { get; set; }
    }
}
