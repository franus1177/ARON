using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System;

namespace WebPortal.Business.Entities.ViewModels
{
	public class CustomerWeeklyOffName_TableType_VM
	{
        [Required]
        public string DayName { get; set; }
    }
};
