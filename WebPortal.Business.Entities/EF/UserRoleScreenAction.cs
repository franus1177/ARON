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
    
    public partial class UserRoleScreenAction
    {
        public short UserRoleID { get; set; }
        public short ScreenID { get; set; }
        public string ActionCode { get; set; }
    
        public virtual ScreenAction ScreenAction { get; set; }
        public virtual UserRole UserRole { get; set; }
        public virtual UserRoleScreen UserRoleScreen { get; set; }
    }
}
