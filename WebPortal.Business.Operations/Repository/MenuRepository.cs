using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Operations.Repository
{
    public class MenuRepository : BaseRepository
    {
        public IEnumerable<SelectListItem> GetMenuDDL(string ModuleCode)
        {
            IEnumerable<SelectListItem> items = new List<SelectListItem>();

            try
            {
                List<Menu_VM> query = ConnectGetDataProcedure(new Menu_VM() { MenuCode = "", MenuName = "", IsActive = true, ModuleCode = ModuleCode });

                items = query.OrderBy(x => x.Sequence).Select(x => new SelectListItem() { Text = x.MenuName, Value = x.MenuCode, Selected = false }).ToList();

                return items;
            }
            catch (Exception ex)
            {
                logger.Error("Repostory_GetOpportunityTypeDDL", ex);
            }

            return items;
        }
        private List<Menu_VM> ConnectGetDataProcedure(Menu_VM VM)
        {
            List<Menu_VM> query = new List<Menu_VM>();

            using (var db = new WebPortalEntities())
            {
                query = db.Database.SqlQuery<Menu_VM>("exec GetMenu @p_MenuCode,@p_MenuName,@p_Sequence, @p_ParentMenuCode, @p_ModuleCode",
                   new SqlParameter[] {
                            new SqlParameter("p_MenuCode", GetDBNULLString(VM.MenuCode)),
                            new SqlParameter("p_MenuName", GetDBNULLString(VM.MenuName)),
                            new SqlParameter("p_Sequence", GetDBNULL(VM.Sequence,true)),
                            new SqlParameter("p_ParentMenuCode", GetDBNULL(VM.ParentMenuCode)),
                            new SqlParameter("p_ModuleCode", GetDBNULLString(VM.ModuleCode)),
                        }).ToList();
            }

            return query;
        }
    }
}
