using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Operations.Repository
{
    public class UserRepository : BaseRepository, IUserRepository
    {
        private List<LoginDetails_VM> ConnectGetAccessDetailsDataProcedure(LoginDetails_VM VM)
        {
            List<LoginDetails_VM> query = new List<LoginDetails_VM>();

            using (var db = new WebPortalEntities())
            {
                //Get User Role of string type
                query = db.Database.SqlQuery<LoginDetails_VM>("exec UserLoginDetails @p_EndUserID",
                   new SqlParameter[] {
                            new SqlParameter("p_EndUserID", GetDBNULL(VM.EndUserID,true))
                        }).ToList();
            }

            return query;
        }
        /// <summary>
        /// Get Single record by his ID
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public List<LoginDetails_VM> GetAccessDetails(LoginDetails_VM Model)
        {
            List<LoginDetails_VM> Data = new List<LoginDetails_VM>();
            try
            {
                Data = ConnectGetAccessDetailsDataProcedure(Model);
            }
            catch (Exception ex)
            {
                logger.Error("UserRepository_GetAccessDetails", ex);
            }

            return Data;
        }
        //end user code start here
        private List<EndUser_VM> ConnectGetDataProcedure(EndUser_VM Model)
        {
            var query = new List<EndUser_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID)),
                                new SqlParameter("@p_LoginID", GetDBNULL(Model.LoginID)),
                                new SqlParameter("@p_FirstName", GetDBNULLString(Model.FirstName)),
                                new SqlParameter("@p_MiddleName", GetDBNULLString(Model.MiddleName)),
                                new SqlParameter("@p_LastName", GetDBNULLString(Model.LastName)),
                                new SqlParameter("@p_Name", GetDBNULLString(Model.Name)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.LanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.UTCOffset)),
                                new SqlParameter("@p_DefaultModuleCode", GetDBNULLString(Model.DefaultModuleCode)),
                                new SqlParameter("@p_Gender", GetDBNULLString(Model.Gender)),
                                new SqlParameter("@p_EmailID", GetDBNULLString(Model.EmailID)),
                                new SqlParameter("@p_UserRoleName", GetDBNULLString(Model.UserRoleName)),

                                new SqlParameter("@p_IsChildResult", GetDBNULL(Model.IsChildResult)),
                                new SqlParameter("@p_IsCustomerUser", GetDBNULL(Model.IsCustomerUser)),
                            };

                    ds = db.ExecuteDataSet("GetEndUser", par);
                    query = ConvertToList<EndUser_VM>(ds.Tables[0]);

                    if (Model.IsChildResult == true)
                    {
                        query[0].EndUserModuleList = ConvertToList<EndUserModule_VM>(ds.Tables[1]);
                        query[0].UserRoleUserList = ConvertToList<UserRoleUser_VM>(ds.Tables[2]);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<EndUser_VM> GetData(EndUser_VM Model)
        {
            List<EndUser_VM> Data = new List<EndUser_VM>();
            try
            {
                Data = ConnectGetDataProcedure(Model);
            }
            catch (Exception ex)
            {
                logger.Error("UserRepository_GetData", ex);
            }

            return Data;
        }

        public List<UserCustomerList_VM> GetCustomerData(UserCustomerList_VM Model)
        {
            var query = new List<UserCustomerList_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID, true)),

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID,true)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID,true)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetOrganizationAndCustomer", par);
                    query = ConvertToList<UserCustomerList_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_GetCustomerData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<EndUser_VM> GetUserNameData(EndUser_VM Model)
        {
            List<EndUser_VM> query = new List<EndUser_VM>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_UserName", GetDBNULL(Model.Name)),
                                new SqlParameter("@p_UserRoleName", GetDBNULLString(Model.UserRoleName))
                            };

                    ds = db.ExecuteDataSet("GetEndUserName", par);
                    query = ConvertToList<EndUser_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_GetUserNameData Error: ", ex);
                throw;
            }

            return query;
        }
        public List<EndUser_VM> GetControllerUserNameData(EndUser_VM Model)
        {
            List<EndUser_VM> query = new List<EndUser_VM>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_UserName", GetDBNULL(Model.Name)),
                            };

                    ds = db.ExecuteDataSet("GetControllerEndUserName", par);
                    query = ConvertToList<EndUser_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_GetUserNameData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(EndUser_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_EndUserModule = new DataTable();
                    if (Model.EndUserModule_TableTypeList != null && Model.EndUserModule_TableTypeList.Count > 0)
                    {
                        dt_EndUserModule = ConvertToDatatable(Model.EndUserModule_TableTypeList);
                    }
                    else
                    {
                        dt_EndUserModule = ConvertToDatatable(new List<EndUserModule_TableType_VM>());
                    }

                    var dt_UserRoleUser = new DataTable();
                    if (Model.UserRoleUser_TableTypeList != null && Model.UserRoleUser_TableTypeList.Count > 0)
                    {
                        dt_UserRoleUser = ConvertToDatatable(Model.UserRoleUser_TableTypeList);
                    }
                    else
                    {
                        dt_UserRoleUser = ConvertToDatatable(new List<UserRoleUser_TableType_VM>());
                    }

                    var output = new SqlParameter("@p_EndUserID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LoginID", GetDBNULL(Model.LoginID)),
                                new SqlParameter("@p_FirstName", GetDBNULL(Model.FirstName)),
                                new SqlParameter("@p_MiddleName", GetDBNULL(Model.MiddleName)),
                                new SqlParameter("@p_LastName", GetDBNULL(Model.LastName)),
                                new SqlParameter("@p_LanguageCode", GetDBNULL(Model.LanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.UTCOffset)),
                                new SqlParameter("@p_DefaultModuleCode", GetDBNULL(Model.DefaultModuleCode)),
                                new SqlParameter("@p_Gender", GetDBNULL(Model.Gender)),
                                new SqlParameter("@p_EmailID", GetDBNULL(Model.EmailID)),
                                new SqlParameter("@p_UserIdentity", GetDBNULLString(Model.UserIdentity)),
                                new SqlParameter("@p_ActivatedDTM", GetDBNULL(Model.ActivatedDTM)),
                                new SqlParameter("@p_LastAccessPoint", GetDBNULLString(Model.LastAccessPoint)),
                                new SqlParameter("@p_LastLoginDTM", GetDBNULL(Model.LastLoginDTM)),
                                new SqlParameter("@p_SecretQuestion", GetDBNULL(Model.SecretQuestion)),
                                new SqlParameter("@p_SecretAnswer", GetDBNULL(Model.SecretAnswer)),
                                new SqlParameter("@p_ActivationURLID", GetDBNULL(Model.ActivationURLID)),
                                new SqlParameter("@p_ResetPasswordURLID", GetDBNULL(Model.ResetPasswordURLID)),
                                new SqlParameter("@p_DesignationID", GetDBNULL(Model.DesignationID)),
                                new SqlParameter("@p_DepartmentID", GetDBNULL(Model.DepartmentID)),

                                new SqlParameter("@p_EndUserModule", dt_EndUserModule) { TypeName = "EndUserModule_TableType" },
                                new SqlParameter("@p_UserRoleUser", dt_UserRoleUser) { TypeName = "UserRoleUser_TableType" },

                                new SqlParameter("@p_CurrentLanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_CurrentUTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_CurrentEndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_CurrentUserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_CurrentScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_CurrentAccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    result = db.ExecuteNonQueryRollBack("AddEndUser", par);

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(EndUser_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_EndUserModule = new DataTable();
                    if (Model.EndUserModule_TableTypeList != null && Model.EndUserModule_TableTypeList.Count > 0)
                    {
                        dt_EndUserModule = ConvertToDatatable(Model.EndUserModule_TableTypeList);
                    }
                    else
                    {
                        dt_EndUserModule = ConvertToDatatable(new List<EndUserModule_TableType_VM>());
                    }

                    var dt_UserRoleUser = new DataTable();
                    if (Model.UserRoleUser_TableTypeList != null && Model.UserRoleUser_TableTypeList.Count > 0)
                    {
                        dt_UserRoleUser = ConvertToDatatable(Model.UserRoleUser_TableTypeList);
                    }
                    else
                    {
                        dt_UserRoleUser = ConvertToDatatable(new List<UserRoleUser_TableType_VM>());
                    }

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.EndUserID)),
                                new SqlParameter("@p_LoginID", GetDBNULLString(Model.LoginID)),
                                new SqlParameter("@p_FirstName", GetDBNULLString(Model.FirstName)),
                                new SqlParameter("@p_MiddleName", GetDBNULLString(Model.MiddleName)),
                                new SqlParameter("@p_LastName", GetDBNULLString(Model.LastName)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.LanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.UTCOffset)),
                                new SqlParameter("@p_DefaultModuleCode", GetDBNULL(Model.DefaultModuleCode)),
                                new SqlParameter("@p_Gender", GetDBNULL(Model.Gender)),
                                new SqlParameter("@p_EmailID", GetDBNULL(Model.EmailID)),
                                new SqlParameter("@p_UserIdentity", GetDBNULLString(Model.UserIdentity)),
                                new SqlParameter("@p_ActivatedDTM", GetDBNULL(Model.ActivatedDTM)),
                                new SqlParameter("@p_LastAccessPoint", GetDBNULLString(Model.LastAccessPoint)),
                                new SqlParameter("@p_LastLoginDTM", GetDBNULL(Model.LastLoginDTM)),
                                new SqlParameter("@p_SecretQuestion", GetDBNULLString(Model.SecretQuestion)),
                                new SqlParameter("@p_SecretAnswer", GetDBNULLString(Model.SecretAnswer)),
                                new SqlParameter("@p_ActivationURLID", GetDBNULL(Model.ActivationURLID)),
                                new SqlParameter("@p_ResetPasswordURLID", GetDBNULL(Model.ResetPasswordURLID)),
                                new SqlParameter("@p_DesignationID", GetDBNULL(Model.DesignationID)),
                                new SqlParameter("@p_DepartmentID", GetDBNULL(Model.DepartmentID)),

                                new SqlParameter("@p_EndUserModule", dt_EndUserModule) { TypeName = "EndUserModule_TableType" },
                                new SqlParameter("@p_UserRoleUser", dt_UserRoleUser) { TypeName = "UserRoleUser_TableType" },

                                new SqlParameter("@p_CurrentLanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_CurrentUTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_CurrentEndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_CurrentUserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_CurrentScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_CurrentAccessPoint", GetDBNULLString(Model.AccessPoint)),
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateEndUser", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("EndUserRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }

        public bool ValidateUser(string Email, string Password, string IP,
            out List<UserEmployee_VM> objUser,
            out List<MenuScreen_VM> objMenu,
            out List<ScreenAction_VM> objAction,
            out List<Module_VM> objModule,
            out List<IsSingleCustomer_VM> objSingleCustomer)
        {
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    ds = db.ExecuteDataSet("UserLogin", new SqlParameter[] {
                                                                new SqlParameter("@p_LoginID", GetDBNULLString( Email)),
                                                                new SqlParameter("@p_UserIdentity", GetDBNULLString(Password)),
                                                                new SqlParameter("@p_LastAccessPoint", GetDBNULLString(IP))
                                                        });

                    objUser = (from DataRow dr in ds.Tables[0].Rows
                               select new UserEmployee_VM()
                               {
                                   EndUserID = Convert.ToInt32(dr["EndUserID"]),
                                   UserRoleID = Convert.ToInt16(dr["UserRoleID"]),
                                   UserName = dr["UserName"].ToString(),
                                   CurrentLanguageCode = dr["LanguageCode"].ToString(),
                                   CurrentUTCOffset = Convert.ToDecimal(dr["UTCOffset"]),
                                   DefaultModuleCode = dr["DefaultModuleCode"].ToString(),
                                   IsCustomerUser = Convert.ToBoolean(dr["IsCustomerUser"])
                               }).ToList();

                    objMenu = (from DataRow dr in ds.Tables[1].Rows
                               select new MenuScreen_VM()
                               {
                                   ModuleCode = dr["ModuleCode"].ToString(),
                                   ObjectName = dr["ObjectName"].ToString(),
                                   IsObjectMenu = bool.Parse(dr["IsObjectMenu"].ToString()),
                                   Sequence = byte.Parse(dr["Sequence"].ToString()),
                                   MenuCode = dr["MenuCode"].ToString(),
                                   ScreenID = dr["ScreenID"].ToString() != "" ? short.Parse(dr["ScreenID"].ToString()) : short.Parse("0"),
                                   HasInsert = dr["HasInsert"].ToString() != "" ? bool.Parse(dr["HasInsert"].ToString()) : false,
                                   HasUpdate = dr["HasUpdate"].ToString() != "" ? bool.Parse(dr["HasUpdate"].ToString()) : false,
                                   HasDelete = dr["HasDelete"].ToString() != "" ? bool.Parse(dr["HasDelete"].ToString()) : false,
                                   HasSelect = dr["HasSelect"].ToString() != "" ? bool.Parse(dr["HasSelect"].ToString()) : false,
                                   HasImport = dr["HasImport"].ToString() != "" ? bool.Parse(dr["HasImport"].ToString()) : false,
                                   HasExport = dr["HasExport"].ToString() != "" ? bool.Parse(dr["HasExport"].ToString()) : false,
                                   EncryptScreenID = dr["ScreenID"].ToString() != "" ? Security.Encrypt(dr["ScreenID"].ToString()) : null
                               }).OrderBy(x => x.Sequence).ToList();

                    objAction = (from DataRow dr in ds.Tables[2].Rows
                                 select new ScreenAction_VM()
                                 {
                                     ScreenID = Convert.ToInt32(dr["ScreenID"]),
                                     ActionCode = dr["ActionCode"].ToString(),
                                     ActionName = dr["ActionName"].ToString(),
                                     Sequence = Convert.ToByte(dr["Sequence"]),
                                     IsAudited = Convert.ToBoolean(dr["IsAudited"]),
                                     IsRendered = Convert.ToBoolean(dr["IsRendered"]),
                                 }).OrderBy(x => x.Sequence).ToList();

                    objModule = (from DataRow dr in ds.Tables[3].Rows select new Module_VM() { ModuleCode = dr["ModuleCode"].ToString(), }).ToList();

                    objSingleCustomer = (from DataRow dr in ds.Tables[4].Rows
                                         select new IsSingleCustomer_VM()
                                         {
                                             IsSingleUserCustomer = Convert.ToBoolean(dr["IsSingleUserCustomer"]),
                                             IsSingleInstance = Convert.ToBoolean(dr["IsSingleInstance"]),
                                             CustomerID = dr["CustomerID"].ToString() != "" ? short.Parse(dr["CustomerID"].ToString()) : short.Parse("0"),
                                             CustomerName = dr["CustomerName"].ToString()
                                         }).ToList();

                    return (objUser.Count > 0);
                }
            }
            catch (Exception ex)
            {
                logger.Error("UserRepository_ValidateUser_Error: ", ex);
                throw;
            }
        }

        public bool ChangePassword(ResetPasswordVM model)
        {
            try
            {
                bool result = false;
                using (var db = new WebPortalEntities())
                {
                    var data = db.ChangePassword(model.EndUserID, model.Password, model.NewPassword);
                    if (data > 0)
                    {
                        result = true;
                    }
                    return result;
                }
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
                throw;
            }
        }

        public int User_ForgotPassword(MailEndUser_VM Model)
        {
            int query = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_MailID", 0) { Direction = ParameterDirection.Output };

                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_EmailID", GetDBNULL(Model.EmailID)),
                                output
                            };

                    ds = db.ExecuteDataSet("SendForgotePasswordMail", par);
                    query = 1;

                    //query = ConvertToList<MailEndUser_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                query = 0;
                logger.Error("EndUserRepository_User_ForgotPassword Error: ", ex);
            }

            return query;
        }

        public int CheckUser_ForgotPassword_URL(string Id)
        {
            int query = 0;
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var data = db.CheckForgotPasswordURL(Convert.ToInt32(Id));
                    if (data.Count() > 0)
                    {
                        query = 1;
                    }
                    else
                    {
                        query = 0;
                    }
                }
            }
            catch (Exception ex)
            {
                query = 0;
                logger.Error("EndUserRepository_CheckUser_ForgotPassword_URL Error: ", ex);
            }

            return query;
        }

        public bool ChangeForgotPassword(ResetPasswordVM model)
        {
            try
            {
                bool result = false;
                using (var db = new WebPortalEntities())
                {
                    var data = db.ResetPassword(model.EndUserID, model.NewPassword, model.LoginID);
                    if (data.Count() > 0)
                    {
                        result = true;
                    }
                    return result;
                }
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
                throw;
            }
        }

        public IEnumerable<SelectListItem> GetUsers()
        {
            IEnumerable<SelectListItem> items = new List<SelectListItem>();

            try
            {
                List<EndUser_VM> query = ConnectGetDataProcedure(new EndUser_VM() { });

                items = query.Select(x => new SelectListItem() { Text = x.FirstName + ' ' + x.LastName, Value = x.EndUserID.ToString() }).ToList();

                return items;
            }
            catch (Exception ex)
            {
                logger.Error("UserRepository_GetUsers", ex);
            }

            return items;
        }

        public int Delete(EndUser_VM Model)
        {
            int result = 0;

            using (var db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        result = db.DeleteEndUser(Model.EndUserID,
                            Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID,
                            Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);

                        db.SaveChanges();
                        trans.Commit();
                    }
                    catch (Exception ex)
                    {
                        logger.Error("EndUserRepository_Delete Error: ", ex);
                        trans.Rollback();
                        throw;
                    }
                }
            }

            return result;
        }
    }

    public class TimeZoneRepository : BaseRepository
    {
        public List<TimeZone_VM> GetData(TimeZone_VM Model)
        {
            var query = new List<TimeZone_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] { };

                    ds = db.ExecuteDataSet("GetTimeZone", par);
                    query = ConvertToList<TimeZone_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("UOMRepository_GetData: ", ex);
                throw;
            }

            return query;
        }

    }

    public interface IUserRepository
    {
        int Add(EndUser_VM Model);
        int Update(EndUser_VM Model);
        List<EndUser_VM> GetData(EndUser_VM Model);
        List<UserCustomerList_VM> GetCustomerData(UserCustomerList_VM Model);
        List<EndUser_VM> GetUserNameData(EndUser_VM Model);
        List<EndUser_VM> GetControllerUserNameData(EndUser_VM Model);
        bool ValidateUser(string Email, string Password, string IP, out List<UserEmployee_VM> objUser,
            out List<MenuScreen_VM> objMenu, out List<ScreenAction_VM> objAction, out List<Module_VM> objModule, out List<IsSingleCustomer_VM> objSingleCustomer);
        bool ChangePassword(ResetPasswordVM model);
        bool ChangeForgotPassword(ResetPasswordVM model);
        int User_ForgotPassword(MailEndUser_VM Userforpass);
        int CheckUser_ForgotPassword_URL(string Id);
        int Delete(EndUser_VM Model);
    }
};