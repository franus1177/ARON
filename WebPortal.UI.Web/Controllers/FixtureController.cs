using System;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Web;
using System.Web.Mvc;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
using WebPortal.Business.Operations.InventoryRepository;
using WebPortal.UI.Web.Controllers;

namespace WebPortal.UI.Web.Work.Controllers
{
    public class FixtureController : BaseController
    {
        private IFixtureRepository _FixtureRepo;

        public FixtureController(IFixtureRepository FixtureRepo)
        {
            _FixtureRepo = FixtureRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Fixture")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();
            return CheckSession(View());
        }

        public JsonResult GetData(Fixture_VM Model)
        {
            try
            {
                var vm = _FixtureRepo.GetData(Model);
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
        public JsonResult AddUpdateData(Fixture_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.FixtureID == 0 || Model.FixtureID == null)
                    {
                        var data = _FixtureRepo.Add(Model);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.FixtureID > 0)
                    {
                        var data = _FixtureRepo.Update(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("FixtureController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(Fixture_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Fixture"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.FixtureID > 0 && Model.FixtureID != null)
                    {
                        var data = _FixtureRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("FixtureController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);

        }

    }
};
