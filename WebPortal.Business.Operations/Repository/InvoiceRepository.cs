using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class InvoiceRepository : BaseRepository, IInvoiceRepository
    {
        public List<Invoice_VM> GetData(Invoice_VM Model)
        {
            List<Invoice_VM> query = new List<Invoice_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_InvoiceID", GetDBNULL(Model.InvoiceID, true)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID, true)),
                                new SqlParameter("@p_OrderDate", GetDBNULL(Model.OrderDate)),
                                new SqlParameter("@p_ExpectedDeliveryDate", GetDBNULL(Model.ExpectedDeliveryDate)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID,true)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID,true)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID,true)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    ds = db.ExecuteDataSet("GetInvoice", par);
                    query = ConvertToList<Invoice_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(Invoice_VM Model)
        {
            int result = 0;

            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_InvoiceID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID, true)),
                                new SqlParameter("@p_OrderDate", GetDBNULL(Model.OrderDate)),
                                new SqlParameter("@p_ExpectedDeliveryDate", GetDBNULL(Model.ExpectedDeliveryDate)),

                                new SqlParameter("@p_InvoiceName", GetDBNULL(Model.InvoiceName, true)),
                                new SqlParameter("@p_Frame", GetDBNULL(Model.Frame, true)),
                                new SqlParameter("@p_Lens", GetDBNULL(Model.Lens, true)),
                                new SqlParameter("@p_FrameAmount", GetDBNULL(Model.FrameAmount, true)),
                                new SqlParameter("@p_LensAmount", GetDBNULL(Model.LensAmount, true)),
                                new SqlParameter("@p_RefractionBy", GetDBNULL(Model.RefractionBy, true)),
                                new SqlParameter("@p_Remarks", GetDBNULLString(Model.Remarks)),

                                new SqlParameter("@p_RESPH", GetDBNULLString(Model.RESPH)),
                                new SqlParameter("@p_RECYL", GetDBNULLString(Model.RECYL)),
                                new SqlParameter("@p_REAXIS", GetDBNULLString(Model.REAXIS)),
                                new SqlParameter("@p_REVA", GetDBNULLString(Model.REVA)),
                                new SqlParameter("@p_READD", GetDBNULLString(Model.READD)),
                                new SqlParameter("@p_LESPH", GetDBNULLString(Model.LESPH)),
                                new SqlParameter("@p_LECYL", GetDBNULLString(Model.LECYL)),

                                new SqlParameter("@p_LEAXIS", GetDBNULLString(Model.LEAXIS)),
                                new SqlParameter("@p_LEVA", GetDBNULLString(Model.LEVA)),
                                new SqlParameter("@p_LEADD", GetDBNULLString(Model.LEADD)),

                                new SqlParameter("@p_AdvanceAmount", GetDBNULL(Model.AdvanceAmount)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    result = db.ExecuteNonQueryRollBack("AddInvoice", par);

                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_Add: ", ex);
                throw;
            }

            return result;
        }

        public int Update(Invoice_VM Model)
        {
            int result = 0;

            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_InvoiceID", GetDBNULL(Model.InvoiceID, true)),
                                new SqlParameter("@p_CustomerID", GetDBNULL(Model.CustomerID, true)),
                                new SqlParameter("@p_OrderDate", GetDBNULL(Model.OrderDate)),
                                new SqlParameter("@p_ExpectedDeliveryDate", GetDBNULL(Model.ExpectedDeliveryDate)),

                                new SqlParameter("@p_InvoiceName", GetDBNULL(Model.InvoiceName, true)),
                                new SqlParameter("@p_Frame", GetDBNULL(Model.Frame, true)),
                                new SqlParameter("@p_Lens", GetDBNULL(Model.Lens, true)),
                                new SqlParameter("@p_FrameAmount", GetDBNULL(Model.FrameAmount, true)),
                                new SqlParameter("@p_LensAmount", GetDBNULL(Model.LensAmount, true)),
                                new SqlParameter("@p_RefractionBy", GetDBNULL(Model.RefractionBy, true)),
                                new SqlParameter("@p_Remarks", GetDBNULLString(Model.Remarks)),

                                new SqlParameter("@p_RESPH", GetDBNULLString(Model.RESPH)),
                                new SqlParameter("@p_RECYL", GetDBNULLString(Model.RECYL)),
                                new SqlParameter("@p_REAXIS", GetDBNULLString(Model.REAXIS)),
                                new SqlParameter("@p_REVA", GetDBNULLString(Model.REVA)),
                                new SqlParameter("@p_READD", GetDBNULLString(Model.READD)),
                                new SqlParameter("@p_LESPH", GetDBNULLString(Model.LESPH)),
                                new SqlParameter("@p_LECYL", GetDBNULLString(Model.LECYL)),

                                new SqlParameter("@p_LEAXIS", GetDBNULLString(Model.LEAXIS)),
                                new SqlParameter("@p_LEVA", GetDBNULLString(Model.LEVA)),
                                new SqlParameter("@p_LEADD", GetDBNULLString(Model.LEADD)),

                                new SqlParameter("@p_AdvanceAmount", GetDBNULL(Model.AdvanceAmount)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateInvoice", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_Add: ", ex);
                throw;
            }

            return result;
        }


        public int Delete(Invoice_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_InvoiceID", GetDBNULL(Model.InvoiceID, true)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("DeleteInvoice", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("InvoiceRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }
    }

    public interface IInvoiceRepository : IBaseInterFace
    {
        List<Invoice_VM> GetData(Invoice_VM Model);
        int Add(Invoice_VM Model);
        int Update(Invoice_VM Model);
        int Delete(Invoice_VM Model);
    }
};