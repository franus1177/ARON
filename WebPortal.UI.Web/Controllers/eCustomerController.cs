using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.UI.Web.Controllers;

namespace WebPortal.UI.Web.Work.Controllers
{
    public class eCustomerController : BaseController
    {
        private IeCustomerRepository _eCustomerRepo;

        public eCustomerController(IeCustomerRepository eCustomerRepo)
        {
            _eCustomerRepo = eCustomerRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Invoice Customer")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();
            return CheckSession(View());
        }

        public JsonResult GetDataDDL(eCustomer_VM Model)
        {
            try
            {
                List<eCustomer_VM> vm = _eCustomerRepo.GeteCustomerDDL(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public JsonResult GetData(eCustomer_VM Model)
        {
            try
            {
                List<eCustomer_VM> vm = _eCustomerRepo.GetData(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public PartialViewResult _partialAddUpdate()
        {
            return PartialView("_partialAddUpdate");
        }

        [HttpPost]
        public JsonResult AddUpdateData(eCustomer_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.CustomerID == 0 || Model.CustomerID == null)
                    {
                        var data = _eCustomerRepo.Add(Model);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.CustomerID > 0)
                    {
                        var data = _eCustomerRepo.Update(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("eCustomerController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(eCustomer_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Invoice Customer"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.CustomerID > 0 && Model.CustomerID != null)
                    {
                        var data = _eCustomerRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("eCustomerController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);

        }
    }
};
