using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.InventoryRepository;

namespace WebPortal.Business.Operations.Repository
{
    public class DropDownRepository
    {
        #region Base Module

        public IEnumerable<SelectListItem> GetMenuList(string ModuleCode)
        {
            IEnumerable<SelectListItem> items = new MenuRepository().GetMenuDDL(ModuleCode);
            return items;
        }

        public IEnumerable<SelectListItem> GetTimeZone(TimeZone_VM Model)
        {
            var query = new TimeZoneRepository().GetData(null);

            IEnumerable<SelectListItem> list = query.Select(x => new SelectListItem() { Text = x.Descriptions, Value = x.TimeZoneID.ToString() }).ToList();

            return list;
        }

        public IEnumerable<SelectListItem> GetUserRole(short? UserRoleID)
        {
            List<UserRole_VM> query = new UserRoleRepository().GetData(null);
            IEnumerable<SelectListItem> list;
            if (UserRoleID != null && UserRoleID > 0)
            {
                list = query.Select(x => new SelectListItem() { Text = x.UserRoleName, Value = x.UserRoleID.ToString(), Selected = (x.UserRoleID == UserRoleID ? true : false) }).ToList();
            }
            else
            {
                list = query.Select(x => new SelectListItem() { Text = x.UserRoleName, Value = x.UserRoleID.ToString() }).ToList();
            }
            return list;
        }

        public IEnumerable<SelectListItem> GetScreen(int? ScreenID)
        {
            List<ScreenAccess_VM> query = new UserRoleRepository().GetScreen(null);
            IEnumerable<SelectListItem> list;
            if (ScreenID != null && ScreenID > 0)
            {
                list = query.Select(x => new SelectListItem() { Text = x.ScreenName, Value = x.ScreenID.ToString(), Selected = (x.UserRoleID == ScreenID ? true : false) }).ToList();
            }
            else
            {
                list = query.Select(x => new SelectListItem() { Text = x.ScreenName, Value = x.ScreenID.ToString() }).ToList();
            }
            return list;
        }

        public IEnumerable<SelectListItem> GetLanguage(string LanguageCode)
        {
            List<Language_VM> query = new CommonRepository().GetLanguageData(null);
            IEnumerable<SelectListItem> list;
            if (LanguageCode != null && LanguageCode != "")
            {
                list = query.Select(x => new SelectListItem() { Text = x.LanguageName, Value = x.LanguageCode, Selected = (x.LanguageCode == LanguageCode ? true : false) }).ToList();
            }
            else
            {
                list = query.Select(x => new SelectListItem() { Text = x.LanguageName, Value = x.LanguageCode }).ToList();
            }
            return list;
        }

        /// <summary>
        /// For Dropdown Filters autocomplete
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public IEnumerable<SelectListItem> GetCustomer(UserLocation_VM Model)
        {
            IEnumerable<Customer_VM> query = new CustomerRepository().GetUserCustomer(Model);

            IEnumerable<SelectListItem> list = query.Select(x => new SelectListItem() { Text = x.CustomerName, Value = x.CustomerID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetCustomerRootLocation(Location_VM Model)
        {
            IEnumerable<GetLocationTree_VM> query = new CustomerRepository().GetCustomerRootLocation(Model);

            IEnumerable<SelectListItem> list;

            if (Model.LocationID != null)
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString(), Selected = (x.LocationID == Model.LocationID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetCustomerAllRootLocation(Location_VM Model)
        {
            IEnumerable<GetLocationTree_VM> query = new CustomerRepository().GetCustomerAllRootLocation(Model);

            IEnumerable<SelectListItem> list;

            if (Model.LocationID != null)
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString(), Selected = (x.LocationID == Model.LocationID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetCustomerChildLocation(Location_VM Model)
        {
            IEnumerable<GetLocationTree_VM> query = new CustomerRepository().GetCustomerChildLocation(Model);

            IEnumerable<SelectListItem> list;

            if (Model.LocationID != null)
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString(), Selected = (x.LocationID == Model.LocationID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.LocationName, Value = x.LocationID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetUsers(EndUser_VM Model)
        {
            IEnumerable<EndUser_VM> query = new UserRepository().GetData(Model);

            IEnumerable<SelectListItem> list;

            if (Model.EndUserID != null)
                list = query.Select(x => new SelectListItem() { Text = x.FirstName + ' ' + x.LastName, Value = x.EndUserID.ToString(), Selected = (x.EndUserID == Model.EndUserID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.FirstName + ' ' + x.LastName, Value = x.EndUserID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetUserAll(EndUser_VM Model)
        {
            IEnumerable<EndUser_VM> query = new UserRepository().GetData(Model);

            IEnumerable<SelectListItem> list;

            if (Model.EndUserID != null)
                list = query.Select(x => new SelectListItem() { Text = x.FirstName + x.LastName, Value = x.EndUserID.ToString(), Selected = (x.EndUserID == Model.EndUserID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.FirstName + x.LastName, Value = x.EndUserID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetUser(EndUser_VM Model)
        {
            IEnumerable<EndUser_VM> query = new UserRepository().GetData(Model);

            IEnumerable<SelectListItem> list;

            if (Model.EndUserID != null)
                list = query.Select(x => new SelectListItem() { Text = x.LoginID + " ( " + x.EmailID + " ) ", Value = x.EndUserID.ToString(), Selected = (x.EndUserID == Model.EndUserID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.LoginID + " ( " + x.EmailID + " ) ", Value = x.EndUserID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetAccountManagerUser(Customer_VM Model)
        {
            IEnumerable<Customer_VM> query = new CustomerRepository().GetData(Model);

            IEnumerable<SelectListItem> list;

            if (Model.AccountManagerID != null)
                list = query.Select(x => new SelectListItem() { Text = x.AccountManagerName, Value = x.AccountManagerID.ToString(), Selected = (x.AccountManagerID == Model.AccountManagerID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.AccountManagerName, Value = x.AccountManagerID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="Model"></param>
        /// <returns></returns>
        public IEnumerable<SelectListItem> GetFixture(Fixture_VM Model)
        {
            IEnumerable<Fixture_VM> query = new FixtureRepository().GetData(Model);

            IEnumerable<SelectListItem> list;

            if (Model.FixtureID != null)
                list = query.Select(x => new SelectListItem() { Text = x.FixtureName + " (" + x.FixtureCost + ")", Value = x.FixtureID.ToString(), Selected = (x.FixtureID == Model.FixtureID ? true : false) }).ToList();
            else
                list = query.Select(x => new SelectListItem() { Text = x.FixtureName + " (" + x.FixtureCost + ")", Value = x.FixtureID.ToString() }).ToList();

            return list.OrderBy(x => x.Text);
        }

        #endregion Base Module
    }
};