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
    
    public partial class FRASCheckListTaskView
    {
        public int FRASCheckListTaskID { get; set; }
        public short FRASCheckListID { get; set; }
        public short TaskSequence { get; set; }
        public bool IsMandatory { get; set; }
        public Nullable<short> CheckListTaskGroupID { get; set; }
        public string CheckListTaskGroupName { get; set; }
        public Nullable<short> GroupSequence { get; set; }
        public string AttributeType { get; set; }
        public bool MarkIfTrue { get; set; }
        public int MarkIfTrueValue { get; set; }
        public System.DateTime EffectiveFrom { get; set; }
        public Nullable<System.DateTime> EffectiveTill { get; set; }
        public string LanguageCode { get; set; }
        public string FRASCheckListTaskName { get; set; }
    }
}
