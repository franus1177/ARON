using System;

namespace WebPortal.Business.Entities.ViewModels
{
    public abstract class Base_VM
    {
        public Nullable<bool> IsActive { get; set; }

        public string id { get; set; }
        public string GlobalID { get; set; }

        #region Login User Details

        public int CurrentEndUserID { get; set; }

        public int CurrentUserRoleID { get; set; }

        public short CurrentScreenID { get; set; }

        public string AccessPoint { get; set; }

        public string CurrentLanguageCode { get; set; }

        public decimal? CurrentUTCOffset { get; set; }

        #endregion Login User Details

        #region Data formating

        internal string DateFormat(DateTime? date)
        {
            if (date != null)
                return Convert.ToDateTime(date.ToString()).ToString("dd-MMM-yyyy");
            return string.Empty;
        }

        internal string DateTimeAMPMFormat(DateTime? date)
        {
            if (date != null)
            {
                var sec = Convert.ToDateTime(date.ToString()).Second;
                var str = ":ss";
                /*if (sec == 0)*/
                str = "";
                return Convert.ToDateTime(date.ToString()).ToString("dd-MMM-yyyy hh:mm" + str + " tt");
            }

            return string.Empty;
        }

        internal string TimeAMPMFormat(DateTime? date)
        {
            if (date != null)
            {
                var sec = Convert.ToDateTime(date.ToString()).Second;
                var str = ":ss";
                //if (sec == 0)
                str = "";
                return Convert.ToDateTime(date.ToString()).ToString("hh:mm" + str + " tt");
            }

            return string.Empty;
        }

        internal string TimeFormat(TimeSpan? date)
        {
            if (date != null)
            {
                var sec = Convert.ToDateTime(date.ToString()).Second;
                var str = ":ss";
                //if (sec == 0)
                str = "";
                return Convert.ToDateTime(date.ToString()).ToString("hh:mm" + str + " tt");
            }

            return string.Empty;
        }

        public bool SequenceColumn { get; set; }

        #endregion Data formating

        public string CurrentModuleCode { get; set; }

        public string CurrentServiceLineCode { get; set; }

        #region Grid Pagining lazy
        /// <summary>
        /// Used for grid lazy pagining
        /// </summary>
        /// 
        public bool? IsChildResult { get; set; }
        public int? PageIndex { get; set; }
        public int? PageCount { get; set; }

        #endregion Grid Pagining lazy
    }
};