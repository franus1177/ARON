using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Web;
using ZXing;

namespace WebPortal.Common.Utilities.Global
{
    public class CookiesStore
    {
        public static class Keys
        {
            public const string Username = "WebPortal.User.Username";
            //public const string Password = "WebPortal.User.Password";
            public const string RememberMe = "WebPortal.User.RememberMe";
        }

        /// <summary>
        /// To get the cookies Value
        /// </summary>
        /// <param name="cookiesName"></param>
        /// <returns></returns>
        public static string GetCookiesValue(string cookiesName)
        {
            try
            {
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.Cookies[cookiesName].Value))
                    return HttpContext.Current.Request.Cookies[cookiesName].Value;
            }
            catch { }
            return string.Empty;
        }

        /// <summary>
        /// This methos is used to set cookies values with Time Expiry.
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="cookieValue"></param>
        public static void SetCookiesValue(string cookieName, string cookieValue, DateTime dt)
        {
            try
            {
                HttpCookie cookie = new HttpCookie(cookieName);
                cookie.Value = cookieValue;
                cookie.Expires = dt;
                HttpContext.Current.Response.Cookies.Add(cookie);
            }
            catch { }
        }
        /// <summary>
        /// This methos is used to set cookies values.
        /// </summary>
        /// <param name="cookiesName"></param>
        /// <param name="cookieValue"></param>
        public static void SetCookiesValue(string cookiesName, string cookieValue)
        {
            try
            {
                HttpCookie cookies = new HttpCookie(cookiesName);
                cookies.Value = cookieValue;
                HttpContext.Current.Response.Cookies.Add(cookies);
            }
            catch { }
        }

        /// <summary>
        /// This methos is used to clear cookies value.
        /// </summary>
        public static void ClearCookiesValue()
        {
            try
            {
                HttpContext.Current.Request.Cookies.Clear();
            }
            catch { }
        }

        /// <summary>
        /// Method used to remove cookies.
        /// </summary>
        /// <param name="cookiesName"></param>
        public static void CookiesRemove(string cookiesName)
        {
            try
            {
                HttpCookie cookies = HttpContext.Current.Request.Cookies[cookiesName];
                cookies.Expires = DateTime.Now.AddDays(-1);
                HttpContext.Current.Response.Cookies.Set(cookies);
            }
            catch { }
        }
    }

    public class QRCode
    {
        public byte[] GetImage(string qrInfo)
        {
            IBarcodeWriter writer = new BarcodeWriter { Format = BarcodeFormat.QR_CODE };
            var result = writer.Write(qrInfo.ToString());
            Bitmap barcodeBitmap = new Bitmap(result);

            System.IO.MemoryStream stream = new System.IO.MemoryStream();
            barcodeBitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Jpeg);

            byte[] byted = ImageToByte2(barcodeBitmap);

            string base64String = Convert.ToBase64String(byted, 0, byted.Length);

            //Session["Image"] = "data:image/png;base64," + base64String;

            return byted;
        }

        public byte[] ImageToByte2(Bitmap img)
        {
            byte[] byteArray = new byte[0];
            using (System.IO.MemoryStream stream = new System.IO.MemoryStream())
            {
                img.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                stream.Close();

                byteArray = stream.ToArray();
            }
            return byteArray;
        }
    }
}