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
    
    public partial class GetTrainingForTrainingFeedback_Result
    {
        public int TrainingID { get; set; }
        public short CourseID { get; set; }
        public string CourseName { get; set; }
        public System.DateTime EffectiveFromDateTime { get; set; }
        public System.DateTime EffectiveTillDateTime { get; set; }
        public int CreatedBy { get; set; }
        public string Remarks { get; set; }
        public Nullable<short> CertificationID { get; set; }
        public bool IsExternalTraining { get; set; }
        public string TrainingLocation { get; set; }
        public string SourceRefID { get; set; }
    }
}
