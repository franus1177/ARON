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
    
    public partial class FeedbackParameterValue
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public FeedbackParameterValue()
        {
            this.TrainingFeedbacks = new HashSet<TrainingFeedback>();
        }
    
        public short FeedbackParameterValueID { get; set; }
        public short FeedbackParameterID { get; set; }
        public string FeedbackParameterValue1 { get; set; }
        public short SequenceNo { get; set; }
    
        public virtual FeedbackParameter FeedbackParameter { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TrainingFeedback> TrainingFeedbacks { get; set; }
    }
}