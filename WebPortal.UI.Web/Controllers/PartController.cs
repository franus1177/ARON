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
    public class PartController : BaseController
    {
        private IPartRepository _PartRepo;

        public PartController(IPartRepository PartRepo)
        {
            _PartRepo = PartRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Part")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();
            return CheckSession(View());
        }

        public JsonResult GetData(Part_VM Model)
        {
            try
            {
                List<Part_VM> vm = _PartRepo.GetData(Model);
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
        public JsonResult AddUpdateData(Part_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.PartID == 0 || Model.PartID == null)
                    {
                        var data = _PartRepo.Add(Model);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.PartID > 0)
                    {
                        var data = _PartRepo.Update(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("PartController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(Part_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Part"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.PartID > 0 && Model.PartID != null)
                    {
                        var data = _PartRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("PartController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }
    }
};