using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.UI.Web.Controllers
{
    public class UserController : BaseController
    {
        private IUserRepository _UserRepo;

        public UserController(IUserRepository UserRepo)
        {
            _UserRepo = UserRepo;
        }

        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "User")))
                    return RedirectOnAccess();
            }
            else
            {
                return RedirectOnAccess();
            }

            return CheckSession(View());
        }

        public PartialViewResult _partialAddUpdate()
        {
            return PartialView("_partialAddUpdate");
        }

        public PartialViewResult _partialTreeView()
        {
            return PartialView("_partialTreeView");
        }

        public PartialViewResult _partialUserLocation()
        {
            return PartialView("_partialUserLocation");
        }

        public JsonResult GetData(EndUser_VM Model)
        {
            List<EndUser_VM> vm = new List<EndUser_VM>();
            try
            {
                GetUserInfo(Model);
                vm = _UserRepo.GetData(Model);

                return Json(new JsonResponse("Success", "Success", vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }
        /// <summary>
        /// Is Use for Controller Tagging in Mobile app
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public JsonResult GetUserData(EndUser_VM Model)
        {
            var vm = new List<EndUser_VM>();
            try
            {
                // This condition tells if comes null/0 then bind from session varial edither comes form user browers
                if (Model.CurrentEndUserID == 0)
                    GetUserInfo(Model);

                vm = _UserRepo.GetUserNameData(Model);

                return Json(new JsonResponse("Success", "Success", vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetControllerUserData(EndUser_VM Model)
        {
            List<EndUser_VM> vm = new List<EndUser_VM>();
            try
            {
                GetUserInfo(Model);
                vm = _UserRepo.GetControllerUserNameData(Model);

                return Json(new JsonResponse("Success", "Success", vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        [HttpPost]
        public JsonResult AddUpdateData(EndUser_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    GetUserInfo(Model);
                    if (Model.EndUserID == 0 || Model.EndUserID == null)
                    {
                        var data = _UserRepo.Add(Model);

                        if (data > 0)
                            return Json(new JsonResponse("Success", saveMessage, data), JsonRequestBehavior.AllowGet);
                        else
                            return Json(new JsonResponse("Error", saveErrorMessage, data), JsonRequestBehavior.AllowGet);
                    }
                    else if (Model.EndUserID > 0)
                    {
                        var data = _UserRepo.Update(Model);

                        if (data > 0)
                            return Json(new JsonResponse("Success", updateMessage, data), JsonRequestBehavior.AllowGet);
                        else
                            return Json(new JsonResponse("Error", updateErrorMessage, data), JsonRequestBehavior.AllowGet);
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("Error: ", ex);
                    if (ex.InnerException != null)
                        return Json(new JsonResponse("Error", ex.InnerException.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                    else
                        return Json(new JsonResponse("Error", ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                }
            }
            else
            {
                string ErrorMessage = string.Empty;

                foreach (ModelState modelState in ViewData.ModelState.Values)
                    foreach (ModelError error in modelState.Errors)
                        ErrorMessage += error.ErrorMessage + "<br/>";

                return Json(new JsonResponse("Error", ErrorMessage, null), JsonRequestBehavior.AllowGet);
            }

            return Json(new JsonResponse("Error", "Data can not be null.", null), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult Delete(EndUser_VM Model)
        {
            if (CheckAccessDelete(Model.CurrentScreenID, "User"))
            {
                try
                {
                    GetUserInfo(Model);

                    if (Model.EndUserID > 0 && Model.EndUserID != null)
                    {
                        var data = _UserRepo.Delete(Model);
                        return GetAddEditDeleteResponse(data, "Delete");
                    }
                }
                catch (Exception ex)
                {
                    logger.Error("UserController_Delete Error: ", ex);
                    return GetAddEditErrorException(ex);
                }
            }
            return GetModelStateIsValidException(ViewData);
        }

        public JsonResult GetCustomerData(UserCustomerList_VM Model)
        {
            List<UserCustomerList_VM> vm = new List<UserCustomerList_VM>();
            try
            {
                GetUserInfo(Model);
                vm = _UserRepo.GetCustomerData(Model);

                return Json(new JsonResponse("Success", "Success", vm), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }
    }
};