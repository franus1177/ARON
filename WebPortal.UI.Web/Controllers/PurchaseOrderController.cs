using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Operations.InventoryRepository;
using WebPortal.UI.Web.Controllers;

namespace WebPortal.UI.Web.Work.Controllers
{
    public class PurchaseOrderController : BaseController
    {
        private IPurchaseOrderRepository _PurchaseOrderRepo;

        public PurchaseOrderController(IPurchaseOrderRepository PurchaseOrderRepo)
        {
            _PurchaseOrderRepo = PurchaseOrderRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Fixture Purchase Order")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();
            return CheckSession(View());
        }

        public JsonResult GetData(PurchaseOrder_VM Model)
        {
            try
            {
                var vm = _PurchaseOrderRepo.GetData(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public JsonResult GetDataPOPart(PurchaseOrder_VM Model)
        {
            try
            {
                List<POPart_VM> vm = _PurchaseOrderRepo.GetDataPOPart(Model);
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
        public JsonResult AddUpdateData(PurchaseOrder_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.POID == 0 || Model.POID == null)
                    {
                        var data = _PurchaseOrderRepo.Add(Model);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.POID != 0 && Model.POID != null)
                    {
                        var data = _PurchaseOrderRepo.Update(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("PurchaseOrderController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }

            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult AddUpdateDataPart(PurchaseOrderPart_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.POID > 0)
                    {
                        var data = _PurchaseOrderRepo.AddEditPart(Model);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("PurchaseOrderController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }

            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(PurchaseOrder_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Fixture Purchase Order"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.POID != 0 && Model.POID != null)
                    {
                        var data = _PurchaseOrderRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("PurchaseOrderController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }

            return GetModelStateIsValidException(ViewData);
        }
    }
};