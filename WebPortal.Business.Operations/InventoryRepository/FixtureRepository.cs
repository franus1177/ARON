using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.Business.Operations.InventoryRepository
{
    public class FixtureRepository : BaseRepository, IFixtureRepository
    {
        public List<Fixture_VM> GetData(Fixture_VM Model)
        {
            var query = new List<Fixture_VM>();

            try
            {
                using (var db = new DBConnection())
                {
                    var ds = new DataSet();
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixtureID", GetDBNULL(Model.FixtureID)),
                                new SqlParameter("@p_FixtureCode", GetDBNULLString(Model.FixtureCode)),
                                new SqlParameter("@p_FixtureName", GetDBNULLString(Model.FixtureName)),
                                new SqlParameter("@p_FixtureCost", GetDBNULL(Model.FixtureCost)),
                                new SqlParameter("@p_IsChildResult", GetDBNULL(Model.IsChildResult))
                            };

                    ds = db.ExecuteDataSet("GetFixture", par);
                    query = ConvertToList<Fixture_VM>(ds.Tables[0]);

                    if (Model.IsChildResult == true)
                    {
                        query[0].FixturePartList = ConvertToList<FixturePart_VM>(ds.Tables[1]);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixtureRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(Fixture_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_FixturePart = new DataTable();
                    if (Model.FixturePart_TableTypeList != null && Model.FixturePart_TableTypeList.Count > 0)
                        dt_FixturePart = ConvertToDatatable(Model.FixturePart_TableTypeList);
                    else
                        dt_FixturePart = ConvertToDatatable(new List<FixturePart_TableType_VM>());

                    var output = new SqlParameter("@p_FixtureID", 0) { Direction = ParameterDirection.Output };

                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixtureName", GetDBNULL(Model.FixtureName)),
                                new SqlParameter("@p_FixtureCost", GetDBNULL(Model.FixtureCost)),
                                new SqlParameter("@p_FixtureCode", GetDBNULLString(Model.FixtureCode)),

                                new SqlParameter("@p_FixturePart", dt_FixturePart) { TypeName = "FixturePart_TableType" },


                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULL(Model.AccessPoint)),
                                output
                            };

                    db.ExecuteNonQueryRollBack("AddFixture", par);
                    result = Convert.ToInt32(output.Value);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixtureRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }

        public int Update(Fixture_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var dt_FixturePart = new DataTable();
                    if (Model.FixturePart_TableTypeList != null && Model.FixturePart_TableTypeList.Count > 0)
                        dt_FixturePart = ConvertToDatatable(Model.FixturePart_TableTypeList);
                    else
                        dt_FixturePart = ConvertToDatatable(new List<FixturePart_TableType_VM>());
                    var par = new SqlParameter[] {
                                new SqlParameter("@p_FixtureID", GetDBNULL(Model.FixtureID)),
                                new SqlParameter("@p_FixtureName", GetDBNULLString(Model.FixtureName)),
                                new SqlParameter("@p_FixtureCost", GetDBNULL(Model.FixtureCost)),
                                new SqlParameter("@p_FixtureCode", GetDBNULLString(Model.FixtureCode)),

                                new SqlParameter("@p_FixturePart", dt_FixturePart) { TypeName = "FixturePart_TableType" },

                                new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                            };

                    result = db.ExecuteNonQueryRollBack("UpdateFixture", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixtureRepository_Update Error: ", ex);
                throw;
            }

            return result;
        }


        public int Delete(Fixture_VM Model)
        {
            int result = 0;
            try
            {
                using (var db = new DBConnection())
                {
                    var par = new SqlParameter[] {
                                                        new SqlParameter("@p_FixtureID", GetDBNULL(Model.FixtureID)),
                                                        new SqlParameter("@p_EndUserID", GetDBNULL(Model.CurrentEndUserID)),
                                                        new SqlParameter("@p_UserRoleID", GetDBNULL(Model.CurrentUserRoleID)),
                                                        new SqlParameter("@p_ScreenID", GetDBNULL(Model.CurrentScreenID)),
                                                        new SqlParameter("@p_AccessPoint", GetDBNULLString(Model.AccessPoint))
                                                   };

                    result = db.ExecuteNonQueryRollBack("DeleteFixture", par);
                }
            }
            catch (Exception ex)
            {
                logger.Error("FixtureRepository_Delete Error: ", ex);
                throw;
            }
            return result;
        }
    }

    public interface IFixtureRepository : IBaseInterFace
    {
        List<Fixture_VM> GetData(Fixture_VM Model);
        int Add(Fixture_VM Model);
        int Update(Fixture_VM Model);
        int Delete(Fixture_VM Model);
    }
};