using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Operations.Repository;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Entities.ViewModels
{
    public class eCustomerRepository : BaseRepository, IeCustomerRepository
    {
        public List<eCustomer_VM> GetData(eCustomer_VM Model)
        {
            var query = new List<eCustomer_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID, true)),
                                new SqlParameter("@p_CustomerName", GetDBNULL(Model.CustomerName, true)),
                                new SqlParameter("@p_CustomerAddress", GetDBNULLString(Model.CustomerAddress)),
                                new SqlParameter("@p_ContactNumber", GetDBNULLString(Model.ContactNumber)),
                                new SqlParameter("@p_DOB", GetDBNULL(Model.DOB)),
                                new SqlParameter("@p_AnniversaryDate", GetDBNULL(Model.AnniversaryDate)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID,true)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID,true)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GeteCustomer", par);
                    query = ConvertToList<eCustomer_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<eCustomer_VM> GeteCustomerDDL(eCustomer_VM Model)
        {
            var query = new List<eCustomer_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] { new SqlParameter("@p_Search", GetDBNULLString(Model.GlobalID)) };

                    ds = db.ExecuteDataSet("GeteCustomerDDL", par);
                    query = ConvertToList<eCustomer_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_GeteCustomerDDL Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(eCustomer_VM Model)
        {
            int result = 0;

            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_CustomerID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName)),
                                new SqlParameter("@p_CustomerAddress", GetDBNULLString(Model.CustomerAddress)),
                                new SqlParameter("@p_ContactNumber", GetDBNULLString(Model.ContactNumber)),

                                new SqlParameter("@p_DOB", GetDBNULL(Model.DOB)),
                                new SqlParameter("@p_AnniversaryDate", GetDBNULL(Model.AnniversaryDate)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    result = db.ExecuteNonQueryRollBack("AddeCustomer", par);

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("eCustomerRepository_Add: ", ex);
                throw;
            }

            return result;
        }

        public int Update(eCustomer_VM Model)
        {
            int result = 0;

            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID,true)),
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName)),
                                new SqlParameter("@p_CustomerAddress", GetDBNULLString(Model.CustomerAddress)),
                                new SqlParameter("@p_ContactNumber", GetDBNULLString(Model.ContactNumber)),

                                new SqlParameter("@p_DOB", GetDBNULL(Model.DOB)),
                                new SqlParameter("@p_AnniversaryDate", GetDBNULL(Model.AnniversaryDate)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateeCustomer", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("eCustomerRepository_Update: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(eCustomer_VM Model)
        {
            int result = 0;

            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID,true)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                            };

                    result = db.ExecuteNonQueryRollBack("DeleteeCustomer", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("eCustomerRepository_Delete: ", ex);
                throw;
            }

            return result;
        }
    }

    public interface IeCustomerRepository : IBaseInterFace
    {
        List<eCustomer_VM> GetData(eCustomer_VM Model);
        List<eCustomer_VM> GeteCustomerDDL(eCustomer_VM Model);
        int Add(eCustomer_VM Model);
        int Update(eCustomer_VM Model);
        int Delete(eCustomer_VM Model);
    }
};
