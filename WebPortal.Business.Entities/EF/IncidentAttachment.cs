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
    
    public partial class IncidentAttachment
    {
        public int IncidentID { get; set; }
        public long FileID { get; set; }
        public Nullable<long> Thumbnail { get; set; }
        public string Remarks { get; set; }
        public Nullable<short> AttachmentSequence { get; set; }
    
        public virtual FolderFile FolderFile { get; set; }
        public virtual Incident Incident { get; set; }
    }
}