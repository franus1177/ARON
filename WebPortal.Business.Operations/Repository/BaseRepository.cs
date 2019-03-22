using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Web;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.Utility;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Operations.Repository
{
    public abstract class BaseRepository
    {
        public static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public string GetDateFormat(DateTime? date, string format)
        {
            string formattedDate = string.Empty;
            try
            {
                formattedDate = (Convert.ToDateTime(date)).ToString(format, CultureInfo.InvariantCulture);
            }
            catch { }
            return formattedDate;
        }
        public string GetDateToSystem(DateTime date)
        {
            var day = date.Day;
            var month = date.Month;
            var year = date.Year;
            return year + "-" + month + "-" + day;
        }
        public static object GetDBNULL(object Value)
        {
            if (Value == null) Value = DBNull.Value;
            return Value;
        }
        public static object GetDBNULLString(object Value)
        {
            if (Value == null || ((string)Value) == "") return Value = DBNull.Value;
            return Value;
        }
        public static object GetDBNULL(object Value, bool IsInteger)
        {
            if (Value == null) return Value = DBNull.Value;
            try
            {
                if (IsInteger) if (Convert.ToInt32(Value) == 0) Value = DBNull.Value;
            }
            catch (Exception)
            {
            }
            return Value;
        }

        //public static void DuckCopyShallow(Object dst, object src)
        //{
        //    var srcT = src.GetType();
        //    var dstT = dst.GetType();
        //    foreach (var f in srcT.GetFields())
        //    {
        //        var dstF = dstT.GetField(f.Name);
        //        if (dstF == null)
        //            continue;
        //        dstF.SetValue(dst, f.GetValue(src));
        //    }

        //    foreach (var f in srcT.GetProperties())
        //    {
        //        var dstF = dstT.GetProperty(f.Name);
        //        if (dstF == null)
        //            continue;

        //        dstF.SetValue(dst, f.GetValue(src, null), null);
        //    }
        //}

        public DataTable ConvertToDatatable<T>(List<T> data)
        {
           return Common.ConvertToDatatable<T>(data);

            //PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            //DataTable table = new DataTable();
            //for (int i = 0; i < props.Count; i++)
            //{
            //    PropertyDescriptor prop = props[i];
            //    if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>))
            //        table.Columns.Add(prop.Name, prop.PropertyType.GetGenericArguments()[0]);
            //    else
            //        table.Columns.Add(prop.Name, prop.PropertyType);
            //}
            //object[] values = new object[props.Count];
            //foreach (T item in data)
            //{
            //    for (int i = 0; i < values.Length; i++)
            //    {
            //        values[i] = props[i].GetValue(item);
            //    }
            //    table.Rows.Add(values);
            //}
            //return table;
        }

        public static List<T> ConvertToList<T>(DataTable dt)
        {
            return Common.ConvertToList<T>(dt);

            //var data = new List<T>();
            //foreach (DataRow row in dt.Rows)
            //{
            //    T item = GetItem<T>(row);
            //    data.Add(item);
            //}

            //return data;
        }

        /// <summary>
        /// Upload Image to server
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public bool UploadImage(Image file, string path, string fileType)
        {
            if (file != null)
            {
                try
                {
                    var p = path;
                    int index = path.LastIndexOf("\\");
                    if (index > 0)
                        path = path.Substring(0, index); // or index + 1 to keep slash

                    if (!Directory.Exists(path))
                        Directory.CreateDirectory(Path.Combine(path));

                    file.Save(Path.Combine(p + "." + fileType));

                    return true;
                }
                catch (Exception ex)
                {
                    logger.Error("BaseRepository_UploadFiles Error: ", ex);
                    throw;
                }
            }
            else
                return false;
        }

        /// <summary>
        /// Can upload any type File to server
        /// </summary>
        /// <param name="file"></param>
        /// <param name="path"></param>
        /// <param name="fileType"></param>
        /// <returns></returns>
        public bool UploadFile(HttpPostedFileBase file, string path, string fileType)
        {
            if (file.FileName != null)
            {
                try
                {
                    var p = path;
                    int index = path.LastIndexOf("\\");
                    if (index > 0)
                        path = path.Substring(0, index); // or index + 1 to keep slash

                    if (!Directory.Exists(path))
                        Directory.CreateDirectory(Path.Combine(path));

                    file.SaveAs(Path.Combine(p + "." + fileType));

                    return true;
                }
                catch (Exception ex)
                {
                    logger.Error("FileSystem_UploadFiles Error: ", ex);
                    throw;
                }
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Hard delete file
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public bool RemoveFile(File_VM Model, string filePath)
        {
            File_VM model = new File_VM();
            using (var db = new WebPortalEntities())
            {
                try
                {
                    model = GetFileInfo(Model);
                    db.RemoveFile(model.FileID, model.TxnTimestamp);
                    db.SaveChanges();

                    DeleteFilePhysical(filePath + model.FileRelativePath + "." + model.FileType);

                    return true;
                }
                catch (Exception ex)
                {
                    logger.Error("FileSystem_RemoveFile Error: ", ex);
                    throw;
                }
            }
        }

        /// <summary>
        /// Get File Info
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public File_VM GetFileInfo(File_VM Model)
        {
            using (var db = new WebPortalEntities())
            {
                try
                {
                    ObjectParameter pFileRelativePath = new ObjectParameter("pFileRelativePath", DBNull.Value);
                    ObjectParameter pFileName = new ObjectParameter("pFileName", DBNull.Value);
                    ObjectParameter pFileType = new ObjectParameter("pFileType", DBNull.Value);
                    ObjectParameter pFileRemarks = new ObjectParameter("pFileRemarks", DBNull.Value);
                    ObjectParameter pCreatedDateTime = new ObjectParameter("pCreatedDateTime", DBNull.Value);
                    ObjectParameter pLastAccessDateTime = new ObjectParameter("pLastAccessDateTime", DBNull.Value);
                    ObjectParameter pAccessCount = new ObjectParameter("pAccessCount", 0);
                    ObjectParameter pTxnTimestamp = new ObjectParameter("pTxnTimestamp", DBNull.Value);

                    db.GetFileInfo(Model.FileID, pFileRelativePath, pFileName, pFileType, pFileRemarks, pCreatedDateTime, pLastAccessDateTime, pAccessCount, pTxnTimestamp);
                    db.SaveChanges();

                    if (pFileRelativePath.Value != DBNull.Value)
                        Model.FileRelativePath = pFileRelativePath.Value.ToString();

                    if (pFileName.Value != DBNull.Value)
                        Model.FileName = pFileName.Value.ToString();

                    if (pFileType.Value != DBNull.Value)
                        Model.FileType = pFileType.Value.ToString();

                    if (pFileRemarks.Value != DBNull.Value)
                        Model.FileRemarks = pFileRemarks.Value.ToString();

                    if (pCreatedDateTime.Value != DBNull.Value)
                        Model.CreatedDateTime = Convert.ToDateTime(pCreatedDateTime.Value);

                    if (pLastAccessDateTime.Value != DBNull.Value)
                        Model.LastAccessDateTime = Convert.ToDateTime(pLastAccessDateTime.Value);

                    if (pAccessCount.Value != DBNull.Value)
                        Model.AccessCount = Convert.ToInt32(pAccessCount.Value);

                    if (pTxnTimestamp.Value != DBNull.Value)
                        Model.TxnTimestamp = (byte[])pTxnTimestamp.Value;

                    return Model;
                }
                catch (Exception ex)
                {
                    logger.Error("FileSystem_GetFileInfo Error: ", ex);
                    throw;
                }
            }

        }

        /// <summary>
        /// Delete File Physically 
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public bool DeleteFilePhysical(string filePath)
        {
            try
            {
                if (File.Exists(filePath))
                    File.Delete(filePath);

                return true;
            }
            catch (IOException iox)
            {
                logger.Error("BaseRepository_DeleteFilePhysical Error: ", iox);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("BaseRepository_DeleteFilePhysical Error: ", ex);
                throw;
            }
        }

        public static byte[] imgToByteConverter(Image inImg)
        {
            ImageConverter imgCon = new ImageConverter();
            return (byte[])imgCon.ConvertTo(inImg, typeof(byte[]));
        }
    }
};