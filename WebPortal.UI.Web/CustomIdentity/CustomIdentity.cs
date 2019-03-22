using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Security;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.UI.Web.CustomIdentity
{
    public static class CustomIdentity
    {
        public static void SetAuthorizedUserCookies(List<UserEmployee_VM> objUser, bool? rememberMe = false)
        {
            #region Custom Identity

            bool persistent = Convert.ToBoolean(rememberMe);

            CustomPrincipalSerializeModel serializeModel = new CustomPrincipalSerializeModel();
            serializeModel.UserId = Convert.ToInt32(objUser[0].CurrentEndUserID);
            serializeModel.FirstName = objUser[0].FirstName;
            serializeModel.LastName = objUser[0].LastName;
            serializeModel.Email = objUser[0].UserName;
            serializeModel.CurrentUserRoleID = objUser[0].CurrentUserRoleID;
            //serializeModel.Role = objUser.RoleIds.Select(x=> ;
            //serializeModel.ScreenPath = objUser.ScreenPath;

            serializeModel.PersistentCookie = persistent;

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string userData = Security.Encrypt(serializer.Serialize(serializeModel));

            #region Add Authentication Cookies

            var authTicket = new FormsAuthenticationTicket(
                    1,
                    objUser[0].UserName,//username,                    // user name
                    DateTime.Now,               // created
                    DateTime.Now.AddMinutes(FormsAuthentication.Timeout.TotalMinutes),// expires
                    persistent,               // persistent?
                    userData                 // can be used to store roles
                    );

            HttpContext.Current.Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(authTicket)));

            #endregion

            #endregion
        }
        public class CustomPrincipalSerializeModel
        {
            public int UserId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string Email { get; set; }
            public List<string> ScreenPath { get; set; }
            //public string Role { get; set; }
            public int CurrentUserRoleID { get; set; }
            public bool PersistentCookie { get; set; }
        }

        //public static void RefreshAuthorizedUserCookies()
        //{
        //    try
        //    {
        //        HttpCookie authCookie = HttpContext.Current.Request.Cookies[FormsAuthentication.FormsCookieName];

        //        if (authCookie != null)
        //        {
        //            FormsAuthenticationTicket ticket = FormsAuthentication.Decrypt(authCookie.Value);
        //            if (ticket != null)
        //            {
        //                #region Custom Identity

        //                JavaScriptSerializer serializer = new JavaScriptSerializer();
        //                CustomPrincipalSerializeModel serializeModel = serializer.Deserialize<CustomPrincipalSerializeModel>(Security.Decrypt(ticket.UserData));
        //                CustomPrincipal newUser = new CustomPrincipal(FormsAuthentication.FormsCookieName);

        //                bool persistent = serializeModel.PersistentCookie;

        //                string userData = Security.Encrypt(serializer.Serialize(serializeModel));

        //                #region Add Authentication Cookies

        //                var authTicket = new FormsAuthenticationTicket(
        //                        1,
        //                        serializeModel.Email,// user name
        //                        DateTime.Now,               // created
        //                        DateTime.Now.AddMinutes(FormsAuthentication.Timeout.TotalMinutes),// expires
        //                        persistent,               // persistent?
        //                        userData                 // can be used to store roles
        //                        );

        //                HttpContext.Current.Response.Cookies.Add(new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(authTicket)));

        //                #endregion

        //                #endregion
        //            }
        //        }
        //    }
        //    catch { }
        //}
    }
}