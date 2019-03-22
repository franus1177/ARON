using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;
using WebPortal.Common.Utilities.Helpers;

namespace WebPortal.UI.Web.Controllers
{
    public class AjaxCommonDataController : BaseController
    {
        public ActionResult RedirectTo(string DefaultModuleCode, string ScreenID)
        {

            return RedirectLoggedInUser(DefaultModuleCode, ScreenID);
        }

        // GET: AjaxCommon
        public ActionResult Index()
        {
            return View();
        }

        #region Base 

        public JsonResult GetTimeZone(short? UserRoleID)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetTimeZone(new TimeZone_VM());

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetTimeZone: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetUserRole(short? UserRoleID)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetUserRole(UserRoleID);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetUserRole: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetScreen(int? ScreenID)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetScreen(ScreenID);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetUserRole: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetMenuList(string ModuleCode)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetMenuList(ModuleCode);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetMenuList: ", ex);

                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetLanguage(string LanguageCode)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetLanguage(LanguageCode);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetLanguage: ", ex);

                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DataType"> Can be a (LanguageCode, ServiceLineName, TimeUnit, ConfigurationCode, RiskLevel, SeverityLevel, InspectionType & AttributeType)</param>
        /// <param name="ServiceLine"></param>
        /// <param name="LanguageCode"></param>
        /// <returns></returns>
        public JsonResult GetConfiguration(string DataType, string ServiceLine, string LanguageCode)
        {
            try
            {
                CommonRepository obj = new CommonRepository();

                var ds = new DataSet();
                ds = obj.GetConfigurationData(ServiceLine, LanguageCode);

                DataTable dt = new DataTable();

                System.Object baseobj = new System.Object();

                switch (DataType)
                {
                    case "ServiceLineName": { dt = ds.Tables[1]; break; }
                    case "TimeUnit": { dt = ds.Tables[2]; break; }
                    case "ConfigurationCode": { dt = ds.Tables[3]; break; }
                    case "RiskLevel": { dt = ds.Tables[4]; break; }
                    case "SeverityLevel": { dt = ds.Tables[5]; break; }
                    case "InspectionType": { dt = ds.Tables[6]; break; }
                    case "AttributeType": { dt = ds.Tables[7]; break; }
                    //case "LanguageCode": { dt = ds.Tables[0]; break; }
                    default:
                        {
                            baseobj = (from DataRow dr in ds.Tables[0].Rows
                                       select new Language_VM()
                                       {
                                           LanguageCode = dr["LanguageCode"].ToString(),
                                           LanguageName = dr["LanguageName"].ToString()

                                       }).ToList();

                            dt = ds.Tables[0]; break;
                        }
                }

                return GetDataResponse(baseobj);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetConfigurationLanguage Error: ", ex);
                return GetDataResponseException(ex);
            }
        }

        /// <summary>
        /// Use for Autocompete
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public JsonResult GetCustomer(UserLocation_VM Model)
        {
            try
            {
                GetUserInfo(Model);

                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetCustomer(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetCustomer: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Get Customer Root Locations
        /// </summary>
        public JsonResult GetCustomerLocation(Location_VM Model)
        {
            try
            {
                GetUserInfo(Model);

                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetCustomerRootLocation(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetCustomerLocation: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetCustomerAllLocation(Location_VM Model)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetCustomerAllRootLocation(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetCustomerAllLocation: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetCustomerChildLocation(Location_VM Model)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetCustomerChildLocation(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetCustomerLocation: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetUser(EndUser_VM Model)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetUser(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetUser: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult GetAccountManagerUser(Customer_VM Model)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetAccountManagerUser(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetAccountManagerUser: ", ex);
                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

       
        #endregion Base 

        #region Safety

        public JsonResult GetUsers(EndUser_VM Model)
        {
            try
            {
                DropDownRepository DDRepo = new DropDownRepository();

                IEnumerable<SelectListItem> data = new List<SelectListItem>();

                data = DDRepo.GetUsers(Model);

                return Json(new JsonResponse("Success", "Success", data), JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                //Log the error
                logger.Error("AjaxCommonDataController_GetRootLocation: ", ex);

                return Json(new JsonResponse("Error", "Error occured while processing request: " + ex.Message.ToString(), null), JsonRequestBehavior.AllowGet);
            }
        }

        #endregion Safety
    }
};