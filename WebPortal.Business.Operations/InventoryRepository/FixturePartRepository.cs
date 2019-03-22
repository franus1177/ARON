using System;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Operations.Repository;
using WebPortal.Business.Entities.Utility;
using System.Data;

namespace WebPortal.Business.Operations.InventoryRepository
{
    public class FixturePartRepository : BaseRepository, IFixturePartRepository
    {
        public List<FixturePart_VM> GetData(FixturePart_VM Model)
        {
            var query = new List<FixturePart_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = db.ExecuteDataSet("GetFixturePart", new SqlParameter[] {
                                new SqlParameter("@p_FixturePartID", GetDBNULL(Model.FixturePartID)),
                                new SqlParameter("@p_FixtureID", GetDBNULLString(Model.FixtureID)),
                                new SqlParameter("@p_PartID", GetDBNULLString(Model.PartID)),
                                new SqlParameter("@p_Quantity", GetDBNULL(Model.Quantity))
                            });

                    query = ConvertToList<FixturePart_VM>(ds.Tables[0]);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixturePartRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(FixturePart_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var output = new SqlParameter("@p_FixturePartID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixtureID", GetDBNULL(Model.FixtureID)),
                                new SqlParameter("@p_PartID", GetDBNULL(Model.PartID)),
                                new SqlParameter("@p_Quantity", GetDBNULL(Model.Quantity)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint)),
                                output
                            };

                    db.ExecuteNonQueryRollBack("AddFixturePart", par);
                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixturePartRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(FixturePart_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixturePartID", GetDBNULL(Model.FixturePartID)),
                                new SqlParameter("@p_FixtureID", GetDBNULL(Model.FixtureID)),
                                new SqlParameter("@p_PartID", GetDBNULL(Model.PartID)),
                                new SqlParameter("@p_Quantity", GetDBNULL(Model.Quantity)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    db.ExecuteNonQueryRollBack("UpdateFixturePart", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixturePartRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }

        public int Delete(FixturePart_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixturePartID", GetDBNULL(Model.FixturePartID)),

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    db.ExecuteNonQueryRollBack("DeleteFixturePart", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixturePartRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }
    }

    public interface IFixturePartRepository : IBaseInterFace
    {
        List<FixturePart_VM> GetData(FixturePart_VM Model);
        int Add(FixturePart_VM Model);
        int Update(FixturePart_VM Model);
        int Delete(FixturePart_VM Model);
    }
};