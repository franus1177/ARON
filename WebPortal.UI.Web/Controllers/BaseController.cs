using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Mvc;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.UI.Web.GlobalResource;

namespace WebPortal.UI.Web.Controllers
{
    public class BaseController : Controller
    {
        public static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        // GET: Base
        public string saveMessage { get { return Resource.SaveSuccessMessage; } }
        public string saveErrorMessage { get { return Resource.SaveErrorMessage; } }
        public string updateMessage { get { return Resource.UpdateSuccessMessage; } }
        public string updateErrorMessage { get { return Resource.UpdateErrorMessage; } }
        public string deleteMessage { get { return Resource.DeleteSuccessMessage; } }
        public string useInAnotherEntityMessage { get { return Resource.UseInAnotherEntityMessage; } }
        public string deleteErrorMessage { get { return Resource.DeleteErrorMessage; } }
        public string nullErrorMessage { get { return Resource.NullErrorMessage; } }
        public string successMessage { get { return Resource.SuccessMessage; } }
        public bool IsServiceLineShow { get { return Convert.ToBoolean(ConfigurationManager.AppSettings["IsServiceLine"]); } }

        protected /*override*/ JsonResult Json2(object data, /*string contentType, Encoding contentEncoding,*/ JsonRequestBehavior behavior)
        {
            return new JsonResult()
            {
                Data = data,
                //ContentType = contentType,
                //ContentEncoding = contentEncoding,
                JsonRequestBehavior = behavior,
                MaxJsonLength = Int32.MaxValue
            };
        }

        public /*ActionResult*/void RedirectToLogin()
        {
            Response.Redirect("~/Login/");
            //return RedirectToAction("Index", "Login", new { area = string.Empty });
        }

        public int UserID
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return Convert.ToInt32(User_LoginInfo["UserID"].ToString());
                }

