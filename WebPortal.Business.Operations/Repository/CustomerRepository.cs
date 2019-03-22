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
    public class CustomerRepository : BaseRepository, ICustomerRepository
    {
        #region Customer Master
        public List<Customer_VM> GetData(Customer_VM Model)
        {
            List<Customer_VM> query = new List<Customer_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerShortCode", GetDBNULL(Model.CustomerShortCode)),
                                new SqlParameter("@p_CustomerName", GetDBNULL(Model.CustomerName)),
                                new SqlParameter("@p_LegalEntityName", GetDBNULL(Model.LegalEntityName)),
                                //new SqlParameter("@p_Logo", GetDBNULL(Model.Logo)),
                                new SqlParameter("@p_Remarks", GetDBNULL(Model.Remarks)),
                                new SqlParameter("@p_AccountManagerID", GetDBNULL(Model.AccountManagerID)),
                                new SqlParameter("@p_EffectiveFromDate", GetDBNULL(Model.EffectiveFromDate)),
                                new SqlParameter("@p_EffectiveTillDate", GetDBNULL(Model.EffectiveTillDate)),
                                new SqlParameter("@p_IsChildResult", GetDBNULL(Model.IsChildResult)),

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset,true)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID,true)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID,true)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetCustomer", par);
                    query = ConvertToList<Customer_VM>(ds.Tables[0]);

                    if (Model.IsChildResult == true && ds.Tables.Count > 1)
                    {
                        //if (query[0].Logo != null)
                        //{
                        //    var base64 = Convert.ToBase64String(query[0].Logo);
                        //    var imgSrc = String.Format("data:image/gif;base64,{0}", base64);
                        //    query[0].LogoString = imgSrc;
                        //}

                        query[0].CustomerLanguageList = ConvertToList<CustomerLanguage_VM>(ds.Tables[1]);
                        query[0].CustomerLocationList = ConvertToList<CustomerLocation_VM>(ds.Tables[2]);
                        query[0].CustomerModuleList = ConvertToList<CustomerModule_VM>(ds.Tables[3]);
                        query[0].CustomerServiceLineList = ConvertToList<CustomerServiceLine_VM>(ds.Tables[4]);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<CustomerDDL_VM> GetDataDDL(CustomerDDL_VM Model)
        {
            var query = new List<CustomerDDL_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName))
                            };

                    ds = db.ExecuteDataSet("GetCustomerDDL", par);
                    query = ConvertToList<CustomerDDL_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetDataDDl Error: ", ex);
                throw;
            }

            return query;
        }

        /// <summary>
        /// User for Customer Search for dropdown filters
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public List<Customer_VM> GetUserCustomer(UserLocation_VM Model)
        {
            List<Customer_VM> query = new List<Customer_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetUserCustomer_Result, Customer_VM>());
                    var mapper = config.CreateMapper();
                    List<GetUserCustomer_Result> data = db.GetUserCustomer(Model.ModuleCode, Model.ServiceLineCode, Model.CustomerName,
                      Model.Date, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                    mapper.Map<List<GetUserCustomer_Result>, List<Customer_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetUserCustomer Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(Customer_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection(true))
                {
                    var dt_CustomerLanguage = new DataTable();
                    if (Model.CustomerLanguage_TableTypeList != null && Model.CustomerLanguage_TableTypeList.Count > 0)
                    {
                        dt_CustomerLanguage = ConvertToDatatable(Model.CustomerLanguage_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerLanguage = ConvertToDatatable(new List<CustomerLanguage_TableType_VM>());
                    }

                    var dt_CustomerLocation = new DataTable();
                    if (Model.CustomerLocation_TableTypeList != null && Model.CustomerLocation_TableTypeList.Count > 0)
                    {
                        dt_CustomerLocation = ConvertToDatatable(Model.CustomerLocation_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerLocation = ConvertToDatatable(new List<CustomerLocation_TableType_VM>());
                    }

                    var dt_CustomerModule = new DataTable();
                    if (Model.CustomerModule_TableTypeList != null && Model.CustomerModule_TableTypeList.Count > 0)
                    {
                        dt_CustomerModule = ConvertToDatatable(Model.CustomerModule_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerModule = ConvertToDatatable(new List<CustomerModule_TableType_VM>());
                    }

                    var dt_CustomerServiceLine = new DataTable();
                    if (Model.CustomerServiceLine_TableTypeList != null && Model.CustomerServiceLine_TableTypeList.Count > 0)
                    {
                        dt_CustomerServiceLine = ConvertToDatatable(Model.CustomerServiceLine_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerServiceLine = ConvertToDatatable(new List<CustomerServiceLine_TableType_VM>());
                    }

                    var output = new SqlParameter("@p_CustomerID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerShortCode", GetDBNULL(Model.CustomerShortCode.ToUpper())),
                                new SqlParameter("@p_CustomerName", GetDBNULL(Model.CustomerName)),
                                new SqlParameter("@p_LegalEntityName", GetDBNULLString(Model.LegalEntityName)),
                                new SqlParameter("@p_Logo", GetDBNULL(Model.Logo)),
                                new SqlParameter("@p_Remarks", GetDBNULLString(Model.Remarks)),
                                new SqlParameter("@p_AccountManagerID", GetDBNULL(Model.AccountManagerID)),
                                new SqlParameter("@p_EffectiveFromDate", GetDBNULL(Model.EffectiveFromDate)),
                                new SqlParameter("@p_EffectiveTillDate", GetDBNULL(Model.EffectiveTillDate)),

                                //new SqlParameter("@p_CustomerLanguage", dt_CustomerLanguage) { TypeName = "CustomerLanguage_TableType" },
                                //new SqlParameter("@p_CustomerLocation", dt_CustomerLocation) { TypeName = "CustomerLocation_TableType" },
                                //new SqlParameter("@p_CustomerModule", dt_CustomerModule) { TypeName = "CustomerModule_TableType" },
                                //new SqlParameter("@p_CustomerServiceLine", dt_CustomerServiceLine) { TypeName = "CustomerServiceLine_TableType" },

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    result = db.ExecuteNonQueryRollBack("AddCustomer", par);

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(Customer_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_CustomerLanguage = new DataTable();
                    if (Model.CustomerLanguage_TableTypeList != null && Model.CustomerLanguage_TableTypeList.Count > 0)
                    {
                        dt_CustomerLanguage = ConvertToDatatable(Model.CustomerLanguage_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerLanguage = ConvertToDatatable(new List<CustomerLanguage_TableType_VM>());
                    }

                    var dt_CustomerLocation = new DataTable();
                    if (Model.CustomerLocation_TableTypeList != null && Model.CustomerLocation_TableTypeList.Count > 0)
                    {
                        dt_CustomerLocation = ConvertToDatatable(Model.CustomerLocation_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerLocation = ConvertToDatatable(new List<CustomerLocation_TableType_VM>());
                    }

                    var dt_CustomerModule = new DataTable();
                    if (Model.CustomerModule_TableTypeList != null && Model.CustomerModule_TableTypeList.Count > 0)
                    {
                        dt_CustomerModule = ConvertToDatatable(Model.CustomerModule_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerModule = ConvertToDatatable(new List<CustomerModule_TableType_VM>());
                    }

                    var dt_CustomerServiceLine = new DataTable();
                    if (Model.CustomerServiceLine_TableTypeList != null && Model.CustomerServiceLine_TableTypeList.Count > 0)
                    {
                        dt_CustomerServiceLine = ConvertToDatatable(Model.CustomerServiceLine_TableTypeList);
                    }
                    else
                    {
                        dt_CustomerServiceLine = ConvertToDatatable(new List<CustomerServiceLine_TableType_VM>());
                    }

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerShortCode", GetDBNULL(Model.CustomerShortCode.ToUpper())),
                                new SqlParameter("@p_CustomerName", GetDBNULL(Model.CustomerName)),
                                new SqlParameter("@p_LegalEntityName", GetDBNULL(Model.LegalEntityName)),
                                new SqlParameter("@p_Logo", GetDBNULL(Model.Logo)),
                                new SqlParameter("@p_Remarks", GetDBNULL(Model.Remarks)),
                                new SqlParameter("@p_AccountManagerID", GetDBNULL(Model.AccountManagerID)),
                                new SqlParameter("@p_EffectiveFromDate", GetDBNULL(Model.EffectiveFromDate)),
                                new SqlParameter("@p_EffectiveTillDate", GetDBNULL(Model.EffectiveTillDate)),
                                new SqlParameter("@p_CustomerLanguage", dt_CustomerLanguage) { TypeName = "CustomerLanguage_TableType" },

                                new SqlParameter("@p_CustomerLocation", dt_CustomerLocation) { TypeName = "CustomerLocation_TableType" },
                                new SqlParameter("@p_CustomerModule", dt_CustomerModule) { TypeName = "CustomerModule_TableType" },
                                new SqlParameter("@p_CustomerServiceLine", dt_CustomerServiceLine) { TypeName = "CustomerServiceLine_TableType" },

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateCustomer", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }

        public int UpdateCustomerLogo(Customer_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new WebPortalEntities())
                {
                    result = db.UpdateCustomerLogo(Model.CustomerID, Model.Logo, Model.CurrentLanguageCode, Model.CurrentUTCOffset,
                        Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_UpdateCustomerLogo Error: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(Customer_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new WebPortalEntities())
                {
                    using (var dbcxtransaction = db.Database.BeginTransaction())
                    {
                        try
                        {
                            result = db.DeleteCustomer(Model.CustomerID, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                            db.SaveChanges();
                            dbcxtransaction.Commit();
                        }
                        catch (Exception ex)
                        {
                            logger.Error("CustomerRepository_Delete Rollback Error: ", ex);
                            dbcxtransaction.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }
        #endregion Customer Master

        #region Customer Location

        public List<GetLocationTree_VM> GetLocationRootAndLeaflevel(Location_VM Model)
        {
            List<GetLocationTree_VM> query = new List<GetLocationTree_VM>();
            try
            {
                //using (var db = new WebPortalEntities())
                //{
                //    var config = new MapperConfiguration(cfg => cfg.CreateMap<f_GetAllLevelLocation_Result, GetLocationTree_VM>());
                //    var mapper = config.CreateMapper();
                //    List<f_GetAllLevelLocation_Result> data = db.f_GetAllLeafLevelLocation(Model.CustomerID, Model.LocationID).ToList();
                //    mapper.Map<List<f_GetAllLevelLocation_Result>, List<GetLocationTree_VM>>(data, query);
                //}

                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {

                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                            };

                    ds = db.ExecuteDataSet("_GetLocationWithQR", par);
                    query = ConvertToList<GetLocationTree_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetLocationRootAndLeaflevel: ", ex);
                throw;
            }

            return query;
        }
        public List<GetLocationTree_VM> GetCustomerAllRootLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> query = new List<GetLocationTree_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerAllRootLocation_Result, GetLocationTree_VM>());
                    var mapper = config.CreateMapper();
                    List<GetCustomerAllRootLocation_Result> data = db.GetCustomerAllRootLocation(Model.CustomerID).ToList();
                    mapper.Map<List<GetCustomerAllRootLocation_Result>, List<GetLocationTree_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetCustomerRootLocation: ", ex);
                throw;
            }

            return query;
        }
        public List<GetLocationTree_VM> GetCustomerRootLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> query = new List<GetLocationTree_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerRootLocation_Result, GetLocationTree_VM>());
                    var mapper = config.CreateMapper();
                    List<GetCustomerRootLocation_Result> data = db.GetCustomerRootLocation(Model.CustomerID).ToList();
                    //List<GetCustomerRootLocation_Result> data = db.GetCustomerRootLocation(Model.CustomerID).ToList();
                    mapper.Map<List<GetCustomerRootLocation_Result>, List<GetLocationTree_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetCustomerRootLocation: ", ex);
                throw;
            }

            return query;
        }
        public List<GetLocationTree_VM> GetCustomerChildLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> query = new List<GetLocationTree_VM>();
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerChildLocation_Result, GetLocationTree_VM>());
                    var mapper = config.CreateMapper();
                    List<GetCustomerChildLocation_Result> data = db.GetCustomerChildLocation(Model.LocationID).ToList();
                    mapper.Map<List<GetCustomerChildLocation_Result>, List<GetLocationTree_VM>>(data, query);
                }

                //using (var db = new DBConnection())
                //{
                //    var ds = new DataSet();
                //    ds = db.ExecuteDataSet("GetCustomerChildLocation", new SqlParameter[] {
                //                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                //            });
                //    query = ConvertToList<GetLocationTree_VM>(ds.Tables[0]);
                //}
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetCustomerChildLocation: ", ex);
                throw;
            }

            return query;
        }

        public List<GetLocationTree_VM> GetCustomerLocationData(Location_VM Model)
        {
            List<GetLocationTree_VM> query = new List<GetLocationTree_VM>();
            try
            {
                //using (var db = new WebPortalEntities())
                //{
                //    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerLocation_Result, GetLocationTree_VM>());
                //    var mapper = config.CreateMapper();
                //    List<GetCustomerLocation_Result> data = db.GetCustomerLocation(Model.CustomerID, Model.LocationID).ToList();
                //    mapper.Map<List<GetCustomerLocation_Result>, List<GetLocationTree_VM>>(data, query);
                //}

                using (var db = new DBConnection())
                {
                    var ds = new DataSet();

                    ds = db.ExecuteDataSet("GetCustomerLocation", new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                            });

                    query = ConvertToList<GetLocationTree_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetCustomerChildLocation: ", ex);
                throw;
            }

            return query;
        }

        /// <summary>
        /// Get User Locations (Roots/) it is simlier with GetCustomerRootLocation sp
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public List<GetLocationTree_VM> GetUserCustomerLocation(Location_VM Model)
        {
            var query = new List<GetLocationTree_VM>();
            try
            {
                //using (var db = new WebPortalEntities())
                //{
                //    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetUserCustomerLocation_Result, GetLocationTree_VM>());
                //    var mapper = config.CreateMapper();
                //    var data = db.GetUserCustomerLocation(Model.CustomerID, Model.LocationID, Model.CurrentModuleCode, Model.CurrentServiceLineCode,
                //        Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                //    mapper.Map<List<GetUserCustomerLocation_Result>, List<GetLocationTree_VM>>(data, query);
                //}

                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {

                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),

                                new SqlParameter("@p_ModuleCode", GetDBNULL(Model.CurrentModuleCode)),
                                new SqlParameter("@p_ServiceLineCode", GetDBNULL(Model.CurrentServiceLineCode)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetUserCustomerLocation", par);
                    query = ConvertToList<GetLocationTree_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetUserCustomerLocation: ", ex);
                throw;
            }

            return query;
        }

        public int AddLocation(Location_VM Model)
        {
            int result = 0;
            try
            {

                using (var db = new DBConnection())
                {
                    var dt_LocationRiskLevel = new DataTable();
                    if (Model.LocationRiskLevel_TableTypeList != null && Model.LocationRiskLevel_TableTypeList.Count > 0)
                    {
                        dt_LocationRiskLevel = ConvertToDatatable(Model.LocationRiskLevel_TableTypeList);
                    }
                    else
                    {
                        dt_LocationRiskLevel = ConvertToDatatable(new List<LocRiskLevel_TableTypeList>());
                    }

                    var output = new SqlParameter("@p_LocationID", Model.LocationID) { Direction = ParameterDirection.Output };
                    output.Size = 1000;

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationName", GetDBNULL(Model.LocationName)),
                                new SqlParameter("@p_ParentLocationID", GetDBNULL(Model.ParentLocationID)),
                                new SqlParameter("@p_HasCustomers", GetDBNULL(Model.HasCustomers)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_Longitude", GetDBNULL(Model.Longitude)),
                                new SqlParameter("@p_Latitude", GetDBNULL(Model.Latitude)),
                                new SqlParameter("@p_Remarks", GetDBNULL(Model.Remarks)),
                                new SqlParameter("@p_LocationRiskLevel", dt_LocationRiskLevel) { TypeName = "LocationRiskLevel_TableTypeList" },
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    db.ExecuteNonQueryRollBack("AddCustomerLocationRiskLevel", par);

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("LocationRepository_Add: ", ex);
                throw;
            }

            return result;
        }

        public int UpdateLocation(Location_VM Model)
        {
            int result = 0;
            try
            {

                using (var db = new DBConnection())
                {
                    var dt_LocationRiskLevel = new DataTable();
                    if (Model.LocationRiskLevel_TableTypeList != null && Model.LocationRiskLevel_TableTypeList.Count > 0)
                    {
                        dt_LocationRiskLevel = ConvertToDatatable(Model.LocationRiskLevel_TableTypeList);
                    }
                    else
                    {
                        dt_LocationRiskLevel = ConvertToDatatable(new List<LocRiskLevel_TableTypeList>());
                    }

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                                new SqlParameter("@p_LocationName", GetDBNULL(Model.LocationName)),
                                new SqlParameter("@p_ParentLocationID", GetDBNULL(Model.ParentLocationID)),
                                new SqlParameter("@p_HasCustomers", GetDBNULL(Model.HasCustomers)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_Longitude", GetDBNULL(Model.Longitude)),
                                new SqlParameter("@p_Latitude", GetDBNULL(Model.Latitude)),
                                new SqlParameter("@p_Remarks", GetDBNULL(Model.Remarks)),
                                new SqlParameter("@p_LocationRiskLevel", dt_LocationRiskLevel) { TypeName = "LocationRiskLevel_TableTypeList" },
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateCustomerLocationRiskLevel", par);

                }

                //using (var db = new WebPortalEntities())
                //{
                //    result = db.UpdateLocation(Model.LocationID, Model.LocationName, Model.ParentLocationID, Model.HasCustomers, Model.Longitude,
                //        Model.Latitude, Model.Remarks, Model.RiskLevelID, Model.CurrentLanguageCode, Model.CurrentUTCOffset,
                //        Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                //    db.SaveChanges();
                //}
            }
            catch (Exception ex)
            {
                logger.Error("LocationRepository_Update: ", ex);
                throw;
            }

            return result;
        }

        public int DeleteLocation(Location_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new WebPortalEntities())
                {
                    result = db.DeleteCustomerLocationRiskLevel(Model.LocationID,
                        Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID,
                        Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                logger.Error("LocationRepository: ", ex);
                throw;
            }
            return result;
        }

        public List<Location_VM> GetDataByID(Location_VM Model)
        {
            var query = new List<Location_VM>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                                new SqlParameter("@p_LocationName", GetDBNULL(Model.LocationName)),
                                new SqlParameter("@p_ParentLocationID", GetDBNULL(Model.ParentLocationID, true)),
                                new SqlParameter("@p_HasCustomers", GetDBNULL(Model.HasCustomers)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_Longitude", GetDBNULL(Model.Longitude)),
                                new SqlParameter("@p_Latitude", GetDBNULL(Model.Latitude)),
                                new SqlParameter("@p_Remarks", GetDBNULL(Model.Remarks)),
                                new SqlParameter("@p_IsChildResult", GetDBNULL(Model.IsChildResult)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetCustomerLocationRiskLevel", par);


                    query = ConvertToList<Location_VM>(ds.Tables[0]);

                    if (Model.IsChildResult == true)
                    {
                        query[0].LocationRiskLevelList = ConvertToList<LocRiskLevel_VM>(ds.Tables[1]);
                    }
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        query[0].FileID = Convert.ToInt64(ds.Tables[2].Rows[0]["FileID"].ToString());

                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetDataByID: ", ex);
                throw;
            }

            return query;
        }

        public List<MEILocation> GetMEICustomerAndLocationDetails(MEILocation Model)
        {
            var query = new List<MEILocation>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode))
                            };

                    ds = db.ExecuteDataSet("GetMEICustomerAndLocationDetails", par);
                    query = ConvertToList<MEILocation>(ds.Tables[0]);

                    if (Model.IsChildResult == true)
                    {
                        query[0].LocationName = ds.Tables[1].Rows[0][0].ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetMEICustomerAndLocationDetails: ", ex);
                throw;
            }

            return query;
        }

        public List<RootAndChildCustomerLocationRiskLevel> GetRootAndChildCustomerLocationRiskLevel(RootAndChildCustomerLocationRiskLevel Model)
        {
            var query = new List<RootAndChildCustomerLocationRiskLevel>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID))
                            };

                    ds = db.ExecuteDataSet("GetRootAndChildCustomerLocationRiskLevel", par);
                    query = ConvertToList<RootAndChildCustomerLocationRiskLevel>(ds.Tables[0]);

                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetRootAndChildCustomerLocationRiskLevel: ", ex);
                throw;
            }

            return query;
        }
        #endregion Customer Location

        #region Customer Module Name

        public List<CustomerModule_VM> GetCustomerModuleName(short? CustomerID, string LanguageCode = "EN")
        {
            var query = new List<CustomerModule_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<CustomerModuleName_Result, CustomerModule_VM>());
                    var mapper = config.CreateMapper();
                    var data = db.CustomerModuleName(CustomerID, LanguageCode).ToList();
                    mapper.Map<List<CustomerModuleName_Result>, List<CustomerModule_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetUserCustomer Error: ", ex);
                throw;
            }

            return query;
        }

        #endregion

        #region Customer Dashboard 
        /// <summary>
        /// See in CustomerDashboard.sql
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>

        public List<CustomerDashboard_VM> GetCustomerDetails(Location_VM Model)
        {
            var query = new List<CustomerDashboard_VM>();
            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetCustomerDashboardCustomerDetails", par);
                    query = ConvertToList<CustomerDashboard_VM>(ds.Tables[0]);
                    ds.Tables[1].Columns.Add(new DataColumn("CustomerLogoImage", typeof(byte[])));
                    foreach (DataRow row in ds.Tables[1].Rows)
                    {
                        if (row["Logo"].ToString() != "")
                        {
                            var URL = "/CustomerLogo/" + Convert.ToString(row["Logo"]);
                            URL = URL.Replace("\\", "");
                            query[0].CustomerLogo = URL;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerRepository_GetCustomerDetails: ", ex);
                throw;
            }

            return query;
        }

        //public List<SafetyDashboard_VM> GetSafetyDashboardInspectionTypeStatus(SafetyDashboard_VM Model)
        //{
        //    var query = new List<SafetyDashboard_VM>();

        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardInspectionTypeStatus_Result, SafetyDashboard_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardInspectionTypeStatus(Model.CategoryID, Model.MonthDuration, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardInspectionTypeStatus_Result>, List<SafetyDashboard_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetSafetyDashboardInspectionTypeStatus Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<SafetyDashboard_VM> GetDashboardMonthlySnapshot(SafetyDashboard_VM Model)
        //{
        //    List<SafetyDashboard_VM> query = new List<SafetyDashboard_VM>();

        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardMonthlySnapshot_Result, SafetyDashboard_VM>());
        //            var mapper = config.CreateMapper();

        //            List<GetSafetyDashboardMonthlySnapshot_Result> data = db.GetSafetyDashboardMonthlySnapshot(Model.CategoryID, Model.CustomerID, Model.InspectionType, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardMonthlySnapshot_Result>, List<SafetyDashboard_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetDashboardMonthlySnapshot Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<SafetyDashboardYearlyChart_VM> GetDashboardYearlySnapshot(SafetyDashboard_VM Model)
        //{
        //    var query = new List<SafetyDashboardYearlyChart_VM>();
        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardYearlyChart_Result, SafetyDashboardYearlyChart_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardYearlyChart(Model.CategoryID, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.Year, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardYearlyChart_Result>, List<SafetyDashboardYearlyChart_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetDashboardYearlySnapshot Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<SafetyDashboardFunnelChart_VM> GetDashboardFunnelChart(SafetyDashboard_VM Model)
        //{
        //    var query = new List<SafetyDashboardFunnelChart_VM>();

        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardPlansAndAssets_Result, SafetyDashboardFunnelChart_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardPlansAndAssets(Model.CategoryID, Model.MonthDuration, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardPlansAndAssets_Result>, List<SafetyDashboardFunnelChart_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetDashboardFunnelChart Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<SafetyDashboardEmergencyInspection_VM> GetDashboardEmergencyInspection(SafetyDashboard_VM Model)
        //{
        //    var query = new List<SafetyDashboardEmergencyInspection_VM>();

        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardEmergencyInspection_Result, SafetyDashboardEmergencyInspection_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardEmergencyInspection(Model.CategoryID, Model.MonthDuration, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardEmergencyInspection_Result>, List<SafetyDashboardEmergencyInspection_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetDashboardEmergencyInspection Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<SafetyDashboardDeviation_VM> GetDashboardDeviation(SafetyDashboard_VM Model)
        //{
        //    var query = new List<SafetyDashboardDeviation_VM>();

        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardDeviatonsChart_Result, SafetyDashboardDeviation_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardDeviatonsChart(Model.CategoryID, Model.MonthDuration, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardDeviatonsChart_Result>, List<SafetyDashboardDeviation_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetDashboardDeviation Error: ", ex);
        //        throw;
        //    }
        //}

        //public List<ActiveData_VM> GetActiveData(SafetyDashboard_VM Model)
        //{
        //    var query = new List<ActiveData_VM>();
        //    try
        //    {
        //        using (var db = new DBConnection())
        //        {
        //            var ds = new DataSet();
        //            var par = new SqlParameter[] {
        //                        new SqlParameter("@p_MonthDuration", GetDBNULL(Model.MonthDuration)),
        //                        new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
        //                        new SqlParameter("@p_ModuleCode", GetDBNULL(Model.CurrentModuleCode)),
        //                        new SqlParameter("@p_ServiceLineCode", GetDBNULL(Model.CurrentServiceLineCode)),
        //                        new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
        //                        new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
        //                        new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
        //                        new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
        //                        new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
        //                        new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
        //                      };

        //            ds = db.ExecuteDataSet("GetSafetyDashboardActiveAssetsPlansDeviations", par);
        //            query = ConvertToList<ActiveData_VM>(ds.Tables[0]);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("EndUserRepository_GetData Error: ", ex);
        //        throw;
        //    }

        //    return query;
        //}

        //public List<TopDeviationCount_VM> GetTopDeviationCount(SafetyDashboard_VM Model)
        //{
        //    var query = new List<TopDeviationCount_VM>();
        //    try
        //    {
        //        using (var db = new WebPortalEntities())
        //        {
        //            var config = new MapperConfiguration(cfg => cfg.CreateMap<GetSafetyDashboardTop5Deviations_Result, TopDeviationCount_VM>());
        //            var mapper = config.CreateMapper();

        //            var data = db.GetSafetyDashboardTop5Deviations(Model.CategoryID, Model.MonthDuration, Model.CustomerID, Model.CurrentModuleCode, Model.CurrentServiceLineCode, Model.CurrentLanguageCode,
        //                Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
        //            return mapper.Map<List<GetSafetyDashboardTop5Deviations_Result>, List<TopDeviationCount_VM>>(data, query);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        logger.Error("DashboardRepository_GetTopDeviationCount Error: ", ex);
        //        throw;
        //    }
        //}

        #endregion Customer Dashboard

        public int UpdateSortingGrid(UpdateSorting_VM Model)
        {
            int result = 0;

            using (var db = new WebPortalEntities())
            {
                using (var transaction = db.Database.BeginTransaction())
                {
                    try
                    {
                        var par = new SqlParameter[] {
                                new SqlParameter("@p_LocationID", GetDBNULL(Model.id)),
                                new SqlParameter("@p_Index", GetDBNULL(Model.Index)),
                                new SqlParameter("@p_Type", GetDBNULLString(Model.Type)),

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                        result = db.Database.ExecuteSqlCommand("exec UpdateLocationSortOrder @p_LocationID, @p_Index, @p_Type, @p_LanguageCode, @p_UTCOffset, @p_EndUserID, @p_UserRoleID, @p_ScreenID, @p_AccessPoint ", par);
                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        logger.Error("UpdateSortingGrid Error: ", ex);
                        transaction.Rollback();
                        throw;
                    }
                }
            }

            return result;
        }
    }

    public interface ICustomerRepository : IBaseInterFace
    {
        List<CustomerDDL_VM> GetDataDDL(CustomerDDL_VM Model);
        List<Customer_VM> GetData(Customer_VM Model);
        List<Customer_VM> GetUserCustomer(UserLocation_VM Model);
        int Add(Customer_VM Model);
        int Update(Customer_VM Model);
        int UpdateCustomerLogo(Customer_VM Model);
        int Delete(Customer_VM Model);

        List<GetLocationTree_VM> GetLocationRootAndLeaflevel(Location_VM Model);
        List<GetLocationTree_VM> GetCustomerAllRootLocation(Location_VM Model);
        List<GetLocationTree_VM> GetCustomerRootLocation(Location_VM Model);
        List<GetLocationTree_VM> GetCustomerChildLocation(Location_VM Model);
        List<GetLocationTree_VM> GetCustomerLocationData(Location_VM Model);
        List<GetLocationTree_VM> GetUserCustomerLocation(Location_VM Model);
        int AddLocation(Location_VM Model);
        int UpdateLocation(Location_VM Model);
        int DeleteLocation(Location_VM Model);
        List<Location_VM> GetDataByID(Location_VM Model);
        List<MEILocation> GetMEICustomerAndLocationDetails(MEILocation Model);

        List<RootAndChildCustomerLocationRiskLevel> GetRootAndChildCustomerLocationRiskLevel(RootAndChildCustomerLocationRiskLevel Model);
        List<CustomerModule_VM> GetCustomerModuleName(short? CustomerID, string LanguageCode = "EN");

        int UpdateSortingGrid(UpdateSorting_VM Model);

        #region Customer Dashboard 
        List<CustomerDashboard_VM> GetCustomerDetails(Location_VM Model);
        //List<SafetyDashboard_VM> GetSafetyDashboardInspectionTypeStatus(SafetyDashboard_VM Model);
        //List<SafetyDashboard_VM> GetDashboardMonthlySnapshot(SafetyDashboard_VM Model);
        //List<SafetyDashboardYearlyChart_VM> GetDashboardYearlySnapshot(SafetyDashboard_VM Model);
        //List<SafetyDashboardFunnelChart_VM> GetDashboardFunnelChart(SafetyDashboard_VM Model);
        //List<SafetyDashboardEmergencyInspection_VM> GetDashboardEmergencyInspection(SafetyDashboard_VM Model);
        //List<SafetyDashboardDeviation_VM> GetDashboardDeviation(SafetyDashboard_VM Model);
        //List<ActiveData_VM> GetActiveData(SafetyDashboard_VM Model);
        //List<TopDeviationCount_VM> GetTopDeviationCount(SafetyDashboard_VM Model);

        #endregion Customer Dashboard 
    }
};
