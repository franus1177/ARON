using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebPortal.Business.Entities.VM;
using WebPortal.Business.Operations.Repository;
using WebPortal.UI.Web.Controllers;

namespace WebPortal.UI.Web.Areas.Safety.Controllers
{
    public class AuditLogController : BaseController
    {
        private IAuditLogRepository _AuditLogsReportRepo;

        public AuditLogController(IAuditLogRepository AuditLogReportRepo)
        {
            _AuditLogsReportRepo = AuditLogReportRepo;
        }

        // GET: Safety/AuditLogReport
        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Audit Log")))
                    return RedirectOnAccess();
            }
            else
            {
                return RedirectOnAccess();
            }
            return CheckSession(View());
        }

        public JsonResult GetDataGrid(AuditLogReport_VM Model)
        {
            try
            {
                GetUserInfo(Model);
                List<AuditLogReport_VM> vm = _AuditLogsReportRepo.GetAuditLogReportData(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public PartialViewResult _partialViewEntityDetails()
        {
            return PartialView("_partialViewEntityDetails");
        }

        public JsonResult GetEntityDetails(AuditLogReport_VM Model)
        {
            try
            {
                GetUserInfo(Model);
                List<AuditLogReport_VM> vm = _AuditLogsReportRepo.GetEntityDetails(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }
    }
};