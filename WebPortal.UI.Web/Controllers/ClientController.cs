using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.UI.Web.Controllers
{
    public class ClientController : BaseController
    {
        // GET: Client
        public ActionResult List(string GlobalID, string LocationID)
        {
            ViewBag.LocationID = 0;

            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Customer")))
                {
                    return RedirectOnAccess();
                }
            }
            else if (GlobalID != null)
            {
                ViewBag.EncryptScreenID = GlobalID;

                if (LocationID != null && LocationID != "")
                {
                    ViewBag.LocationID = Convert.ToInt32(LocationID);
                }

                int screenID = Convert.ToInt16(Decrypt(GlobalID));
                ViewBag.screenID = screenID;

                if (!CheckAccess(screenID, "Customer"))
                {
                    return RedirectOnAccess();
                }
            }
            else
            {
                return RedirectOnAccess();
            }

            return CheckSession(View("List"));
        }

        public JsonResult GetData(Customer_VM Model)
        {
            try
            {
                if (CheckUserHasValue(Model))
                    GetUserInfo(Model);

                ICustomerRepository _CustomerRepo = new CustomerRepository();

                List<Customer_VM> vm = _CustomerRepo.GetData(Model);

                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public PartialViewResult _partialAddUpdate()
        {
            return PartialView("~/Views/Client/_partialAddUpdate.cshtml");
        }
    }
};