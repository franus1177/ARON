using AutoMapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class CommonRepository : BaseRepository, ICommonRepository
    {
        public List<Language_VM> GetLanguageData(string LanguageCode)
        {
            List<Language_VM> RoleModel = new List<Language_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    return RoleModel = ConnectGetDataProcedure(new Language_VM() { LanguageCode = LanguageCode }).ToList();
                }
            }
            catch (Exception ex)
            {
                logger.Error("CommonRepository_GetLanguageData: ", ex);
                throw;
            }
        }

        private List<Language_VM> ConnectGetDataProcedure(Language_VM VM)
        {
            List<Language_VM> query = new List<Language_VM>();

            using (var db = new WebPortalEntities())
            {
                var config = new MapperConfiguration(cfg => cfg.CreateMap<Language_VM, Language_VM>());
                var mapper = config.CreateMapper();

                List<Language_VM> data = null;
                return mapper.Map<List<Language_VM>, List<Language_VM>>(data, query);
            }
        }

        public DataSet GetConfigurationData(string ServiceLine, string LanguageCode)
        {
            try
            {
                using (var db = new DBConnection())
                {
                    DataSet data = db.ExecuteDataSet("GetConfigurationData", new SqlParameter[] {
                        new SqlParameter("@S", GetDBNULLString(ServiceLine)),
                        new SqlParameter("@L", GetDBNULLString(LanguageCode)) });

                    return data;
                }
            }
            catch (Exception ex)
            {
                logger.Error("CommonRepository_GetConfigurationData Error: ", ex);
                throw;
            }
        }

        public GetConfigurationData_VM GetConfigurationData2(string ServiceLine, string LanguageCode, List<IsSingleCustomer_VM> objSingleCustomer)
        {
            GetConfigurationData_VM model = new GetConfigurationData_VM();

            try
            {
                using (var db = new DBConnection())
                {
                    DataSet data = db.ExecuteDataSet("__GetConfigurationData", new SqlParameter[] {
                        new SqlParameter("@M", GetDBNULLString(ServiceLine)),
                        new SqlParameter("@L", GetDBNULLString(LanguageCode)) });

                    if (data.Tables.Count > 0)
                    {
                        model.LanguageList = ConvertToList<Language_VM>(data.Tables[0]);
                        model.ModuleList = ConvertToList<Module_VM>(data.Tables[1]);
                        model.CountryList = ConvertToList<Country_VM>(data.Tables[2]);
                        model.TimeUnitList = ConvertToList<TimeUnit_VM>(data.Tables[3]);

                        model.ServiceLineList = ConvertToList<ServiceLine_VM>(data.Tables[5]);

                        model.ConfigurationCodeList = ConvertToList<ConfigurationCode_VM>(data.Tables[6]);

                        model.RiskLevelList = ConvertToList<RiskLevel_VM>(data.Tables[7]);
                        model.SeverityLevelList = ConvertToList<SeverityLevel_VM>(data.Tables[8]);
                        model.InspectionTypeList = ConvertToList<InspectionType_VM>(data.Tables[9]);
                        model.ServiceLevelList = ConvertToList<ServiceLevel_VM>(data.Tables[10]);
                        model.AttributeTypeList = ConvertToList<AttributeType_VM>(data.Tables[11]);

                        if (data.Tables.Count == 13)
                        {
                            model.PriorityLevelList = ConvertToList<PriorityLevel_VM>(data.Tables[12]);/*added on 10 aug 18*/
                        }

                        if (data.Tables.Count == 14)
                        {
                            model.PriorityLevelList = ConvertToList<PriorityLevel_VM>(data.Tables[12]);/*added on 10 aug 18*/
                            model.FRASInspectionTypeList = ConvertToList<InspectionType_VM>(data.Tables[13]);
                        }

                        model.IsSingleCustomerList = objSingleCustomer;
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CommonRepository_GetConfigurationData2 Error: ", ex);
                throw;
            }

            return model;
        }
    }
};