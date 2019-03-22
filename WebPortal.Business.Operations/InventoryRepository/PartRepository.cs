using System;
using System.Data;
using System.Collections.Generic;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
using WebPortal.Business.Operations.Repository;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;

namespace WebPortal.Business.Operations.InventoryRepository
{
    public class PartRepository : BaseRepository, IPartRepository
    {
        public List<Part_VM> GetData(Part_VM Model)
        {
            var query = new List<Part_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();

                    ds = db.ExecuteDataSet("GetPart", new SqlParameter[] {
                                new SqlParameter("@p_PartID", GetDBNULL(Model.PartID)),
                                new SqlParameter("@p_PartName", GetDBNULLString(Model.PartName)),
                                new SqlParameter("@p_PartDescription", GetDBNULLString(Model.PartDescription)),
                                new SqlParameter("@p_PartVendor", GetDBNULLString(Model.PartVendor)),
                                new SqlParameter("@p_PartCost", GetDBNULL(Model.PartCost)),
                                new SqlParameter("@p_PartQuantity", GetDBNULL(Model.PartQuantity))
                            });

                    query = ConvertToList<Part_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PartRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<Part_VM> GetPartDDL(Part_VM Model)
        {
            var query = new List<Part_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();

                    ds = db.ExecuteDataSet("GetPartDDL", new SqlParameter[] {
                                new SqlParameter("@p_PartName", GetDBNULLString(Model.PartName))
                            });

                    query = ConvertToList<Part_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PartRepository_GetDataDDL Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(Part_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_PartID", 0) { Direction = ParameterDirection.Output };

                    result = db.ExecuteNonQueryRollBack("AddPart", new SqlParameter[] {
                                new SqlParameter("@p_PartName", GetDBNULLString(Model.PartName)),
                                new SqlParameter("@p_PartDescription", GetDBNULLString(Model.PartDescription)),
                                new SqlParameter("@p_PartVendor", GetDBNULLString(Model.PartVendor)),
                                new SqlParameter("@p_PartCost", GetDBNULL(Model.PartCost)),
                                new SqlParameter("@p_PartQuantity", GetDBNULL(Model.PartQuantity)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            });

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PartRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(Part_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    result = db.ExecuteNonQueryRollBack("UpdatePart", new SqlParameter[] {
                                new SqlParameter("@p_PartID", GetDBNULL(Model.PartID)),
                                new SqlParameter("@p_PartName", GetDBNULLString(Model.PartName)),
                                new SqlParameter("@p_PartDescription", GetDBNULLString(Model.PartDescription)),
                                new SqlParameter("@p_PartVendor", GetDBNULLString(Model.PartVendor)),
                                new SqlParameter("@p_PartCost", GetDBNULL(Model.PartCost)),
                                new SqlParameter("@p_PartQuantity", GetDBNULL(Model.PartQuantity)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            });
                }
            }
            catch (Exception ex)
            {
                logger.Error("PartRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(Part_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    result = db.ExecuteNonQueryRollBack("DeletePart", new SqlParameter[] {
                                new SqlParameter("@p_PartID", GetDBNULL(Model.PartID)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            });
                }
            }
            catch (Exception ex)
            {
                logger.Error("PartRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }
    }

    public interface IPartRepository : IBaseInterFace
    {
        List<Part_VM> GetData(Part_VM Model);
        List<Part_VM> GetPartDDL(Part_VM Model);

        int Add(Part_VM Model);
        int Update(Part_VM Model);
        int Delete(Part_VM Model);
    }
};