using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using WebPortal.UI.Web.Controllers;
using WebPortal.Business.Operations.InventoryRepository;
using WebPortal.Business.Entities.InventoryModels;

namespace WebPortal.UI.Web.Work.Controllers
{
    public class FixturePartController : BaseController
    {
        private IFixturePartRepository _FixturePartRepo;

        public FixturePartController(IFixturePartRepository FixturePartRepo)
        {
            _FixturePartRepo = FixturePartRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Fixture Part")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();

            return CheckSession(View());
        }

        public JsonResult GetData(FixturePart_VM Model)
        {
            try
            {
                List<FixturePart_VM> vm = _FixturePartRepo.GetData(Model);
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
        public JsonResult AddUpdateData(FixturePart_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.FixturePartID == 0 || Model.FixturePartID == null)
                    {
                        var data = _FixturePartRepo.Add(Model);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.FixturePartID > 0)
                    {
                        var data = _FixturePartRepo.Update(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("FixturePartController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(FixturePart_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Fixture Part"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.FixturePartID > 0 && Model.FixturePartID != null)
                    {
                        var data = _FixturePartRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("FixturePartController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }
    }
};