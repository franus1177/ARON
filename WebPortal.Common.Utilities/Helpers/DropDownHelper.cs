using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.Common.Utilities.Helpers
{
    public class DropDownHelper
    {
        #region General static dropdowns

        public static IEnumerable<SelectListItem> Get_PageSize_DropDown_List()
        {
            List<SelectListItem> data = new List<SelectListItem>();

            data.Add(new SelectListItem() { Text = "2", Value = "2", Selected = true });
            data.Add(new SelectListItem() { Text = "3", Value = "3", Selected = true });
            data.Add(new SelectListItem() { Text = "5", Value = "5", Selected = true });
            data.Add(new SelectListItem() { Text = "10", Value = "10", Selected = true });
            data.Add(new SelectListItem() { Text = "20", Value = "20", Selected = false });
            data.Add(new SelectListItem() { Text = "30", Value = "30", Selected = false });
            data.Add(new SelectListItem() { Text = "50", Value = "50", Selected = false });
            data.Add(new SelectListItem() { Text = "100", Value = "100", Selected = false });

            return data;
        }

        public static IEnumerable<SelectListItem> Get_Status_Dropdown_List()
        {
            List<SelectListItem> data = new List<SelectListItem>();

            data.Add(new SelectListItem() { Text = "Pending", Value = "1", Selected = true });
            data.Add(new SelectListItem() { Text = "Accepted", Value = "2", Selected = false });

            return data;
        }

        public static IEnumerable<SelectListItem> Get_Duration_DropDown_List()
        {
            List<SelectListItem> data = new List<SelectListItem>();

            data.Add(new SelectListItem() { Text = "1", Value = "1", Selected = true });
            data.Add(new SelectListItem() { Text = "2", Value = "2", Selected = false });
            data.Add(new SelectListItem() { Text = "3", Value = "3", Selected = false });
            //data.Add(new SelectListItem() { Text = "4", Value = "4", Selected = false });
            //data.Add(new SelectListItem() { Text = "5", Value = "5", Selected = false });
            data.Add(new SelectListItem() { Text = "6", Value = "6", Selected = false });
            //data.Add(new SelectListItem() { Text = "7", Value = "7", Selected = false });
            //data.Add(new SelectListItem() { Text = "8", Value = "8", Selected = false });
            //data.Add(new SelectListItem() { Text = "9", Value = "9", Selected = false });
            //data.Add(new SelectListItem() { Text = "10", Value = "10", Selected = false });

            //data.Add(new SelectListItem() { Text = "11", Value = "11", Selected = false });
            data.Add(new SelectListItem() { Text = "12", Value = "12", Selected = false });
            //data.Add(new SelectListItem() { Text = "13", Value = "13", Selected = false });
            //data.Add(new SelectListItem() { Text = "14", Value = "14", Selected = false });
            //data.Add(new SelectListItem() { Text = "15", Value = "15", Selected = false });
            //data.Add(new SelectListItem() { Text = "16", Value = "16", Selected = false });
            //data.Add(new SelectListItem() { Text = "17", Value = "17", Selected = false });
            data.Add(new SelectListItem() { Text = "18", Value = "18", Selected = false });
            //data.Add(new SelectListItem() { Text = "19", Value = "19", Selected = false });
            //data.Add(new SelectListItem() { Text = "20", Value = "20", Selected = false });

            //data.Add(new SelectListItem() { Text = "21", Value = "21", Selected = false });
            //data.Add(new SelectListItem() { Text = "22", Value = "22", Selected = false });
            //data.Add(new SelectListItem() { Text = "23", Value = "23", Selected = false });
            data.Add(new SelectListItem() { Text = "24", Value = "24", Selected = false });
            //data.Add(new SelectListItem() { Text = "25", Value = "25", Selected = false });
            //data.Add(new SelectListItem() { Text = "26", Value = "26", Selected = false });
            //data.Add(new SelectListItem() { Text = "27", Value = "27", Selected = false });
            //data.Add(new SelectListItem() { Text = "28", Value = "28", Selected = false });
            //data.Add(new SelectListItem() { Text = "29", Value = "29", Selected = false });
            data.Add(new SelectListItem() { Text = "30", Value = "30", Selected = false });

            //data.Add(new SelectListItem() { Text = "31", Value = "31", Selected = false });
            //data.Add(new SelectListItem() { Text = "32", Value = "32", Selected = false });
            //data.Add(new SelectListItem() { Text = "33", Value = "33", Selected = false });
            //data.Add(new SelectListItem() { Text = "34", Value = "34", Selected = false });
            //data.Add(new SelectListItem() { Text = "35", Value = "35", Selected = false });
            data.Add(new SelectListItem() { Text = "36", Value = "36", Selected = false });

            return data;
        }
        public static IEnumerable<SelectListItem> Get_Months_DropDown_List()
        {
            List<SelectListItem> data = new List<SelectListItem>();

            data.Add(new SelectListItem() { Text = "1", Value = "1", Selected = true });
            data.Add(new SelectListItem() { Text = "2", Value = "2", Selected = false });
            data.Add(new SelectListItem() { Text = "3", Value = "3", Selected = false });
            data.Add(new SelectListItem() { Text = "4", Value = "4", Selected = false });
            data.Add(new SelectListItem() { Text = "5", Value = "5", Selected = false });
            data.Add(new SelectListItem() { Text = "6", Value = "6", Selected = false });
            data.Add(new SelectListItem() { Text = "7", Value = "7", Selected = false });
            data.Add(new SelectListItem() { Text = "8", Value = "8", Selected = false });
            data.Add(new SelectListItem() { Text = "9", Value = "9", Selected = false });
            data.Add(new SelectListItem() { Text = "10", Value = "10", Selected = false });

            data.Add(new SelectListItem() { Text = "11", Value = "11", Selected = false });
            data.Add(new SelectListItem() { Text = "12", Value = "12", Selected = false });
            data.Add(new SelectListItem() { Text = "13", Value = "13", Selected = false });
            data.Add(new SelectListItem() { Text = "14", Value = "14", Selected = false });
            data.Add(new SelectListItem() { Text = "15", Value = "15", Selected = false });
            data.Add(new SelectListItem() { Text = "16", Value = "16", Selected = false });
            data.Add(new SelectListItem() { Text = "17", Value = "17", Selected = false });
            data.Add(new SelectListItem() { Text = "18", Value = "18", Selected = false });
            data.Add(new SelectListItem() { Text = "19", Value = "19", Selected = false });
            data.Add(new SelectListItem() { Text = "20", Value = "20", Selected = false });

            data.Add(new SelectListItem() { Text = "21", Value = "21", Selected = false });
            data.Add(new SelectListItem() { Text = "22", Value = "22", Selected = false });
            data.Add(new SelectListItem() { Text = "23", Value = "23", Selected = false });
            data.Add(new SelectListItem() { Text = "24", Value = "24", Selected = false });
            data.Add(new SelectListItem() { Text = "25", Value = "25", Selected = false });
            data.Add(new SelectListItem() { Text = "26", Value = "26", Selected = false });
            data.Add(new SelectListItem() { Text = "27", Value = "27", Selected = false });
            data.Add(new SelectListItem() { Text = "28", Value = "28", Selected = false });
            data.Add(new SelectListItem() { Text = "29", Value = "29", Selected = false });
            data.Add(new SelectListItem() { Text = "30", Value = "30", Selected = false });

            //data.Add(new SelectListItem() { Text = "31", Value = "31", Selected = false });
            //data.Add(new SelectListItem() { Text = "32", Value = "32", Selected = false });
            //data.Add(new SelectListItem() { Text = "33", Value = "33", Selected = false });
            //data.Add(new SelectListItem() { Text = "34", Value = "34", Selected = false });
            //data.Add(new SelectListItem() { Text = "35", Value = "35", Selected = false });
            //data.Add(new SelectListItem() { Text = "36", Value = "36", Selected = false });

            return data;
        }

        #endregion

        public static IEnumerable<SelectListItem> GetUserType()
        {
            List<SelectListItem> data = new List<SelectListItem>();

            data.Add(new SelectListItem() { Text = "Organization Level", Value = "Organization Level", Selected = true });
            data.Add(new SelectListItem() { Text = "Customer Level", Value = "Customer Level", Selected = false });

            return data;
        }
    }
}