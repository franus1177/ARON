using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Resources;

namespace WebPortal.UI.Web.App_Start
{
    public static class ResourceSerialiser
    {
        #region JSON Serialisation
        /// <summary>
        /// Converts a resrouce type into an equivalent JSON object using the 
        /// current Culture
        /// </summary>
        /// <param name="resource">The resoruce type to serialise</param>
        /// <returns>A JSON string representation of the resource</returns>
        public static string ToJson(Type resource)
        {
            return ToJson(resource, CultureInfo.CurrentCulture);
        }

        /// <summary>
        /// Converts a resrouce type into an equivalent JSON object using the 
        /// culture derived from the language code passed in
        /// </summary>
        /// <param name="resource">The resoruce type to serialise</param>
        /// <param name="languageCode">The language code to derive the culture</param>
        /// <returns>A JSON string representation of the resource</returns>
        public static string ToJson(Type resource, string languageCode)
        {
            CultureInfo culture = CultureInfo.GetCultureInfo(languageCode);
            return ToJson(resource, culture);
        }

        /// <summary>
        /// Converts a resrouce type into an equivalent JSON object
        /// </summary>
        /// <param name="resource">The resoruce type to serialise</param>
        /// <param name="culture">The culture to retrieve</param>
        /// <returns>A JSON string representation of the resource</returns>
        public static string ToJson(Type resource, CultureInfo culture)
        {
            Dictionary<string, string> dictionary = ResourceToDictionary(resource, culture);
            return JsonConvert.SerializeObject(dictionary);
        }
        #endregion

        /// <summary>
        /// Converts a resrouce type into a dictionary type while localising 
        /// the strings using the passed in culture
        /// </summary>
        /// <param name="resource">The resoruce type to serialise</param>
        /// <param name="culture">The culture to retrieve</param>
        /// <returns>A dictionary representation of the resource</returns>
        private static Dictionary<string, string> ResourceToDictionary(Type resource, CultureInfo culture)
        {
            ResourceManager rm = new ResourceManager(resource);
            PropertyInfo[] pis = resource.GetProperties(BindingFlags.Public | BindingFlags.Static);
            IEnumerable<KeyValuePair<string, string>> values =
                from pi in pis
                where pi.PropertyType == typeof(string)
                select new KeyValuePair<string, string>(
                    pi.Name,
                    rm.GetString(pi.Name, culture));
            Dictionary<string, string> dictionary = values.ToDictionary(k => k.Key, v => v.Value);

            return dictionary;
        }
    }
}