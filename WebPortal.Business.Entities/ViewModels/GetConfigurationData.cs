using System;
using System.Collections.Generic;

namespace WebPortal.Business.Entities.ViewModels
{
    public class GetConfigurationData_VM
    {
        public List<Language_VM> LanguageList { get; set; }
        public List<Module_VM> ModuleList { get; set; }
        public List<Country_VM> CountryList { get; set; }
        public List<ServiceLine_VM> ServiceLineList { get; set; }
        public List<ConfigurationCode_VM> ConfigurationCodeList { get; set; }
        public List<TimeUnit_VM> TimeUnitList { get; set; }
        public List<RiskLevel_VM> RiskLevelList { get; set; }
        public List<SeverityLevel_VM> SeverityLevelList { get; set; }
        public List<InspectionType_VM> InspectionTypeList { get; set; }
        public List<InspectionType_VM> FRASInspectionTypeList { get; set; }
        public List<ServiceLevel_VM> ServiceLevelList { get; set; }
        public List<AttributeType_VM> AttributeTypeList { get; set; }
        public List<IsSingleCustomer_VM> IsSingleCustomerList { get; set; }
        public List<PriorityLevel_VM> PriorityLevelList { get; set; }
        
        public string EncryptScreenID { get; set; }
    }

    public class Module_VM
    {
        public string LanguageCode { get; set; }
        public string ModuleCode { get; set; }
        public string ModuleName { get; set; }
        public bool? IsForEndUser { get; set; }
        public int SequenceNo { get; set; }
        public string Text { get { return ModuleName; } }
        public string Value { get { return ModuleCode; } }
    };

    public class Country_VM
    {
        public string LanguageCode { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string Text { get { return CountryName; } }
        public string Value { get { return CountryCode; } }
    };

    public class ServiceLine_VM
    {
        public string ServiceLineCode { get; set; }
        public string ServiceLineName { get; set; }
        public string Text { get { return ServiceLineName; } }
        public string Value { get { return ServiceLineCode; } }
    };

    public class TimeUnit_VM
    {
        public string TimeUnitCode { get; set; }
        public string TimeUnitName { get; set; }
        public string FrequencyName { get; set; }
        public int SequenceNo { get; set; }
        public bool IsUsedForFrequency { get; set; }
        public bool IsUsedForResolution { get; set; }

        public string Text { get { return TimeUnitName; } }
        public string Value { get { return TimeUnitCode; } }
    };

    public class ConfigurationCode_VM
    {
        public string ConfigurationCode { get; set; }
        public string ConfigurationName { get; set; }
        public int ConfigurationValue { get; set; }

        public string Text { get { return ConfigurationName; } }
        public string Value { get { return ConfigurationCode; } }
    };

    public class RiskLevel_VM
    {
        public int RiskLevelID { get; set; }
        public string RiskLevelName { get; set; }
        public string ColorCode { get; set; }

        public string Text { get { return RiskLevelName; } }
        public string Value { get { return RiskLevelID.ToString(); } }
    };

    public class SeverityLevel_VM
    {
        public int SeverityLevelID { get; set; }
        public string SeverityLevelName { get; set; }

        public string Text { get { return SeverityLevelName; } }
        public string Value { get { return SeverityLevelID.ToString(); } }
    };

    public class InspectionType_VM
    {
        public string InspectionType { get; set; }
        public string InspectionTypeName { get; set; }

        public string Text { get { return InspectionTypeName; } }
        public string Value { get { return InspectionType; } }
    };

    public class AttributeType_VM
    {
        public string AttributeType { get; set; }
        public string AttributeTypeName { get; set; }
        public string BaseDataType { get; set; }
        public bool IsUsedForObjects { get; set; }
        public bool IsUsedForCheckLists { get; set; }

        public Int16? MaxTextLength { get; set; }
        public string Text { get { return AttributeTypeName; } }
        public string Value { get { return AttributeType; } }
    };

    public class ServiceLevel_VM
    {
        public byte? ServiceLevelID { get; set; }
        public string ServiceLevelName { get; set; }

        public string Text { get { return ServiceLevelName; } }
        public string Value { get { return ServiceLevelID.ToString(); } }
    };

    public class IsSingleCustomer_VM
    {
        public bool IsSingleUserCustomer { get; set; }
        public bool IsSingleInstance { get; set; }
        public short? CustomerID { get; set; }
        public string CustomerName { get; set; }
    };

    public class PriorityLevel_VM
    {
        public byte PriorityLevelID { get; set; }
        public string PriorityLevelName { get; set; }

        public string Text { get { return PriorityLevelName; } }
        public string Value { get { return PriorityLevelID.ToString(); } }
    };
};