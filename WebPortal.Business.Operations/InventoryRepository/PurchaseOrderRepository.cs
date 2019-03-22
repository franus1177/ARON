using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.Business.Operations.InventoryRepository
{
    public class PurchaseOrderRepository : BaseRepository, IPurchaseOrderRepository
    {
        public List<PurchaseOrder_VM> GetData(PurchaseOrder_VM Model)
        {
            var query = new List<PurchaseOrder_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),
                                new SqlParameter("@p_PONumber", GetDBNULLString(Model.PONumber)),
                                new SqlParameter("@p_POItemID", GetDBNULL(Model.POItemID)),
                                new SqlParameter("@p_PORecDate", GetDBNULL(Model.PORecDate)),
                                new SqlParameter("@p_POEstShipDate", GetDBNULL(Model.POEstShipDate)),
                                new SqlParameter("@p_POActShipDate", GetDBNULL(Model.POActShipDate)),

                                new SqlParameter("@p_POCost", GetDBNULL(Model.POCost)),
                                new SqlParameter("@p_POPrice", GetDBNULL(Model.POPrice)),
                                new SqlParameter("@p_POCompleted", GetDBNULL(Model.POCompleted)),
                                new SqlParameter("@p_CreatedAt", GetDBNULL(Model.CreatedAt)),
                                new SqlParameter("@p_POPartID", GetDBNULL(Model.POPartID)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName)),

                                new SqlParameter("@p_IsChildResult", GetDBNULL(Model.IsChildResult)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULL(Model.AccessPoint)),
                            };

                    ds = db.ExecuteDataSet("GetPurchaseOrder", par);
                    query = ConvertToList<PurchaseOrder_VM>(ds.Tables[0]);

                    if (Model.IsChildResult == true)
                    {
                        //query[0].POItemList = ConvertToList<POItem_VM>(ds.Tables[1]);
                        query[0].POItem_TableTypeList2 = ConvertToList<POItem_TableType_VM2>(ds.Tables[1]);
                        query[0].POPartList = ConvertToList<POPart_VM>(ds.Tables[2]);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public List<POPart_VM> GetDataPOPart(PurchaseOrder_VM Model)
        {
            var query = new List<POPart_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),
                                new SqlParameter("@Flag", GetDBNULL(Model.IsActive)),
                                
                            };

                    ds = db.ExecuteDataSet("GetPurchaseOrderPart", par);
                    query = ConvertToList<POPart_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_GetDataPOPart Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(PurchaseOrder_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_POItem = new DataTable();
                    if (Model.POItem_TableTypeList != null && Model.POItem_TableTypeList.Count > 0)
                        dt_POItem = ConvertToDatatable(Model.POItem_TableTypeList);
                    else
                        dt_POItem = ConvertToDatatable(new List<POItem_TableType_VM>());

                    var dt_POPart = new DataTable();
                    if (Model.POPart_TableTypeList != null && Model.POPart_TableTypeList.Count > 0)
                        dt_POPart = ConvertToDatatable(Model.POPart_TableTypeList);
                    else
                        dt_POPart = ConvertToDatatable(new List<POPart_TableType_VM>());

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),
                                new SqlParameter("@p_PONumber", GetDBNULLString(Model.PONumber)),
                                new SqlParameter("@p_POItemID", GetDBNULL(Model.POItemID)),
                                new SqlParameter("@p_PORecDate", GetDBNULL(Model.PORecDate)),
                                new SqlParameter("@p_POEstShipDate", GetDBNULL(Model.POEstShipDate)),
                                new SqlParameter("@p_POActShipDate", GetDBNULL(Model.POActShipDate)),
                                new SqlParameter("@p_POCost", GetDBNULL(Model.POCost)),
                                new SqlParameter("@p_POPrice", GetDBNULL(Model.POPrice)),
                                new SqlParameter("@p_POCompleted", GetDBNULL(Model.POCompleted)),
                                new SqlParameter("@p_CreatedAt", GetDBNULL(Model.CreatedAt)),
                                new SqlParameter("@p_POPartID", GetDBNULL(Model.POPartID)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName)),
                                new SqlParameter("@p_POItem", dt_POItem) { TypeName = "POItem_TableType" },
                                new SqlParameter("@p_POPart", dt_POPart) { TypeName = "POPart_TableType" },

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("AddPurchaseOrder", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(PurchaseOrder_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_POItem = new DataTable();
                    if (Model.POItem_TableTypeList != null && Model.POItem_TableTypeList.Count > 0)
                        dt_POItem = ConvertToDatatable(Model.POItem_TableTypeList);
                    else
                        dt_POItem = ConvertToDatatable(new List<POItem_TableType_VM>());

                    var dt_POPart = new DataTable();
                    if (Model.POPart_TableTypeList != null && Model.POPart_TableTypeList.Count > 0)
                        dt_POPart = ConvertToDatatable(Model.POPart_TableTypeList);
                    else
                        dt_POPart = ConvertToDatatable(new List<POPart_TableType_VM>());

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),
                                new SqlParameter("@p_PONumber", GetDBNULLString(Model.PONumber)),
                                new SqlParameter("@p_POItemID", GetDBNULL(Model.POItemID)),
                                new SqlParameter("@p_PORecDate", GetDBNULL(Model.PORecDate)),
                                new SqlParameter("@p_POEstShipDate", GetDBNULL(Model.POEstShipDate)),
                                new SqlParameter("@p_POActShipDate", GetDBNULL(Model.POActShipDate)),
                                new SqlParameter("@p_POCost", GetDBNULL(Model.POCost)),
                                new SqlParameter("@p_POPrice", GetDBNULL(Model.POPrice)),
                                new SqlParameter("@p_POCompleted", GetDBNULL(Model.POCompleted)),
                                new SqlParameter("@p_CreatedAt", GetDBNULL(Model.CreatedAt)),
                                new SqlParameter("@p_POPartID", GetDBNULL(Model.POPartID)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID)),
                                new SqlParameter("@p_CustomerName", GetDBNULLString(Model.CustomerName)),

                                new SqlParameter("@p_POItem", dt_POItem) { TypeName = "POItem_TableType" },
                                new SqlParameter("@p_POPart", dt_POPart) { TypeName = "POPart_TableType" },

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdatePurchaseOrder", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(PurchaseOrder_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                    };

                    result = db.ExecuteNonQueryRollBack("DeletePurchaseOrder", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }

        public int AddEditPart(PurchaseOrderPart_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_POPart = new DataTable();
                    if (Model.POPart_TableTypeList != null && Model.POPart_TableTypeList.Count > 0)
                        dt_POPart = ConvertToDatatable(Model.POPart_TableTypeList);
                    else
                        dt_POPart = ConvertToDatatable(new List<POPart_TableType_VM>());

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_POID", GetDBNULL(Model.POID)),

                                new SqlParameter("@p_POPart", dt_POPart) { TypeName = "POPart_TableType" },

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("AddPurchaseOrderPart", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("PurchaseOrderRepository_AddPart Error: ", ex);
                throw;
            }

            return result;
        }
    }

    public interface IPurchaseOrderRepository : IBaseInterFace
    {
        List<PurchaseOrder_VM> GetData(PurchaseOrder_VM Model);
        List<POPart_VM> GetDataPOPart(PurchaseOrder_VM Model);

        int Add(PurchaseOrder_VM Model);
        int AddEditPart(PurchaseOrderPart_VM Model);
        int Update(PurchaseOrder_VM Model);
        int Delete(PurchaseOrder_VM Model);
    }
};