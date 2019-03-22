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
    public class CustomerContactRepository : BaseRepository, ICustomerContactRepository
    {
        public List<CustomerContact_VM> GetData(CustomerContact_VM Model)
        {
            List<CustomerContact_VM> query = new List<CustomerContact_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerContact_Result, CustomerContact_VM>());
                    var mapper = config.CreateMapper();
                    List<GetCustomerContact_Result> data = db.GetCustomerContact(Model.CustomerID, Model.ContactName,
                        Model.Email, Model.Telephone, Model.Mobile, Model.IsPrimaryContact, Model.CurrentLanguageCode,
                        Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();

                    mapper.Map<List<GetCustomerContact_Result>, List<CustomerContact_VM>>(data, query);
                }

                if (query.Count > 0)
                {
                    if (query[0].UserID != null && Model.IsChildResult == true)
                    {
                        var customerContact = query[0];
                        UserRepository user_ = new UserRepository();

                        var CustomerContactUser = user_.GetData(new EndUser_VM() { EndUserID = customerContact.UserID, IsChildResult = true, IsCustomerUser = true });

                        if (CustomerContactUser.Count > 0)
                        {
                            var _CustomerContactUser = CustomerContactUser[0];

                            customerContact.IsWebAccess = true;
                            customerContact.LanguageCode = _CustomerContactUser.LanguageCode;
                            customerContact.Gender = _CustomerContactUser.Gender;
                            customerContact.UTCOffset = _CustomerContactUser.UTCOffset;
                            customerContact.DefaultModuleCode = _CustomerContactUser.DefaultModuleCode;
                            customerContact.EndUserModuleList = _CustomerContactUser.EndUserModuleList;
                            customerContact.UserRoleUserList = _CustomerContactUser.UserRoleUserList;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerContactRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Update(CustomerContact_VM Model)
        {
            int result = 0;

            try
            {
                var dt_EndUserModule = new DataTable();
                if (Model.EndUserModule_TableTypeList != null && Model.EndUserModule_TableTypeList.Count > 0)
                    dt_EndUserModule = ConvertToDatatable(Model.EndUserModule_TableTypeList);
                else
                    dt_EndUserModule = ConvertToDatatable(new List<EndUserModule_TableType_VM>());

                var dt_UserRoleUser = new DataTable();
                if (Model.UserRoleUser_TableTypeList != null && Model.UserRoleUser_TableTypeList.Count > 0)
                    dt_UserRoleUser = ConvertToDatatable(Model.UserRoleUser_TableTypeList);
                else
                    dt_UserRoleUser = ConvertToDatatable(new List<UserRoleUser_TableType_VM>());

                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {

                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_ContactName", GetDBNULLString(Model.ContactName)),
                                new SqlParameter("@p_ContactNameOld", GetDBNULLString(Model.ContactNameOld)),
                                new SqlParameter("@p_Email", GetDBNULLString(Model.Email)),
                                new SqlParameter("@p_Telephone", GetDBNULL(Model.Telephone)),
                                new SqlParameter("@p_Mobile", GetDBNULL(Model.Mobile)),
                                new SqlParameter("@p_IsPrimaryContact", GetDBNULL(Model.IsPrimaryContact)),

                                new SqlParameter("@p_IsWebAccess", GetDBNULL(Model.IsWebAccess)),
                                new SqlParameter("@p_UserID", GetDBNULL(Model.UserID)),
                                new SqlParameter("@p_CustomerContactLanguageCode", GetDBNULL(Model.LanguageCode)),
                                new SqlParameter("@p_CustomerContactUTCOffset", GetDBNULL(Model.UTCOffset)),
                                new SqlParameter("@p_DefaultModuleCode", GetDBNULL(Model.DefaultModuleCode)),
                                new SqlParameter("@p_Gender", GetDBNULL(Model.Gender)),
                                new SqlParameter("@p_UserIdentity", GetDBNULL(Model.UserIdentity)),
                                new SqlParameter("@p_EndUserModule", dt_EndUserModule) { TypeName = "EndUserModule_TableType" },
                                new SqlParameter("@p_UserRoleUser", dt_UserRoleUser) { TypeName = "UserRoleUser_TableType" },

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateCustomerContact", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerContactRepository_Update: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(CustomerContact_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {

                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_ContactName", GetDBNULLString(Model.ContactName)),

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("DeleteCustomerContact", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerContactRepository_Delete: ", ex);
                throw;
            }
            return result;
        }
    }

    public interface ICustomerContactRepository : IBaseInterFace
    {
        List<CustomerContact_VM> GetData(CustomerContact_VM Model);
        int Update(CustomerContact_VM Model);
        int Delete(CustomerContact_VM Model);
    }
};
