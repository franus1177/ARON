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
    
    public partial class GetDrillCheckListTask_Result
    {
        public int DrillCheckListTaskID { get; set; }
        public string DrillCheckListName { get; set; }
        public short DrillCheckListID { get; set; }
        public short TaskSequence { get; set; }
        public bool IsMandatory { get; set; }
        public string AttributeType { get; set; }
        public byte DrillTypeID { get; set; }
        public string DrillCheckListTaskName { get; set; }
        public System.DateTime EffectiveFrom { get; set; }
        public Nullable<short> CheckListTaskGroupID { get; set; }
        public string CheckListTaskGroupName { get; set; }
        public Nullable<System.DateTime> EffectiveTill { get; set; }
    }
}
