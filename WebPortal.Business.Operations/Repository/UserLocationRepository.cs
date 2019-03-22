using System;
using System.Collections.Generic;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.Business.Operations.Repository
{
    public class UserLocationRepository : BaseRepository, IUserLocationRepository
    {
        public List<UserLocation_VM> GetData(UserLocation_VM Model)
        {
            List<UserLocation_VM> query = new List<UserLocation_VM>();

            try
            {
                //				using (var db = new WebPortalEntities())
                //				{
                //	var config = new MapperConfiguration(cfg => cfg.CreateMap<GetUserLocation_Result, UserLocation_VM>());
                //var mapper = config.CreateMapper();
                //List<GetUserLocation_Result> data = db.GetUserLocation(Model.ServiceLineCode,Model.UserID,Model.LocationID,Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint).ToList();
                //mapper.Map<List<GetUserLocation_Result>, List<UserLocation_VM>>(data, query);
                //				}
            }
            catch (Exception ex)
            {
                logger.Error("UserLocationRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Add(UserLocation_VM Model)
        {
            int result = 0;
            try
            {
                //			using (var db = new WebPortalEntities())
                //			{	
                //result = db.AddUserLocation(Model.ServiceLineCode,Model.UserID,Model.LocationID,Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                //			db.SaveChanges();
                //							}
            }
            catch (Exception ex)
            {
                logger.Error("UserLocationRepository_Add Error: ", ex);
                throw;
            }

            return result;
        }
    }

    public interface IUserLocationRepository : IBaseInterFace
    {
        List<UserLocation_VM> GetData(UserLocation_VM Model);
        int Add(UserLocation_VM Model);
    }
};
