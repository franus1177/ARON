using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace WebPortal.Business.Entities.ViewModels
{
    public class Location_VM : Base_VM
    {
        [Key]
        public int? LocationID { get; set; }

        [MaxLength(50)]
        [Required]
        public string LocationName { get; set; }

        public int? ParentLocationID { get; set; }
        /// <summary>
        /// set true = if has child location
        /// set false = is a leaf node to add object instance.
        /// </summary>
        public bool HasChild { get; set; }

        public int? ContractID { get; set; }

        [Required]
        public bool? HasCustomers { get; set; }

        public float? Longitude { get; set; }

        public float? Latitude { get; set; }

        [MaxLength(100)]
        public string Remarks { get; set; }

        public short? CustomerID { get; set; }

        public byte? RiskLevelID { get; set; }

        public int CustomerCount { get; set; }

        public string Text { get { return LocationName.ToString(); } }
        public string Value { get { return "" + LocationID.ToString(); } }

        public List<LocRiskLevel_VM> LocationRiskLevelList { get; set; }

        //[Required]
        public List<LocRiskLevel_TableTypeList> LocationRiskLevel_TableTypeList { get; set; }

        public long? FileID { get; set; }

    }

    public class MEILocation : Base_VM
    {
        public int? LocationID { get; set; }

        [MaxLength(50)]
        public string LocationName { get; set; }

        public short? CustomerID { get; set; }

        public string CustomerName { get; set; }
    }

    public class GetLocationHierarchy_VM
    {
        public int? id { get; set; }
        public string text { get; set; }
        public string state { get; set; }
        public int? parentId { get; set; }
        public int? ParentLocationID { get; set; }
        public bool HasCustomers { get; set; }
        public int? TreeLevel { get; set; }
        public bool HasChild { get; set; }
    }

    public class GetLocationTree_VM
    {
        public short? CustomerID { get; set; }
        public int LocationID { get; set; }
        public string text { get; set; }
        public string LocationName { get; set; }
        public int? ParentLocationID { get; set; }
        public bool HasCustomers { get; set; }
        public bool HasChild { get; set; }
        public int? SequenceNo { get; set; }
        public short? LocationSequence { get; set; }
        public int? LocID { get; set; }

        public string QRCODE { get; set; }
    }

    public class LocRiskLevel_VM
    {
        public string ModuleCode { get; set; }
        public byte? RiskLevelID { get; set; }
    }

    public class LocRiskLevel_TableTypeList
    {
        public string ModuleCode { get; set; }
        public byte? RiskLevelID { get; set; }
    }

    public class RootAndChildCustomerLocationRiskLevel
    {
        public string ModuleCode { get; set; }
        public byte? RiskLevelID { get; set; }
        public int LocationID { get; set; }
        public string Node { get; set; }
    }
}