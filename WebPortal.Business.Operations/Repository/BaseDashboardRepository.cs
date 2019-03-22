using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class BaseDashboardRepository : BaseRepository, IBaseDashboardRepository
    {
        public List<BaseDashboardCustomerList_VM> GetBaseDashboardCustomerList(BaseDashboard_VM Model)
        {
            //List<BaseDashboardCustomerList_VM> query = new List<BaseDashboardCustomerList_VM>();
            var query = new List<BaseDashboardCustomerList_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_MonthDuration", GetDBNULL(Model.MonthDuration)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                              };

                    ds = db.ExecuteDataSet("GetBaseDashboardCustomerList", par);
                    query = ConvertToList<BaseDashboardCustomerList_VM>(ds.Tables[0]);
                    if (ds.Tables.Count > 1 && query.Count > 0)
                    {
                        query[0].ModuleCodeListEndUserwise = ConvertToList<EndUserModule_VM>(ds.Tables[1]);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("BaseDashboardRepository_GetBaseDashboardCustomerList Error: ", ex);
                throw;
            }

            return query;
        }

    }

    public interface IBaseDashboardRepository : IBaseInterFace
    {
        List<BaseDashboardCustomerList_VM> GetBaseDashboardCustomerList(BaseDashboard_VM Model);
    }
};

