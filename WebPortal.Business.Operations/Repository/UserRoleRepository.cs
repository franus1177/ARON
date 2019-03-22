using AutoMapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.Linq;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Operations.Repository
{
    public class UserRoleRepository : BaseRepository, IUserRoleRepository
    {
        #region Role master
        public bool Add(UserRole_VM Model)
        {
            try
            {
                using (var db = new WebPortalEntities())
                {
                    var returnResult = new ObjectParameter("p_UserRoleID", 0);

                    db.AddUserRole(Model.UserRoleName, Model.CurrentEndUserID, Model.CurrentScreenID, Model.AccessPoint, returnResult);

                    db.SaveChanges();

                    return Convert.ToInt32(returnResult.Value) > 0;
                }
            }
            catch (Exception ex)
            {
                logger.Error("UserRoleRepository_Add: ", ex);
                throw;
            }
        }
        public bool Update(UserRole_VM Model)
        {
            try
            {
                using (var db = new WebPortalEntities())
                {
                    int returnResult = db.UpdateUserRole(Model.UserRoleID, Model.UserRoleName, Model.CurrentEndUserID, Model.CurrentScreenID, Model.AccessPoint);

                    db.SaveChanges();

                    return returnResult > 0;
                }
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
                throw;
            }
        }

        public List<UserRole_VM> GetData(short? Id)
        {
            List<UserRole_VM> RoleModel = new List<UserRole_VM>();

            try
            {
                return RoleModel = ConnectGetDataProcedure(new UserRole_VM() { UserRoleID = Id }).ToList();
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
                throw;
            }
        }

        private List<UserRole_VM> ConnectGetDataProcedure(UserRole_VM VM)
        {
            List<UserRole_VM> query = new List<UserRole_VM>();

            using (var db = new WebPortalEntities())
            {
                var config = new MapperConfiguration(cfg => cfg.CreateMap<GetUserRole_Result, UserRole_VM>());
                var mapper = config.CreateMapper();

                List<GetUserRole_Result> data = db.GetUserRole(VM.UserRoleID, VM.UserRoleName).ToList();
                return mapper.Map<List<GetUserRole_Result>, List<UserRole_VM>>(data, query);
            }
        }
        #endregion

        #region Access permission

        public List<ScreenAccess_VM> GetScreenAccess(ScreenAccess_VM VM)
        {
            List<ScreenAccess_VM> query = new List<ScreenAccess_VM>();

            using (var db = new WebPortalEntities())
            {
                //Get Opportunity Type of string type
                query = db.Database.SqlQuery<ScreenAccess_VM>("exec GetScreenAccess @p_MenuCode,@p_UserRoleID,@p_ModuleCode",
                   new SqlParameter[] {
                            new SqlParameter("p_MenuCode",  GetDBNULLString(VM.MenuCode)),
                            new SqlParameter("p_UserRoleID", GetDBNULL(VM.UserRoleID)),
                            new SqlParameter("p_ModuleCode", GetDBNULL(VM.CurrentModuleCode))
                        }).ToList();
            }
            return query;
        }

        public Accesspermission_Wrapper GetMenuAndScreenData(ScreenAccess_VM Model)
        {
            Accesspermission_Wrapper query = new Accesspermission_Wrapper();

            using (var db = new DBConnection())
            {
                DataSet ds = db.ExecuteDataSet("GetMenuAndScreenData", new SqlParameter[] {
                    new SqlParameter("@pUserRoleID", GetDBNULL(Model.UserRoleID))
                });

                query.MenuList = ConvertToList<MenuScreen_VM>(ds.Tables[0]);
                query.ScreenActionList = ConvertToList<ScreenAction_VM>(ds.Tables[1]);
            }

            return query;
        }

        public List<ScreenAccess_VM> GetScreen(ScreenAccess_VM VM)
        {
            List<ScreenAccess_VM> query = new List<ScreenAccess_VM>();

            using (var db = new WebPortalEntities())
            {
                query = db.Database.SqlQuery<ScreenAccess_VM>("exec GetScreen", new SqlParameter[] { }).ToList();
            }
            return query;
        }

        public int AddScreenUserRole(List<ScreenAccess_VM> Model)
        {
            using (var db = new DBConnection())
            {
                try
                {
                    DataTable dtUserRoleScreen = new DataTable();
                    DataTable dtUserRoleScreenAction = new DataTable();

                    dtUserRoleScreen.Columns.Add(new DataColumn("UserRoleID", Type.GetType("System.Int16")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("ScreenID", Type.GetType("System.Int16")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasInsert", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasUpdate", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasDelete", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasSelect", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasImport", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("HasExport", Type.GetType("System.Boolean")));
                    dtUserRoleScreen.Columns.Add(new DataColumn("UserRoleScreenActions", Type.GetType("System.String")));

                    dtUserRoleScreenAction.Columns.Add(new DataColumn("UserRoleID", Type.GetType("System.Int16")));     //Contains UserRole
                    dtUserRoleScreenAction.Columns.Add(new DataColumn("ScreenID", Type.GetType("System.Int16")));       //Contains ScreenID
                    dtUserRoleScreenAction.Columns.Add(new DataColumn("ActionCode", Type.GetType("System.String")));    //Contains ActionCode Name

                    foreach (ScreenAccess_VM item in Model)
                    {
                        DataRow dr = dtUserRoleScreen.NewRow();

                        dr["UserRoleID"] = (Int16)item.UserRoleID;
                        dr["ScreenID"] = (Int16)item.ScreenID;
                        dr["HasInsert"] = item.HasInsert;
                        dr["HasUpdate"] = item.HasUpdate;
                        dr["HasDelete"] = item.HasDelete;
                        dr["HasSelect"] = item.HasSelect;
                        dr["HasImport"] = item.HasImport;
                        dr["HasExport"] = item.HasExport;

                        if (item.AdditionalAccess != null)
                        {
                            dr["UserRoleScreenActions"] = Convert.ToString(item.AdditionalAccess).TrimStart('[').TrimEnd(']');

                            foreach (string Child in dr["UserRoleScreenActions"].ToString().Split(','))
                            {
                                DataRow drChild = dtUserRoleScreenAction.NewRow();
                                drChild["ActionCode"] = Child.ToString();
                                drChild["UserRoleID"] = (Int16)item.UserRoleID;
                                drChild["ScreenID"] = (Int16)item.ScreenID;

                                dtUserRoleScreenAction.Rows.Add(drChild);
                            }
                        }
                        dtUserRoleScreen.Rows.Add(dr);
                    }

                    dtUserRoleScreen.AcceptChanges();

                    var par = new SqlParameter[] {

                            new SqlParameter("@p_ModuleCode", GetDBNULLString(Model[0].CurrentModuleCode)),
                            new SqlParameter("@p_MenuCode", GetDBNULLString(Model[0].MenuCode)),
                            new SqlParameter("@p_UserRoleID", Model[0].UserRoleID),     //For this User role
                            new SqlParameter("@p_UserRoleScreen_TableType",dtUserRoleScreen) { TypeName = "UserRoleScreen_TableType" },
                            new SqlParameter("@p_UserRoleScreenAction_TableType",dtUserRoleScreenAction) { TypeName = "UserRoleScreenAction_TableType" },
                            new SqlParameter("@p_UserID", Model[0].CurrentEndUserID),
                            new SqlParameter("@p_CurrentUserRoleID", Model[0].CurrentUserRoleID),
                            new SqlParameter("@p_AccessPoint", Model[0].AccessPoint),
                            new SqlParameter("@p_ScreenID", Model[0].CurrentScreenID)
                        };

                    int result = db.ExecuteNonQueryRollBack("AddUserRoleScreen", par);

                    return result;
                }
                catch (Exception ex)
                {
                    logger.Error("UserRoleRepository_AddScreenUserRole", ex);
                    throw;
                }
            }
        }

        #endregion
    }

    public interface IUserRoleRepository
    {
        Boolean Add(UserRole_VM Model);
        Boolean Update(UserRole_VM Model);
        List<UserRole_VM> GetData(short? Id);

        List<ScreenAccess_VM> GetScreenAccess(ScreenAccess_VM VM);
        int AddScreenUserRole(List<ScreenAccess_VM> Model);
        Accesspermission_Wrapper GetMenuAndScreenData(ScreenAccess_VM Model);
    }
};