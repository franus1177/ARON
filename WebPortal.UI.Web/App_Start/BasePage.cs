using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System;
using System.Collections;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Threading;
using WebPortal.UI.Web.GlobalResource;
using ZXing;

namespace WebPortal.UI.Web.App_Start
{
    public class BasePage : System.Web.UI.Page
    {
        public static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        public String Download = "";
        public string DocumentFolderpath = "~/Areas/Safety/Documents/";
        public string TimeStamp = DateTime.Now.ToString("yyyyMMddhhmmss");

        public string NoRecordFound = Resource.Nodatafound;
        public string Close = Resource.Close;
        public string QRPowerbyLabel = "";

        public ReportDocument rd = new ReportDocument();

        CultureInfo provider = CultureInfo.InvariantCulture;
        public class LanguagePreFix
        {
            public const string English_US = "en-US";
            public const string Swedish = "sv-SE";
            //public const string Norway = "NO";
            //public const string Danish = "DA";
            //public const string Finish = "FI";
        }
        protected override void InitializeCulture()
        {
            try
            {
                string languageCode;
                Hashtable User_LoginInfo = (Hashtable)Session["User_LoginInfo"];
                languageCode = User_LoginInfo["LanguageCode"].ToString();

                string culture = "EN";

                switch (languageCode)
                {
                    case "EN": culture = LanguagePreFix.English_US; break;
                    case "SV": culture = LanguagePreFix.Swedish; break;
                    default: culture = LanguagePreFix.English_US; break;
                }
                //set culture to current thread
                Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(culture);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);

                //call base class
                base.InitializeCulture();
            }
            catch (Exception)
            {
                Response.Redirect("~/Login/");
            }
        }

        public static void SaveImage(string imagePath, string savedName, int width = 0, int height = 0)
        {
            System.Drawing.Image originalImage = System.Drawing.Image.FromFile(imagePath);
            string filePath = AppDomain.CurrentDomain.BaseDirectory + savedName;

            if (width > 0 && height > 0)
            {
                System.Drawing.Image.GetThumbnailImageAbort myCallback =
                new System.Drawing.Image.GetThumbnailImageAbort(ThumbnailCallback);
                System.Drawing.Image imageToSave = originalImage.GetThumbnailImage
                    (width, height, myCallback, IntPtr.Zero);
                imageToSave.Save(filePath, System.Drawing.Imaging.ImageFormat.Png);
            }
            else
                originalImage.Save(filePath, System.Drawing.Imaging.ImageFormat.Png);
        }
        private static bool ThumbnailCallback() { return false; }
        //End

        //ImageConverter Class convert Image object to Byte array.
        static byte[] ImageToBinary(string imagePath)
        {
            FileStream fileStream = new FileStream(imagePath, FileMode.Open, FileAccess.Read);
            byte[] buffer = new byte[fileStream.Length];
            fileStream.Read(buffer, 0, (int)fileStream.Length);
            fileStream.Close();
            return buffer;
        }

        public byte[] imgToByteArray(System.Drawing.Image img)
        {
            using (MemoryStream mStream = new MemoryStream())
            {
                img.Save(mStream, img.RawFormat);
                return mStream.ToArray();
            }
        }

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

        public void ExportTo(ReportDocument rd, string Filename)
        {
            switch (Download)
            {
                case "Word":
                    rd.ExportToHttpResponse(ExportFormatType.WordForWindows, Response, false, Filename);
                    break;
                case "PDF":
                    rd.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, false, Filename);
                    break;
                case "Excel":
                    rd.ExportToHttpResponse(ExportFormatType.Excel, Response, false, Filename);
                    break;
                case "CSV":
                    rd.ExportToHttpResponse(ExportFormatType.CharacterSeparatedValues, Response, false, Filename);
                    break;
            }
        }
    }
};