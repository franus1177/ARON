using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using WebPortal.Business.Entities.InventoryModels;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.Repository;

namespace WebPortal.Business.Operations.InventoryRepository
{
    public class DropDownInventory
    {
        public IEnumerable<SelectListItem> GetPart(Part_VM Model)
        {
            IEnumerable<Part_VM> query = new PartRepository().GetData(Model);

            IEnumerable<SelectListItem> list = query.Select(x => new SelectListItem() { Text = x.PartName, Value = x.PartID.ToString() }).ToList();

            return list;//.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetFixture(Fixture_VM Model)
        {
            IEnumerable<Fixture_VM> query = new FixtureRepository().GetData(Model);

            IEnumerable<SelectListItem> list = query.Select(x => new SelectListItem() { Text = x.FixtureName, Value = x.FixtureID.ToString() }).ToList();

            return list;//.OrderBy(x => x.Text);
        }

        public IEnumerable<SelectListItem> GetCustomerDDL(CustomerDDL_VM Model)
        {
            IEnumerable<CustomerDDL_VM> query = new CustomerRepository().GetDataDDL(Model);

            IEnumerable<SelectListItem> list = query.Select(x => new SelectListItem() { Text = x.CustomerName, Value = x.CustomerID.ToString() }).ToList();

            return list;//.OrderBy(x => x.Text);
        }
    }
};