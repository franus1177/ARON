using Microsoft.Practices.Unity;
using System;
using WebPortal.Business.Entities.ViewModels;
using WebPortal.Business.Operations.InventoryRepository;
using WebPortal.Business.Operations.Repository;
using WebPortal.Business.Operations.RepositoryInterfaces;

namespace WebPortal.UI.Web
{
    /// <summary>
    /// Specifies the Unity configuration for the main container.
    /// </summary>
    public partial class UnityConfig
    {
        #region Unity Container
        private static Lazy<IUnityContainer> container = new Lazy<IUnityContainer>(() =>
        {
            var container = new UnityContainer();
            RegisterTypes(container);
            return container;
        });

        /// <summary>
        /// Gets the configured Unity container.
        /// </summary>
        public static IUnityContainer GetConfiguredContainer()
        {
            return container.Value;
        }
        #endregion

        /// <summary>Registers the type mappings with the Unity container.</summary>
        /// <param name="container">The unity container to configure.</param>
        /// <remarks>There is no need to register concrete types such as controllers or API controllers (unless you want to 
        /// change the defaults), as Unity allows resolving a concrete type even if it was not previously registered.</remarks>
        public static void RegisterTypes(IUnityContainer container)
        {
            // NOTE: To load from web.config uncomment the line below. Make sure to add a Microsoft.Practices.Unity.Configuration to the using statements.
            // container.LoadConfiguration();

            // TODO: Register your types here

            #region Base Module

            container.RegisterType<IUserRepository, UserRepository>();
            container.RegisterType<IUserRoleRepository, UserRoleRepository>();

            container.RegisterType<ICustomerRepository, CustomerRepository>();
            container.RegisterType<ICustomerAddressRepository, CustomerAddressRepository>();

            container.RegisterType<IAuditLogRepository, AuditLogRepository>();
            container.RegisterType<IBaseDashboardRepository, BaseDashboardRepository>();

            container.RegisterType<IeCustomerRepository, eCustomerRepository>();
            container.RegisterType<IInvoiceRepository, InvoiceRepository>();

            container.RegisterType<IFixtureRepository, FixtureRepository>();
            container.RegisterType<IPartRepository, PartRepository>();
            container.RegisterType<IFixturePartRepository, FixturePartRepository>();
            container.RegisterType<IPurchaseOrderRepository, PurchaseOrderRepository>();

            #endregion Base Module

        }
    }
};