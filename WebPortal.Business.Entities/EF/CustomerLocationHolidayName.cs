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
    
    public partial class CustomerLocationHolidayName
    {
        public int CustomerLocationID { get; set; }
        public System.DateTime HolidayDate { get; set; }
        public string LanguageCode { get; set; }
        public string HolidayName { get; set; }
    
        public virtual CustomerLocationHoliday CustomerLocationHoliday { get; set; }
    }
}
