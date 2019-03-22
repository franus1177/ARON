using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Entities.VM;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.UI.Web.Controllers
{
    public class UserRoleController : BaseController
    {
        private IUserRoleRepository _RoleRepo;

        public UserRoleController(IUserRoleRepository RoleRepo)
        {
            _RoleRepo = RoleRepo;
        }

        #region Role Master
        // GET: UserRole
        public ActionResult Index()
        {
            if (RouteData.Values["id"] != null)
            {
                ViewBag.EncryptScreenID = RouteData.Values["id"].ToString();
                int screenID = Convert.ToInt16(Decrypt(RouteData.Values["id"].ToString()));
                ViewBag.screenID = screenID;
                if (!(CheckAccess(screenID, "User Role")))
                {
                    return RedirectOnAccess();
                }
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

        [HttpPost]
        public JsonResult AddUpdateData(UserRole_VM Model)
        {
            if (Model != null)
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        GetUserInfo(Model);
                        if (Model.UserRoleID == null || Model.UserRoleID == 0)
                        {
                            var data = _RoleRepo.Add(Model);
                            if (data)
                            {
                                return Json(new JsonResponse("Success", saveMessage, data), JsonRequestBehavior.AllowGet);
                            }
                            else
                            {
                                return Json(new JsonResponse("Error", saveErrorMessage, data), JsonRequestBehavior.AllowGet);
                            }
                        }
                        else if (Model.UserRoleID > 0)
                        {
                            var data = _RoleRepo.Update(Model);
                            if (data)
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
                        //Log the error
                        logger.Error("UserRoleController_AddUpdateData Error: ", ex);

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
            }
            return Json(new JsonResponse("Error", "Data can not be null.", null), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetData(short? Id)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var data = _RoleRepo.GetData(Id);
                    return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
                }
                catch (Exception ex)
                {
                    //Log the error
                    logger.Error("UserRoleController_GetData Error: ", ex);

                    return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                }
            }
            return Json(new JsonResponse("Error", "Invalid Request. Please reload the screen and try again.", null), JsonRequestBehavior.AllowGet);
        }

        #endregion Role Master

        #region Access Permission

        public ActionResult AccessPermission()
        {
            return CheckSession(View("AccessPermission"));
        }

        [HttpGet]
        public JsonResult GetScreenAccess(string MenuCode, short UserRoleID, string CurrentModuleCode = null)
        {
            if (UserRoleID > 0)
            {
                var obj = new ScreenAccess_VM() { MenuCode = MenuCode, UserRoleID = UserRoleID, CurrentModuleCode = CurrentModuleCode };

                var response = _RoleRepo.GetScreenAccess(obj);

                return Json(new JsonResponse("Success", "Success", response), JsonRequestBehavior.AllowGet);
            }

            return Json(new JsonResponse("Error", "Invalid Request. Please reload the screen and try again.", null), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult AddEditUserRolePermissionData(string Model)
        {
            List<ScreenAccess_VM> myModel = (List<ScreenAccess_VM>)JsonConvert.DeserializeObject(Model, (typeof(List<ScreenAccess_VM>)));

            if (myModel[0].ScreenID != null)
            {
                if (ModelState.IsValid)
                {
                    try
                    {
                        GetUserInfo(myModel[0]);

                        if (myModel[0].ScreenID > 0)
                        {
                            var result = _RoleRepo.AddScreenUserRole(myModel);

                            if (result > 0)
                            {
                                try
                                {
                                    Accesspermission_Wrapper _obj = _RoleRepo.GetMenuAndScreenData(new ScreenAccess_VM() { UserRoleID = myModel[0].UserRoleID });
                                    /*Update server cache for all login users by userrole*/

                                    HttpContext.Cache["objMenu" + myModel[0].UserRoleID] = _obj.MenuList;              /* also store to localstorage*/
                                    HttpContext.Cache["objAction" + myModel[0].UserRoleID] = _obj.ScreenActionList;    /* also store to localstorage*/
                                }
                                catch (Exception)
                                {
                                }
                            }

                            return Json(new JsonResponse("Success", saveMessage, result), JsonRequestBehavior.AllowGet);
                        }
                    }
                    catch (Exception ex)
                    {
                        logger.Error("UserRoleController_AddEditUserRolePermissionData Error: ", ex);

                        return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
                    }
                }
            }

            return Json(new JsonResponse("Error", "Data can not be null.", null), JsonRequestBehavior.AllowGet);
        }

        #endregion Access Permission
    }
};