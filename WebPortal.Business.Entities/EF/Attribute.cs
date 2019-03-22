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
    
    public partial class Attribute
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Attribute()
        {
            this.AttributeLanguages = new HashSet<AttributeLanguage>();
            this.CategoryAttributes = new HashSet<CategoryAttribute>();
            this.ObjectAttributes = new HashSet<ObjectAttribute>();
        }
    
        public short AttributeID { get; set; }
        public string AttributeType { get; set; }
        public Nullable<byte> TextLength { get; set; }
        public Nullable<byte> FloatPrecision { get; set; }
        public Nullable<byte> FloatScale { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<AttributeLanguage> AttributeLanguages { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<CategoryAttribute> CategoryAttributes { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ObjectAttribute> ObjectAttributes { get; set; }
    }
}