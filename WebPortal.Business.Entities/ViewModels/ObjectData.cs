using System;
using System.Collections.Generic;

namespace WebPortal.Business.Entities.ViewModels
{
    public class ObjectData :Base_VM
    {

        public int CustomerID { get; set; }
        public int LocationID { get; set; }
        //Object Data
        public int? ObjectID { get; set; }
        public string ObjectCode { get; set; }
        public DateTime DateYearBuilt { get; set; }
        public DateTime DateLastRemodeled { get; set; }
        public int? NumberOfFloorsItem { get; set; }
        public int? NumberOfBasementsObject { get; set; }
        public int? TotalAreaDevoted { get; set; }
        public int? Maxnoofemployee { get; set; }
        public int? Minnoofemployee { get; set; }
        public int? Maxnoofpersons { get; set; }
        public string GeneralBusiness { get; set; }
        public string Residencial { get; set; }
        public string Industry { get; set; }
        public string OtherActivities { get; set; }
        public int? ActivitiesDuringDay { get; set; }
        public int? ActivitiesRunsOnNight { get; set; }
        public int? ResponsibilityforFireSafety { get; set; }
        public int? HandlingOfFlammable { get; set; }
        public string Basement { get; set; }
        public string VillagesActivityCarriedOut { get; set; }
        public int? Handlingover { get; set; }
        public string BrieflyDescription { get; set; }
        //
        //Fire protection operation and maintenance
        public int? AgreedResponsibilities { get; set; }
        public int? RoutineMaitenance { get; set; }
        public int? StaffCompetence { get; set; }
        public int? Ifyesmaintenance { get; set; }
        public int? AreRemedying { get; set; }
        public int? AreThereDocumented { get; set; }
        public int? AreCurrentFireProtection { get; set; }
        //
        //Preparedness for fire :
        public int? ThereAnyPlanning { get; set; }
        public int? AreEvacuation { get; set; }
        public int? AreAllStaff { get; set; }
        public int? BusinessDependent { get; set; }
        public int? ThereDivision { get; set; }
        public int? AreCoordinated { get; set; }
        public int? IsThereEmergency { get; set; }
        public int? Documented { get; set; }
        public int? DoEveryoneInformation  { get; set; }
        public int? DoesTheStaffcompetence { get; set; }
        public int? MaintainedAndGuaranteed { get; set; }
        public int? ThroughPractical { get; set; }
        public int? collaborationPlanned { get; set; }
        public string comments { get; set; }

        public string LocationName { get; set; }
        public string ObjectName { get; set; }
        public string CategoryName { get; set; }
        public int ScheduledCount { get; set; }
        public string Status { get; set; }
        public string ScheduledMonth { get; set; }
        public string ScheduledYear { get; set; }
        public int CheckedCount { get; set; }
        public int ObjectInstanceCount { get; set; }

        public string StatusPercentage
        {
            get
            {
                if (ScheduledCount != 0 && ObjectInstanceCount != 0)
                {
                   float StatusPercentage= CheckedCount / (ScheduledCount * ObjectInstanceCount);
                    StatusPercentage = StatusPercentage * 100;
                    return Convert.ToString(StatusPercentage) +'%';
                }
                else
                {
                    return Convert.ToString(0) + '%';
                }

            }
            //set { CreatedDate = value; }
        }

        public string StatusCount
        {
            get
            {
                if (ScheduledCount != 0 && ObjectInstanceCount != 0)
                {
                    float ScheduledObjectMultiply = ScheduledCount * ObjectInstanceCount;
                    return " ( "+Convert.ToString(CheckedCount)+" / " + Convert.ToString(ScheduledObjectMultiply)+" ) ";
                }
                else
                {
                    return " ( " + Convert.ToString(CheckedCount) + " / " + Convert.ToString(ScheduledCount * ObjectInstanceCount) + " ) ";
                }

            }
            //set { CreatedDate = value; }
        }

        public List<DocumentList_VM> DocumentList { get; set; }
    }

    public class DocumentList_VM:Base_VM
    {
        public string Document { get; set; }
        public DateTime RevisedDate { get; set; }

        public string RevisedDateCustom
        {
            get
            {
                return DateFormat(RevisedDate);
            }
        }

       
    }
}
