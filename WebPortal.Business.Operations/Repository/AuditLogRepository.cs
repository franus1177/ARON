using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.VM;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class AuditLogRepository : BaseRepository, IAuditLogRepository
    {
        public List<AuditLogReport_VM> GetAuditLogReportData(AuditLogReport_VM Model)
        {
            var query = new List<AuditLogReport_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = db.ExecuteDataSet("GetAuditLogReport", new SqlParameter[] {
                        new SqlParameter("@p_Object", GetDBNULL(Model.ObjectName)),
                        new SqlParameter("@p_ModuleCode", GetDBNULL(Model.ModuleCode)),
                        new SqlParameter("@p_OperationType", GetDBNULL(Model.OperationType)),
                        new SqlParameter("@p_StartDate", GetDBNULL(Model.StartDate)),
                        new SqlParameter("@p_EndDate", GetDBNULL(Model.EndDate)),

                        new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                        new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset,true)),
                        new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID,true)),
                        new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                        new SqlParameter("@p_ScreenID", GetDBNULL(Model.ScreenID,true)),
                        new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoints))
                    });

                    query = ConvertToList<AuditLogReport_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("AuditLogRepository_GetAuditLogReportData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<AuditLogReport_VM> GetEntityDetails(AuditLogReport_VM Model)
        {
            var query = new List<AuditLogReport_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = db.ExecuteDataSet("GetEntityDetails", new SqlParameter[] {
                        new SqlParameter("@p_AuditLogID", GetDBNULL(Model.AuditLogID)),

                        new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                        new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset,true)),
                        new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID,true)),
                        new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                        new SqlParameter("@p_ScreenID", GetDBNULL(Model.ScreenID,true)),
                        new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoints))
                    });

                    query = ConvertToList<AuditLogReport_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("AuditLogRepository_GetEntityDetails Error: ", ex);
                throw;
            }

            return query;
        }
    }

    public interface IAuditLogRepository : IBaseInterFace
    {
        List<AuditLogReport_VM> GetAuditLogReportData(AuditLogReport_VM Model);
        List<AuditLogReport_VM> GetEntityDetails(AuditLogReport_VM Model);
    }
};