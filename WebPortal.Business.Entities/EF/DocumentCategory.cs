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
    
    public partial class DocumentCategory
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public DocumentCategory()
        {
            this.Documents = new HashSet<Document>();
            this.DocumentCategory1 = new HashSet<DocumentCategory>();
            this.DocumentCategoryLanguages = new HashSet<DocumentCategoryLanguage>();
        }
    
        public short DocumentCategoryID { get; set; }
        public Nullable<short> ParentDocumentCategoryID { get; set; }
        public bool HasDocuments { get; set; }
        public string Remarks { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Document> Documents { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DocumentCategory> DocumentCategory1 { get; set; }
        public virtual DocumentCategory DocumentCategory2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DocumentCategoryLanguage> DocumentCategoryLanguages { get; set; }
    }
}