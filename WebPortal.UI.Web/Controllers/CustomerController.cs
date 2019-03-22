using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;
using WebPortal.Common.Utilities.Global;

namespace WebPortal.UI.Web.Controllers
{
    public class CustomerController : BaseController
    {

        private ICustomerRepository _CustomerRepo;

        public CustomerController(ICustomerRepository CustomerRepo)
        {
            _CustomerRepo = CustomerRepo;
        }

        #region customer
        public ActionResult Customer(string GlobalID, string LocationID)
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

            return CheckSession(View("index"));
        }

        public JsonResult GetData(Customer_VM Model)
        {
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                List<Customer_VM> vm = _CustomerRepo.GetData(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public JsonResult GetDataDDL(CustomerDDL_VM Model)
        {
            try
            {
                List<CustomerDDL_VM> vm = _CustomerRepo.GetDataDDL(Model);
                return GetDataResponse(vm);
            }
            catch (Exception ex)
            {
                return GetDataResponseException(ex);
            }
        }

        public JsonResult MEIGetData(Customer_VM Model)
        {
            try
            {
                Model.CurrentUTCOffset = Convert.ToDecimal(4.5);
                Model.CurrentEndUserID = 1;
                Model.CurrentUserRoleID = 1;
                //Model.AccessPoint = "102.120.36.25";
                Model.AccessPoint = GetIpAddress();

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
            return PartialView("_partialAddUpdate");
        }

        public PartialViewResult _partialLocationSorting()
        {
            return PartialView("_partialLocationSorting");
        }

        [HttpPost]
        public ActionResult AddUpdateData2(HttpPostedFileBase postedFile)
        {
            return View();
        }

        [HttpPost]
        public JsonResult AddUpdateData()
        {
            var ModelJson = Request.Form["Model"];

            Customer_VM Model = (Customer_VM)JsonConvert.DeserializeObject(ModelJson, (typeof(Customer_VM)));

            if (ModelState.IsValid && Model != null)
            {
                //  Get all files from Request object  
                HttpFileCollectionBase files = Request.Files;
                FolderFile_VM model = new FolderFile_VM();
                model.ObjectType = "Customer";
                string filePath = null;
                filePath = Path.Combine(Server.MapPath("~/" + WebConfigurationManager.AppSettings["CustomerLogo"]));
                FolderFile_VM vm = new Common.Utilities.Global.FolderFile_VM();

                try
                {
                    GetUserInfo(Model);
                    var data = 0;
                    if (Model.CustomerID == 0 || Model.CustomerID == null)
                    {
                        data = _CustomerRepo.Add(Model);
                        model.ObjectInstanceID = data;

                        for (int i = 0; i < files.Count; i++)
                        {
                            HttpPostedFileBase file = files[i];
                            model.FileSize = file.ContentLength;
                            vm = new FileSystem().AddFile(model, file, filePath);
                        }
                        Model.CustomerID = Convert.ToInt16(data);
                        Model.Logo = vm.FileID;

                        if (files.Count > 0)
                        {
                            _CustomerRepo.UpdateCustomerLogo(Model);
                        }

                        return GetAddEditDeleteResponse(data, "Add");
                    }
                    else if (Model.CustomerID > 0)
                    {
                        data = _CustomerRepo.Update(Model);
                        model.ObjectInstanceID = data;
                        if (files.Count > 0)
                        {
                            for (int i = 0; i < files.Count; i++)
                            {
                                HttpPostedFileBase file = files[i];
                                model.FileSize = file.ContentLength;
                                vm = new FileSystem().AddFile(model, file, filePath);
                            }

                            try
                            {
                                Model.Logo = vm.FileID;
                                _CustomerRepo.UpdateCustomerLogo(Model);
                            }
                            catch (Exception)
                            {
                            }
                        }

                        return GetAddEditDeleteResponse(data, "Update");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("CustomerController_AddUpdateData Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        [HttpPost]
        public JsonResult Delete(Customer_VM Model)
        {
            if (CheckAccessDelete(Model.CurrentScreenID, "Customer"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.CustomerID > 0 && Model.CustomerID != null)
                    {
                        List<Customer_VM> vm = _CustomerRepo.GetData(Model);
                        FolderFile_VM model = new FolderFile_VM();
                        if (vm.Count > 0)
                        {
                            model.FileID = vm[0].Logo;
                        }

                        string filePath = null;
                        filePath = Path.Combine(Server.MapPath("~/" + WebConfigurationManager.AppSettings["CustomerLogo"]));

                        var data = _CustomerRepo.Delete(Model);

                        if (model.FileID != null)
                        {
                            new FileSystem().RemoveFile(model, filePath);
                        }

                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("CustomerController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);

        }
        #endregion customer

        #region customer location
        public ActionResult Location(Location_VM Model)
        {
            if (Model.GlobalID != null && Model.GlobalID != "")
            {
                ViewBag.customerID = Model.CustomerID;
                ViewBag.EncryptScreenID = Model.GlobalID;

                int screenID = Convert.ToInt16(Decrypt(Model.GlobalID));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Customer Location")))
                {
                    return RedirectOnAccess();
                }
            }
            else
            {
                return RedirectOnAccess();
            }

            return CheckSession(View("Location"));
        }

        public PartialViewResult _partialLocationAddUpdate()
        {
            return PartialView("_partialLocationAddUpdate");
        }

        public PartialViewResult _partialTreeView()
        {
            return PartialView("_partialTreeView");
        }

        public JsonResult GetLocationRootAndLeaflevel(Location_VM Model)
        {
            List<GetLocationTree_VM> vm = new List<GetLocationTree_VM>();
            try
            {
                GetUserInfo(Model);
                vm = _CustomerRepo.GetLocationRootAndLeaflevel(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult GetCustomerRootLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> vm = new List<GetLocationTree_VM>();
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                vm = _CustomerRepo.GetCustomerRootLocation(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult GetCustomerChildLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> vm = new List<GetLocationTree_VM>();
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                vm = _CustomerRepo.GetCustomerChildLocation(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult GetUserCustomerLocation(Location_VM Model)
        {
            var vm = new List<GetLocationTree_VM>();
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                vm = _CustomerRepo.GetUserCustomerLocation(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult MEIGetUserCustomerLocation(Location_VM Model)
        {
            List<GetLocationTree_VM> vm = new List<GetLocationTree_VM>();
            try
            {
                vm = _CustomerRepo.GetUserCustomerLocation(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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
        /// <summary>
        /// Get Leaf to 
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public JsonResult GetCustomerLocationData(Location_VM Model)
        {
            var vm = new List<GetLocationTree_VM>();
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                vm = _CustomerRepo.GetCustomerLocationData(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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
        [HttpPost]
        public JsonResult AddUpdateCustomerLocationData(Location_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);
                    if (Model.LocationID == 0 || Model.LocationID == null)
                    {
                        var data = _CustomerRepo.AddLocation(Model);

                        if (data > 0)
                        {
                            return Json(new JsonResponse("Success", saveMessage, data), JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new JsonResponse("Error", saveErrorMessage, data), JsonRequestBehavior.AllowGet);
                        }
                    }
                    else if (Model.LocationID > 0)
                    {
                        var data = _CustomerRepo.UpdateLocation(Model);

                        if (data > 0)
                        {
                            return Json(new JsonResponse("Success", updateMessage, data), JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new JsonResponse("Error", updateErrorMessage, data), JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("Error: ", ex);
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
            else
            {
                string ErrorMessage = string.Empty;

                foreach (ModelState modelState in ViewData.ModelState.Values)
                {
                    foreach (ModelError error in modelState.Errors)
                    {
                        ErrorMessage += error.ErrorMessage + "<br/>";
                    }
                }

                return Json(new JsonResponse("Error", ErrorMessage, null), JsonRequestBehavior.AllowGet);
            }

            return Json(new JsonResponse("Error", nullErrorMessage, null), JsonRequestBehavior.AllowGet);
        }

        public JsonResult DeleteLocation(Location_VM Model)
        {
            if (Model.LocationID > 0)
            {
                try
                {
                    GetUserInfo(Model);
                    var data = _CustomerRepo.DeleteLocation(Model);
                    if (data > 0)
                    {
                        return Json(new JsonResponse("Success", deleteMessage, data), JsonRequestBehavior.AllowGet);
                    }
                    else
                    {
                        return Json(new JsonResponse("Error", deleteErrorMessage, data), JsonRequestBehavior.AllowGet);
                    }

                }
                catch (Exception ex)
                {
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
            else
            {
                return Json(new JsonResponse("Error", deleteErrorMessage, null), JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetDataByID(Location_VM Model)
        {
            var vm = new List<Location_VM>();
            try
            {
                if (CheckUserHasValue(Model))
                {
                    GetUserInfo(Model);
                }

                vm = _CustomerRepo.GetDataByID(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult GetMEICustomerAndLocationDetails(MEILocation Model)
        {
            List<MEILocation> vm = new List<MEILocation>();
            try
            {
                vm = _CustomerRepo.GetMEICustomerAndLocationDetails(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public JsonResult GetRootAndChildCustomerLocationRiskLevel(RootAndChildCustomerLocationRiskLevel Model)
        {
            List<RootAndChildCustomerLocationRiskLevel> vm = new List<RootAndChildCustomerLocationRiskLevel>();
            try
            {
                //GetUserInfo(Model);
                vm = _CustomerRepo.GetRootAndChildCustomerLocationRiskLevel(Model);

                return Json(new JsonResponse("Success", successMessage, vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        [HttpPost]
        public JsonResult UpdateSortingGrid(UpdateSorting_VM Model)
        {
            //if (ModelState.IsValid)
            //{
            try
            {
                GetUserInfo(Model);
                var data = _CustomerRepo.UpdateSortingGrid(Model);
                if (data > 0)
                {
                    return GetAddEditDeleteResponse(data, "Update");
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerController_UpdateSortingGrid Error: ", ex);
                return GetAddEditErrorException(ex);
            }
            //}

            return GetModelStateIsValidException(ViewData);
        }

        #endregion customer location

        #region Dashboard
        public ActionResult Dashboard(Location_VM Model)
        {
            if (Model.GlobalID != null && Model.GlobalID != "")
            {
                ViewBag.GlobalID = Model.GlobalID;
                ViewBag.customerID = Model.CustomerID;
                ViewBag.EncryptScreenID = Model.GlobalID;
                int screenID = Convert.ToInt16(Decrypt(Model.GlobalID));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "Customer")))
                {
                    return RedirectOnAccess();
                }
            }
            else
            {
                return RedirectOnAccess();
            }

            return CheckSession(View("Dashboard"));
        }//GetCustomerDetails
        #endregion 

        public JsonResult GetCustomerDetails(Location_VM Model)
        {
            try
            {
                GetUserInfo(Model);
                var data = _CustomerRepo.GetCustomerDetails(Model);
                return Json(new JsonResponse("Success", successMessage, data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                logger.Error("Error: ", ex);
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

        public string GetIpAddress()  // Get IP Address
        {
            string ip = "";
            IPHostEntry ipEntry = Dns.GetHostEntry(GetCompCode());
            IPAddress[] addr = ipEntry.AddressList;
            ip = addr[1].ToString();
            return ip;
        }

        public static string GetCompCode()  // Get Computer Name
        {
            string strHostName = "";
            strHostName = Dns.GetHostName();
            return strHostName;
        }
    }
};
