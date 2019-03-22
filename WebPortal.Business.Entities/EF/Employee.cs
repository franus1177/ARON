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
    
    public partial class Employee
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Employee()
        {
            this.Drills = new HashSet<Drill>();
            this.Drills1 = new HashSet<Drill>();
            this.Drills2 = new HashSet<Drill>();
            this.DrillDatas = new HashSet<DrillData>();
            this.DrillDatas1 = new HashSet<DrillData>();
            this.DrillDatas2 = new HashSet<DrillData>();
            this.DrillSetups = new HashSet<DrillSetup>();
            this.Employee1 = new HashSet<Employee>();
            this.EmployeeShifts = new HashSet<EmployeeShift>();
            this.EmployeeSquads = new HashSet<EmployeeSquad>();
            this.FRASInspections = new HashSet<FRASInspection>();
            this.FRASInspections1 = new HashSet<FRASInspection>();
            this.FRASInspectionTasks = new HashSet<FRASInspectionTask>();
            this.FRASInspectionTasks1 = new HashSet<FRASInspectionTask>();
            this.Incidents = new HashSet<Incident>();
            this.IncidentInspectionTasks = new HashSet<IncidentInspectionTask>();
            this.IncidentInspectionTasks1 = new HashSet<IncidentInspectionTask>();
            this.IncidentInspectionTasks2 = new HashSet<IncidentInspectionTask>();
            this.TrainingEnrolments = new HashSet<TrainingEnrolment>();
            this.TrainingEnrolments1 = new HashSet<TrainingEnrolment>();
            this.TrainingTrainers = new HashSet<TrainingTrainer>();
            this.WorkPermits = new HashSet<WorkPermit>();
            this.WorkPermits1 = new HashSet<WorkPermit>();
            this.FRASInspections2 = new HashSet<FRASInspection>();
        }
    
        public int EmployeeID { get; set; }
        public string HRMSEmployeeID { get; set; }
        public string Salutation { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public string ShortCode { get; set; }
        public Nullable<System.DateTime> DOB { get; set; }
        public string FullEmployeeAddress { get; set; }
        public string TelephoneNo { get; set; }
        public string CellNo { get; set; }
        public string ExtensionNo { get; set; }
        public string Email { get; set; }
        public string EmergencyContact1 { get; set; }
        public string EmergencyContact2 { get; set; }
        public Nullable<int> ReportingEmployeeID { get; set; }
        public System.DateTime AppointmentDate { get; set; }
        public Nullable<System.DateTime> LeavingDate { get; set; }
        public short DesignationID { get; set; }
        public short DepartmentID { get; set; }
        public Nullable<int> EndUserID { get; set; }
        public Nullable<short> CustomerID { get; set; }
    
        public virtual Customer Customer { get; set; }
        public virtual Department Department { get; set; }
        public virtual Designation Designation { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Drill> Drills { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Drill> Drills1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Drill> Drills2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillData> DrillDatas { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillData> DrillDatas1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillData> DrillDatas2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<DrillSetup> DrillSetups { get; set; }
        public virtual EndUser EndUser { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Employee> Employee1 { get; set; }
        public virtual Employee Employee2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EmployeeShift> EmployeeShifts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<EmployeeSquad> EmployeeSquads { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FRASInspection> FRASInspections { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FRASInspection> FRASInspections1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FRASInspectionTask> FRASInspectionTasks { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FRASInspectionTask> FRASInspectionTasks1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Incident> Incidents { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspectionTask> IncidentInspectionTasks { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspectionTask> IncidentInspectionTasks1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<IncidentInspectionTask> IncidentInspectionTasks2 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TrainingEnrolment> TrainingEnrolments { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TrainingEnrolment> TrainingEnrolments1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TrainingTrainer> TrainingTrainers { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<WorkPermit> WorkPermits { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<WorkPermit> WorkPermits1 { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<FRASInspection> FRASInspections2 { get; set; }
    }
}