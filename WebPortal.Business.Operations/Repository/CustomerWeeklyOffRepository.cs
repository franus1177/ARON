using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class CustomerWeeklyOffRepository : BaseRepository, ICustomerWeeklyOffRepository
	{
		public List<CustomerWeeklyOff_VM> GetData(CustomerWeeklyOff_VM Model)
		{
			List<CustomerWeeklyOff_VM> query = new List<CustomerWeeklyOff_VM>();

			try
			{
				using (var db = new DBConnection())
				{
					var ds = new DataSet();
					var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
								new SqlParameter("@p_DayName", GetDBNULL(Model.DayName)),

								new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
								new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
								new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
								new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
								new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
								new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),							};

					ds = db.ExecuteDataSet("GetCustomerWeeklyOff", par);
					query = ConvertToList<CustomerWeeklyOff_VM>(ds.Tables[0]);

					if(Model.IsChildResult == true)
						query[0].CustomerWeeklyOffNameList = ConvertToList<CustomerWeeklyOffName_VM>(ds.Tables[1]);
				}
			}
			catch (Exception ex)
			{
				logger.Error("CustomerWeeklyOffRepository_GetData Error: ", ex);
				throw;
			}

			return query;
		}

		public int Add(CustomerWeeklyOff_VM Model)
		{
			int result = 0;
			try
			{
                using (var db = new DBConnection())
                {

					var dt_CustomerWeeklyOffName = new DataTable();
					if (Model.CustomerWeeklyOffName_TableTypeList != null && Model.CustomerWeeklyOffName_TableTypeList.Count > 0)
						dt_CustomerWeeklyOffName = ConvertToDatatable(Model.CustomerWeeklyOffName_TableTypeList);
					else
						dt_CustomerWeeklyOffName = ConvertToDatatable(new List<CustomerWeeklyOffName_TableType_VM>());

                    var dt_CustomerLocation = new DataTable();
                    if (Model.CustomerLocation_TableTypeList != null && Model.CustomerLocation_TableTypeList.Count > 0)
                        dt_CustomerLocation = ConvertToDatatable(Model.CustomerLocation_TableTypeList);
                    else
                        dt_CustomerLocation = ConvertToDatatable(new List<CustomerLocationList_VM>());


                    var par = new SqlParameter[] {
								//new SqlParameter("@p_LocationID", GetDBNULL(Model.LocationID)),
                                new SqlParameter("@p_CustomerLocation", dt_CustomerLocation) { TypeName = "CustomerLocation_TableType" },
                                new SqlParameter("@p_CustomerWeeklyOffName", dt_CustomerWeeklyOffName) { TypeName = "CustomerWeeklyOffName_TableType" },

								new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
								new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
								new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
								new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
								new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
								new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                            };

                    db.ExecuteNonQueryRollBack("AddCustomerWeeklyOff", par);
                    result = 1;
                }
			}
			catch (Exception ex)
			{
				logger.Error("CustomerWeeklyOffRepository_Add Error: ", ex);
				throw;
			}

			return result;
		}

		public int Update(CustomerWeeklyOff_VM Model)
		{
			int result = 0;
			try
			{
                using (var db = new DBConnection())
                {

                    var dt_CustomerWeeklyOffName = new DataTable();
                    if (Model.CustomerWeeklyOffName_TableTypeList != null && Model.CustomerWeeklyOffName_TableTypeList.Count > 0)
                        dt_CustomerWeeklyOffName = ConvertToDatatable(Model.CustomerWeeklyOffName_TableTypeList);
                    else
                        dt_CustomerWeeklyOffName = ConvertToDatatable(new List<CustomerWeeklyOffName_TableType_VM>());

                    var dt_CustomerLocation = new DataTable();
                    if (Model.CustomerLocation_TableTypeList != null && Model.CustomerLocation_TableTypeList.Count > 0)
                        dt_CustomerLocation = ConvertToDatatable(Model.CustomerLocation_TableTypeList);
                    else
                        dt_CustomerLocation = ConvertToDatatable(new List<CustomerLocationList_VM>());


                    var par = new SqlParameter[] {
								new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerLocation", dt_CustomerLocation) { TypeName = "CustomerLocation_TableType" },
                                new SqlParameter("@p_CustomerWeeklyOffName", dt_CustomerWeeklyOffName) { TypeName = "CustomerWeeklyOffName_TableType" },

                                new SqlParameter("@p_LanguageCode", GetDBNULLString(Model.CurrentLanguageCode)),
                                new SqlParameter("@p_UTCOffset", GetDBNULL(Model.CurrentUTCOffset)),
                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                            };

                    db.ExecuteNonQueryRollBack("UpdateCustomerWeeklyOff", par);
                    result = 1;
                }
            }
			catch (Exception ex)
			{
				logger.Error("CustomerWeeklyOffRepository_Update Error: ", ex);
				throw;
			}

			return result;
		}


		public int Delete(CustomerWeeklyOff_VM Model)
		{
			int result = 0;
			try
			{
				using (var db = new WebPortalEntities())
				{
					result = db.DeleteCustomerWeeklyOff(Model.LocationID, Model.DayName, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
					db.SaveChanges();
				}
			}
			catch (Exception ex)
			{
				logger.Error("CustomerWeeklyOffRepository_Delete Error: ", ex);
				throw;
			}
			return result;
		}
	}

	public interface ICustomerWeeklyOffRepository : IBaseInterFace
	{
		List<CustomerWeeklyOff_VM> GetData(CustomerWeeklyOff_VM Model);
		int Add(CustomerWeeklyOff_VM Model);
		int Update(CustomerWeeklyOff_VM Model);
		int Delete(CustomerWeeklyOff_VM Model);
	}
}
