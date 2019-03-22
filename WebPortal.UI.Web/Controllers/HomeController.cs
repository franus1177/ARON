using System;
using System.Collections;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;
using WebPortal.UI.Web.GlobalResource;

namespace WebPortal.UI.Web.Controllers
{
    public class HomeController : BaseController
    {
        private IBaseDashboardRepository _DashboardRepo;

        public HomeController(IBaseDashboardRepository DashboardRepo)
        {
            _DashboardRepo = DashboardRepo;
        }
        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                ViewBag.UserLoginInfo = User_LoginInfo["UserModules"];

                if (User_LoginInfo != null)
                {
                    ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                    int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                    ViewBag.screenID = screenID;
                    if (!(CheckAccess(screenID, "Dashboard")))
                    {
                        return RedirectOnAccess();
                    }
                }
            }
            else
            {
                return RedirectOnAccess();
            }

            return CheckSession(View());
        }

        public JsonResult GetAccessDetails()
        {
            List<LoginDetails_VM> vm = new List<LoginDetails_VM>();

            try
            {
                vm = new UserRepository().GetAccessDetails(new LoginDetails_VM() { EndUserID = UserID });

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new JsonResponse("Error", ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }
        public ActionResult AccessDenied(int? id)
        {
            if (id == 1)
            {
                ViewBag.AccessMessage = Resource.PermissionMessage;// "You don't have permission to access this screen!";
            }
            return CheckSession(View());
        }
        public JsonResult GetBaseDashboardCustomerList(BaseDashboard_VM Model)
        {
            try
            {
                GetUserInfo(Model);
                var data = _DashboardRepo.GetBaseDashboardCustomerList(Model);
                return Json(new JsonResponse("Success", successMessage, data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("HomeController_GetBaseDashboardCustomerList: ", ex);
                if (ex.InnerException != null)
                {
                    return Json(new JsonResponse("Error", ex.InnerException.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(new JsonResponse("Error", ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                }
            }
        }
    }
};