using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WebPortal.Business.Entities.ViewModels
{
    public class Menu_VM : Base_VM
    {
        [Key]
        public string MenuCode { get; set; }
        [Required(ErrorMessageResourceName = "Menu Name Required")]
        public string MenuName { get; set; }
        [Required(ErrorMessageResourceName = "Sequence Required")]
        public byte Sequence { get; set; }
        [Required(ErrorMessageResourceName = "Parent MenuCode Required")]
        public string ParentMenuCode { get; set; }
        public string ModuleCode { get; set; }
    }

    public class MenuScreen_VM : Base_VM
    {
        public string ModuleCode { get; set; }
        public string ObjectName { get; set; }
        public bool IsObjectMenu { get; set; }
        public short Sequence { get; set; }//why this is short it should be byte
        public string MenuCode { get; set; }
        public Int16? ScreenID { get; set; }
        public bool? HasInsert { get; set; }
        public bool? HasUpdate { get; set; }
        public bool? HasDelete { get; set; }
        public bool? HasSelect { get; set; }
        public bool? HasImport { get; set; }
        public bool? HasExport { get; set; }
        public string EncryptScreenID { get; set; }
    }

    public class Accesspermission_Wrapper {

       public List<MenuScreen_VM> MenuList = new List<MenuScreen_VM>();
        public List<ScreenAction_VM> ScreenActionList = new List<ScreenAction_VM>();
    }

    public enum EnumScreenAccess
    {
        HasInsert = 1,
        HasUpdate = 2,
        HasDelete = 3,
        HasSelect = 4,
        HasImport = 5,
        HasExport = 6
    };

    //public class Module_VM
    //{
    //    public int? EndUserID { get; set; }
    //    public string ModuleCode { get; set; }
    //    public string ModuleName { get; set; }
    //}
}
