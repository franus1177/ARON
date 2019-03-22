using System.Collections.Generic;
using WebPortal.Business.Entities.ViewModels;

namespace WebPortal.Business.Operations.RepositoryInterfaces
{
    public interface IBaseInterFace
    {
    }

    interface ICommonRepository
    {
        List<Language_VM> GetLanguageData(string LanguageCode);
    }
};