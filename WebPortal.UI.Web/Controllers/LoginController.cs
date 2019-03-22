using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Web.Mvc;
using System.Web.Security;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;
using WebPortal.Common.Utilities.Global;
using WebPortal.UI.Web.GlobalResource;

namespace WebPortal.UI.Web.Controllers
{
    public class LoginController : BaseController
    {
        private IUserRepository _UserRepo;

        public LoginController(IUserRepository UserRepo)
        {
            _UserRepo = UserRepo;
        }

        // GET: Login
        public ActionResult Index()
        {
            Session.Clear();
            return View();
        }

        private static string GetCompCode()  // Get Computer Name
        {
            string strHostName = "";
            strHostName = Dns.GetHostName();
            return strHostName;
        }

        public ActionResult Error()
        {
            return View();
        }

        public ActionResult Login()
        {
            //Session.Abandon();
            Session.Clear();
            //HttpContext.Cache.Remove("objMenu");
            //HttpContext.Cache.Remove("objAction");
            return View("Index");
        }

        [HttpPost]
        public ActionResult Login(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    List<UserEmployee_VM> objUser = null;
                    List<MenuScreen_VM> objMenu = null;
                    List<ScreenAction_VM> objAction = null;
                    List<Module_VM> objModule = null;
                    List<IsSingleCustomer_VM> objSingleCustomer = null;

                    //model.IPAddress = "102.120.36.25";
                    //Dns.GetHostByName(Dns.GetHostName()).AddressList[0].ToString()
                    if (_UserRepo.ValidateUser(model.Username,
                        model.Password, model.IPAddress,
                        out objUser, out objMenu, out objAction, out objModule, out objSingleCustomer))
                    {
                        var row = objUser[0];

                        if (row.EndUserID > 0 && (objMenu.Count > 0 || row.IsCustomerUser))
                        {
                            Hashtable User_LoginInfo = new Hashtable();
                            User_LoginInfo["UserID"] = row.EndUserID;
                            User_LoginInfo["UserRoleID"] = row.UserRoleID;
                            User_LoginInfo["AccessPoint"] = model.IPAddress; // Request.Url;
                            User_LoginInfo["UserName"] = row.UserName;
                            User_LoginInfo["LanguageCode"] = row.CurrentLanguageCode;//Current login user language
                            User_LoginInfo["UTCOffset"] = row.CurrentUTCOffset;
                            ViewBag.UserRoleID = row.UserRoleID;

                            switch (row.CurrentLanguageCode)
                            {
                                case "SV": { User_LoginInfo["GlobalLanguageCode"] = (string)LanguagePostFix.Swedish; break; }
                                default: { User_LoginInfo["GlobalLanguageCode"] = (string)LanguagePostFix.EnglishUS; break; }
                            }

                            foreach (var item in objModule)
                            {
                                User_LoginInfo["UserModules"] += item.ModuleCode + ",";
                            }

                            Session["User_LoginInfo"] = User_LoginInfo;

                            HttpContext.Cache["objMenu" + row.UserRoleID] = objMenu;/* also store to localstorage*/
                            HttpContext.Cache["objAction" + row.UserRoleID] = objAction;/* also store to localstorage*/
                            HttpContext.Cache["GetConfigurationData"] = objAction;

                            #region Get Configuration Data sp Data
                            //Service Line can be user module wise
                            var ObjConfig = new CommonRepository().GetConfigurationData2(ModuleCode.Safety, LanguageCode, objSingleCustomer);

                            HttpContext.Cache["GetConfigurationData"] = ObjConfig;

                            #endregion Get Configuration Data sp Data

                            string scrID = null;
                            bool? HasDashboardAccess = false;

                            User_LoginInfo["CurrentModuleCode"] = row.DefaultModuleCode;

                            //check accress of module wise
                            if (row.IsCustomerUser)
                            {
                                var aa = ObjConfig.IsSingleCustomerList;
                                scrID = Convert.ToString(aa[0].CustomerID);
                                row.DefaultModuleCode = "CD";
                                HasDashboardAccess = true;
                            }
                            else
                            {
                                switch (row.DefaultModuleCode)
                                {
                                    case ModuleCode.Base:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Invoice" && x.ModuleCode == ModuleCode.Base).EncryptScreenID;/*Base Dashboard*/
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Invoice").HasSelect;

                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                    case ModuleCode.Safety:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Safety Dashboard" && x.ModuleCode == ModuleCode.Safety).EncryptScreenID;
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Safety Dashboard").HasSelect;
                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                    case ModuleCode.Training:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Dashboard Training" && x.ModuleCode == ModuleCode.Training).EncryptScreenID;
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Dashboard Training").HasSelect;
                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                    case ModuleCode.Incident:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Dashboard Incident" && x.ModuleCode == ModuleCode.Incident).EncryptScreenID;
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Dashboard Incident").HasSelect;
                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                    case ModuleCode.Drill:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Dashboard Drill" && x.ModuleCode == ModuleCode.Drill).EncryptScreenID;
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Dashboard Drill").HasSelect;
                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                    case ModuleCode.FRAS:
                                        {
                                            try
                                            {
                                                scrID = objMenu.Find(x => x.ObjectName == "Dashboard FRAS" && x.ModuleCode == ModuleCode.FRAS).EncryptScreenID;
                                                HasDashboardAccess = objMenu.Find(item => item.ObjectName == "Dashboard FRAS").HasSelect;
                                            }
                                            catch (Exception)
                                            {
                                                scrID = "";
                                                HasDashboardAccess = true;
                                            }
                                            break;
                                        };
                                }
                            }

                            if (HasDashboardAccess == true)
                            {
                                //Cache the new current culture into the user HTTP session.   
                                CustomIdentity.CustomIdentity.SetAuthorizedUserCookies(objUser, model.RememberMe);

                                if (Convert.ToBoolean(model.RememberMe))
                                {
                                    CookiesStore.SetCookiesValue(CookiesStore.Keys.Username, model.Username);
                                    CookiesStore.SetCookiesValue(CookiesStore.Keys.RememberMe, Convert.ToBoolean(model.RememberMe).ToString());
                                }
                                else
                                {
                                    CookiesStore.CookiesRemove(CookiesStore.Keys.Username);
                                    CookiesStore.CookiesRemove(CookiesStore.Keys.RememberMe);
                                }

                                return RedirectLoggedInUser(row.DefaultModuleCode, scrID);
                            }
                            else
                            {
                                ViewBag.Error = Resource.PermissionMessage;
                            }
                        }
                        else
                        {
                            if (objMenu.Count == 0)
                            {
                                ViewBag.Error = Resource.LoginPermissionMessage;
                            }
                            else
                            {
                                ViewBag.Error = Resource.ValidationMessage;
                            }
                        }
                    }
                    else
                    {
                        ViewBag.Error = Resource.InvalidUserMessage;
                    }
                }
                catch (Exception ex)
                {
                    if (ex.InnerException != null)
                    {
                        ViewBag.Error = ex.InnerException.Message.ToString();
                    }
                    else
                    {
                        ViewBag.Error = ex.Message.ToString();
                    }
                }
            }