                return 0;
            }
        }
        public Int16 UserRoleID
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return Convert.ToInt16(User_LoginInfo["UserRoleID"].ToString());
                }

                return 0;
            }
        }
        public short CurrentScreenID
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    Int16 ScreenID = Convert.ToInt16(User_LoginInfo["CurrentScreenID"].ToString());
                    return Convert.ToInt16(User_LoginInfo["CurrentScreenID"].ToString());
                }

                return 0;
            }
        }
        public string AccessPoint
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return (string)User_LoginInfo["AccessPoint"];
                }

                return "";
            }
        }
        public void GetUserInfo(dynamic Model)
        {
            Model.CurrentEndUserID = UserID;
            Model.CurrentUserRoleID = UserRoleID;
            Model.AccessPoint = AccessPoint == null ? "0.0.0.0": AccessPoint;
            Model.CurrentLanguageCode = LanguageCode;
            Model.CurrentUTCOffset = UTCOffset;
        }
        public ActionResult CheckSession(ViewResult viewResult)
        {
            if (Session["User_LoginInfo"] == null)
            {
                RedirectToLogin();
            }

            return viewResult;
        }
        public void CheckSession()
        {
            if (Session["User_LoginInfo"] == null)
            {
                RedirectToLogin();
            }
        }

        /// <summary>
        /// Updated 17 nov 2018 by Rajendra
        /// </summary>
        /// <param name="ScreenID"></param>
        /// <param name="ScreenName"></param>
        /// <param name="accesstype">has default check view access else one have to pass</param>
        /// <returns></returns>
        public bool CheckAccess(int ScreenID, string ScreenName, EnumScreenAccess accesstype = EnumScreenAccess.HasSelect)
        {
            List<MenuScreen_VM> objMenuList = null; //  List<ScreenAction_VM> objActionList = null;
            //if (HttpContext.Cache["objMenu" + ViewBag.UserRoleID] != null)
            //{
            //    objMenuList = (List<MenuScreen_VM>)HttpContext.Cache["objMenu" + ViewBag.UserRoleID];
            //    foreach (var item in objMenuList.Where(x => x.ScreenID == ScreenID))
            //    {
            //        if (item.HasSelect == true && item.ObjectName == ScreenName)
            //        {
            //            return true;
            //        }
            //    }
            //}

            if (HttpContext.Cache["objMenu" + UserRoleID] != null)
            {
                objMenuList = (List<MenuScreen_VM>)HttpContext.Cache["objMenu" + UserRoleID];

                switch (accesstype)
                {
                    case EnumScreenAccess.HasInsert:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasInsert == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                    case EnumScreenAccess.HasUpdate:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasUpdate == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                    case EnumScreenAccess.HasDelete:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasDelete == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                    case EnumScreenAccess.HasSelect:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasSelect == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                    case EnumScreenAccess.HasImport:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasImport == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                    case EnumScreenAccess.HasExport:
                        {
                            if (objMenuList.Where(x => x.ScreenID == ScreenID && x.HasExport == true && x.ObjectName == ScreenName).ToList().Count > 0)
                            {
                                return true;
                            }
                            break;
                        }
                }
            }
            return false;
        }

        public bool CheckAccessDelete(int ScreenID, string ScreenName)
        {
            return CheckAccess(ScreenID, ScreenName, EnumScreenAccess.HasDelete);
        }

        public ActionResult RedirectOnAccess()
        {
            if (Session["User_LoginInfo"] == null)
            {
                RedirectToLogin();
            }

            return RedirectToAction("AccessDenied", "Home", new { id = 1, area = string.Empty });
        }

        public ActionResult RedirectOnAccess(string Message)
        {
            ViewBag.Message = Message;
            return RedirectToAction("AccessDenied", "/Home", new { area = string.Empty });
        }

        public static string Encrypt(string data)
        {
            return Security.Encrypt(data);
        }

        public static string Decrypt(string data)
        {
            return Security.Decrypt(data);
        }
        /// <summary>
        /// //Default Set English
        /// </summary>
        protected string GlobalLanguageCode
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    return (string)LanguagePostFix.EnglishUS;/*Default Set English*/
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return User_LoginInfo["GlobalLanguageCode"].ToString();
                }
            }
        }

        public string LanguageCode
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return User_LoginInfo["LanguageCode"].ToString();
                }

                return null;
            }
        }
        public decimal UTCOffset
        {
            get
            {
                if (Session["User_LoginInfo"] == null)
                {
                    RedirectToLogin();
                }
                else
                {
                    Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                    return Convert.ToDecimal(User_LoginInfo["UTCOffset"].ToString());
                }

                return 0;
            }
        }
        protected override void ExecuteCore()
        {
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(GlobalLanguageCode);
            Thread.CurrentThread.CurrentCulture = Thread.CurrentThread.CurrentUICulture;
            base.ExecuteCore();
        }
        protected override bool DisableAsyncSupport
        {
            get { return true; }
        }
        public JsonResult GetAddEditDeleteResponse(dynamic Data, string ActionType)
        {
            if (Data > 0 && (ActionType == "Add" || ActionType == "AddOrUpdate"))
            {
                return Json(new JsonResponse("Success", saveMessage, Data), JsonRequestBehavior.AllowGet);
            }

            if (Data > 0 && ActionType == "Update")
            {
                return Json(new JsonResponse("Success", updateMessage, Data), JsonRequestBehavior.AllowGet);
            }

            if (Data > 0 && ActionType == "Delete")
            {
                return Json(new JsonResponse("Success", deleteMessage, Data), JsonRequestBehavior.AllowGet);
            }

            if (Data == -1 && ActionType == "Delete")
            {
                return Json(new JsonResponse("ReferenceError", useInAnotherEntityMessage, Data), JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new JsonResponse("Error", saveErrorMessage, Data), JsonRequestBehavior.AllowGet);
            }
        }
        public JsonResult GetModelStateIsValidException(ViewDataDictionary viewData)
        {
            string ErrorMessage = string.Empty;
            foreach (ModelState modelState in viewData.Values)
            {
                foreach (ModelError error in modelState.Errors)
                {
                    ErrorMessage += error.ErrorMessage + "<br/>";
                }
            }

            return Json(new JsonResponse("Error", ErrorMessage, null), JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetAddEditErrorException(Exception ex)
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
        public dynamic GetDataResponse(dynamic vm)
        {
            return Json2(new JsonResponse("Success", "Success", vm), /*"text", Encoding.UTF8,*/ JsonRequestBehavior.AllowGet);
        }

        public dynamic GetDataResponseException(Exception ex)
        {
            return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
        }

        protected override void OnException(ExceptionContext filterContext)
        {
            logger.Error("BaseController_OnException: ", filterContext.Exception);

            if (filterContext.Exception.Message == "Server cannot set content type after HTTP headers have been sent." || filterContext.Exception.Message == "Cannot redirect after HTTP headers have been sent.")
            {//need to show on pop up

                ViewBag.LogoutMessage = "Session is Expired!";
                Response.Redirect("~/Login");

                // commted due to login page open into page
                //RedirectToAction("Login", "Login", new { area = "" });

                //if (filterContext.ExceptionHandled)
                //    return;
                //filterContext.ExceptionHandled = true;
                //filterContext.Result = this.RedirectToAction("Login2", "Login",new { area = "" }); // Redirect to error page.
                //base.OnException(filterContext);
            }
        }

        public ActionResult RedirectLoggedInUser(string ModuleCode, string ScreenID)
        {
            switch (ModuleCode)
            {
                case "SF":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "Safety/SafetyDashboard", new { }) : RedirectToAction("Index", "Safety/SafetyDashboard", new { id = ScreenID });
                    };
                case "IN":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "Incident/IncidentDashboard", new { }) : RedirectToAction("Dashboard", "Incident/IncidentDashboard", new { id = ScreenID });
                    };
                case "TR":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "Training/TrainingDashboard", new { }) : RedirectToAction("Dashboard", "Training/TrainingDashboard", new { id = ScreenID });
                    };
                case "DR":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "Drill/DrillDashboard", new { }) : RedirectToAction("Dashboard", "Drill/DrillDashboard", new { id = ScreenID });
                    };
                case "FR":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "FRAS/FRASDashboard", new { }) : RedirectToAction("Dashboard", "FRAS/FRASDashboard", new { id = ScreenID });
                    };
                case "WO":
                    {
                        return (ScreenID == "") ? RedirectToAction("blankindex", "Work/WorkDashboard", new { }) : RedirectToAction("Dashboard", "Work/WorkDashboard", new { id = ScreenID });
                    };
                case "CD":
                    {
                        return RedirectToAction("Dashboard", "CustomerPortal/CustomerDashboard", new { id = ScreenID/*can be called as Customer ID*/ });
                    };
                default:
                    { return (ScreenID == "") ? RedirectToAction("blankindex", "home", new { }) : RedirectToAction("Index", "Invoice", new { id = ScreenID }); };// Base Module
            }
        }

        protected void BindUploadInformation(HttpPostedFileBase file, List<DeviationImages> _deviationImages, dynamic Model, string filename)
        {
            filename = filename.Replace(".", "").Replace(" ", "").Replace("-", "").Trim();
            Model.FileName = filename;

            // Main Image
            var img = Image.FromStream(file.InputStream);
            _deviationImages.Add(new DeviationImages() { image = img, fileName = filename });


            //----Create Thumbnail from above File-----------------------------------------------------------------------------
            string ext = Path.GetExtension(file.FileName);
            string fleNameWithoutExt = Path.GetFileNameWithoutExtension(filename);
            fleNameWithoutExt = fleNameWithoutExt + "_Thumbnail";
            //var ratio = (double)100 / img.Height;
            int imageHeight = 50;//(int)(img.Height * ratio);
            int imageWidth = 50;//(int)(img.Width * ratio);

            var dCallback = new Image.GetThumbnailImageAbort(ThumbnailCallback);
            var thumbnailImg = img.GetThumbnailImage(imageWidth, imageHeight, dCallback, IntPtr.Zero);

            Model.FileNameSmall = fleNameWithoutExt;
            Model.FileSizeSmall = Model.FileSize;//temp as big image????need to find small image

            Model.FileType = ext.Replace(".", "");
            Model.FileTypeSmall = ext.Replace(".", "");
            _deviationImages.Add(new DeviationImages() { image = thumbnailImg, fileName = fleNameWithoutExt });
        }

        protected bool ThumbnailCallback()
        {
            return false;
        }

        protected bool CheckUserHasValue(dynamic Model)
        {
            if (Model.CurrentEndUserID == 0)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// use when login user don't have dashboard access
        /// </summary>
        /// <returns></returns>
        public ActionResult BlankIndex()
        {
            return View();
        }
    }
};