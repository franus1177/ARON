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
    
    public partial class GetInspectionCheckListTaskDeviationListGrid_Result
    {
        public int CheckListTaskID { get; set; }
        public string InspectionType { get; set; }
        public string Frequency { get; set; }
        public string CheckListTaskName { get; set; }
        public string LanguageCode { get; set; }
        public short CheckListID { get; set; }
        public short TaskSequence { get; set; }
        public string AttributeType { get; set; }
        public Nullable<short> CheckListTaskGroupID { get; set; }
        public bool IsMandatory { get; set; }
        public Nullable<short> TextLength { get; set; }
        public Nullable<byte> FloatPrecision { get; set; }
        public Nullable<byte> FloatScale { get; set; }
        public Nullable<short> UOMID { get; set; }
        public string UOMName { get; set; }
        public Nullable<bool> DeviationIfFalse { get; set; }
        public Nullable<short> BoolDeviationTypeID { get; set; }
        public string BoolDeviationTypeName { get; set; }
        public Nullable<double> DeviationIfLessValue { get; set; }
        public Nullable<short> LessValueDeviationTypeID { get; set; }
        public string LessValueDeviationTypeName { get; set; }
        public Nullable<double> DeviationIfMoreValue { get; set; }
        public Nullable<short> MoreValueDeviationTypeID { get; set; }
        public string MoreValueDeviationTypeName { get; set; }
        public System.DateTime EffectiveFrom { get; set; }
        public Nullable<System.DateTime> EffectiveTill { get; set; }
        public Nullable<int> ObjectInstanceInspectionID { get; set; }
        public short CheckListSequence { get; set; }
    }
}
