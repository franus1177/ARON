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
    
    public partial class GetObjectInstanceGrid_Result
    {
        public int ObjectInstanceID { get; set; }
        public string QRCode { get; set; }
        public short ObjectID { get; set; }
        public string ObjectName { get; set; }
        public int LocationID { get; set; }
        public string LocationName { get; set; }
        public string CategoryName { get; set; }
        public string QRCode1 { get; set; }
        public string SerialNumber { get; set; }
        public Nullable<short> ObjectSequence { get; set; }
        public Nullable<double> Longitude { get; set; }
        public Nullable<double> Latitude { get; set; }
        public Nullable<System.DateTime> WarrantyEndDate { get; set; }
        public Nullable<System.DateTime> AMCStartDate { get; set; }
        public Nullable<System.DateTime> AMCEndDate { get; set; }
        public System.DateTime EffectiveFromDate { get; set; }
        public Nullable<System.DateTime> EffectiveTillDate { get; set; }
        public Nullable<short> NotInUseReasonID { get; set; }
        public string NotInUseReasonName { get; set; }
        public string SourceRefID { get; set; }
        public Nullable<int> PreviousObjectInstanceID { get; set; }
        public string CustomerName { get; set; }
        public short CustomerID { get; set; }
        public string Make { get; set; }
        public string Remarks { get; set; }
    }
}
