using System.Web.Optimization;

namespace WebPortal.UI.Web
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/assets/js/jquery-2.1.4.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/assets/js/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                        "~/assets/js/bootstrap.min.js"));
            
            bundles.Add(new ScriptBundle("~/bundles/ace").Include(
                "~/assets/js/ace-elements.min.js",
                      "~/assets/js/ace.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/aceextra").Include(
                        "~/assets/js/ace-extra.min.js"));

            bundles.Add(new StyleBundle("~/assets/js/css").Include(
                      "~/assets/js/bootstrap.min.css"));

            bundles.Add(new StyleBundle("~/assets/font-awesome/4.5.0/css").Include(
                      "~/assets/font-awesome/4.5.0/css/font-awesome.min.css"));

            bundles.Add(new StyleBundle("~/assets/css").Include(
                      "~/assets/css/fonts.googleapis.com.css",
                      "~/assets/css/ace.min.css",
                      "~/assets/css/ace-skins.min.css",
                      "~/assets/css/ace-rtl.min.css"));
        }
    }
}