            return View("Index");
        }

        public ActionResult _PasswordChange()
        {
            return View("~/Views/Shared/_PasswordChange.cshtml");
        }

        [HttpGet]
        public ActionResult UserForgotpassword()
        {
            if (RouteData.Values["id"] != null)
            {
                string Id = Convert.ToString(RouteData.Values["id"]);
                var data = _UserRepo.CheckUser_ForgotPassword_URL(Id);

                if (data > 0)
                {
                    ViewBag.ID = RouteData.Values["id"];
                    return View();
                }
                else
                {
                    ViewBag.ID = RouteData.Values["id"];
                    ViewBag.URLexpired = Resource.URLexpired;
                    return View();
                }
            }
            else
            {
                ViewBag.ErrorUrl = Resource.UrlError;
            }

            return View();
        }

        [HttpPost]
        public JsonResult UserForgotpassword(ResetPasswordVM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (Model.EndUserID > 0)
                    {
                        if (_UserRepo.ChangeForgotPassword(Model))
                        {
                            return Json(new JsonResponse("Success", Resource.PassChangeMessage, true), JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new JsonResponse("Error", Resource.InvalidUserMessage, null), JsonRequestBehavior.AllowGet);
                        }
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

            return Json(new JsonResponse("Error", Resource.NullErrorMessage, null), JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public ActionResult LogOff()
        {
            Session.Clear();
            Session.Abandon();
            //HttpContext.Cache.Remove("objMenu");
            //HttpContext.Cache.Remove("objAction");
            FormsAuthentication.SignOut();
            return RedirectToAction("", "Login");
        }

        [HttpGet]
        public ActionResult ChangePassword()
        {
            return CheckSession(View());
        }

        [HttpPost]
        public JsonResult ChangePassword(ResetPasswordVM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (Model.Email != "" || Model.Email != null)
                    {
                        Model.EndUserID = UserID;

                        if (_UserRepo.ChangePassword(Model))
                        {
                            return Json(new JsonResponse("Success", Resource.PassChangeMessage, true), JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new JsonResponse("Error", Resource.InvalidUserMessage, null), JsonRequestBehavior.AllowGet);
                        }
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

            return Json(new JsonResponse("Error", Resource.NullErrorMessage, null), JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult User_ForgotPassword(MailEndUser_VM Model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (Model.EmailID != "" || Model.EmailID != null)
                    {

                        var Data = _UserRepo.User_ForgotPassword(Model);
                        if (Data > 0)
                        {
                            return Json(new JsonResponse("Success", Resource.RegisteredEmail, true), JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(new JsonResponse("Error", Resource.InvalidEmail, null), JsonRequestBehavior.AllowGet);
                        }
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

            return Json(new JsonResponse("Error", Resource.NullErrorMessage, null), JsonRequestBehavior.AllowGet);
        }
    }
};