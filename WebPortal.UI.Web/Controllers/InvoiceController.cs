using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.UI.Web.Controllers
{
    public class InvoiceController : BaseController
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
                if (!(CheckAccess(screenID, "Invoice")))
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

                if (!CheckAccess(screenID, "Invoice"))
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

        //public JsonResult GetData(Customer_VM Model)
        //{
        //    try
        //    {
        //        if (CheckUserHasValue(Model))
        //            GetUserInfo(Model);

        //        ICustomerRepository _CustomerRepo = new CustomerRepository();

        //        List<Customer_VM> vm = _CustomerRepo.GetData(Model);

        //        return GetDataResponse(vm);
        //    }
        //    catch (Exception ex)
        //    {
        //        return GetDataResponseException(ex);
        //    }
        //}

        private IInvoiceRepository _InvoiceRepo;

        public InvoiceController(IInvoiceRepository InvoiceRepo)
        {
            _InvoiceRepo = InvoiceRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Invoice")))
                    return RedirectOnAccess();
            }
            else
                return RedirectOnAccess();
            return CheckSession(View("List"));
        }

        public JsonResult GetData(Invoice_VM Model)
        {
            try
            {
                List<Invoice_VM> vm = _InvoiceRepo.GetData(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public PartialViewResult _partialAddUpdate()
        {
            return PartialView("~/Views/Invoice/_partialAddUpdate.cshtml");
        }

        [HttpPost]
        public JsonResult AddUpdateData(InvoiceCustomerWrapper_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    IeCustomerRepository ff = new eCustomerRepository();

                    GetUserInfo(Model.Customer);
                    GetUserInfo(Model.Invoice);
                    if (Model.Customer.CustomerID == null)
                    {
                        short result = Convert.ToInt16(ff.Add(Model.Customer));
                        Model.Invoice.CustomerID = result;
                    }
                    else
                    {
                        ff.Update(Model.Customer);
                    }

                    if (Model.Invoice.InvoiceID == 0 || Model.Invoice.InvoiceID == null)
                    {
                        var data = _InvoiceRepo.Add(Model.Invoice);
                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.Invoice.InvoiceID > 0)
                    {
                        var data = _InvoiceRepo.Update(Model.Invoice);
                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("InvoiceController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(Invoice_VM Model)
        {
            if (CheckAccess(Model.CurrentScreenID, "Invoice"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.InvoiceID > 0 && Model.InvoiceID != null)
                    {
                        var data = _InvoiceRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("InvoiceController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }
    }
};