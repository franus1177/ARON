using AutoMapper;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.Entity.Core.Objects;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using WebPortal.Business.Entities.EF;

namespace WebPortal.Common.Utilities.Global
{
    public class FileSystem
    {
        public static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        /// <summary>
        /// Save file
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public FolderFile_VM AddFile(FolderFile_VM Model, HttpPostedFileBase file, string path)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        Model.FileName = file.FileName;
                        Model.FileType = Path.GetExtension(file.FileName).Replace(".", "").ToLower();
                        //Model.FileSize = file.ContentLength;

                        ObjectParameter pFileID = new ObjectParameter("pFileID", 0);
                        ObjectParameter pFileRelativePath = new ObjectParameter("pFileRelativePath", "");

                        db.AddFile(Model.ObjectType, Model.ObjectInstanceID, Model.FileName, Model.FileType, Model.FileSize, Model.FileRemarks, pFileID, pFileRelativePath);
                        db.SaveChanges();

                        Model.FileID = Convert.ToInt32(pFileID.Value);
                        Model.FileRelativePath = pFileRelativePath.Value.ToString();
                        Model.FileRelativePath = path + Model.FileRelativePath;

                        UploadFiles(file, Model.FileRelativePath, Model);

                        trans.Commit();
                        return Model;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_AddFile Error: ", ex);
                        throw;
                    }
                }
            }

        }

        /// <summary>
        /// Upload Files
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        public bool UploadFiles(HttpPostedFileBase file, string path, FolderFile_VM Model)
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
                    {
                        Directory.CreateDirectory(Path.Combine(path));
                    }

                    file.SaveAs(Path.Combine(p + "." + Model.FileType));

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
        /// Delete File Physically 
        /// </summary>
        /// <param name="filePath"></param>
        /// <returns></returns>
        public bool DeleteFilePhysical(string filePath)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                try
                {
                    File.Delete(filePath);
                    return true;
                }
                catch (IOException iox)
                {
                    logger.Error("FileSystem_DeleteFilePhysical Error: ", iox);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("FileSystem_DeleteFilePhysical Error: ", ex);
                    throw;
                }
            }
        }

        /// <summary>
        /// Hard delete file
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public bool RemoveFile(FolderFile_VM Model,string filePath)
        {
            FolderFile_VM model = new FolderFile_VM();
            using (WebPortalEntities db = new WebPortalEntities())
            {
                try
                {
                    model = GetFileInfo(Model);
                    db.RemoveFile(Model.FileID, model.TxnTimestamp);
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
        /// Soft delete file
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public bool DeleteFile(FolderFile_VM Model)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        db.DeleteFile(Model.FileID, Model.TxnTimestamp);
                        db.SaveChanges();
                        trans.Commit();

                        return true;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_DeleteFile Error: ", ex);
                        throw;
                    }
                }
            }
        }

        /// <summary>
        /// UnDelete File
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public bool UnDeleteFile(FolderFile_VM Model)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        db.UnDeleteFile(Model.FileID, Model.TxnTimestamp);
                        db.SaveChanges();
                        trans.Commit();

                        return true;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_UnDeleteFile Error: ", ex);
                        throw;
                    }
                }
            }
        }

        /// <summary>
        /// Update File Info
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public FolderFile_VM UpdateFileInfo(FolderFile_VM Model)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        ObjectParameter pTxnTimestamp = new ObjectParameter("pTxnTimestamp", Model.TxnTimestamp);

                        db.UpdateFileInfo(Model.FileID, Model.FileRemarks, pTxnTimestamp);
                        db.SaveChanges();
                        trans.Commit();

                        Model.TxnTimestamp = (byte[])pTxnTimestamp.Value;
                        return Model;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_UpdateFileInfo Error: ", ex);
                        throw;
                    }
                }
            }

        }

        /// <summary>
        /// Get File Info
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public FolderFile_VM GetFileInfo(FolderFile_VM Model)
        {
            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
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
                        trans.Commit();

                        Model.FileRelativePath = pFileRelativePath.Value.ToString();
                        Model.FileName = pFileName.Value.ToString();
                        Model.FileType = pFileType.Value.ToString();
                        Model.FileRemarks = pFileRemarks.Value.ToString();
                        Model.CreatedDateTime = Convert.ToDateTime(pCreatedDateTime.Value);

                        if(pLastAccessDateTime.Value != DBNull.Value)
                            Model.LastAccessDateTime = Convert.ToDateTime(pLastAccessDateTime.Value);

                        Model.AccessCount = Convert.ToInt32(pAccessCount.Value);
                        Model.TxnTimestamp = (byte[])pTxnTimestamp.Value;

                        return Model;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_GetFileInfo Error: ", ex);
                        throw;
                    }
                }
            }

        }

        /// <summary>
        /// Get Files Info
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public List<FolderFile_VM> GetFilesInfo(FolderFile_VM Model)
        {
            List<FolderFile_VM> model = new List<FolderFile_VM>();

            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {

                        DataTable dt_FileIDModule = new DataTable();
                        if (Model.FileID_TableTypeList != null && Model.FileID_TableTypeList.Count > 0)
                            dt_FileIDModule = ConvertToDatatable(Model.FileID_TableTypeList);
                        else
                            dt_FileIDModule = ConvertToDatatable(new List<FileID_TableType_VM>());

                        var par = new SqlParameter[] {
                                new SqlParameter("@pFileTable", dt_FileIDModule) { TypeName = "FileID_TableType" }
                            };

                        model = db.Database.SqlQuery<FolderFile_VM>("exec GetFilesInfo", par).ToList();

                        trans.Commit();

                        return model;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_GetFilesInfo Error: ", ex);
                        throw;
                    }
                }
            }

        }

        /// <summary>
        /// Get Deleted Files Info
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public List<FolderFile_VM> GetDeletedFilesInfo(FolderFile_VM Model)
        {
            List<FolderFile_VM> model = new List<FolderFile_VM>();

            using (WebPortalEntities db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        var config = new MapperConfiguration(cfg => cfg.CreateMap<GetDeletedFilesInfo_Result, FolderFile_VM>());
                        var mapper = config.CreateMapper();
                        List<GetDeletedFilesInfo_Result> data = db.GetDeletedFilesInfo(Model.FileName, Model.FileType, Model.FileRemarks).ToList();
                        mapper.Map<List<GetDeletedFilesInfo_Result>, List<FolderFile_VM>>(data, model);

                        trans.Commit();
                        return model;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        logger.Error("FileSystem_GetDeletedFilesInfo Error: ", ex);
                        throw;
                    }
                }
            }

        }

        public DataTable ConvertToDatatable<T>(List<T> data)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            DataTable table = new DataTable();
            for (int i = 0; i < props.Count; i++)
            {
                PropertyDescriptor prop = props[i];
                if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>))
                    table.Columns.Add(prop.Name, prop.PropertyType.GetGenericArguments()[0]);
                else
                    table.Columns.Add(prop.Name, prop.PropertyType);
            }
            object[] values = new object[props.Count];
            foreach (T item in data)
            {
                for (int i = 0; i < values.Length; i++)
                {
                    values[i] = props[i].GetValue(item);
                }
                table.Rows.Add(values);
            }
            return table;
        }

    }
    public class Folder_VM
    {
        [Key]
        public int? FolderID { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(250)]
        [Display(Name = "Folder Path")]
        public string FolderPath { get; set; }
    }

    public class FolderFile_VM
    {
        [Key]
        public Int64? FileID { get; set; }
        public int? FolderID { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(20)]
        [Display(Name = "Object Type")]
        public string ObjectType { get; set; }
        public int ObjectInstanceID { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(100)]
        [Display(Name = "File Name")]
        public string FileName { get; set; }

        [Required(ErrorMessageResourceName = "Required")]
        [MaxLength(10)]
        [Display(Name = "File Type")]
        public string FileType { get; set; }
        public Int64 FileSize { get; set; }

        [MaxLength(200)]
        [Display(Name = "File Remarks")]
        public string FileRemarks { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime? LastAccessDateTime { get; set; }
        public DateTime? DeletedDateTime { get; set; }
        public int AccessCount { get; set; }
        public virtual byte[] TxnTimestamp { get; set; }
        public int? DocumentID { get; set; }

        [MaxLength(250)]
        [Display(Name = "File Relative Path")]
        public string FileRelativePath { get; set; }

        //[Required]
        public List<FileID_TableType_VM> FileID_TableTypeList { get; set; }
    }
    public class FileID_TableType_VM
    {
        public Int64 FileID { get; set; }
    }
};