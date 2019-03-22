namespace WebPortal.Business.Entities.ViewModels
{
    public class FileModel : Base_VM
    {
        public int LocationID { get; set; }
        public string ObjectType { get; set; }
        public string LocationName { get; set; }

        public int ObjectPhotoID { get; set; }
        public string FileNameSmall { get; set; }
        public string FileTypeSmall { get; set; }
        public int FileSizeSmall { get; set; }
        public string FileRemarksSmall { get; set; }
        public long FileID { get; set; }
        public string FileRelativePath { get; set; }
    }
};
