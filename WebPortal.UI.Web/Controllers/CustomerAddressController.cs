using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;
namespace WebPortal.UI.Web.Controllers
{
    public class CustomerAddressController : BaseController
    {
        private ICustomerAddressRepository _CustomerAddressRepo;

        public CustomerAddressController(ICustomerAddressRepository CustomerAddressRepo)
        {
            _CustomerAddressRepo = CustomerAddressRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Customer")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();

            return CheckSession(View());
        }

        public JsonResult GetData(CustomerAddress_VM Model)
        {
            try
            {
                List<CustomerAddress_VM> data = _CustomerAddressRepo.GetData(Model);
                return GetDataResponse(data);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public PartialViewResult _partialAddUpdate()
        {
            return PartialView("_partialAddressAddUpdate");
        }

        [HttpPost]
        public JsonResult AddUpdateData(CustomerAddress_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);

                    //if (Model.CustomerID == 0 || Model.CustomerID == null)
                    //{
                    //    var data = _CustomerAddressRepo.Add(Model);
                    //    return GetAddEditDeleteResponse(data, "Add");
                    //}
                    //else 
                    if (Model.CustomerID != 0 && Model.CustomerID != null)
                    {
                        var data = _CustomerAddressRepo.Update(Model);
                        if(Model.AddressTypeOld == null || Model.AddressTypeOld == "")
                            return GetAddEditDeleteResponse(data, "Add");
                        else
                            return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("CustomerAddressController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(CustomerAddress_VM Model)
        {
            if (CheckAccessDelete(Model.CurrentScreenID, "Customer"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.CustomerID != 0 && Model.CustomerID != null)
                    {
                        var data = _CustomerAddressRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("CustomerAddressController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }

            return GetModelStateIsValidException(ViewData);
        }
    }
};
