using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Entities.InventoryModels
{
    public class PurchaseOrder_VM : Base_VM
    {
        [Key]
        //[Required]
        public Nullable<int> POID { get; set; }

        [MaxLength(50)]
        public string PONumber { get; set; }

        public Nullable<int> POItemID { get; set; }
        public Nullable<int> CustomerID { get; set; }
        public string CustomerName { get; set; }

        public Nullable<DateTime> PORecDate { get; set; }
        public string PORecDateCustom { get { return DateFormat(PORecDate); } }

        public Nullable<DateTime> POEstShipDate { get; set; }

        public string POEstShipDateCustom { get { return DateFormat(POEstShipDate); } }

        public Nullable<DateTime> POActShipDate { get; set; }

        public string POActShipDateCustom { get { return DateFormat(POActShipDate); } }

        public Nullable<decimal> POCost { get; set; }

        public Nullable<decimal> POPrice { get; set; }

        public Nullable<bool> POCompleted { get; set; }

        public string POCompletedStatus
        {
            get
            {
                if (POCompleted == true)
                    return "Completed";
                else
                    return "Pending...";
            }
        }

        public Nullable<DateTime> CreatedAt { get; set; }
        public string CreatedAtName { get; set; }

        public Nullable<int> POPartID { get; set; }

        public List<POItem_VM> POItemList { get; set; }

        [Required]
        public List<POItem_TableType_VM> POItem_TableTypeList { get; set; }
        public List<POItem_TableType_VM2> POItem_TableTypeList2 { get; set; }

        
        public List<POPart_VM> POPartList { get; set; }

        //[Required]
        public List<POPart_TableType_VM> POPart_TableTypeList { get; set; }
    }

    public class PurchaseOrderPart_VM : Base_VM
    {
        [Key]
        //[Required]
        public Nullable<int> POID { get; set; }

        public List<POPart_TableType_VM> POPart_TableTypeList { get; set; }
    }
};