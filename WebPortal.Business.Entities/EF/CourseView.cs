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
    
    public partial class CourseView
    {
        public short CourseID { get; set; }
        public string CourseName { get; set; }
        public short CourseTypeID { get; set; }
        public string CourseCode { get; set; }
        public string LanguageCode { get; set; }
        public string CourseTypeName { get; set; }
        public string Frequency { get; set; }
        public string Remarks { get; set; }
        public Nullable<byte> CourseMarks { get; set; }
        public Nullable<short> CustomerID { get; set; }
        public string CustomerName { get; set; }
    }
}
