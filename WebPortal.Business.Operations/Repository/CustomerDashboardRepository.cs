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
    public class CustomerDashboardRepository : BaseRepository, ICustomerDashboardRepository
    {
        public int RefreshUserLeafLocation(EndUser_VM Model)
        {
            List<int> outPara = new List<int>();

            using (var db = new WebPortalEntities())
            {
                try
                {
                    var par = new SqlParameter[] { new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID)) };
                    var dd = db.Database.SqlQuery<List<int>>("exec InsertUserLeafLocation", par).ToList();
                    return 1;
                }
                catch (Exception ex)
                {
                    logger.Error("CustomerDashboardRepository_RefreshUserLeafLocation Error: ", ex);
                    throw;
                }
            }
        }

        public List<SafetyDashboard_VM> GetSafetyDashboardInspectionTypeStatus(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboard_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardInspectionTypeStatus_Result, SafetyDashboard_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardInspectionTypeStatus(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardInspectionTypeStatus_Result>, List<SafetyDashboard_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetSafetyDashboardInspectionTypeStatus Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboard_VM> GetDashboardMonthlySnapshot(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboard_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardMonthlySnapshot_Result, SafetyDashboard_VM>());
                    var mapper = config.CreateMapper();

                    List<GetCustomerSafetyDashboardMonthlySnapshot_Result> data = db.GetCustomerSafetyDashboardMonthlySnapshot(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();

                    return mapper.Map<List<GetCustomerSafetyDashboardMonthlySnapshot_Result>, List<SafetyDashboard_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetDashboardMonthlySnapshot Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboardYearlyChart_VM> GetDashboardYearlySnapshot(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboardYearlyChart_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardYearlyChart_Result, SafetyDashboardYearlyChart_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardYearlyChart(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardYearlyChart_Result>, List<SafetyDashboardYearlyChart_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetDashboardYearlySnapshot Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboardFunnelChart_VM> GetDashboardFunnelChart(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboardFunnelChart_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardPlansAndAssets_Result, SafetyDashboardFunnelChart_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardPlansAndAssets(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardPlansAndAssets_Result>, List<SafetyDashboardFunnelChart_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetDashboardFunnelChart Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboardEmergencyInspection_VM> GetDashboardEmergencyInspection(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboardEmergencyInspection_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardEmergencyInspection_Result, SafetyDashboardEmergencyInspection_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardEmergencyInspection(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardEmergencyInspection_Result>, List<SafetyDashboardEmergencyInspection_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetDashboardEmergencyInspection Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboardDeviation_VM> GetDashboardDeviation(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboardDeviation_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardDeviatonsChart_Result, SafetyDashboardDeviation_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardDeviatonsChart(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardDeviatonsChart_Result>, List<SafetyDashboardDeviation_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetDashboardDeviation Error: ", ex);
                throw;
            }
        }

        public List<ActiveData_VM> GetActiveData(SafetyDashboard_VM Model)
        {
            var query = new List<ActiveData_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_ModuleCode", GetDBNULL(Model.CurrentModuleCode)),
                                new SqlParameter("@p_ServiceLineCode", GetDBNULL(Model.CurrentServiceLineCode)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                              };

                    ds = db.ExecuteDataSet("GetCustomerSafetyDashboardActiveAssetsPlansDeviations", par);
                    query = ConvertToList<ActiveData_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetActiveData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<TopDeviationCount_VM> GetTopDeviationCount(SafetyDashboard_VM Model)
        {
            var query = new List<TopDeviationCount_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardTop5Deviations_Result, TopDeviationCount_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardTop5Deviations(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardTop5Deviations_Result>, List<TopDeviationCount_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerDashboardRepository_GetTopDeviationCount Error: ", ex);
                throw;
            }
        }

        public List<SafetyDashboardYearlyDeviationsChart_VM> GetDashboardYearlyDeviations(SafetyDashboard_VM Model)
        {
            var query = new List<SafetyDashboardYearlyDeviationsChart_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerSafetyDashboardYearlyDeviationsChart_Result, SafetyDashboardYearlyDeviationsChart_VM>());
                    var mapper = config.CreateMapper();

                    var data = db.GetCustomerSafetyDashboardYearlyDeviationsChart(Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    return mapper.Map<List<GetCustomerSafetyDashboardYearlyDeviationsChart_Result>, List<SafetyDashboardYearlyDeviationsChart_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("DashboardRepository_GetDashboardYearlyDeviations Error: ", ex);
                throw;
            }
        }
    }

    public interface ICustomerDashboardRepository : IBaseInterFace
    {
        int RefreshUserLeafLocation(EndUser_VM Model);

        List<SafetyDashboard_VM> GetSafetyDashboardInspectionTypeStatus(SafetyDashboard_VM Model);
        List<SafetyDashboard_VM> GetDashboardMonthlySnapshot(SafetyDashboard_VM Model);
        List<SafetyDashboardYearlyChart_VM> GetDashboardYearlySnapshot(SafetyDashboard_VM Model);
        List<SafetyDashboardFunnelChart_VM> GetDashboardFunnelChart(SafetyDashboard_VM Model);
        List<SafetyDashboardEmergencyInspection_VM> GetDashboardEmergencyInspection(SafetyDashboard_VM Model);
        List<SafetyDashboardDeviation_VM> GetDashboardDeviation(SafetyDashboard_VM Model);
        List<ActiveData_VM> GetActiveData(SafetyDashboard_VM Model);
        List<TopDeviationCount_VM> GetTopDeviationCount(SafetyDashboard_VM Model);
        List<SafetyDashboardYearlyDeviationsChart_VM> GetDashboardYearlyDeviations(SafetyDashboard_VM Model);
    }
};