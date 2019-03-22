using System;

namespace WebPortal.Business.Entities.InventoryModels
{
    public class POItem_TableType_VM
    {
        public Nullable<int> FixtureID { get; set; }

        public Nullable<int> POFixtureQuantity { get; set; }

        public Nullable<decimal> FixtureCommision { get; set; }

        public Nullable<decimal> FixturePrice { get; set; }
    }

    public class POItem_TableType_VM2: POItem_TableType_VM
    {
        public Nullable<decimal> FixtureCost { get; set; }
    }
};