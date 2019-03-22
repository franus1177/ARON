using AutoMapper;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using WebPortal.Business.Entities.EF;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.RepositoryInterfaces;
namespace WebPortal.Business.Operations.Repository
{
    public class CustomerAddressRepository : BaseRepository, ICustomerAddressRepository
    {
        public List<CustomerAddress_VM> GetData(CustomerAddress_VM Model)
        {
            List<CustomerAddress_VM> query = new List<CustomerAddress_VM>();

            try
            {
                using (var db = new WebPortalEntities())
                {
                    var config = new MapperConfiguration(cfg => cfg.CreateMap<GetCustomerAddress_Result, CustomerAddress_VM>());
                    var mapper = config.CreateMapper();
                    ObjectResult<GetCustomerAddress_Result> data = db.GetCustomerAddress(Model.CustomerID, Model.AddressType, Model.AddressLine1, Model.AddressLine2, Model.CityName, Model.StateName, Model.CountryName, Model.Pincode, Model.IsPrimaryAddress, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);

                    mapper.Map<ObjectResult<GetCustomerAddress_Result>, List<CustomerAddress_VM>>(data, query);
                }
            }
            catch (Exception ex)
            {
                logger.Error("CustomerAddressRepository_GetData Error: ", ex);
                throw;
            }

            return query;
        }

        public int Update(CustomerAddress_VM Model)
        {
            int result = 0;

            using (var db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        result = db.UpdateCustomerAddress(Model.CustomerID, Model.AddressType, Model.AddressTypeOld, Model.AddressLine1, Model.AddressLine2, Model.CityName, Model.StateName, Model.CountryName, Model.Pincode, Model.IsPrimaryAddress, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                        db.SaveChanges();
                        trans.Commit();
                    }
                    catch (Exception ex)
                    {
                        logger.Error("CustomerAddressRepository_Update Error: ", ex);
                        trans.Rollback();
                        throw;
                    }
                }
            }

            return result;
        }

        public int Delete(CustomerAddress_VM Model)
        {
            int result = 0;

            using (var db = new WebPortalEntities())
            {
                using (var trans = db.Database.BeginTransaction())
                {
                    try
                    {
                        result = db.DeleteCustomerAddress(Model.CustomerID, Model.AddressType, Model.CurrentLanguageCode, Model.CurrentUTCOffset, Model.CurrentEndUserID, Model.CurrentUserRoleID, Model.CurrentScreenID, Model.AccessPoint);
                        db.SaveChanges();
                        trans.Commit();
                    }
                    catch (Exception ex)
                    {
                        logger.Error("CustomerAddressRepository_Delete Error: ", ex);
                        trans.Rollback();
                        throw;
                    }
                }
            }

            return result;
        }
    }

    public interface ICustomerAddressRepository : IBaseInterFace
    {
        List<CustomerAddress_VM> GetData(CustomerAddress_VM Model);

        int Update(CustomerAddress_VM Model);
        int Delete(CustomerAddress_VM Model);
    }
};
