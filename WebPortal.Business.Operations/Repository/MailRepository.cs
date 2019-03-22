using System;
using System.Data;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class MailRepository : BaseRepository, IMailLogRepository
    {
        public Int64 AddMailLog(MailLog_VM Model)
        {
            Int64 result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_MailID", 0) { Direction = ParameterDirection.Output };
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_MailType", GetDBNULLString(Model.MailType)),
                                new SqlParameter("@p_CreatedDate",  GetDBNULL(Model.CreatedDate)),
                                new SqlParameter("@p_IsMailFromFrontEnd", Model.IsMailFromFrontEnd),
                                new SqlParameter("@p_FromMailID",  GetDBNULLString(Model.FromMailID)),
                                new SqlParameter("@p_RecipientMailList",  GetDBNULLString(Model.RecipientMailList)),
                                new SqlParameter("@p_CCMailList",  GetDBNULLString(Model.CCMailList)),
                                new SqlParameter("@p_BCCMailList",  GetDBNULLString(Model.BCCMailList)),

                                new SqlParameter("@p_MailSubject",  GetDBNULLString(Model.MailSubject)),
                                new SqlParameter("@p_Body", GetDBNULLString(Model.Body)),

                                new SqlParameter("@p_UserID",GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID",GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID",GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint",GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    db.ExecuteNonQueryRollBack("AddMailLog", par);

                    result = Convert.ToInt64(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("MailRepository_AddMailLog: ", ex);
                throw;
            }

            return result;
        }
    }

    public interface IMailLogRepository : IBaseInterFace
    {
        Int64 AddMailLog(MailLog_VM Model);
    }
}
